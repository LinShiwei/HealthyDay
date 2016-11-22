//
//  StepBar_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "StepBar_OC.h"

@interface StepBar_OC ()

@property CGSize dateLabelSize;
@property UIView *bar;
@property UILabel *dateLabel;
@property int distinationStepCount;

@end

@implementation StepBar_OC

- (id)initWithFrame:(CGRect)frame distinationStepCount:(int)distinationStepCount{
    self = [super initWithFrame:frame];
    if (self) {
        self.bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-_dateLabelSize.height)];
        self.bar.transform = CGAffineTransformMakeRotation(M_PI);
        self.bar.layer.backgroundColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
        self.bar.layer.cornerRadius = 5;
        CALayer *barLayer;
        barLayer.frame = CGRectMake(0, 0, frame.size.width, 30);
        barLayer.backgroundColor = [[[Theme sharedTheme] darkThemeColor] CGColor];
        barLayer.cornerRadius = 5;
        [self.bar.layer addSublayer:barLayer];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-_dateLabelSize.width)/2, frame.size.height-_dateLabelSize.height, _dateLabelSize.width, _dateLabelSize.height)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = [[Theme sharedTheme] darkThemeColor];
        [_dateLabel setAdjustsFontSizeToFitWidth:NO];
        _dateLabel.font = [UIFont systemFontOfSize:9];
        
        [self addSubview:self.bar];
        [self addSubview:_dateLabel];
        
        self.distinationStepCount = distinationStepCount;
    }
    return self;
}

- (void)setDay:(NSString *)day{
    _day = day;
    _dateLabel.text = day;
}

- (void)setStepCount:(int)stepCount{
    _stepCount = stepCount;
    NSAssert(_bar.layer.sublayers.count == 1, @"");
    CALayer *barLayer = [_bar.layer.sublayers firstObject];
    CGFloat height = stepCount > _distinationStepCount ? _bar.frame.size.height : _bar.frame.size.height*stepCount/_distinationStepCount;
    [barLayer setBounds:CGRectMake(0, 0, self.frame.size.width, height)];
}
@end
