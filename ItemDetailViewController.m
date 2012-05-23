    //
//  ItemDetailViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "ItemDetailViewController.h"
@interface ItemDetailViewController(PRIVATE)

- (void) leftButtonClicked;
- (void) rightButtonClicked;
- (void) opButtonToggled;

- (void) FetchItemDatasWithLocalFileName:(NSString*)fileName OfType:(NSString*) typeName;
- (void) FetchItemDatasAtHttpRequestInXMLFormat:(NSString*)urlString WithXPath:(NSString*) xPathString;

- (void) LoadWebContent:(NSString*)urlString;

- (void) toggleFavorite:(NSTimer*)theTimer;
- (void) toggleFavoriteCallback:(NSDictionary*)customData;
- (void) updateToolbarItemForFavorite;
@end

@implementation ItemDetailViewController

@synthesize detailView,toolbar,toolbarItemForPrint,toolbarItemForFavorite,toolbarItemForRefresh,toolbarItemForDateTime;


-(void) FetchItemDatasWithLocalFileName:(NSString*)fileName OfType:(NSString*) typeName{
	
	NSString *dataPath = [[NSBundle mainBundle] pathForResource:fileName ofType:typeName];	
	NSArray *nodes = [NSArray arrayWithContentsOfFile:dataPath];
	//必须重新分配内存地址进行拷贝，否则执行玩以后nodes会自动释放,在didselect事件时会产生问题
	NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[nodes count]];
	for (NSDictionary *node in nodes){
		[items addObject:[NSMutableDictionary dictionaryWithDictionary:node]];
	} 
	if (dataItems != nil) {
		[dataItems release];
	}
	dataItems = items;
}

-(void) FetchItemDatasAtHttpRequestInXMLFormat:(NSString*)urlString WithXPath:(NSString*) xPathString{
	NSHTTPURLResponse *response = nil;  
    NSError *error = [[NSError alloc] init];  
	NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url]; 
	[request setURL:url];
	[request setValue:gUser.userID forHTTPHeaderField:@"USER_ID"];
	[request setHTTPMethod:@"GET"];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request 
											   returningResponse:&response error:&error];
	//NSLog(@"%d",[response statusCode]);
	
	if ([response statusCode] >= 200 && [response statusCode] < 300) { 
		
		
		NSArray *nodes = PerformXMLXPathQuery(returnData,xPathString);
		
		NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[nodes count]];
		for (NSDictionary *node in nodes){
			NSArray *children = [node objectForKey:kXmlRawChildrenArrayKey];
			NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:[children count]];
			
			for(NSDictionary *child in children){
				[item setObject:[child objectForKey:kXmlRawContentNameKey] forKey: 
				 [child objectForKey:kXmlRawNodeNameKey]];
			}
			[items addObject:item];
		} 
		if (dataItems != nil) {
			[dataItems release];
		}
		dataItems = items;
		//[nodes release];
	}
}
-(void) LoadReportDetailWebContent{
	if(requestURL !=nil){
		[self LoadWebContent:requestURL];
	}
}

- (void) LoadWebContent:(NSString*)urlString{
	
	selectedRequestUrlWhenAllowedSelectMore = urlString;//仅复制引用地址
	
	NSMutableString *newUrlString = [NSMutableString stringWithFormat:@"%@",urlString];
	//NSLog(@"%@",newUrlString);
	[newUrlString replaceOccurrencesOfString:paramBeginDate withString:@"2009-02-02" options:NSCaseInsensitiveSearch range:(NSRange){0,[newUrlString length]}];
	//NSLog(@"%@",newUrlString);
	[newUrlString replaceOccurrencesOfString:paramEndDate withString:@"2009-02-05" options:NSCaseInsensitiveSearch range:(NSRange){0,[newUrlString length]}];
	NSLog(@"%@",newUrlString);
	
	NSString* urlEncoding = [newUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	
	NSURL *url = [NSURL URLWithString: urlEncoding];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] 
									initWithURL:url]; 
	[request setURL:url];
	[request setValue:REQUEST_HEAD_VALUE_FOR_CLIENT_OS forHTTPHeaderField:REQUEST_HEAD_NAME_FOR_CLIENT_OS];
	
	//[request setValue:@"0000000035" forHTTPHeaderField:@"APP_ID"];
	[request setHTTPMethod:@"GET"];
	//NSLog(@"Request:%@ reponse_code:%d",urlString,[response statusCode]);
	[detailView loadRequest:request];
}


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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
- (void) leftButtonClicked{
	ShowInfo(@"上一张报表");
}

