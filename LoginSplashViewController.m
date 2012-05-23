    //
//  LoginSplashViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-21.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "LoginSplashViewController.h"


@implementation LoginSplashViewController

@synthesize operationAreaView,nameTextField,passwordTextField,loginButton;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	nameTextField.delegate = self; 
	passwordTextField.delegate = self;
	
	operationAreaView.backgroundColor = [UIColor clearColor];
	[operationAreaView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
	
	loginButton.layer.cornerRadius = 12;
	loginButton.layer.masksToBounds = YES;
	
	nameTextField.text = GetSettingItemValue(kSettingItemForUserCode);
	passwordTextField.text = GetSettingItemValue(kSettingItemForPassword);
	NSLog(@"%@",nameTextField.text);
	isAutoLogin = (nameTextField.text != nil && passwordTextField.text !=nil);
	if(isAutoLogin){
		
		ShowWaitingProcessView(self,@"正在登录，请稍候...");
		
		if (DEBUG_WITH_NETWORK_CONDITION==YES) {
			[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(Authentication:) userInfo:nil repeats:NO];
		}
		else {
			[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(AuthenticationWithoutNetwork:) userInfo:nil repeats:NO];
		}
	}

}



- (IBAction) DoLogin{
	[self HideKeyboard];
	ShowGlobalWaitingProcessView(@"正在登录，请稍候...");
	//ShowWaitingProcessView2(self.view,@"正在登录，请稍候...");
	if (DEBUG_WITH_NETWORK_CONDITION==YES) {
		[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(Authentication:) userInfo:nil repeats:NO];
	}
	else {
		[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(AuthenticationWithoutNetwork:) userInfo:nil repeats:NO];
	}
}

