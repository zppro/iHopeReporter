//
//  AboutUsViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-11.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "SettingsViewController.h"

@interface AboutUsViewController : MyBaseViewController<SettingsDelegate> {
	UITextView *textView;
}

@property (nonatomic,retain) IBOutlet UITextView *textView;

@end
