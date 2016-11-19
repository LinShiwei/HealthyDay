//
//  HealthManager.h
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

enum PeriodDataType{
    Specified,
    Current,
    Weekly,
    Monthly
};

@interface HealthManager : NSObject

+ (instancetype)sharedHealthManager;

-(void)authorizeWithCompletion:(void(^)(BOOL,NSError*))completion;

-(void)readStepCountInDate:(NSDate*)date withPeriodDataType:(enum PeriodDataType)type withCompletion:(void(^)(NSInteger[],NSError*))completion;
-(void)readStepCountWithPeriodDataType:(enum PeriodDataType)type withCompletion:(void(^)(NSInteger[],NSError*))completion;

-(void)readDistanceWalkingRunningInDate:(NSDate*)date withPeriodType:(enum PeriodDataType)type withCompletion:(void(^)(NSInteger[],NSError*))completion;
-(void)readDistanceWalkingRunningWithPeriodType:(enum PeriodDataType)type withCompletion:(void(^)(NSInteger[],NSError*))completion;

-(void)readDetailStepCountInDate:(NSDate*)date withCompletion:(void(^)(HKSample[],NSError*))completion;
-(void)readDetailStepCountWithCompletion:(void(^)(HKSample[],NSError*))completion;

@end
