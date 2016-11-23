//
//  StepBarChartView_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVCStateEnum.h"
#import "StepBar_OC.h"
#import "Define.h"

@interface StepBarChartView_OC : UIView
@property (nonatomic) int destinationStepCount;

@property (nonatomic) NSArray<NSNumber *> *stepCounts;

- (void)panAnimationWithProgress:(CGFloat)progress currentState:(enum MainVCState)currentState;

@end
