//
//  HealthManager.m
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "HealthManager.h"
#import <HealthKit/HealthKit.h>
#import "Define.h"

@interface HealthManager()
@property HKHealthStore *store;

@end


@implementation HealthManager

+(instancetype)sharedHealthManager {
    static HealthManager *sharedHealthManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedHealthManager = [[self alloc] init];
    });
    return sharedHealthManager;
}

- (id)init{
    self = [super init];
    if (self){
        self.store = [[HKHealthStore alloc] init];
    }
    return self;
}

-(void)authorizeWithCompletion:(void(^)(BOOL,NSError*))completion{
    NSSet *typesToRead = [NSSet setWithArray:@[
                                               [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                               [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]
                                               ]];
    if (![HKHealthStore isHealthDataAvailable]){
//        NSError *error = [NSError errorWithDomain:[@"com.linshiwei.healthkit" code:2 userInfo:@{NSLocalizedDescriptionKey:@"HealthKit is not available in this Device"}];
        completion(NO,NULL);
        return;
    }
    [_store requestAuthorizationToShareTypes:nil readTypes:typesToRead completion:^(BOOL success, NSError *error){
        completion(success,error);
    }];
    
    
}





-(NSDate*)getBeginningDateWithPeriodDataType:(enum PeriodDataType)type ofDate:(NSDate*)date{
    NSCalendar *calendar = [Define sharedDefine].calendar;
    switch (type) {
        case Current:
            return [calendar startOfDayForDate:date];
            break;
        case Specified:
            return [calendar startOfDayForDate:date];
            break;
        case Weekly:
            return [calendar dateByAddingUnit:NSCalendarUnitDay value:-6 toDate:date options:NSCalendarMatchStrictly];
        case Monthly:
            return [calendar dateByAddingUnit:NSCalendarUnitDay value:-6 toDate:date options:NSCalendarMatchStrictly];
        default:
            break;
    }
}
@end
