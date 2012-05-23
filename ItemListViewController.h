//
//  ItemListViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ItemListCell.h"
#import "EGORefreshTableHeaderView.h"

@interface ItemListViewController : MyBaseViewController
	<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView *listTableView;
	ItemListCell *listCell;
	EGORefreshTableHeaderView *refreshHeaderView;
	BOOL _reloading;
		BOOL isFinished;
	//UINib *cellNib;
}
@property (nonatomic,retain) IBOutlet UITableView *listTableView;
@property (nonatomic, retain) IBOutlet ItemListCell *listCell;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