- (void) rightButtonClicked{
	ShowInfo(@"下一张报表");	
}

- (void) opButtonToggled{
	CGRect buttonFrame = self.navigationItem.rightBarButtonItem.customView.frame;
	float newX = buttonFrame.origin.x+buttonFrame.size.width - DropDownListViewContainerWidth;
	if (dropDownListView==nil) {
		dropDownListView = [[CUIDropDownListView alloc] initWithFrame:CGRectMake(newX,0,DropDownListViewContainerWidth,DropDownListViewContainerHeight)];
		dropDownListView.delegate = self;
		dropDownListView.dataSource = self;
		dropDownListView.allowMultiSelect = NO;//不允许多选
		dropDownListView.allowInvertSelect = NO;//不允许反选
		dropDownListView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BackgroundImage_App]];
		[self.view addSubview:dropDownListView];
		[dropDownListView release];
	}
	
	[dropDownListView setDropDownAreaDisplay:!dropDownListView.dropDownAreaDisplay];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	ShowGlobalWaitingProcessView(sCommonLoadingMessage);
	
	//控制按钮
	toolbarItemForPrint.enabled=NO;

	/**自定义设置导航栏右上角三个按钮**/
	UIView *opArea = [[UIView alloc] initWithFrame:CGRectMake(0,0,140,30)];

	UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//设置位置大小
	[leftButton setFrame:CGRectMake(0,0,30,30)];
	//设置圆角
	leftButton.layer.cornerRadius = 6;
	leftButton.layer.masksToBounds = YES;
	//设置按钮上的文字  
    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    //设置按钮上文字的大小和颜色  
    [leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];  
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];  
    //设置按钮的图片  
    [leftButton setBackgroundImage:[UIImage imageNamed:@"blackbuttonbg1"] forState:UIControlStateNormal];  
	//设置代理
	[leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[opArea addSubview:leftButton];
	
	UIButton *opButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//设置位置大小
	[opButton setFrame:CGRectMake(40,0,60,30)];
	//设置圆角
	opButton.layer.cornerRadius = 6;
	opButton.layer.masksToBounds = YES;
	//设置按钮上的文字  
    [opButton setTitle:@"选择" forState:UIControlStateNormal];
    //设置按钮上文字的大小和颜色  
    [opButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];  
    [opButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];  
    //设置按钮的图片  
    [opButton setBackgroundImage:[UIImage imageNamed:@"blackbuttonbg1"] forState:UIControlStateNormal];  
	//设置代理
	[opButton addTarget:self action:@selector(opButtonToggled) forControlEvents:UIControlEventTouchUpInside];

	[opArea addSubview:opButton];
	
	UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//设置位置大小
	[rightButton setFrame:CGRectMake(110,0,30,30)];
	//设置圆角
	rightButton.layer.cornerRadius = 6;
	rightButton.layer.masksToBounds = YES;
	//设置按钮上的文字  
    [rightButton setTitle:@">" forState:UIControlStateNormal];
    //设置按钮上文字的大小和颜色  
    [rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];  
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];  
    //设置按钮的图片  
    [rightButton setBackgroundImage:[UIImage imageNamed:@"blackbuttonbg1"] forState:UIControlStateNormal];  
	//设置代理
	[rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[opArea addSubview:rightButton];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:opArea] autorelease];
	[opArea release];
	
	[toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
	
	detailView.delegate = self;
	if (allowSelectMore) {
		if (DEBUG_WITH_NETWORK_CONDITION==YES) {
			[self FetchItemDatasAtHttpRequestInXMLFormat:requestURL WithXPath:XPATH_FOR_ROW_LEVELS];
		}
		else {
			if (dataFileName != nil) {
				[self FetchItemDatasWithLocalFileName:dataFileName OfType:@"plist"];
			}
		}
		
		if ([dataItems count]>0) {
			NSDictionary *dataItem = (NSDictionary* )[dataItems objectAtIndex:0];
			currentDataItem = dataItem;
			NSString* oldTitle = self.tabBarItem.title;
			self.title = [dataItem objectForKey:kItemNameKey];
			self.tabBarItem.title = oldTitle;
			[self UpdateTitle: [dataItem objectForKey:kItemNameKey] SynToTabBar:NO];
			[self LoadWebContent:[dataItem objectForKey:kNextURLKey]];
		}
	}
	else {
		[self LoadReportDetailWebContent];
	} 
	
	[self updateToolbarItemForFavorite];
} 

