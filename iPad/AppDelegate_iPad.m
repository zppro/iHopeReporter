//
//  AppDelegate_iPad.m
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "AppDelegate_iPad.h"
@interface AppDelegate_iPad(PRIVATE)

- (void) ReadSettings;
- (void)registerDefaultsFromSettingsBundle;

@end

@implementation AppDelegate_iPad

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	 
	//读取设置
	[self ReadSettings];


	//添加监控联网状态的代码
	[[NetWorkChecker sharedOne] StartListening];
	
	
	//创建tab
	tabBarController = [[UITabBarController alloc] init];
	
	/*
	test *testViewController = [[[test alloc] initWithTabBarSetTitle:@"测试" AndImage:[UIImage imageNamed:@"icon_tab_my_fav.png"]] autorelease];
	ItemDetailViewController *itemDetailViewController = [[[ItemDetailViewController alloc] initWithTabBarSetTitle:@"明细窗口" AndImage:[UIImage imageNamed:@"icon_tab_report.png"]] autorelease];
	
	ItemListViewController *itemListViewController = [[[ItemListViewController alloc] initWithTabBarSetTitle:@"报表分类" AndImage:[UIImage imageNamed:@"icon_tab_report_catalog.png"]] autorelease];
	
	//UINavigationController *nvCtr1=[[[UINavigationController alloc] init] autorelease];
	UINavigationController *nvCtr2=[[[UINavigationController alloc] initWithRootViewController:testViewController] autorelease];
	UINavigationController *nvCtr3=[[[UINavigationController alloc] initWithRootViewController:itemDetailViewController] autorelease];
	UINavigationController *nvCtr4=[[[UINavigationController alloc] initWithRootViewController:itemListViewController] autorelease];
	UINavigationController *nvCtr5=[[[UINavigationController alloc] init] autorelease];//[[[UINavigationController alloc] initWithRootViewController:nil] autorelease];
	*/
	
	tabBarController.delegate = self;
	
	//nvCtr2.tabBarItem.enabled=NO;
//	nvCtr3.tabBarItem.enabled=NO;
//	nvCtr4.tabBarItem.enabled=NO;
	/*
    UINavigationController *localNavigationController;
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:3];
	
	
	
	test *testViewController = [[test alloc] initWithTabBarSetTitle:@"测试" AndImage:[UIImage imageNamed:@"icon_tab_my_fav.png"]];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:testViewController];
	[localControllersArray addObject:localNavigationController];
	[localNavigationController release];
	[testViewController release];
	 
	NSString *itemDetailViewTitle = @"明细窗口";
	UIImage *itemDetailTabImage = [UIImage imageNamed:@"icon_tab_report.png"];
	ItemDetailViewController *itemDetailViewController = [[ItemDetailViewController alloc] initWithTabBarSetTitle:itemDetailViewTitle AndImage:itemDetailTabImage];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:itemDetailViewController];
	[localControllersArray addObject:localNavigationController];
	[localNavigationController release];
	[itemDetailViewController release];
	
	
	NSString *itemListViewTitle = @"报表分类";
	UIImage *itemListTabImage = [UIImage imageNamed:@"icon_tab_report_catalog.png"];
	ItemListViewController *itemListViewController = [[ItemListViewController alloc] initWithTabBarSetTitle:itemListViewTitle AndImage:itemListTabImage];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:itemListViewController];
	[localControllersArray addObject:localNavigationController];
	[localNavigationController release];
	[itemListViewController release];
	 	
	tabBarController.viewControllers = localControllersArray;
	[localControllersArray release];
	*/
	 
	
	//[window addSubview:tabBarController.view];
	//LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginView_H" bundle:nil];
	
	LoginSplashViewController *loginSplashViewController = [[LoginSplashViewController alloc] init];
	[window addSubview:loginSplashViewController.view];
	//RefreshNewsViewController *viewController = [[RefreshNewsViewController alloc] init];
	//UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	//[window addSubview:navController.view];
	//[viewController release];
	//self.window.autoresizesSubviews = YES;
	self.window.backgroundColor =[UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
 
- (void) ReadSettings{
	 
	gHostName =GetSettingItemValue(kSettingItemForServiceHost);
	if(gHostName == nil){
		NSLog(@"registerDefaultsFromSettingsBundle");
		[self registerDefaultsFromSettingsBundle];
		gHostName = GetSettingItemValue(kSettingItemForServiceHost);
	}
	if (gHostName == nil) {
		if (DEBUG_WITH_NETWORK_CONDITION==YES) {
			if (DEBUG_USE_IBM==YES) {
				gHostName = @"http://192.168.1.70";
				
			}
			else {
				gHostName = @"http://thothinfo.gicp.net";
			}
		}
	}
	gAppName = GetSettingItemValue(kSettingItemForAppName);//[[NSUserDefaults standardUserDefaults] stringForKey:kAppName];
	if (gAppName == nil) {
		gAppName = @"hopetargle";
	}
	
	//NSLog(@"gHostName:%@,gAppName:%@",gHostName,gAppName);
	
	//拼接appPath
	
	gAppPath = [[NSString alloc] initWithFormat:@"%@/%@/",gHostName,gAppName];
}

- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
	
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
	
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [defaultsToRegister release];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark -
#pragma mark 实现UITabBarControllerDelegate 

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	/*
	if ([((UINavigationController*)viewController).topViewController isKindOfClass:[ItemListViewController class]]) {
		ShowGlobalWaitingProcessView(sCommonLoadingMessage);
	}
	*/
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end

