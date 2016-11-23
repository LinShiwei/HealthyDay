//
//  StepBarChartView_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "StepBarChartView_OC.h"

@interface StepBarChartView_OC ()

@property NSMutableArray<StepBar_OC *> *stepBars;

@end

@implementation StepBarChartView_OC

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.destinationStepCount = 10000;
        self.stepBars = [NSMutableArray array];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self addStepBars];
}


- (void)setStepCounts:(NSArray<NSNumber *> *)stepCounts{
    _stepCounts = stepCounts;
    NSAssert(stepCounts.count == 7, @"");
    NSAssert(_stepBars.count == 7, @"");
    for (NSInteger index=0; index < 7; index++) {
        _stepBars[index].stepCount = stepCounts[index].intValue;
    }
}


#pragma mark Private func
- (NSArray<NSString *> *)getDateLabelTexts{
    NSDate *currentDate = [NSDate date];
    NSMutableArray<NSString *> *texts = [NSMutableArray array];
    for (NSInteger day=0; day < 7; day++) {
        NSDate *date = [[[Define sharedDefine] calendar] dateByAddingUnit:NSCalendarUnitDay value:-day toDate:currentDate options:NSCalendarMatchStrictly];
        [texts addObject:[NSString stringWithFormat:@"%ld 日",(long)[[[Define sharedDefine] calendar] component:NSCalendarUnitDay fromDate:date]]];
    }
    
    NSAssert(texts.count == 7, @"");
    return texts;
}

- (void)addStepBars{
    if (_stepBars.count != 0) {
        return;
    }else{
        NSArray<NSString *> *barTexts = [self getDateLabelTexts];
        CGFloat barInterval = self.frame.size.width / 7;
        CGFloat barWidth = 6;
        for (NSInteger barNumber=1; barNumber < 8; barNumber++) {
            StepBar_OC *stepBar = [[StepBar_OC alloc] initWithFrame:CGRectMake(barInterval*barNumber-barInterval/2-barWidth/2, 0, barWidth, self.frame.size.height) destinationStepCount:_destinationStepCount];
            stepBar.day = barTexts[7-barNumber];
            [_stepBars addObject:stepBar];
            [self addSubview:stepBar];
        }
    }
}

#pragma mark Animation helper
- (void)hideWithProgress:(CGFloat)progress{
    self.transform = CGAffineTransformMakeTranslation(0, 20*progress);
    self.alpha = 1 - progress;
}

- (void)showWithPregress:(CGFloat)progress{
    self.transform = CGAffineTransformMakeTranslation(0, 20*(1-progress));
    self.alpha = progress;
}

#pragma mark Public func
- (void)panAnimationWithProgress:(CGFloat)progress currentState:(enum MainVCState)currentState{
    NSAssert(progress >= -1 && progress <= 1, @"");
    if (progress == 1) {
        [self hideWithProgress:1];
    }else{
        if (progress == -1) {
            [self showWithPregress:1];
        }else{
            switch (currentState) {
                case Step:
                    if (progress > 0) {
                        [self hideWithProgress:progress];
                    }
                    break;
                case Running:
                    if (progress < 0) {
                        [self showWithPregress:-progress];
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
}

@end