- (void) updateToolbarItemForFavorite{
	if (currentDataItem!=nil) {
		if([[currentDataItem objectForKey:kItemFavoriteFlagKey] intValue]==0){
			//没有收藏
			toolbarItemForFavorite.title = @"收藏";
		}
		else {
			//已收藏
			toolbarItemForFavorite.title = @"取消收藏";
		}
	}
}

#pragma mark -
#pragma mark webview响应
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	NSString *urlString = request.URL.absoluteString;
	if ([urlString isEqualToString:@"about:blank"]) {
		return NO;
	}
	else if([urlString isEqualToString:sTouchStartEventUrlOnUIWebView]){
		//检测到需要交互的touchStart事件
		[dropDownListView setDropDownAreaDisplay:NO];
		return NO;
	}
	else {
		//NSLog(@"%@", urlString);
		return YES;
	}
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
	detailViewFramesCount++;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
	detailViewFramesCount--;
	if(detailViewFramesCount==0){
		//NSLog(@"finished loading");
		
		[webView stringByEvaluatingJavaScriptFromString:
		[NSString stringWithFormat:@"document.ontouchstart=function(){document.location.href ='%@';};", sTouchStartEventUrlOnUIWebView]  
		];
		//document.ontouchend=function(){document.localtion};document.ontouchmove=function(){return true;}
		CloseGlobalWaitingProcessView();
	}
}

#pragma mark -
#pragma mark toggle收藏

# pragma 认证
- (void) toggleFavorite:(NSTimer*)theTimer{
	
	NSString* relationID = [theTimer userInfo];
	NSLog(@"%@",relationID);
	//CloseWaitingProcessView(self);
	NSHTTPURLResponse *response = nil;  
    NSError *error = [[NSError alloc] init];  
	NSString *urlString = [NSString stringWithFormat:@"%@api/system/02/favorite/toggle" ,gAppPath];
	//NSLog(@"requestURL:%@",requestURL);
	NSURL *url = [NSURL URLWithString: urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url]; 
	[request setURL:url];
	[request setHTTPMethod:@"POST"]; 
	
	NSString* postStr= [NSString stringWithFormat:@"USER_ID=%@&USER_NAME=%@&RELATION_ID=%@", gUser.userID,gUser.userName,relationID];
	
    [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request 
											   returningResponse:&response error:&error];
	//NSLog(@"%d",[response statusCode]);
	//NSLog(@"%@",[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
	if ([response statusCode] >= 200 && [response statusCode] < 300) { 
		
		NSArray *nodes = PerformXMLXPathQuery(returnData,XPATH_FOR_ROW_LEVELS);
		if([nodes count] > 0){ 
			
			NSArray *children = [[nodes objectAtIndex:0] objectForKey:kXmlRawChildrenArrayKey];
			NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithCapacity:[children count]];
			
			for(NSDictionary *child in children){
				[item setObject:[child objectForKey:kXmlRawContentNameKey] forKey: 
				 [child objectForKey:kXmlRawNodeNameKey]];
			} 
			CloseGlobalWaitingProcessView();
			[self toggleFavoriteCallback:item];
		}
		else {
			CloseGlobalWaitingProcessView();
			ShowError([NSString stringWithFormat:@"无效的服务器地址，错误代码:%d", 508]);
		}
		
	}
	else {
		CloseGlobalWaitingProcessView();
		ShowError([NSString stringWithFormat:@"服务器连接超时，错误代码:%d", [response statusCode]]);
	}
	[theTimer invalidate];
}

