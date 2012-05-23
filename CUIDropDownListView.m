//
//  CUIDropDownListView.m
//  iHopeReporter
//
//  Created by zppro on 11-3-16.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#define MAX_WIDTH 700
#define MAX_HEIGHT 500
#define ListView_LandscapeMargin 20
#define ListView_PortraitTopMargin 40
#define ListView_PortraitBottomMargin 20

#define iDropDownListBackgroundViewTag 998
#define iDropDownListViewItemTag 999

#import "CUIDropDownListView.h"

@interface CUIDropDownListView(PRIVATE)    
	-(void)drawView;
	-(void)dropdown;
@end

@implementation CUIDropDownListView
@synthesize lineColor,delegate,dataSource,viewItemSize,viewItemCount,SelectedViewItems,allowMultiSelect,allowInvertSelect;



- (id)initWithFrame:(CGRect)frame{
    if(frame.size.width>MAX_WIDTH)
		frame.size.width = MAX_WIDTH;
	if(frame.size.height>MAX_HEIGHT)
		frame.size.height = MAX_HEIGHT;
    self = [super initWithFrame:frame];
    if (self) {
		NSLog(@"%f" ,frame.origin.y);
        // Initialization code. 
		[self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
		
        dropDownAreaDisplay = NO;
        lineColor = [UIColor lightGrayColor]; 
        lineWidth = 1;
        self.backgroundColor = MF_RGBA(57,23,9,1.0);
		SelectedViewItems = [[NSMutableArray alloc] initWithCapacity:10];
        [self drawView];
    }
    return self;
}

-(void)dropdown
{
    if (dropDownAreaDisplay) {
        return;
    }
    else {
        [self.superview bringSubviewToFront:self];
        [self setDropDownAreaDisplay:YES];
    }
	
}

- (void)drawView
{
	CGFloat width = self.frame.size.width - ListView_LandscapeMargin*2;	
	CGFloat height = self.frame.size.height - ListView_PortraitTopMargin - ListView_PortraitBottomMargin;
	
	viewItemSize = CGSizeMake(width,MIN_HEIGHT_FOR_VIEW_ITEM);
	
    listView = [[UITableView alloc]initWithFrame:CGRectMake(ListView_LandscapeMargin, ListView_PortraitTopMargin, width, height)];
    listView.dataSource = self;
    listView.delegate = self;
    listView.backgroundColor = [UIColor whiteColor]; 
    listView.separatorColor = lineColor;
	listView.layer.cornerRadius = 6;
	listView.layer.masksToBounds = YES;
    [self addSubview:listView];
    [listView release];
}
 

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count = 0;
	if([(id)dataSource respondsToSelector:@selector(dropDownListView:numberOfRowsInSection:)]){
		count = [dataSource dropDownListView:self numberOfRowsInSection:[NSNumber numberWithInt:section]];
	}
	viewItemCount = count;
	return count;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{ 
	CGFloat viewItemHeight = MIN_HEIGHT_FOR_VIEW_ITEM;
	if (delegate != nil)
    {  
		if([(id)delegate respondsToSelector:@selector(dropDownListView:heightForViewItemAtIndexPath:)]){
			viewItemHeight = [delegate dropDownListView:self heightForViewItemAtIndexPath:indexPath];
		}
	} 
	viewItemSize.height = viewItemHeight;
    return viewItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListViewItemIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    } 
	CUIDropDownListViewItem *viewItem = [[CUIDropDownListViewItem alloc] initWithFrame:CGRectMake(0, 0, self.viewItemSize.width,self.viewItemSize.height)];
	viewItem.delegate = self;
	viewItem.tag = iDropDownListViewItemTag;
	NSLog(@"indexPath retainCount:%d",[indexPath retainCount]);
	viewItem.indexPath = indexPath;
	NSLog(@"indexPath retainCount:%d",[indexPath retainCount]);
	[dataSource dropDownListView:self customizeViewItem:viewItem];
	
	[cell.contentView addSubview:viewItem]; 
	
	[viewItem release];
	viewItem = nil;

    return cell;
}



