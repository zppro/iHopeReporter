//
//  CUIDropDownListView.h
//  iHopeReporter
//
//  Created by zppro on 11-3-16.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CUIDropDownListViewItem.h"
#import "Colors.h"

@class CUIDropDownListView;


@protocol CUIDropDownListViewDelegate

@optional

- (void) dropDownListView:(CUIDropDownListView*)viewItem didSelectViewItem:(CUIDropDownListViewItem *)viewItem;

- (void) dropDownListView:(CUIDropDownListView *)ddlView SelectedItemChanged:(CUIDropDownListViewItem *)viewItem;

- (CGFloat) dropDownListView:(CUIDropDownListView *)ddlView heightForViewItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CUIDropDownListViewDataSource

@optional

- (NSInteger)numberOfSectionsInDropDownListView:(CUIDropDownListView *)ddlView;

@required

- (NSInteger)dropDownListView:(CUIDropDownListView *)ddlView numberOfRowsInSection:(NSNumber*)section;

- (void)dropDownListView:(CUIDropDownListView *)ddlView customizeViewItem:(CUIDropDownListViewItem *)viewItem;


@end


@interface CUIDropDownListView : UIView <CUIDropDownListViewItemDelegate,UITableViewDelegate, UITableViewDataSource> {
	NSUInteger viewItemCount;
	NSArray *SelectedViewItems;
	UITableView *listView; 
	UIColor *lineColor;
	BOOL allowMultiSelect;
	BOOL allowInvertSelect;
    BOOL dropDownAreaDisplay;
    CGFloat lineWidth; 
    id<CUIDropDownListViewDelegate> delegate;
	id<CUIDropDownListViewDataSource> dataSource;
	CGSize viewItemSize;
}

@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, assign) id<CUIDropDownListViewDelegate> delegate;
@property (nonatomic, assign) id<CUIDropDownListViewDataSource> dataSource;
@property (nonatomic,readonly) CGSize viewItemSize;
@property (nonatomic,readonly) NSUInteger viewItemCount;
@property (nonatomic,readonly) NSArray *SelectedViewItems;
@property (nonatomic,assign) BOOL allowMultiSelect;
@property (nonatomic,assign) BOOL allowInvertSelect;

@property (nonatomic,assign) UIView *backgroundView;

-(void)setDropDownAreaDisplay:(BOOL)b;
-(BOOL)dropDownAreaDisplay;

-(void)setBackgroundView:(UIView*) newBackgroundView;
-(UIView*) backgroundView;



@end
