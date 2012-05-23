    //
//  SettingsViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-24.
//  Copyright 2011 zppro.zhong. All rights reserved.
//
#define iSettingItemLabelTag 101
#define iSettingItemEditControlTag 102

#import "SettingsViewController.h"

@interface SettingsViewController(PRIVATE)

- (void) saveButtonToggled;

- (void) cancelButtonToggled;

@end

@implementation SettingsViewController
@synthesize delegate,listViewForSettings; 

static NSBundle *languageBundle = nil;
static NSString *settingsName = @"Root";

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//[listViewForSettings setAutoresizingMask: UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
	
	/*
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];*/
	self.title = @"首选项";
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	//listViewForSettings.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BackgroundImage_App]];
	
	UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//设置位置大小
	[saveButton setFrame:CGRectMake(0,0,60,30)];
	//设置圆角	
	saveButton.layer.cornerRadius = 6;
	saveButton.layer.masksToBounds = YES;
	//设置按钮上的文字  
	[saveButton setTitle:@"存储" forState:UIControlStateNormal];
	//设置按钮上文字的大小和颜色  
	[saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];  
	[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];  
	//设置按钮的图片  
	[saveButton setBackgroundImage:[UIImage imageNamed:@"redbuttonbg1"] forState:UIControlStateNormal];
	//设置代理
	[saveButton addTarget:self action:@selector(saveButtonToggled) forControlEvents:UIControlEventTouchUpInside];
	 	 					
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:saveButton] autorelease];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//设置位置大
	[cancelButton setFrame:CGRectMake(0,0,60,30)];
	//设置圆角
	cancelButton.layer.cornerRadius = 6;
	cancelButton.layer.masksToBounds = YES;
	//设置按钮上的文字  
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	//设置按钮上文字的大小和颜色  
	[cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];  
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];  
	//设置按钮的图片  
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"blackbuttonbg1"] forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"redbuttonbg1"] forState:UIControlStateHighlighted];  
	//设置代理
	[cancelButton addTarget:self action:@selector(cancelButtonToggled) forControlEvents:UIControlEventTouchUpInside];
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
	
	
	 
	NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
	
	settingGroups = [[NSMutableArray alloc] initWithCapacity:2];
	settingItems = [[NSMutableArray alloc] initWithCapacity:2];
	NSString *settingsName = @"Root";
    
	//获取当前语言所在的束
	NSString *pathRootForLocalization = [settingsBundle stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.lproj",[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]]];
	languageBundle = [NSBundle bundleWithPath:pathRootForLocalization];
	
	//获取设置项文件字典
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.plist",settingsName]]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    //NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *type = [prefSpecification objectForKey:@"Type"];
        if([type isEqualToString:vPSGroupSpecifier]){
			[settingGroups addObject:[languageBundle localizedStringForKey:[prefSpecification objectForKey:@"Title"] value:[prefSpecification objectForKey:@"Title"] table:settingsName]];
			NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:5];
			[settingItems addObject:items];
			[items release];
			 //[defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
		else{
			NSMutableArray *items = [settingItems objectAtIndex:([settingItems count]-1)];
			[items addObject: [NSMutableDictionary dictionaryWithDictionary:prefSpecification]];
		}
    }
}

#pragma mark -
#pragma mark 存储和取消
- (void) saveButtonToggled{

	for (int i= 0; i<[settingItems count]; i++) {
		for (int j=0; j<[[settingItems objectAtIndex:i] count]; j++) {
			NSDictionary *item = [[settingItems objectAtIndex:i] objectAtIndex:j];
			UITableViewCell *cell = [listViewForSettings cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
			if([[item objectForKey:@"Type"] isEqualToString:vPSTextFieldSpecifier]){
				//文本框
				UITextField* textFieldForValue = (UITextField*)[cell viewWithTag:iSettingItemEditControlTag];
				SetSettingItemValue([item objectForKey:@"Key"], textFieldForValue.text);
			}
		}
	}
	[self.delegate SettingsUpdated:self]; 
}

- (void) cancelButtonToggled{
	[self.delegate SettingsCanceled];
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [settingGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [(NSArray*)[settingItems objectAtIndex:section] count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [settingGroups objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SettingIdentifier";
	NSDictionary *item = [(NSArray*)[settingItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	UILabel *labelForTitle = nil;
	UITextField *textFieldForValue = nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		float widthForTitle = 168;
		float heightForTitle = cell.frame.size.height;
		float widthForValue = 350;
		
		labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0,widthForTitle , heightForTitle)];
		labelForTitle.backgroundColor = [UIColor clearColor];
		labelForTitle.tag = iSettingItemLabelTag;
		[cell.contentView addSubview:labelForTitle]; 
		[labelForTitle release];
		
		if([[item objectForKey:@"Type"] isEqualToString:vPSTextFieldSpecifier]){
			//文本框
			textFieldForValue = [[UITextField alloc] initWithFrame:CGRectMake(218, (heightForTitle-31) /2,widthForValue, 31)];
			textFieldForValue.backgroundColor = [UIColor clearColor];
			textFieldForValue.tag = iSettingItemEditControlTag;
			[cell.contentView addSubview:textFieldForValue]; 
			[textFieldForValue release];
		}
    } 

	
	//NSLog(@"%@",NSLocalizedStringFromTableInBundle([item objectForKey:@"Title"],nil));
	//cell.textLabel.text = [languageBundle localizedStringForKey:[item objectForKey:@"Title"] value:[item objectForKey:@"Title"] table:settingsName];
	//iSettingItemLabelTag 101
	//iSettingItemEditControlTag 
	
	labelForTitle = (UILabel*)[cell viewWithTag:iSettingItemLabelTag];
	labelForTitle.text = [languageBundle localizedStringForKey:[item objectForKey:@"Title"] value:[item objectForKey:@"Title"] table:settingsName];
	
	if([[item objectForKey:@"Type"] isEqualToString:vPSTextFieldSpecifier]){
		//文本框
		textFieldForValue = (UITextField*)[cell viewWithTag:iSettingItemEditControlTag];
		NSString *itemValue = GetSettingItemValue([item objectForKey:@"Key"]);
		if (itemValue==nil) {
			itemValue = [item objectForKey:@"DefaultValue"];
		}
		textFieldForValue.text = itemValue;
		textFieldForValue.keyboardType = GetKeyboardTypeFromSettingsStr([item objectForKey:@"KeyboardType"]);
		textFieldForValue.autocapitalizationType = GetAutocapitalizationTypeFromSettingsStr([item objectForKey:@"AutocapitalizationType"]);
		textFieldForValue.autocorrectionType = GetAutocorrectionTypeFromSettingsStr([item objectForKey:@"AutocorrectionType"]);
		textFieldForValue.secureTextEntry = [(NSNumber*)[item objectForKey:@"IsSecure"] boolValue];
	}
    return cell;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.navigationController pushViewController:targetViewController animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[listViewForSettings release];
	[settingGroups release];
	[settingItems release];
    [super dealloc];
}


@end
