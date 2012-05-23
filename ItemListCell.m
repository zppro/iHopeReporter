//
//  ItemListCell.m
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "ItemListCell.h"


@implementation ItemListCell 


- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
	
    iconView.backgroundColor = [UIColor clearColor];
    itemNameLabel.backgroundColor = [UIColor clearColor];
	childrenNumIconView.backgroundColor = [UIColor clearColor];
    childrenNumLabel.backgroundColor = [UIColor clearColor]; 
	favoriteIconView.backgroundColor = [UIColor clearColor];
	
}


- (void) ControlSubViewHidden{
	childrenNumIconView.hidden = childrenNum < 0;
	childrenNumLabel.hidden = childrenNum < 0;
	favoriteIconView.hidden = !favorited;
}


- (void)setIcon:(UIImage *)newIcon
{
    [super setIcon:newIcon];
    iconView.image = newIcon;
}
- (void)setItemName:(NSString *)newItemName
{
    [super setItemName:newItemName];
    itemNameLabel.text = newItemName;
}

- (void)setChildrenNum:(NSInteger)newChildrenNum
{
    [super setChildrenNum:newChildrenNum];
    childrenNumLabel.text = [NSString stringWithFormat:@"%d", newChildrenNum];
}

- (void)setFavorited:(BOOL)newFavorited
{
    [super setFavorited:newFavorited];
}

- (void)dealloc {
	
	[iconView release]; 
	[itemNameLabel release]; 
	[childrenNumIconView release];
	[childrenNumLabel release];
	[favoriteIconView release];
    [super dealloc];
}

@end
