//
//  CUIDropDownListItem.m
//  iHopeReporter
//
//  Created by zppro on 11-3-16.
//  Copyright 2011 zppro.zhong. All rights reserved.
//


#define kItemLabelValue @"ITEM_NAME"
#define iSelectedFlagViewTag 9998
#define iContentViewTag 9999
#define iImageName @"flag.png"

#import "CUIDropDownListViewItem.h"

@interface CUIDropDownListViewItem(PRIVATE)
-(void)drawView;
@end

@implementation CUIDropDownListViewItem
@synthesize contentView,delegate,indexPath;

- (id)initWithFrame:(CGRect)frame{
    
	if(frame.size.width<MIN_WIDH_FOR_VIEW_ITEM)
		frame.size.width = MIN_WIDH_FOR_VIEW_ITEM;
	if(frame.size.height<MIN_HEIGHT_FOR_VIEW_ITEM)
		frame.size.height = MIN_HEIGHT_FOR_VIEW_ITEM;
	
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        
        selected = NO;
        self.backgroundColor = [UIColor yellowColor];
        [self drawView];
		
    }
    return self;
} 
- (void)drawView
{
	UILabel *selectedFlagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, self.frame.size.height)];
	if (selected==YES) {
		selectedFlagLabel.text = @"✔";
	}
	selectedFlagLabel.textAlignment = UITextAlignmentCenter;

	selectedFlagLabel.tag = iSelectedFlagViewTag;
	[self addSubview:selectedFlagLabel];
	[selectedFlagLabel release];
	
	contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-20, self.frame.size.height)];
	contentView.tag = iContentViewTag;
	contentView.backgroundColor = selectedFlagLabel.backgroundColor;
	[self addSubview:contentView];
	[contentView release];
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


-(BOOL)selected
{
    return selected;
}
-(void)setSelected:(BOOL)b
{
	if(selected!=b){
		
		UILabel *selectedLabelView = (UILabel*)[self viewWithTag:iSelectedFlagViewTag];

		if (b)
		{
			//从no-yes 
			selectedLabelView.text = @"✔";
		}
		else 
		{
			//从yes-no
			selectedLabelView.text = @"";
		}
		BOOL oldSelected = selected;
		selected = b;
		if (delegate != nil)
		{  
			if([(id)delegate respondsToSelector:@selector(dropDownListViewIem:SelectedChangeFrom:)]){
				
				[(id)delegate performSelector:@selector(dropDownListViewIem:SelectedChangeFrom:) withObject:self withObject:[NSNumber numberWithBool:oldSelected]];
			}
		}
		[self setNeedsDisplay];
	}
}
 
- (void)dealloc {
	[contentView release];
    [super dealloc];
}


@end
