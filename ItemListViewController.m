    //
//  ItemListViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//


#import "ItemListViewController.h"

@interface ItemListViewController(PRIVATE)

- (void) FetchItemDatas:(NSTimer*)theTimer;
- (void) FetchItemDatasWithLocalFileName:(NSString*)fileName OfType:(NSString*) typeName;
- (void) FetchItemDatasAtHttpRequestInXMLFormat:(NSString*)urlString WithXPath:(NSString*) xPathString;

@end


@implementation ItemListViewController
@synthesize listTableView, listCell;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	//  update the last update date
	[refreshHeaderView refreshLastUpdatedDate];
	
	ShowGlobalWaitingProcessView(sCommonLoadingMessage);
	// Configure the table view.
    listTableView.rowHeight = 75.0;
    listTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BackgroundImage_App]];
	//listTableView.backgroundColor = [UIColor clearColor];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(FetchItemDatas:) userInfo:nil repeats:NO];
	
	
	if (refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - listTableView.bounds.size.height, self.view.frame.size.width, self.listTableView.bounds.size.height)];
		view.delegate = self;
		[listTableView addSubview:view];
		refreshHeaderView = view;
		[view release];
	}
	
}

- (void) FetchItemDatas:(NSTimer*)theTimer{
	
	if (DEBUG_WITH_NETWORK_CONDITION==YES) {
		[self FetchItemDatasAtHttpRequestInXMLFormat:requestURL WithXPath:XPATH_FOR_ROW_LEVELS];
	}
	else {
		if (dataFileName != nil) {
			[self FetchItemDatasWithLocalFileName:dataFileName OfType:@"plist"];
		}
	}
	[listTableView reloadData];
	CloseGlobalWaitingProcessView();
	[theTimer invalidate];
	
}

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
	[request setTimeoutInterval:iTimeOutSeconds];
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


#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [dataItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ItemListCell";
    
    ItemListBaseCell *cell = (ItemListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
		UINib *theCellNib = [UINib nibWithNibName:@"ItemListCellView" bundle:nil];
		[theCellNib instantiateWithOwner:self options:nil];
		//[cellNib instantiateWithOwner:self options:nil];
		cell = listCell;
		listCell = nil;
    }
    
	// Display dark and light background in alternate rows -- see tableView:willDisplayCell:forRowAtIndexPath:.
    
	// Configure the data for the cell.
    NSMutableDictionary *dataItem = [dataItems objectAtIndex:indexPath.row];
	int item_type = [[dataItem objectForKey:kItemTypeKey] intValue];
	cell.icon = [UIImage imageNamed:[NSString stringWithFormat:@"item_type_%d", item_type]];
	 
	
    cell.itemName = [dataItem objectForKey:kItemNameKey];
	cell.childrenNum = [[dataItem objectForKey:kChildrenNumCatalogKey] intValue]+[[dataItem objectForKey:kChildrenNumItemKey] intValue]; 
	cell.favorited = [[dataItem objectForKey:kItemFavoriteFlagKey] intValue] > 0;
	
	//[(ItemListCell*)cell setBackgroundColor:[UIColor clearColor]];
	cell.useDarkBackground = (indexPath.row % 2 == 0);
	[(ItemListCell*)cell ControlSubViewHidden];
						
    return cell;
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = ((ItemListCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableDictionary *dataItem = [dataItems objectAtIndex:indexPath.row];
	MyBaseViewController *targetViewController = [dataItem objectForKey:kViewControllerKey];
	if (!targetViewController)
	{
		if([[dataItem objectForKey:kItemTypeKey] intValue] ==0){
			if ([[dataItem objectForKey:kChildrenNumCatalogKey] intValue]==0  && [[dataItem objectForKey:kChildrenNumItemKey] intValue]==1 ) {
				targetViewController = [[NSClassFromString(sItemDetailControllerName) alloc] initWithNibName:sItemDetailXIBName bundle:nil];
				targetViewController.allowSelectMore = YES;
			}
			else {
				targetViewController = [[NSClassFromString(sItemListControllerName) alloc] initWithNibName:sItemListXIBName bundle:nil];
			}
			// The view controller has not been created yet, create it and set it to our menuList array
		}
		else{
			targetViewController = [[NSClassFromString(sItemDetailControllerName) alloc] initWithNibName:sItemDetailXIBName bundle:nil];
			//如果是明细需要绑定同级分类的数据
			targetViewController.allowSelectMore = YES;
			targetViewController.dataItems = dataItems;
		}

		targetViewController.title = [dataItem objectForKey:kItemNameKey];
		targetViewController.requestURL = [dataItem objectForKey:kNextURLKey];
		[dataItem setValue:targetViewController forKey:kViewControllerKey];
		[targetViewController release];
    }
    [self.navigationController pushViewController:targetViewController animated:YES];
	
}

#pragma mark -
#pragma mark 线程调用数据

-(void)BeginThread
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	isFinished = NO;	
	[self performSelectorInBackground:@selector(CallWS) withObject:nil];
	[self performSelectorOnMainThread:@selector(UpdateUI) withObject:nil waitUntilDone:YES];
	[pool release];
}
-(void)BeginGetData{
	[NSThread detachNewThreadSelector:@selector(BeginThread) toTarget:self withObject:nil];
}
-(void)UpdateUI
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];	
	if(!(isFinished))
	{
		[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(UpdateUI) 
									   userInfo:nil repeats:NO];
		NSLog(@"waiting.....");
    }
	else {
		[listTableView reloadData];
	}
	[pool release];
}

-(void)CallWS
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];			
	//这里调用网络数据，是一个耗时的操作。
	if (DEBUG_WITH_NETWORK_CONDITION==YES) {
		[self FetchItemDatasAtHttpRequestInXMLFormat:requestURL WithXPath:XPATH_FOR_ROW_LEVELS];
	}
	else {
		if (dataFileName != nil) {
			[self FetchItemDatasWithLocalFileName:dataFileName OfType:@"plist"];
		}
	}
	isFinished = YES;
	[pool release];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	NSLog(@"call reloadTableViewDataSource");
	[self BeginGetData];
	_reloading = YES;
	
}



- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:listTableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
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
	listTableView = nil;
	//cellNib = nil;
	listCell = nil; 
	refreshHeaderView=nil;
}


- (void)dealloc {
	[listTableView release];
	[listCell release];
	refreshHeaderView = nil;
	//[cellNib release];
    [super dealloc];
}


@end
