//
//  HealthManager.m
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "HealthManager.h"
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

#pragma mark Public API
-(void)authorizeWithCompletion:(void(^)(BOOL,NSError* _Nullable))completion{
    NSSet *typesToRead = [NSSet setWithArray:@[
                                               [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],
                                               [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning]
                                               ]];
    if (![HKHealthStore isHealthDataAvailable]){
//        NSError *error = [NSError errorWithDomain:[@"com.linshiwei.healthkit" code:2 userInfo:@{NSLocalizedDescriptionKey:@"HealthKit is not available in this Device"}];
        completion(NO,nil);
        return;
    }
    [_store requestAuthorizationToShareTypes:nil readTypes:typesToRead completion:^(BOOL success, NSError *error){
        completion(success,error);
    }];
    
    
}

-(void)readStepCountInDate:(NSDate*)date withPeriodDataType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion{
    __block NSArray<NSNumber *> *stepCounts;
    HKSampleQuery *sampleQuery = [self createQuantitySampleQueryInDate:date typeIdentifier:HKQuantityTypeIdentifierStepCount periodDataType:type withCompletion:^(HKSampleQuery *query,NSArray<HKSample *> *samples,NSError *error){
        if (error == nil && samples != nil) {
            stepCounts = [self calculatePerDayDataFromAscendingSamples:samples typeIdentifier:HKQuantityTypeIdentifierStepCount periodDataType:type];
            completion(stepCounts,nil);
        }else{
            completion(nil,error);
        }
    }];
    [_store executeQuery:sampleQuery];
}

-(void)readStepCountWithPeriodDataType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion{
    [self readStepCountInDate:[NSDate date] withPeriodDataType:type withCompletion:completion];
}

-(void)readDistanceWalkingRunningInDate:(NSDate*)date withPeriodType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion{
    __block NSArray<NSNumber *> *distances;
    HKSampleQuery * sampleQuery = [self createQuantitySampleQueryInDate:date typeIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning periodDataType:type withCompletion:^(HKSampleQuery *query,NSArray<HKSample *> * samples,NSError * error){
        if (error == nil && samples != nil) {
            distances = [self calculatePerDayDataFromAscendingSamples:samples typeIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning periodDataType:type];
            completion(distances,nil);
        }else{
            completion(nil,error);

        }
    }];
    [_store executeQuery:sampleQuery];
}

-(void)readDistanceWalkingRunningWithPeriodType:(enum PeriodDataType)type withCompletion:(void(^)(NSArray<NSNumber *> * _Nullable,NSError* _Nullable))completion{
    [self readDistanceWalkingRunningInDate:[NSDate date] withPeriodType:type withCompletion:completion];
}


-(void)readDetailStepCountInDate:(NSDate*)date withCompletion:(void(^)(NSArray<HKSample *> * _Nullable,NSError* _Nullable))completion{
    HKSampleQuery *detailSampleQuery = [self createQuantitySampleQueryInDate:date typeIdentifier:HKQuantityTypeIdentifierStepCount periodDataType:Specified withCompletion:^(HKSampleQuery *query,NSArray<HKSample *> *samples,NSError *error){
        if (error == nil && samples != nil) {
            completion(samples,nil);
        }else{
            completion(nil,error);
        }
    }];
    [_store executeQuery:detailSampleQuery];
}


#pragma mark Private Help Func
- (HKSampleQuery *)createQuantitySampleQueryInDate:(NSDate*)date typeIdentifier:(HKQuantityTypeIdentifier)identifier periodDataType:(enum PeriodDataType)type withCompletion:(void(^)(HKSampleQuery*,NSArray<HKSample *> * _Nullable,NSError* _Nullable))completion{
    NSDate *beginningDate = [self getBeginningDateWithPeriodDataType:type ofDate:date];
    NSDate *endDate = (type == Specified)? [beginningDate dateByAddingTimeInterval:24*3600] : date;
    HKQuantityType *readingType = [HKQuantityType quantityTypeForIdentifier:identifier];
    NSPredicate *currentDayPerdicate = [HKQuery predicateForSamplesWithStartDate:beginningDate endDate:endDate options:HKQueryOptionNone];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:true];
    return [[HKSampleQuery alloc] initWithSampleType:readingType predicate:currentDayPerdicate limit:HKObjectQueryNoLimit sortDescriptors:[NSArray arrayWithObject:sortDescriptor] resultsHandler:completion];
}

- (NSArray<NSNumber *>*)calculatePerDayDataFromAscendingSamples:(NSArray<HKSample *> *)samples typeIdentifier:(HKQuantityTypeIdentifier)identifier periodDataType:(enum PeriodDataType)type{
    HKUnit *unit = [HKUnit countUnit];
    if (identifier == HKQuantityTypeIdentifierStepCount){
        unit = [HKUnit countUnit];
    }else{
        if (identifier == HKQuantityTypeIdentifierDistanceWalkingRunning) {
            unit = [HKUnit meterUnit];
        }else{
            
        }
    }
    NSMutableArray *counts;
    int count = 0;
    NSDate *perDay = [NSDate dateWithTimeInterval:24*3600 sinceDate:[[Define sharedDefine].calendar startOfDayForDate:[samples[0] endDate]]];
    for (HKSample *sample in samples){
        if ([[sample endDate] compare:perDay] == NSOrderedAscending){
            count += [[(HKQuantitySample*)sample quantity] doubleValueForUnit:unit];
        }else{
            NSTimeInterval interval = [[sample endDate] timeIntervalSinceDate:[sample startDate]];
            if ([[[sample startDate] dateByAddingTimeInterval:interval] compare:perDay] == NSOrderedAscending) {
                count += [[(HKQuantitySample*)sample quantity] doubleValueForUnit:unit];
                [counts addObject:[NSNumber numberWithInt:count]];
                count = 0;
            }else{
                [counts addObject:[NSNumber numberWithInt:count]];
                count = [[(HKQuantitySample*)sample quantity] doubleValueForUnit:unit];
            }
            perDay = [NSDate dateWithTimeInterval:24*3600 sinceDate:perDay];
        }
    }
    [counts addObject:[NSNumber numberWithInt:count]];
    switch (type) {
        case Current:
        case Specified:
            NSAssert([counts count] <= 1,@"counts.count <=1");
            break;
        case Weekly:
            NSAssert([counts count] <= 7,@"counts.count <=7");
            break;
        case Monthly:
            NSAssert([counts count] <= 30,@"counts.count <=30");
            break;
        default:
            break;
    }
    return counts;
}

- (NSDate*)getBeginningDateWithPeriodDataType:(enum PeriodDataType)type ofDate:(NSDate*)date{
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