- (void) DoLoginCallback:(NSDictionary*)customData{
	//NSLog(@"%@",[customData objectForKey:@"MESSAGE"]);
	
	if ([[customData objectForKey:@"RET"] intValue] == 0) { 
		
		//ShowGlobalWaitingProcessView(@"初始化界面组件...");
		
		AppDelegate_iPad *delegate = GetAppDelegate();
		gUser = [[ReporterUser alloc] init];
		gUser.userID = [customData objectForKey:@"USER_ID"];
		gUser.userCode = [customData objectForKey:@"USER_CODE"];
		gUser.userName = [customData objectForKey:@"USER_NAME"];
		gUser.deptID = [customData objectForKey:@"DEPT_ID"];
		gUser.deptCode = [customData objectForKey:@"DEPT_CODE"];
		gUser.deptName = [customData objectForKey:@"DEPT_NAME"];
		
		
		NSArray *dataItems = nil;
		if (DEBUG_WITH_NETWORK_CONDITION==YES) {
			NSString *requestURL = [NSString stringWithFormat:@"%@api/report/02/focus/" ,gAppPath];
			dataItems = [self FetchTabDatas:requestURL];
		}
		else {
			NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Debug_As_Focus" ofType:@"plist"];
			dataItems = [NSArray arrayWithContentsOfFile:dataPath];
		}
		
		
		
		NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
		UINavigationController *navController = nil;
		MyBaseViewController *viewController= nil; 
		for (NSDictionary* dataItem in dataItems) {
			int item_type = [[dataItem objectForKey:kItemTypeKey] intValue];
			if (item_type ==0) {
				viewController = [[[ItemListViewController alloc] 
								   initWithTabBarSetTitle:[dataItem objectForKey:kItemNameKey] 
								   AndImage:[UIImage imageNamed:[dataItem objectForKey:kItemIconKey]]] 
								  autorelease];
				
			}
			else {
				//1－直接展示报表本身 2-代表展示报表列表的第一条，并且在右上角可切换选择状态
				viewController = [[[ItemDetailViewController alloc] 
								   initWithTabBarSetTitle:[dataItem objectForKey:kItemNameKey]
								   AndImage:[UIImage imageNamed:[dataItem objectForKey:kItemIconKey]]] 
								  autorelease];
				if (item_type==1) {
					((ItemDetailViewController*)viewController).currentDataItem = dataItem;
				}
			}
			viewController.allowSelectMore = item_type == 2;
			
			if (DEBUG_WITH_NETWORK_CONDITION==YES) {
				viewController.requestURL = [dataItem objectForKey:kNextURLKey];
			}
			else {
				if(item_type == 0){
					viewController.dataFileName = @"Debug_As_Catalog";
				}
				else if(item_type == 2) {
					viewController.dataFileName = @"Debug_As_DropDownListView";
				}
				
				
			}
			
			
			navController =[[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
			[tabViewControllers addObject:navController];
		}
		
		//我的收藏
		viewController = [[[ItemListViewController alloc] initWithTabBarSetTitle:@"我的收藏" AndImage:[UIImage imageNamed:@"icon_tab_my_fav"]] autorelease];
		if (DEBUG_WITH_NETWORK_CONDITION==YES) {
			viewController.requestURL = [NSString stringWithFormat:@"%@api/report/02/favorite/" ,gAppPath];
		}
		else {
			viewController.dataFileName = @"Debug_As_Favorite";
		}
		
		navController =[[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
		[tabViewControllers addObject:navController];
		
		
		//报表分类
		viewController = [[[ItemListViewController alloc] initWithTabBarSetTitle:@"报表分类" AndImage:[UIImage imageNamed:@"icon_tab_report_catalog"]] autorelease];
		if (DEBUG_WITH_NETWORK_CONDITION==YES) {
			viewController.requestURL = [NSString stringWithFormat:@"%@api/report/02/catalog/" ,gAppPath];
		}
		else {
			viewController.dataFileName = @"Debug_As_Catalog";
		}
		
		navController =[[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
		[tabViewControllers addObject:navController];
		
		//关于我们
		viewController = [[[AboutUsViewController alloc] initWithTabBarSetTitle:@"关于我们" AndImage:[UIImage imageNamed:@"icon_tab_top_rate"]] autorelease];
		navController =[[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
		[tabViewControllers addObject:navController];
		
		
		delegate.tabBarController.viewControllers = tabViewControllers;
		
		[navController release];
		[tabViewControllers release]; 
		
		//CloseGlobalWaitingProcessView();//将等待窗口先卸载
		[delegate.window addSubview:delegate.tabBarController.view];
		[self.view removeFromSuperview];
		[self release];
	}
	else {
		ShowError([customData objectForKey:@"MESSAGE"]);
	}
	
} 

- (NSArray*) FetchTabDatas:(NSString*) requestURL{
	NSMutableArray *items =nil;
	NSHTTPURLResponse *response = nil;  
    NSError *error = [[NSError alloc] init];  
	NSURL *url = [NSURL URLWithString: requestURL];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url]; 
	[request setURL:url];
	[request setValue:gUser.userID forHTTPHeaderField:@"USER_ID"];
	[request setHTTPMethod:@"GET"];
	[request setTimeoutInterval:iTimeOutSeconds];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request 
											   returningResponse:&response error:&error];
	//NSLog(@"%d",[response statusCode]);
	
	if ([response statusCode] >= 200 && [response statusCode] < 300) { 
		
		
		NSArray *nodes = PerformXMLXPathQuery(returnData,XPATH_FOR_ROW_LEVELS);
		items = [[[NSMutableArray alloc] initWithCapacity:[nodes count]] autorelease];
		for (NSDictionary *node in nodes){
			NSArray *children = [node objectForKey:kXmlRawChildrenArrayKey];
			NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:[children count]];
			
			for(NSDictionary *child in children){
				[item setObject:[child objectForKey:kXmlRawContentNameKey] forKey: 
				 [child objectForKey:kXmlRawNodeNameKey]];
			}
			[items addObject:item];
		}
	}
	else {
		items = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	}
	
	return items; 
}

# pragma 认证
- (void) Authentication:(NSTimer*)theTimer{
	//CloseWaitingProcessView(self);
	NSHTTPURLResponse *response = nil;  
    NSError *error = [[NSError alloc] init];  
	NSString *requestURL = [NSString stringWithFormat:@"%@api/system/02/authentication/logon" ,gAppPath];
	NSLog(@"requestURL:%@",requestURL);
	NSURL *url = [NSURL URLWithString: requestURL];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url]; 
	[request setURL:url];
	[request setHTTPMethod:@"POST"]; 
	
	NSString* postStr= [NSString stringWithFormat:@"USER_CODE=%@&PASSWORD=%@", nameTextField.text,passwordTextField.text];
	
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request 
											   returningResponse:&response error:&error];
	//NSLog(@"%d",[response statusCode]);
	//NSLog(@"%@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
	if ([response statusCode] >= 200 && [response statusCode] < 300) { 
		/******************记住用户名密码**************************/
		SetSettingItemValue(@"UserCode", nameTextField.text);
		SetSettingItemValue(@"Password", passwordTextField.text);
		/*******************************************************/
		NSArray *nodes = PerformXMLXPathQuery(returnData,XPATH_FOR_ROW_LEVELS);
		if([nodes count] > 0){ 
			
			NSArray *children = [[nodes objectAtIndex:0] objectForKey:kXmlRawChildrenArrayKey];
			NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:[children count]];
			
			for(NSDictionary *child in children){
				[item setObject:[child objectForKey:kXmlRawContentNameKey] forKey: 
				 [child objectForKey:kXmlRawNodeNameKey]];
			} 
			if (isAutoLogin) {
				CloseWaitingProcessView(self);
			}
			else {
				CloseGlobalWaitingProcessView();
			}
			[self DoLoginCallback:item];
		}
		else {
			if (isAutoLogin) {
				CloseWaitingProcessView(self);
			}
			else {
				CloseGlobalWaitingProcessView();
			}
			ShowError([NSString stringWithFormat:@"无效的服务器地址，错误代码:%d", 508]);
		}

	}
	else {
		if (isAutoLogin) {
			CloseWaitingProcessView(self);
		}
		else {
			CloseGlobalWaitingProcessView();
		}
		ShowError([NSString stringWithFormat:@"服务器连接超时，错误代码:%d", [response statusCode]]);
	}
	
	//[self DoLoginCallback:YES WithErrorMessage:nil]; 
	[theTimer invalidate];
}

- (void) AuthenticationWithoutNetwork:(NSTimer*)theTimer{
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Debug_As_Authentication" ofType:@"plist"];
	[self DoLoginCallback:[[NSArray arrayWithContentsOfFile:dataPath] objectAtIndex:0]];
	
}



- (void) HideKeyboard{
	[nameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self HideKeyboard];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[nameTextField release];
	[passwordTextField release];
	[loginButton release];
	[operationAreaView release];
    [super dealloc];
}


@end
