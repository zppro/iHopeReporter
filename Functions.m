//
//  Functions.m
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//
#define tagGlobalWaitingProcessView 12345671
#define tagWaitingProcessView 12345672

#import "Functions.h"
#import "AppDelegate_iPad.h"

void ShowInfo(NSString* message){
	UIAlertView *alertDialog=[[UIAlertView alloc] initWithTitle:@"信息" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertDialog show];
	[alertDialog release];
}

void ShowError(NSString* message){
	UIAlertView *alertDialog=[[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertDialog show];
	[alertDialog release];
}


id GetAppDelegate(){
	return [UIApplication sharedApplication].delegate;
}

void ShowWaitingProcessView(UIViewController* occurViewController,NSString* message){
	
	WaitingProcessViewController *vc= [[[WaitingProcessViewController alloc] initWithMessage:message] autorelease];
	[occurViewController.view addSubview:vc.view];
}

void CloseWaitingProcessView(UIViewController* occurViewController){
	UIView *waitingProcessView = [occurViewController.view.subviews lastObject];
	[waitingProcessView removeFromSuperview];
}

void ShowWaitingProcessView2(UIView* occurView,NSString* message){

	WaitingProcessViewController *vc= [[[WaitingProcessViewController alloc] initWithMessage:message] autorelease];
	vc.view.tag = tagWaitingProcessView;
	[occurView addSubview:vc.view];
}

void CloseWaitingProcessView2(UIView* occurView){
	UIView *waitingProcessView = [occurView viewWithTag:tagWaitingProcessView];
	[waitingProcessView removeFromSuperview];
} 
void ShowGlobalWaitingProcessView(NSString* message){
	WaitingProcessViewController *vc= [[[WaitingProcessViewController alloc] initWithMessage:message] autorelease];
	vc.view.tag = tagGlobalWaitingProcessView;
	[((AppDelegate_iPad*)[UIApplication sharedApplication].delegate).window addSubview:vc.view];
}

void CloseGlobalWaitingProcessView(){
	UIView *waitingProcessView = [((AppDelegate_iPad*)[UIApplication sharedApplication].delegate).window viewWithTag:tagGlobalWaitingProcessView];
	[waitingProcessView removeFromSuperview];
}

/*************设置项目有关 start******************/
UIKeyboardType GetKeyboardTypeFromSettingsStr(NSString* keyboardTypeStr){
	if ([keyboardTypeStr isEqualToString:@"Alphabet"]) {
		return UIKeyboardTypeAlphabet;
	}
	else if([keyboardTypeStr isEqualToString:@"NumbersAndPunctuation"]){
		return UIKeyboardTypeNumbersAndPunctuation;
	}
	else if([keyboardTypeStr isEqualToString:@"NumberPad"]){
		return UIKeyboardTypeNumberPad;
	}
	else if([keyboardTypeStr isEqualToString:@"URL"]){
		return UIKeyboardTypeURL;
	}
	else if([keyboardTypeStr isEqualToString:@"EmailAddress"]){
		return UIKeyboardTypeEmailAddress;
	}
	else {
		return UIKeyboardTypeDefault;
	}
}

UITextAutocapitalizationType GetAutocapitalizationTypeFromSettingsStr(NSString* autocapitalizationTypeStr){
	if ([autocapitalizationTypeStr isEqualToString:@"None"]) {
		return UITextAutocapitalizationTypeNone;
	}
	else if([autocapitalizationTypeStr isEqualToString:@"Sentences"]){
		return UITextAutocapitalizationTypeSentences;
	}
	else if([autocapitalizationTypeStr isEqualToString:@"Words"]){
		return UITextAutocapitalizationTypeWords;
	}
	else if([autocapitalizationTypeStr isEqualToString:@"AllCharacters"]){
		return UITextAutocapitalizationTypeAllCharacters;
	}
	else {
		return UITextAutocapitalizationTypeNone;
	}
	
}

UITextAutocorrectionType GetAutocorrectionTypeFromSettingsStr(NSString* autocorrectionTypeStr){
	if ([autocorrectionTypeStr isEqualToString:@"Default"]) {
		return UITextAutocorrectionTypeDefault;
	}
	else if([autocorrectionTypeStr isEqualToString:@"No"]){
		return UITextAutocorrectionTypeNo;
	}
	else if([autocorrectionTypeStr isEqualToString:@"Yes"]){
		return UITextAutocorrectionTypeYes;
	} 
	else {
		return UITextAutocorrectionTypeDefault;
	}
}

NSString* GetSettingItemValue(NSString* settingItemKey){
	return [[NSUserDefaults standardUserDefaults] stringForKey:settingItemKey];
}

void SetSettingItemValue(NSString *settingItemKey,id value){
	NSLog(@"%@ ,%@",settingItemKey,value);
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:settingItemKey];
}
/*************设置项目有关 end******************/