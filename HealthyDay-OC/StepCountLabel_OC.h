//
//  StepCountLabel_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepRingView_OC.h"

@interface StepCountLabel_OC : UILabel

@property (nonatomic) int stepCount;
@property (nonatomic) CGFloat subviewsAlpha;

- (id)initWithSize:(CGSize)size center:(CGPoint)center;


@end
