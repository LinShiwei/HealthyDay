//
//  DistanceStatisticsChartView_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceStatisticsDataManager.h"
#import "DistanceStatisticsChartBar_OC.h"

@interface DistanceStatisticsChartView_OC : UIView

@property (nonatomic) NSArray<NSNumber *> *distanceStatistics;
@property enum StatisticsPeriod type;

@end
