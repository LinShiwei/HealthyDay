//
//  BottomDecorativeCurve_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "BottomDecorativeCurve_OC.h"

@interface BottomDecorativeCurve_OC ()

@property CAShapeLayer *shapeLayer;
@property CAShapeLayer *shapeLayerTwo;

@property CABasicAnimation *shapeLayerAnimation;
@property CABasicAnimation *shapeLayerTwoAnimation;

@end


@implementation BottomDecorativeCurve_OC

- (id)initWithMainInfoViewFrame:(CGRect)frame andBottomDecorativeViewSize:(CGSize)size{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayerTwo = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, size.height)];
    [path addCurveToPoint:CGPointMake(size.width, size.height) controlPoint1:CGPointMake(size.width/3, size.height/2) controlPoint2:CGPointMake(size.width/3*2, size.height/2)];
    NSArray<CAShapeLayer *> *layerArray = [NSArray arrayWithObjects:_shapeLayer,_shapeLayerTwo, nil];
    for (CAShapeLayer *layer in layerArray) {
        layer.path = path.CGPath;
        layer.lineWidth = 1;
        layer.fillColor = nil;
        CGPathRef strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 1, kCGLineCapRound, kCGLineJoinMiter, 1);
        layer.bounds = CGPathGetPathBoundingBox(strokingPath);
        layer.anchorPoint = CGPointMake(0.5, 0);
    }
    _shapeLayer.strokeColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
    _shapeLayerTwo.strokeColor = [[UIColor colorWithWhite:1 alpha:0.3] CGColor];
    
    _shapeLayerTwo.transform = CATransform3DMakeRotation(2*M_PI/180, 0, 0, 1);
    
    _shapeLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    _shapeLayerTwoAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    
    _shapeLayerTwoAnimation.fromValue = @(_shapeLayer.position.y + 3);
    _shapeLayerTwoAnimation.toValue = @(_shapeLayer.position.y -3);
    _shapeLayerTwoAnimation.repeatCount = NSIntegerMax;
    _shapeLayerTwoAnimation.autoreverses = YES;
    _shapeLayerTwoAnimation.duration = 5;
    
    _shapeLayerAnimation.fromValue = @(_shapeLayer.position.y - 3);
    _shapeLayerAnimation.toValue = @(_shapeLayer.position.y +3);
    _shapeLayerAnimation.repeatCount = NSIntegerMax;
    _shapeLayerAnimation.autoreverses = YES;
    _shapeLayerAnimation.duration = 5;
    
    self = [super init];
    if (self) {
        [self refreshAnimation];
        [self.layer addSublayer:_shapeLayer];
        [self.layer addSublayer:_shapeLayerTwo];
    }
    return self;
}

- (void)refreshAnimation{
    [_shapeLayer removeAllAnimations];
    [_shapeLayerTwo removeAllAnimations];
    [_shapeLayer addAnimation:_shapeLayerAnimation forKey:@"positionYAnimation"];
    [_shapeLayerTwo addAnimation:_shapeLayerTwoAnimation forKey:@"positionYAnimation"];
}

@end