-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	CUIDropDownListViewItem *viewItem = (CUIDropDownListViewItem *)[cell.contentView viewWithTag:iDropDownListViewItemTag];
	BOOL oldViewItemSelected = viewItem.selected;
	
	/* 理论上应该相等，此处先保留
	if (viewItem.indexPath != indexPath) {
		NSLog(@"indexPath retainCount:%d",[indexPath retainCount]);
		viewItem.indexPath = indexPath;
		NSLog(@"indexPath retainCount:%d",[indexPath retainCount]);
	}
	*/
	
	if(allowInvertSelect==YES){
		viewItem.selected = !viewItem.selected;
	}
	else{
		if (oldViewItemSelected==NO) {
			viewItem.selected = YES;
		}
	}
	
    if (delegate != nil)
    {  
		if([(id)delegate respondsToSelector:@selector(dropDownListView:didSelectViewItem:)]){
			[(id)delegate performSelector:@selector(dropDownListView:didSelectViewItem:) withObject:self withObject:viewItem];
		}
		
		if (oldViewItemSelected != viewItem.selected) {
			if([(id)delegate respondsToSelector:@selector(dropDownListView:SelectedItemChanged:)]){
				[(id)delegate performSelector:@selector(dropDownListView:SelectedItemChanged:) withObject:self withObject:viewItem];
			}
		}
	}
	[self setDropDownAreaDisplay:NO];
}

#pragma mark -
#pragma mark CUIDropDownListViewItemDelegate代理

- (void)dropDownListViewIem:(CUIDropDownListViewItem*)listViewItem SelectedChangeFrom:(NSNumber*) before{
	BOOL oldSelected = [before boolValue];
	if (oldSelected == YES) {
		//将viewItem .selected 从yes->no
		if (allowInvertSelect == YES) {
			//允许反选
			int index = [(NSMutableArray*)SelectedViewItems indexOfObject:listViewItem];
			if (index>=0 && index < [SelectedViewItems count]) {
				[(NSMutableArray*)SelectedViewItems removeObjectAtIndex:index];
			}
		}
	}
	else {
		//将viewItem .selected 从no->yes
		if (allowMultiSelect==YES) {
			//允许多选
			[(NSMutableArray*)SelectedViewItems addObject:listViewItem];
		}
		else {
			//只允许单选,去掉以选SelectedViewItems 数组中的所有元素
			for (int index=0; index<[SelectedViewItems count]; index++) {
				((CUIDropDownListViewItem*)[SelectedViewItems objectAtIndex:index]).selected = NO;
			}
			[(NSMutableArray*)SelectedViewItems removeAllObjects];
			[(NSMutableArray*)SelectedViewItems addObject:listViewItem];
		}
	}

}

-(BOOL)dropDownAreaDisplay
{
    return dropDownAreaDisplay;
}
-(void)setDropDownAreaDisplay:(BOOL)b
{
    dropDownAreaDisplay = b;
    self.hidden = !b;
}

-(UIView*) backgroundView{
	return [self viewWithTag:iDropDownListBackgroundViewTag];
}
-(void)setBackgroundView:(UIView*) newBackgroundView{
	UIView *backgroundView = [self viewWithTag:iDropDownListBackgroundViewTag];
	if (backgroundView !=nil) {
		[backgroundView removeFromSuperview];
	}
	self.backgroundColor = [UIColor clearColor];
	newBackgroundView.tag = iDropDownListBackgroundViewTag;
	newBackgroundView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
	//NSLog(@"x:%f y:%f width:%f height:%f",newBackgroundView.frame.origin.x,newBackgroundView.frame.origin.y,newBackgroundView.frame.size.width,newBackgroundView.frame.size.height);
	[self insertSubview:newBackgroundView atIndex:0];
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect drawRect;
	CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
	
	//重置listview高度
	float newHeightForListView = viewItemSize.height*viewItemCount;
	if (newHeightForListView > MAX_HEIGHT - ListView_PortraitTopMargin*2 - ListView_PortraitBottomMargin*2) {
		newHeightForListView = MAX_HEIGHT - ListView_PortraitTopMargin*2 - ListView_PortraitBottomMargin*2;
	}
	listView.frame = CGRectMake(listView.frame.origin.x, listView.frame.origin.y, listView.frame.size.width, newHeightForListView);
	float newHeightForSelf = listView.frame.size.height+ListView_PortraitTopMargin+ListView_PortraitBottomMargin;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeightForSelf);
	
	self.layer.cornerRadius = 6;
	self.layer.masksToBounds = YES;
	
	drawRect = self.frame;
	CGContextStrokeRect(ctx, drawRect);
	
   // if (dropDownAreaDisplay)
//    {
//        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
//        drawRect = listView.frame;
//        CGContextStrokeRect(ctx, drawRect);
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[listView release];
	[lineColor release]; 
	[SelectedViewItems release];
    [super dealloc];
}



@end
