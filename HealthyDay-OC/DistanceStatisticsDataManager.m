//
//  DistanceStatisticsDataManager.m
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceStatisticsDataManager.h"

@interface DistanceStatisticsDataManager ()

@property (nonatomic) NSDate *currentDate;
@property NSDateInterval *dateInterval;


@end


@implementation DistanceStatisticsDataManager


+(instancetype)sharedStatisticsDataManager {
    static DistanceStatisticsDataManager *sharedStatisticsDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedStatisticsDataManager = [[self alloc] init];
    });
    return sharedStatisticsDataManager;
}

- (id)init{
    self = [super init];
    if (self){

    }
    return self;
}

- (NSDate *)currentDate{
    return [NSDate date];
}

- (void)setType:(enum StatisticsPeriod)type{
    _type = type;
    _dateInterval = [self getDateIntervalWithType:type];
}

#pragma mark Public API

- (NSArray<NSString *> *)getPeriodDescriptionText{
    switch (_type) {
        case Week:
            return [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
            break;
        case Month:{
            NSMutableArray<NSString *> *dayOfMonth = [NSMutableArray array];
            NSRange range = [[[Define sharedDefine] calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate];
            for (NSUInteger day=range.location; day<range.location+range.length; day++) {
                if (day ==1 || day%5 == 0) {
                    [dayOfMonth addObject:[NSString stringWithFormat:@"%lu",(unsigned long)day]];
                }else{
                    [dayOfMonth addObject:@"·"];
                }
            }
            return dayOfMonth;
            break;
        }
        case Year:
            return [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
            break;
        case All:{
            NSCalendar *calendar = [[Define sharedDefine] calendar];
            if (_distances.count == 0) {
                return [NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",[calendar component:NSCalendarUnitYear fromDate:[NSDate date]] + 1911]];
            }else{
                NSInteger firstYear = [calendar component:NSCalendarUnitYear fromDate:[_distances firstObject].date];
                NSInteger lastYear = [calendar component:NSCalendarUnitYear fromDate:[_distances lastObject].date];
                NSAssert(firstYear <= lastYear, @"firstYear should less than lastYear");
                NSMutableArray<NSString *> *years = [NSMutableArray array];
                for (NSInteger year = firstYear; year <= lastYear; year++) {
                    [years addObject:[NSString stringWithFormat:@"%ld",year+1911]];
                }
                return years;
            }
            break;
        }
        default:
            break;
    }
}

- (NSArray<NSNumber *> *)getDistanceStatistics{
    switch (_type) {
        case Week:
            return [self getWeekDistanceStatistics];
            break;
        case Month:
            return [self getMonthDistanceStatistics];
            break;
        case Year:
            return [self getYearDistanceStatistics];
            break;
        case All:
            return [self getAllDistanceStatistics];
            break;
        default:
            break;
    }
}

- (double)getTotalDistance{
    double totalDistance = 0.0l;
    for (DistanceDetailItem *item in _distances) {
        if ([_dateInterval containsDate:item.date]) {
            totalDistance += item.distance;
        }
    }
    return totalDistance;
}

- (int)getTotalDuration{
    int totalDuration = 0;
    for (DistanceDetailItem *item in _distances) {
        if ([_dateInterval containsDate:item.date]) {
            totalDuration += item.duration;
        }
    }
    return totalDuration;
}

- (int)getAverageDurationPerKilometer{
    int dataCount = 0;
    int totalDuration = 0;
    for (DistanceDetailItem *item in _distances) {
        if ([_dateInterval containsDate:item.date]) {
            totalDuration += item.duration;
            dataCount += 1;
        }
    }
    if (dataCount != 0) {
        totalDuration = totalDuration/dataCount;
    }
    return totalDuration;
}

- (double)getAverageSpeed{
    int durationPerKilometer = [self getAverageDurationPerKilometer];
    if (durationPerKilometer == 0) {
        return 0.0;
    }else{
        return 1000.0/(double)durationPerKilometer;
    }
}


#pragma mark Private func

- (NSDateInterval *)getDateIntervalWithType:(enum StatisticsPeriod)type{
    NSCalendar *calendar = [[Define sharedDefine] calendar];
    NSDate *currentDate = self.currentDate;
    NSDate *startDate;
    switch (type) {
        case Week:{
            if ([calendar component:NSCalendarUnitWeekday fromDate:currentDate]==1) {
                startDate = [calendar dateByAddingUnit:NSCalendarUnitWeekOfMonth value:-1 toDate:currentDate options:NSCalendarMatchStrictly];
            }else{
                NSDate *tempDate = [calendar dateBySettingUnit:NSCalendarUnitWeekday value:1 ofDate:currentDate options:NSCalendarSearchBackwards];
                startDate = [calendar dateByAddingUnit:NSCalendarUnitWeekOfMonth value:-1 toDate:tempDate options:NSCalendarMatchStrictly];
            }
            return [[NSDateInterval alloc] initWithStartDate:startDate duration:24*3600*7];
            break;
        }
        case Month:{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.year = [calendar component:NSCalendarUnitYear fromDate:currentDate];
            components.month = [calendar component:NSCalendarUnitMonth fromDate:currentDate];
            startDate = [calendar dateFromComponents:components];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
            return [[NSDateInterval alloc] initWithStartDate:startDate duration:24*3600*range.length];
            break;
        }
        case Year:{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.year = [calendar component:NSCalendarUnitYear fromDate:currentDate];
            startDate = [calendar dateFromComponents:components];
            NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:startDate options:NSCalendarSearchBackwards];
            return [[NSDateInterval alloc] initWithStartDate:startDate endDate:endDate];
            break;
        }
        case All:{
            return [[NSDateInterval alloc] initWithStartDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0] endDate:currentDate];
            break;
        }
        default:
            break;
    }
}

- (NSArray<NSNumber *> *)getWeekDistanceStatistics{
    NSMutableArray<NSNumber *> *results = [NSMutableArray array];
    double distance = 0.0;
    NSDate *focusDay = [_dateInterval startDate];
    for (DistanceDetailItem *item in _distances) {
        if ([_dateInterval containsDate:item.date]) {
            NSCalendar *calendar = [[Define sharedDefine] calendar];
            if ([calendar isDate:item.date inSameDayAsDate:focusDay]) {
                distance += item.distance;
            }else{
                do {
                    [results addObject:[NSNumber numberWithDouble:distance]];
                    distance = 0.0;
                    focusDay = [focusDay dateByAddingTimeInterval:3600*24];
                } while (![calendar isDate:item.date inSameDayAsDate:focusDay]);
                distance += item.distance;
            }
        }
    }
    [results addObject:[NSNumber numberWithDouble:distance]];
    while (results.count < 7) {
        [results addObject:[NSNumber numberWithDouble:0.0]];
    }
    NSAssert(results.count == 7, @"");
    return results;
}

- (NSArray<NSNumber *> *)getMonthDistanceStatistics{
    NSMutableArray<NSNumber *> *results = [NSMutableArray array];
    NSCalendar *calendar = [[Define sharedDefine] calendar];
    NSDate *currentDate = self.currentDate;

    double distance = 0.0;
    NSDate *focusDay = [_dateInterval startDate];
    for (DistanceDetailItem *item in _distances) {
        if ([_dateInterval containsDate:item.date]) {
            if ([calendar isDate:item.date inSameDayAsDate:focusDay]) {
                distance += item.distance;
            }else{
                do {
                    [results addObject:[NSNumber numberWithDouble:distance]];
                    distance = 0.0;
                    focusDay = [focusDay dateByAddingTimeInterval:3600*24];
                } while (![calendar isDate:item.date inSameDayAsDate:focusDay]);
                distance += item.distance;
            }
        }
    }
    [results addObject:[NSNumber numberWithDouble:distance]];
    while (results.count < [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate].length) {
        [results addObject:[NSNumber numberWithDouble:0.0]];
    }
    NSAssert(results.count == [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate].length, @"");
    return results;
}

- (NSArray<NSNumber *> *)getYearDistanceStatistics{
    NSMutableArray<NSNumber *> *results = [NSMutableArray array];
    double distance = 0.0;
    NSDate *focusMonth = [_dateInterval startDate];
    for (DistanceDetailItem *item in _distances) {
        if ([_dateInterval containsDate:item.date]) {
            NSCalendar *calendar = [[Define sharedDefine] calendar];
            if ([calendar isDate:item.date equalToDate:focusMonth toUnitGranularity:NSCalendarUnitMonth]) {
                distance += item.distance;
            }else{
                do {
                    [results addObject:[NSNumber numberWithDouble:distance]];
                    distance = 0.0;
                    focusMonth = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:focusMonth options:NSCalendarSearchBackwards];
                } while (![calendar isDate:item.date equalToDate:focusMonth toUnitGranularity:NSCalendarUnitMonth]);
                distance += item.distance;
            }
        }
    }
    [results addObject:[NSNumber numberWithDouble:distance]];
    while (results.count < 12) {
        [results addObject:[NSNumber numberWithDouble:0.0]];
    }
    NSAssert(results.count == 12, @"");
    return results;
}

- (NSArray<NSNumber *> *)getAllDistanceStatistics{
    if (_distances.count == 0) {
        return [NSArray arrayWithObject:[NSNumber numberWithDouble:0.0]];
    }else{
        NSMutableArray<NSNumber *> *results = [NSMutableArray array];
        NSCalendar *calendar = [[Define sharedDefine] calendar];
        double distance = 0.0;
        NSInteger year = [calendar component:NSCalendarUnitYear fromDate:_distances.firstObject.date];
        NSDate *focusYear = [calendar dateBySettingUnit:NSCalendarUnitYear value:year ofDate:_dateInterval.startDate options:NSCalendarSearchBackwards];
        for (DistanceDetailItem *item in _distances) {
            if ([_dateInterval containsDate:item.date]) {
                if ([calendar isDate:item.date equalToDate:focusYear toUnitGranularity:NSCalendarUnitYear]) {
                    distance += item.distance;
                }else{
                    do {
                        [results addObject:[NSNumber numberWithDouble:distance]];
                        distance = 0.0;
                        focusYear = [calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:focusYear options:NSCalendarSearchBackwards];
                    } while (![calendar isDate:item.date equalToDate:focusYear toUnitGranularity:NSCalendarUnitYear]);
                    distance += item.distance;
                }
            }
        }
        [results addObject:[NSNumber numberWithDouble:distance]];
        while (results.count < [calendar component:NSCalendarUnitYear fromDate:_distances.lastObject.date]-[calendar component:NSCalendarUnitYear fromDate:_distances.firstObject.date]+1) {
            [results addObject:[NSNumber numberWithDouble:0.0]];
        }
        NSAssert(results.count == [calendar component:NSCalendarUnitYear fromDate:_distances.lastObject.date]-[calendar component:NSCalendarUnitYear fromDate:_distances.firstObject.date]+1, @"");
        return results;
    }
    
}



@end
