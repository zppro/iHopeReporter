//
//  Functions.h
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#define sCommonLoadingMessage @"正在加载..."

#import <Foundation/Foundation.h>  
#import "WaitingProcessViewController.h"

#define DeviceOrientation [[UIApplication sharedApplication] statusBarOrientation]


void ShowInfo(NSString* message);

void ShowError(NSString* message);

id GetAppDelegate();

void ShowWaitingProcessView(UIViewController* occurViewController,NSString* message);
void CloseWaitingProcessView(UIViewController* occurViewController);


void ShowWaitingProcessView2(UIView* occurView,NSString* message);
void CloseWaitingProcessView2(UIView* occurView);

void ShowGlobalWaitingProcessView(NSString* message);
void CloseGlobalWaitingProcessView();

/*************设置项目有关 start******************/
UIKeyboardType GetKeyboardTypeFromSettingsStr(NSString* keyboardTypeStr);

UITextAutocapitalizationType GetAutocapitalizationTypeFromSettingsStr(NSString* autocapitalizationTypeStr);

UITextAutocorrectionType GetAutocorrectionTypeFromSettingsStr(NSString* autocorrectionTypeStr);

NSString* GetSettingItemValue(NSString* settingItemKey);

void SetSettingItemValue(NSString *settingItemKey,id value);
/*************设置项目有关 end******************/