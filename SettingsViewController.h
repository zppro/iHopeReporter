//
//  SettingsViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-24.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@class SettingsViewController;
@protocol SettingsDelegate

- (void) SettingsUpdated:(SettingsViewController*)controller;

- (void) SettingsCanceled;

@end


@interface SettingsViewController : UIViewController 
	<UITableViewDelegate,UITableViewDataSource>{
	id<SettingsDelegate> delegate;
	NSMutableArray *settingGroups;
	NSMutableArray *settingItems;
	UITableView  *listViewForSettings;
}

@property (nonatomic,assign) id<SettingsDelegate> delegate;
@property (nonatomic,retain) IBOutlet UITableView *listViewForSettings;
@end


