//
//  MainInfomationView_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "MainInfomationView_OC.h"

@interface MainInfomationView_OC ()

@property StepCountLabel_OC *stepCountLabel;
@property DistanceWalkingRunningLabel_OC *distanceWalkingRunningLabel;

@property UIView *containerView;
@property UIView *dot;
@property UIView *labelMaskView;
@property UIView *decorativeView;
@property CAGradientLayer *gradientLayer;
@property BottomDecorativeCurve_OC * bottomDecorativeCurveView;

@end


@implementation MainInfomationView_OC

CGFloat bottomDecorativeCurveFotateDegree = M_PI/180.0*2;

- (void)layoutSubviews{
    [super layoutSubviews];
    [self initGradientLayer];
    [self initContainerViewWithRotateRadius:self.frame.size.height];
    [self initDotView];
    [self initBottomDecorativeView];
    [self addGestureToSelf];
}

- (void)setStepCount:(int)stepCount{
    _stepCount = stepCount;
    _stepCountLabel.stepCount = stepCount;
}

- (void)setDistance:(double)distance{
    _distance = distance;
    _distanceWalkingRunningLabel.text = [NSString stringWithFormat:@"%.2f",(double)distance/1000.0];
}

#pragma mark Private func
- (void)initGradientLayer{
    if (_gradientLayer.superlayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[[Theme sharedTheme].lightThemeColor CGColor],(id)[[Theme sharedTheme].darkThemeColor CGColor], nil];
        [self.layer addSublayer:_gradientLayer];
    } else {
        return;
    }
}

- (void)initContainerViewWithRotateRadius:(CGFloat)radius{
    if (_containerView.superview == nil) {
        _containerView = [[UIView alloc] init];
        _containerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+radius);
        
        _distanceWalkingRunningLabel = [[DistanceWalkingRunningLabel_OC alloc] initWithFrame:CGRectMake(-_containerView.center.x, -_containerView.center.y+self.frame.size.height*0.17, self.frame.size.width, self.frame.size.height*0.6)];
        _stepCountLabel = [[StepCountLabel_OC alloc] initWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height*0.47) center:CGPointMake(radius*sin(M_PI/3), -radius*sin(M_PI/6))];
        [_containerView addSubview:_stepCountLabel];
        [_containerView addSubview:_distanceWalkingRunningLabel];
        [self addSubview:_containerView];
    }else{
        return;
    }
}

- (void)initDotView{
    if (_dot.superview == nil) {
        _dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _dot.center = CGPointMake(self.frame.size.width*2/5, 66);
        _dot.layer.cornerRadius = _dot.frame.size.width;
        _dot.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        [self addSubview:_dot];
    } else {
        return;
    }
}

- (void)initBottomDecorativeView{
    if (_decorativeView.superview == nil) {
        CGFloat height = self.frame.size.height * 0.24;
        CGFloat width = self.frame.size.width;
        
        _decorativeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, width, height)];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, height)];
        [path addCurveToPoint:CGPointMake(width, height) controlPoint1:CGPointMake(width/3, height/2) controlPoint2:CGPointMake(width/3*2, height/2)];
        [path addLineToPoint:CGPointMake(0, height)];
        [path closePath];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.lineWidth = 1;
        shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        
        [_decorativeView.layer addSublayer:shapeLayer];
        if (_bottomDecorativeCurveView == nil) {
            _bottomDecorativeCurveView = [[BottomDecorativeCurve_OC alloc] initWithMainInfoViewFrame:self.frame andBottomDecorativeViewSize:CGSizeMake(width, height)];
            [_decorativeView addSubview:_bottomDecorativeCurveView];
        }
        [self addSubview:_decorativeView];
    } else {
        return;
    }
}

- (void)addGestureToSelf{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)didTap:(UITapGestureRecognizer *)sender{
    if ([self pointIsInLabelText:[sender locationInView:_stepCountLabel] label:_stepCountLabel]) {
        [_delegate didTapInLabel:_stepCountLabel];
    }
    if ([self pointIsInLabelText:[sender locationInView:_distanceWalkingRunningLabel] label:_distanceWalkingRunningLabel]) {
        [_delegate didTapInLabel:_distanceWalkingRunningLabel];
    }
}

