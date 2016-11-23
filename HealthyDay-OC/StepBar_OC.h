//
//  StepBar_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

@interface StepBar_OC : UIView

@property (nonatomic) NSString *day;
@property (nonatomic) int stepCount;

- (id)initWithFrame:(CGRect)frame destinationStepCount:(int)destinationStepCount;

@end
