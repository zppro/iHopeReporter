//
//  ItemListBaseCell.m
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "ItemListBaseCell.h"


@implementation ItemListBaseCell
@synthesize icon,childrenNum,favorited;

- (void)dealloc {
	
	[icon release];
    [super dealloc];
}
@end
