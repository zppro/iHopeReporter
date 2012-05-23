//
//  ItemListBaseCell.h
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface ItemListBaseCell : MyBaseTableViewCell {

	UIImage *icon;
	NSInteger childrenNum;
	BOOL favorited;
}

@property(retain) UIImage *icon;
@property NSInteger childrenNum;
@property BOOL favorited;

@end
