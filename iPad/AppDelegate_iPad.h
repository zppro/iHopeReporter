//
//  AppDelegate_iPad.h
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "NetWorkChecker.h"

#import "ItemListViewController.h"
#import "ItemDetailViewController.h"
#import "LoginSplashViewController.h"



@interface AppDelegate_iPad : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

