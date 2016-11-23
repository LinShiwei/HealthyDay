//
//  StepRingView_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "StepRingView_OC.h"

@interface StepRingView_OC ()

@property CAReplicatorLayer *maskLayer;
@property CAShapeLayer *strokeLayer;
@property CALayer *ringLayer;

@end

@implementation StepRingView_OC

CGFloat dotCount = 60;
CGFloat dotRadius = 1;
CGFloat ringGap = 4;

- (id)initWithSize:(CGSize)size center:(CGPoint)center precent:(double)precent{
    CGRect frame = CGRectMake(center.x-size.width/2, center.y-size.height/2, size.width, size.height);
    self = [super initWithFrame:frame];
    if (self) {
        
        self.percent = precent;
        CALayer *dot = [CALayer layer];
        dot.frame = CGRectMake(-dotRadius, 0, 2*dotRadius, 2*dotRadius);
        dot.cornerRadius = dotRadius;
        dot.backgroundColor = [[UIColor whiteColor] CGColor];
        
        _maskLayer = [CAReplicatorLayer layer];
        _maskLayer.frame = CGRectMake((size.width-size.width/1.41)/2, (size.width-size.width/1.41)/2, size.width/1.41, size.width/1.41);
        _maskLayer.instanceCount = (NSInteger)dotCount;
        _maskLayer.instanceColor = [[UIColor darkGrayColor] CGColor];
        _maskLayer.instanceTransform = CATransform3DMakeRotation(M_PI*2/dotCount, 0, 0, 1);
        [_maskLayer addSublayer:dot];
        
        CGMutablePathRef circlePath = CGPathCreateMutable();
        CGPathAddArc(circlePath, NULL, size.width/2, size.height/2, size.width/2, -M_PI/2, M_PI/2*3, NO);
//        CGPathRef *circlePath
        
        _strokeLayer = [CAShapeLayer layer];
        _strokeLayer.frame = self.bounds;
        _strokeLayer.path = circlePath;
        _strokeLayer.fillColor = nil;
        _strokeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        _strokeLayer.lineWidth = dotRadius*3;
        _strokeLayer.mask = _maskLayer;
        _strokeLayer.backgroundColor = [[UIColor darkGrayColor] CGColor];
        
        CGFloat angle = dotRadius/(frame.size.height/2);
        _strokeLayer.transform = CATransform3DMakeRotation(M_PI/4+angle*2, 0, 0, 1);
        
        [self.layer addSublayer:_strokeLayer];
        
        CALayer *ringLayer = [CALayer layer];
        ringLayer.frame = CGRectMake(ringGap, ringGap, self.bounds.size.width-ringGap*2, self.bounds.size.height-ringGap*2);
        ringLayer.borderColor = [[UIColor colorWithWhite:1 alpha:0.2] CGColor];
        ringLayer.borderWidth = 1;
        ringLayer.cornerRadius = ringLayer.frame.size.width/2;
        [self.layer addSublayer:ringLayer];
    }
    return self;
}


@end
