//
//  ItemDetailViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface ItemDetailViewController : MyBaseViewController <UIWebViewDelegate,CUIDropDownListViewDelegate,CUIDropDownListViewDataSource>{
	UIWebView *detailView;
	NSUInteger *detailViewFramesCount;
	NSString *selectedRequestUrlWhenAllowedSelectMore;//当开启允许切换开关allowSelectMore
	CUIDropDownListView * dropDownListView;

	UIToolbar *toolbar;
	UIBarItem *toolbarItemForPrint;
	UIBarItem *toolbarItemForFavorite;
	UIBarItem *toolbarItemForRefresh;
	UIBarItem *toolbarItemForDateTime;
	
	NSDictionary *currentDataItem;
}

@property (nonatomic, retain) IBOutlet UIWebView *detailView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarItem *toolbarItemForPrint;
@property (nonatomic, retain) IBOutlet UIBarItem *toolbarItemForFavorite;
@property (nonatomic, retain) IBOutlet UIBarItem *toolbarItemForRefresh;
@property (nonatomic, retain) IBOutlet UIBarItem *toolbarItemForDateTime;

- (void) setCurrentDataItem:(NSDictionary*)newCurrentDataItem;

- (IBAction) toolbarItemForPrintClicked:(id)sender;
- (IBAction) toolbarItemForFavoriteClicked:(id)sender;
- (IBAction) toolbarItemForRefreshClicked:(id)sender;
- (IBAction) toolbarItemForDateTimeClicked:(id)sender;

@end