- (BOOL)pointIsInLabelText:(CGPoint)point label:(UILabel *)label{
    if ((ABS(point.x-label.bounds.size.width/2)<[label textRectForBounds:label.bounds limitedToNumberOfLines:0].size.width/2)&&(ABS(point.y-label.bounds.size.height/2)<[label textRectForBounds:label.bounds limitedToNumberOfLines:0].size.height/2)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)hideDistanceWalkingRunningSublabelWithAlpha:(CGFloat)alpha{
    if (_distanceWalkingRunningLabel.subviewsAlpha != alpha) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _distanceWalkingRunningLabel.subviewsAlpha = alpha;
        }completion:nil];
    } else {
        return;
    }
}

- (void)hideStepCountSublabelWithAlpha:(CGFloat)alpha{
    if (_stepCountLabel.subviewsAlpha != alpha) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _stepCountLabel.subviewsAlpha = alpha;
        }completion:nil];
    } else {
        return;
    }
}

- (void)swipeClockwise{
    _containerView.transform = CGAffineTransformIdentity;
    _dot.center = CGPointMake(self.frame.size.width*2/5, _dot.center.y) ;
    _bottomDecorativeCurveView.transform = CGAffineTransformIdentity;
}

- (void)swipeCounterclockwise{
    _containerView.transform = CGAffineTransformMakeRotation(-M_PI/3);
    _dot.center = CGPointMake(self.frame.size.width*3/5, _dot.center.y) ;
    _bottomDecorativeCurveView.transform = CGAffineTransformMakeRotation(-bottomDecorativeCurveFotateDegree);
}

- (void)panAnimationWithProgress:(CGFloat)progress currentState:(enum MainVCState)currentState{
    NSAssert(progress >= -1 && progress <= 1, @"");
    if (progress == 1) {
        [self swipeClockwise];
        [self hideDistanceWalkingRunningSublabelWithAlpha:1];
        [self hideStepCountSublabelWithAlpha:1];
    }else{
        if (progress == -1) {
            [self swipeCounterclockwise];
            [self hideDistanceWalkingRunningSublabelWithAlpha:1];
            [self hideStepCountSublabelWithAlpha:1];
        } else {
            switch (currentState) {
                case Running:
                    [self hideDistanceWalkingRunningSublabelWithAlpha:0];
                    [self hideStepCountSublabelWithAlpha:1];
                    if (progress > 0) {
                        _containerView.transform = CGAffineTransformMakeRotation(M_PI/3*progress/2);
                        _dot.center = CGPointMake(self.frame.size.width*2/5, _dot.center.y);
                        _bottomDecorativeCurveView.transform = CGAffineTransformIdentity;
                    }
                    if (progress < 0) {
                        _containerView.transform = CGAffineTransformMakeRotation(M_PI/3*progress);
                        _dot.center = CGPointMake(self.frame.size.width*2/5-self.frame.size.width/5*progress, _dot.center.y);
                        _bottomDecorativeCurveView.transform = CGAffineTransformMakeRotation(bottomDecorativeCurveFotateDegree*progress);
                    }
                    break;
                case Step:
                    [self hideDistanceWalkingRunningSublabelWithAlpha:1];
                    [self hideStepCountSublabelWithAlpha:0];
                    if (progress > 0) {
                        _containerView.transform = CGAffineTransformMakeRotation(M_PI/3*(progress-1));
                        _dot.center = CGPointMake(self.frame.size.width*3/5-self.frame.size.width/5*progress, _dot.center.y);
                        _bottomDecorativeCurveView.transform = CGAffineTransformMakeRotation(-bottomDecorativeCurveFotateDegree*(1-progress));
                    }
                    if (progress < 0) {
                        _containerView.transform = CGAffineTransformMakeRotation(M_PI/3*(progress/2-1));
                        _dot.center = CGPointMake(self.frame.size.width*3/5, _dot.center.y);
                        _bottomDecorativeCurveView.transform = CGAffineTransformMakeRotation(-bottomDecorativeCurveFotateDegree);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

- (void)refreshAnimation{
    [_bottomDecorativeCurveView refreshAnimation];
}

@end
