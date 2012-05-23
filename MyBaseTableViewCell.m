//
//  MyBaseTableViewCell.m
//  iHopeReporter
//
//  Created by zppro on 11-3-9.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "MyBaseTableViewCell.h"


@implementation MyBaseTableViewCell

@synthesize useDarkBackground,itemName;


- (void)setUseDarkBackground:(BOOL)flag
{
    if (flag != useDarkBackground || !self.backgroundView)
    {
        useDarkBackground = flag;
        //NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:useDarkBackground ? DARK_BACKGROUND_PNG : LIGHT_BACKGROUND_PNG ofType:@"png"];		
        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"item_bg1" ofType:@"png"];
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
    }
}

/*
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}
*/

- (void)dealloc {
	[itemName release];
    [super dealloc];
}


@end
