//
//  ReporterUser.h
//  iHopeReporter
//
//  Created by zppro on 11-3-11.
//  Copyright 2011 zppro.zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyBaseModel.h"

@interface ReporterUser : MyBaseModel {
	NSString *userID;
	NSString *userCode;
	NSString *userName;
	NSString *deptID;
	NSString *deptCode;
	NSString *deptName;
}

@property (nonatomic,retain) NSString *userID;
@property (nonatomic,retain) NSString *userCode;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *deptID;
@property (nonatomic,retain) NSString *deptCode;
@property (nonatomic,retain) NSString *deptName;

@end
