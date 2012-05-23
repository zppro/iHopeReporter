//
//  MyBaseTableViewCell.h
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface MyBaseTableViewCell : UITableViewCell {
	BOOL useDarkBackground;
	 
	NSString *itemName; 

}

@property BOOL useDarkBackground;

@property (retain) NSString* itemName;

@end
