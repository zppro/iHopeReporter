//
//  UIDropDownListView.h
//  iHopeReporter
//
//  Created by zppro on 11-3-15.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CUIDropDownListField;

@protocol DropDownListFieldDelegate

@optional

- (void) dropDownListField:(CUIDropDownListField*)ddlField PickedValue:(NSString*)value;

@end


@interface CUIDropDownListField : UIView <UITableViewDelegate, UITableViewDataSource>{
	UITextField *textField;
    UITableView *listView;
    NSArray *dataItems;
    BOOL dropDownAreaDisplay;
    CGRect oldFrame, newFrame;
    UIColor *lineColor, *listBackColor;
    CGFloat lineWidth;
    UITextBorderStyle borderStyle;
    id<DropDownListFieldDelegate>delegate;
}

@property (nonatomic, retain) UITextField* textField;
@property (nonatomic, retain) NSArray *dataItems;
@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, retain) UIColor *lineColor, *listBackColor;
@property (nonatomic, assign) UITextBorderStyle borderStyle;
@property (nonatomic, assign) id<DropDownListFieldDelegate> delegate;


-(void)setDropDownAreaDisplay:(BOOL)b;

@end
