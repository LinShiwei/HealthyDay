//
//  DistanceStatisticsViewController_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceStatisticsChartView_OC.h"
#import "DistanceDetailItem.h"
#import "DistanceStatisticsDataManager.h"
#import "Define.h"

@interface DistanceStatisticsViewController_OC : UIViewController

@property (nonatomic) NSArray<DistanceDetailItem *> *distanceDetailItem;

@end
