//
//  HealthManager.h
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

enum PeriodDataType{
    Specified,
    Current,
    Weekly,
    Monthly
};

@interface HealthManager : NSObject
NS_ASSUME_NONNULL_BEGIN
+ (instancetype)sharedHealthManager;

-(void)authorizeWithCompletion:(void(^)(BOOL,NSError* _Nullable))completion;

-(void)readStepCountInDate:(NSDate*)date withPeriodDataType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion;
-(void)readStepCountWithPeriodDataType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion;

-(void)readDistanceWalkingRunningInDate:(NSDate*)date withPeriodType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion;
-(void)readDistanceWalkingRunningWithPeriodType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion;

-(void)readDetailStepCountInDate:(NSDate*)date withCompletion:(void(^)(NSArray<HKSample *> * _Nullable,NSError * _Nullable))completion;
NS_ASSUME_NONNULL_END
@end
