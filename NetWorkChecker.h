//
//  NetWorkChecker.h
//  iHopeReporter
//
//  Created by zppro on 11-3-14.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Common.h"

@interface NetWorkChecker : NSObject {
	Reachability* hostReach;
}

+ (NetWorkChecker*)sharedOne;

- (void) StartListening;

@end