- (void) toggleFavoriteCallback:(NSDictionary*)customData{
	if ([[customData objectForKey:@"RET"] intValue] == 0) {
		[currentDataItem setValue:[customData objectForKey:kItemFavoriteFlagKey] forKey:kItemFavoriteFlagKey];
		[self updateToolbarItemForFavorite];
		ShowInfo([NSString stringWithFormat:@"操作成功"]);
	}
	else {
		ShowError([customData objectForKey:@"MESSAGE"]);
	}

	
}

#pragma mark -
#pragma mark 响应工具栏按钮事件
- (IBAction) toolbarItemForPrintClicked:(id)sender{
	ShowInfo(@"打印");	
}
- (IBAction) toolbarItemForFavoriteClicked:(id)sender{
	if (currentDataItem != nil) {
		ShowGlobalWaitingProcessView(@"操作执行中...");
		NSString *selectItemID = [currentDataItem objectForKey:kItemIDKey];
		[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(toggleFavorite:) userInfo:selectItemID repeats:NO];
	}
}
- (IBAction) toolbarItemForRefreshClicked:(id)sender{
	if (currentDataItem != nil) {
		ShowGlobalWaitingProcessView(sCommonLoadingMessage);
		NSString *selectItemRequestUrl = [currentDataItem objectForKey:kNextURLKey];
		[self UpdateTitle: [currentDataItem objectForKey:kItemNameKey] SynToTabBar:NO];
		[self LoadWebContent:selectItemRequestUrl]; 
	}
}
- (IBAction) toolbarItemForDateTimeClicked:(id)sender{
	ShowInfo(@"时间");
}

#pragma mark -
#pragma mark DropDownListView  delegate datasource

/* 每次选择项都会调用
- (void) dropDownListView:(CUIDropDownListView*)ddlView didSelectViewItem:(CUIDropDownListViewItem *)viewItem{
	ShowInfo([NSString stringWithFormat:@"%d",viewItem.indexPath.row]);
}
*/

/**仅在选中变化时调用**/
- (void) dropDownListView:(CUIDropDownListView*)ddlView SelectedItemChanged:(CUIDropDownListViewItem *)viewItem{
	ShowGlobalWaitingProcessView(sCommonLoadingMessage);
	NSDictionary *selectDataItem = (NSDictionary*)[dataItems objectAtIndex:viewItem.indexPath.row];
	NSString *selectItemRequestUrl = [selectDataItem objectForKey:kNextURLKey];
	[self UpdateTitle: [selectDataItem objectForKey:kItemNameKey] SynToTabBar:NO];
	[self LoadWebContent:selectItemRequestUrl];
	
	currentDataItem = selectDataItem;//引用复值
	
	[self updateToolbarItemForFavorite];
}

/*
- (CGFloat) dropDownListView:(CUIDropDownListView *)ddlView heightForViewItemAtIndexPath:(NSIndexPath *)indexPath{
	return 73.0;
}
*/

- (NSInteger)dropDownListView:(CUIDropDownListView *)ddlView numberOfRowsInSection:(NSNumber*)section{
	return [dataItems count];
}

- (void)dropDownListView:(CUIDropDownListView *)ddlView customizeViewItem:(CUIDropDownListViewItem *)viewItem{
	
	NSDictionary *dataItem = [dataItems objectAtIndex:viewItem.indexPath.row];
    
	UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dataItem objectForKey:kItemIconKey]]];
	[viewItem.contentView addSubview:iconView];
	[iconView release];
	
	UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.size.width+5, 0, viewItem.frame.size.width - iconView.frame.size.width-5, viewItem.frame.size.height)];
	textView.text = [dataItem objectForKey:kItemNameKey];
	[viewItem.contentView addSubview:textView];
	[textView release];
	
	if ([(NSString*)[dataItem objectForKey:kNextURLKey] isEqualToString:selectedRequestUrlWhenAllowedSelectMore]) {
		viewItem.selected = YES;
	}
}

- (void) setCurrentDataItem:(NSDictionary*)newCurrentDataItem{
	//[newCurrentDataItem retain];
	//[currentDataItem release];
	currentDataItem = newCurrentDataItem;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[dropDownListView release];
	[detailView release];
	[toolbar release];
	[toolbarItemForPrint release];
	[toolbarItemForFavorite release];
	[toolbarItemForRefresh release];
	[toolbarItemForDateTime release];
	//[currentDataItem release];
    [super dealloc];
}


@end
