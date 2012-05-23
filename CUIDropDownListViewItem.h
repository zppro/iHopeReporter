//
//  CUIDropDownListItem.h
//  iHopeReporter
//
//  Created by zppro on 11-3-16.
//  Copyright 2011 zppro.zhong. All rights reserved.
//
#define MIN_WIDH_FOR_VIEW_ITEM 150.0
#define MIN_HEIGHT_FOR_VIEW_ITEM 30.0
#import <UIKit/UIKit.h>

@class CUIDropDownListViewItem;

@protocol CUIDropDownListViewItemDelegate

@required

- (void)dropDownListViewIem:(CUIDropDownListViewItem*)listViewItem SelectedChangeFrom:(NSNumber*) before;

@end

@interface CUIDropDownListViewItem : UIView {
	BOOL selected;
	NSIndexPath *indexPath;
	UIView *contentView;
	id<CUIDropDownListViewItemDelegate> delegate;
}

@property (nonatomic, assign) id<CUIDropDownListViewItemDelegate> delegate;
@property (nonatomic, assign) NSIndexPath *indexPath;

-(BOOL) selected;
-(void)setSelected:(BOOL)b;

@property (nonatomic,readonly) UIView *contentView;

@end
