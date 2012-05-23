//
//  NetWorkChecker.m
//  iHopeReporter
//
//  Created by zppro on 11-3-14.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import "NetWorkChecker.h"

@interface NetWorkChecker(PRIVATE)

- (void) reachabilityChanged:(NSNotification* )note;

- (void) NotifyInterfaceWithReachability: (Reachability*) curReach;
	
@end

@implementation NetWorkChecker

- (void) StartListening{
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	NSLog(@"%@",gHostName);
	hostReach = [[Reachability reachabilityWithHostName: gHostName] retain];
	[hostReach startNotifier];
	//[self NotifyInterfaceWithReachability: hostReach];
	
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);

	[self NotifyInterfaceWithReachability:curReach];
}

- (void) NotifyInterfaceWithReachability: (Reachability*) curReach{
	
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	BOOL connected = NO;
    BOOL connectionRequired= [curReach connectionRequired];
    NSString* statusString= nil;
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"无法请求到目标服务器，请检测您的联网情况!";
			connectionRequired= NO;  
            break;
        }
            
        case ReachableViaWWAN:
        {
			if(connectionRequired)
			{
				statusString= @"您的蜂窝网络没有起用";
			}
			else{
				connected=YES;
			}
            break;
        }
        case ReachableViaWiFi:
        {
			if(connectionRequired)
			{
				statusString= @"您的wifi没有起用";
			}
			else {
				connected=YES;
			}
            break;
		}
    }
	
	if(connected==NO){
		ShowError(statusString);
	} 
	//[statusString release];
}

static NetWorkChecker *mySharedOne = nil;

+ (NetWorkChecker*)sharedOne
{
    if (mySharedOne == nil) {
        mySharedOne = [[super allocWithZone:NULL] init];
    }
    return mySharedOne;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedOne] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
