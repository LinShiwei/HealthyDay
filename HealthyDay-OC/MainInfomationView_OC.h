//
//  MainInfomationView_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainInfoViewTapGestureDelegate.h"
#import "MainVCStateEnum.h"
#import "StepCountLabel_OC.h"
#import "DistanceWalkingRunningLabel_OC.h"
#import "BottomDecorativeCurve_OC.h"
#import "Theme.h"


@interface MainInfomationView_OC : UIView

@property (nonatomic) int stepCount;
@property (nonatomic) double distance;

@property id<MainInfoViewTapGestureDelegate> delegate;


- (void)panAnimationWithProgress:(CGFloat)progress currentState:(enum MainVCState)currentState;
- (void)refreshAnimation;

@end
