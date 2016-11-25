//
//  DistanceStatisticsChartView_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceStatisticsChartView_OC.h"

@interface DistanceStatisticsChartView_OC (){
    double maxDistance;
    DistanceStatisticsDataManager *statisticsManager;
}

@end


@implementation DistanceStatisticsChartView_OC

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        statisticsManager = [DistanceStatisticsDataManager sharedStatisticsDataManager];
    }
    return self;
}

- (void)setDistanceStatistics:(NSArray<NSNumber *> *)distanceStatistics{
    _distanceStatistics = distanceStatistics;
    maxDistance = 0.0;
    for (NSNumber *value in distanceStatistics) {
        if (maxDistance < value.doubleValue) {
            maxDistance = value.doubleValue;
        }
    }
    [self initStatisticsChartWithStatisticsData:distanceStatistics];
}

- (void)initStatisticsChartWithStatisticsData:(NSArray<NSNumber *> *)data{
    
    int barCount = 0;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[DistanceStatisticsChartBar_OC class]]) {
            barCount += 1;
        }
    }
    if (barCount != data.count || _type == Year) {
        [self checkTypeAndDataMatching:data];
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[DistanceStatisticsChartBar_OC class]]) {
                [view removeFromSuperview];
            }
        }
        NSArray<NSString *> *titles = [statisticsManager getPeriodDescriptionText];
        NSAssert(titles.count == data.count, @"");
        
        CGFloat barWidth;
        CGFloat startXPosition;
        if (_type == All) {
            barWidth = self.frame.size.width/(CGFloat)(data.count + 4);
            startXPosition = barWidth*2;
        }else{
            barWidth = self.frame.size.width/(CGFloat)data.count;
            startXPosition = 0;
        }
        for (NSInteger count=0; count < data.count; count++) {
            DistanceStatisticsChartBar_OC *chartBar = [[[NSBundle mainBundle] loadNibNamed:@"DistanceStatisticsChartBar_OC" owner:self options:NULL] firstObject];
            chartBar.frame = CGRectMake(startXPosition+count*barWidth, 0, barWidth, self.frame.size.height);
            if (maxDistance == 0.0 || data[count].doubleValue == 0) {
                chartBar.barHeight = 0;
            }else{
                chartBar.barHeight = (self.frame.size.height-22-5)*data[count].doubleValue/maxDistance;
            }
            chartBar.barTitle = titles[count];
            chartBar.barInfo = @"";
            if ([chartBar.barTitle isEqual: @""]) {
                [self insertSubview:chartBar atIndex:0];
            }else{
                [self addSubview:chartBar];
            }
        }
    }else{
        return;
    }
}

- (void)checkTypeAndDataMatching:(NSArray<NSNumber *> *)data{
    switch (_type) {
        case Week:
            NSAssert(data.count==7, @"");
            break;
        case Month:
            NSAssert(data.count > 27, @"");
            break;
        case Year:
            NSAssert(data.count == 12, @"");
            break;
        default:
            break;
    }
}
@end
