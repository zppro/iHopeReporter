    //
//  MyBaseViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "MyBaseViewController.h"
#import "Colors.h"

@implementation MyBaseViewController
@synthesize requestURL,dataFileName,allowSelectMore;

-(id)initWithTabBarSetTitle:(NSString*) title AndImage:(UIImage*) image{
	if ([self init]) {
		//this is the label on the tab button itself
		self.title = title;
		self.tabBarItem.title = title;
		//use whatever image you want and add it to your project
		self.tabBarItem.image = image;
		// set the long name shown in the navigation bar at the top
		//self.navigationItem.title=@"Nav LoginTab";
	}
	return self;
}

-(void) UpdateTitle:(NSString*)newTitle SynToTabBar:(BOOL) isSynToTabBar{
	if (isSynToTabBar==NO) {
		NSString* oldTitle = self.tabBarItem.title;
		self.title = newTitle;
		self.tabBarItem.title = oldTitle;
	}
	else {
		self.title = newTitle;
	}

}

- (void) setDataItems:(NSArray*)newDataItems{
	[newDataItems retain];
	[dataItems release];
	dataItems = newDataItems;
}


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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
	self.view.backgroundColor = DARK_BACKGROUND;
} 

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[requestURL release];
	[dataFileName release];
	[dataItems release];
    [super dealloc];
}


@end
