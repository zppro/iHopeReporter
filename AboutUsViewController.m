    //
//  AboutUsViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-11.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "AboutUsViewController.h"
@interface AboutUsViewController(PRIVATE)

- (void) toggleAboutView;

@end

@implementation AboutUsViewController

@synthesize textView;

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
	[textView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(toggleAboutView) forControlEvents:UIControlEventTouchUpInside]; 
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
	
}

- (void) SettingsUpdated:(SettingsViewController*)controller {
    
	[self dismissModalViewControllerAnimated:YES];
    ShowInfo(@"更改的应用程序首选项将在下次启动后生效");
}

- (void) SettingsCanceled{
	[self dismissModalViewControllerAnimated:YES];
}


- (void) toggleAboutView{
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(resetNoticeReceived:)
												 name:@"userRequestsReset"
											   object:nil];
	
	SettingsViewController *controller = [[[SettingsViewController alloc] init] autorelease];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	controller.delegate = self;
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
	[self presentModalViewController:navController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	
	/*
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||
		interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		textView.frame = CGRectMake(162, 174, textView.frame.size.width, textView.frame.size.height); 
	}
	else {
		textView.frame = CGRectMake(34, 302, textView.frame.size.width, textView.frame.size.height); 
	}*/
	
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
	[textView release];
    [super dealloc];
}


@end
