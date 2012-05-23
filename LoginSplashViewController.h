//
//  LoginSplashViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-21.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_iPad.h"
#import "Common.h"
#import "AboutUsViewController.h"

@interface LoginSplashViewController : UIViewController<UITextFieldDelegate> {
	UIView *operationAreaView;
	UITextField *nameTextField;
	UITextField *passwordTextField;
	UIButton *loginButton;
	BOOL isAutoLogin;
}

@property (nonatomic,retain) IBOutlet UIView *operationAreaView;
@property (nonatomic,retain) IBOutlet UITextField *nameTextField;
@property (nonatomic,retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic,retain) IBOutlet UIButton *loginButton;

- (IBAction) DoLogin;

- (void) Authentication:(NSTimer*)theTimer;
- (void) AuthenticationWithoutNetwork:(NSTimer*)theTimer;

- (void) DoLoginCallback:(NSDictionary*)customData; 

- (void) HideKeyboard;

- (NSArray*) FetchTabDatas:(NSString*) requestURL;
@end
