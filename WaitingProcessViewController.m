    //
//  WaitingProcessViewController.m
//  iHopeReporter
//
//  Created by zppro on 11-3-10.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "WaitingProcessViewController.h"


@implementation WaitingProcessViewController

@synthesize spinner,spinnerContainer,messageLabel;

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

- (id) initWithMessage:(NSString*)newMessage{
	self = [super init];
	if(self){
		if(newMessage !=nil)
			message = newMessage;
	}
	return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	/*
	if(DeviceOrientation == UIInterfaceOrientationLandscapeLeft ||
	   DeviceOrientation == UIInterfaceOrientationLandscapeRight){
		self.view.frame = CGRectMake(0, 0, 1024, 748);
		spinnerContainer.frame = CGRectMake(372, 338, spinnerContainer.frame.size.width, spinnerContainer.frame.size.height);
	}
	 */
	
	CGFloat angle = 0.0;
    CGRect newFrame = self.view.window.frame;
	//NSLog(@"x:%f y:%f width:%f height:%f",newFrame.origin.x,newFrame.origin.y,newFrame.size.width,newFrame.size.height);
   
	if(DeviceOrientation == UIInterfaceOrientationLandscapeLeft){
		angle = - M_PI / 2.0f;
		newFrame.origin.x = -120;
		newFrame.origin.y = 128;
		newFrame.size.width = 1024;
		newFrame.size.height = 768;
	}else if(DeviceOrientation == UIInterfaceOrientationLandscapeRight) {
		angle = M_PI / 2.0f;
		newFrame.origin.x = -120;
		newFrame.origin.y = 128;
		newFrame.size.width = 1024;
		newFrame.size.height = 768;
	}
	else if(DeviceOrientation == UIInterfaceOrientationPortraitUpsideDown){
		angle = M_PI; 
		newFrame.size.width = 768;
		newFrame.size.height = 1004;
	}
	else {
		angle = 0.0;
		newFrame.size.width = 768;
		newFrame.size.height = 1004;
	}
	
	
	spinnerContainer.layer.cornerRadius = 6;
	spinnerContainer.layer.masksToBounds = YES;
    [spinnerContainer setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
	self.view.backgroundColor = [UIColor clearColor];
	messageLabel.text = message;
	spinner.hidesWhenStopped = YES;
	[spinner startAnimating];
	
	self.view.frame = newFrame;
	self.view.transform = CGAffineTransformMakeRotation(angle);


}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	/*
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||
		interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		spinnerContainer.frame = CGRectMake(372, 338, spinnerContainer.frame.size.width, spinnerContainer.frame.size.height); 
	}
	else {
		spinnerContainer.frame = CGRectMake(244, 466, spinnerContainer.frame.size.width, spinnerContainer.frame.size.height); 
	}
	*/
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
	[spinner release];
	[messageLabel release];
	[spinnerContainer release];
    [super dealloc];
}


@end
