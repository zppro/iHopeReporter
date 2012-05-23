//
//  UIDropDownListView.m
//  iHopeReporter
//
//  Created by zppro on 11-3-15.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "CUIDropDownListField.h"

@interface CUIDropDownListField(PRIVATE)
	-(void)drawView;
	-(void)dropdown;
@end

@implementation CUIDropDownListField
@synthesize textField,dataItems,listView,lineColor,listBackColor,borderStyle,delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		// Initialization code
        dataItems = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
        borderStyle = UITextBorderStyleRoundedRect;
        
        dropDownAreaDisplay = NO;
        oldFrame = frame;
        newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*5);
        
        lineColor = [UIColor lightGrayColor];
        listBackColor = [UIColor whiteColor];
        lineWidth = 1;
        
        self.backgroundColor = [UIColor clearColor];
        [self drawView];
    }
    return self;
}

-(void)dropdown
{
    [textField resignFirstResponder];
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
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, oldFrame.size.width, oldFrame.size.height)];
    textField.borderStyle = borderStyle;
    [self addSubview:textField];
    [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllEvents];
    
    listView = [[UITableView alloc]initWithFrame:CGRectMake(lineWidth, oldFrame.size.height+lineWidth, oldFrame.size.width-lineWidth*2, oldFrame.size.height*4-lineWidth*2)];
    listView.dataSource = self;
    listView.delegate = self;
    listView.backgroundColor = listBackColor;
    listView.separatorColor = lineColor;
    listView.hidden = !dropDownAreaDisplay;
    [self addSubview:listView];
    [listView release];
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ListCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = (NSString *)[dataItems objectAtIndex:indexPath.row];
    //cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = textField.font;
    
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return oldFrame.size.height;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    textField.text = (NSString*)[dataItems objectAtIndex:indexPath.row];
    [self setDropDownAreaDisplay:NO];
    if (delegate != nil)
    {  
		if([(id)delegate respondsToSelector:@selector(dropDownListField:PickedValue:)]){
			[(id)delegate performSelector:@selector(dropDownListField:PickedValue:) withObject:self withObject:textField.text];
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
    if (b)
    {
        self.frame = newFrame;
    }
    else 
    {
        self.frame = oldFrame;
    }
    listView.hidden = !b;
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect drawRect;
    if (dropDownAreaDisplay)
    {
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        drawRect = listView.frame;
        CGContextStrokeRect(ctx, drawRect);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[textField release];
	[lineColor release];
	[listBackColor release];
	[listView release]; 
	[dataItems release];
	
	[super dealloc];
}


@end
