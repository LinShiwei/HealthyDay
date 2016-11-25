//
//  StepRingView_OC.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepRingView_OC : UIView

@property (nonatomic) double percent;

- (id)initWithSize:(CGSize)size center:(CGPoint)center precent:(double)precent;

@end
