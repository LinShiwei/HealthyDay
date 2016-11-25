//
//  DistanceStatisticsDataManager.h
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistanceDetailItem.h"
#import "Define.h"

enum StatisticsPeriod{
    Week,Month,Year,All
};

@interface DistanceStatisticsDataManager : NSObject

+ (instancetype)sharedStatisticsDataManager;

@property NSArray<DistanceDetailItem *> *distances;
@property (nonatomic) enum StatisticsPeriod type;

- (NSArray<NSString *> *)getPeriodDescriptionText;
- (NSArray<NSNumber *> *)getDistanceStatistics;
- (double)getTotalDistance;
- (int)getTotalDuration;
- (int)getAverageDurationPerKilometer;
- (double)getAverageSpeed;

@end
