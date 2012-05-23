//
//  MyBaseViewController.h
//  iHopeReporter
//
//  Created by zppro on 11-3-8.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyBaseViewController : UIViewController {
	NSString *requestURL;
	NSString *dataFileName;
	BOOL allowSelectMore;
	NSArray *dataItems;
}

@property (nonatomic,retain) NSString *requestURL;
@property (nonatomic,retain) NSString *dataFileName;
@property BOOL allowSelectMore;//是否在右上角切换同级

-(id)initWithTabBarSetTitle:(NSString*) title AndImage:(UIImage*) image;
- (void) setDataItems:(NSArray*)newDataItems;

-(void) UpdateTitle:(NSString*)newTitle SynToTabBar:(BOOL) isSynToTabBar;
@end
