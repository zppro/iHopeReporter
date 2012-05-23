//
//  WaitingProcessViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-10.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Functions.h"


@interface WaitingProcessViewController : UIViewController {
	UIActivityIndicatorView *spinner;
	UIView *spinnerContainer;
	UILabel *messageLabel;
	NSString *message; 
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic,retain) IBOutlet UIView *spinnerContainer;
@property (nonatomic,retain) IBOutlet UILabel *messageLabel; 

- (id) initWithMessage:(NSString*)newMessage;
@end
