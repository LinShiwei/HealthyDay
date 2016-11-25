//
//  StartRunningButton_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "StartRunningButton_OC.h"

@interface StartRunningButton_OC ()



@end


@implementation StartRunningButton_OC
CGFloat _buttonDiameter = 100;
CGFloat _ringGap = 5;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = _buttonDiameter/2;
        self.layer.backgroundColor = [[Theme sharedTheme].lightThemeColor CGColor];
        self.tintColor = [UIColor whiteColor];
        
        CALayer *ringLayer = [CALayer layer];
        ringLayer.frame = CGRectMake(-_ringGap, -_ringGap, _buttonDiameter+_ringGap*2, _buttonDiameter+_ringGap*2);
        ringLayer.cornerRadius = _buttonDiameter/2+_ringGap;
        ringLayer.borderColor = [[Theme sharedTheme].lightThemeColor CGColor];
        ringLayer.borderWidth = 1;
        [self.layer addSublayer:ringLayer];
    }
    return self;
}

- (void)hideWithProgress:(CGFloat)progress{
    self.alpha = 1- progress;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1-0.5*progress, 1-0.5*progress);
    CGAffineTransform scaleShiftTransform = CGAffineTransformTranslate(scaleTransform, 0, (_buttonDiameter/2+30)*(progress));
    self.transform = scaleShiftTransform;
}

- (void)showWithProgress:(CGFloat)progress{
    self.alpha = progress;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.5+0.5*progress, 0.5+0.5*progress);
    CGAffineTransform scaleShiftTransform = CGAffineTransformTranslate(scaleTransform, 0, (_buttonDiameter/2+30)*(1-progress));
    self.transform = scaleShiftTransform;
}

- (void)panAnimationWithProgress:(CGFloat)progress currentState:(enum MainVCState)currentState{
    NSAssert(progress >= -1 && progress <= 1, @"");
    if (progress == 1) {
        [self showWithProgress:1];
    }else{
        if (progress == -1) {
            [self hideWithProgress:1];
        }else{
            switch (currentState) {
                case Step:
                    if (progress > 0) {
                        [self showWithProgress:progress];
                    }
                    break;
                case Running:
                    if (progress < 0) {
                        [self hideWithProgress:-progress];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

@end
