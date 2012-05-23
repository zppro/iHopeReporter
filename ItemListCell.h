//
//  ItemListCell.h
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "ItemListBaseCell.h"

@interface ItemListCell : ItemListBaseCell {
	IBOutlet UIImageView *iconView;
	IBOutlet UILabel *itemNameLabel;
	IBOutlet UIImageView *childrenNumIconView;
    IBOutlet UILabel *childrenNumLabel;
	IBOutlet UIImageView *favoriteIconView;
}

- (void) ControlSubViewHidden;
@end
