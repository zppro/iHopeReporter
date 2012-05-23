//
//  CUIDropDownListButton.h
//  iHopeReporter
//
//  Created by zppro on 11-3-16.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUIDropDownListButton;

@protocol DropDownListButtonDelegate

@optional

- (void) dropDownListButton:(CUIDropDownListButton*)ddlButton PickedValue:(NSString*)value;

@end


@interface CUIDropDownListButton : UIView {

}

@end
