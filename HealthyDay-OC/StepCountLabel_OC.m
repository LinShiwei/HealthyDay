//
//  StepCountLabel_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "StepCountLabel_OC.h"

@interface StepCountLabel_OC ()

@property UILabel *nameLabel;
@property UILabel *targetLabel;
@property StepRingView_OC *ringView;


@end


@implementation StepCountLabel_OC

int targetCount = 10000;

- (id)initWithSize:(CGSize)size center:(CGPoint)center{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.center = center;
        self.textAlignment = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
        self.textColor = [UIColor whiteColor];
        self.text = @"0";
        self.font = [UIFont fontWithName:@"DINCondensed-Bold" size:self.frame.size.width*70/320];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.184, size.width, self.frame.size.height*0.1)];
        _nameLabel.text = @"今日步数";
        _nameLabel.font = [UIFont systemFontOfSize:self.frame.size.width*14/320];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        [self addSubview:_nameLabel];
        
        _targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.71, size.width, self.frame.size.height*0.1)];
        _targetLabel.text = [NSString stringWithFormat: @"目标%d步",targetCount];
        _targetLabel.font = [UIFont systemFontOfSize:self.frame.size.width*14/320];
        _targetLabel.adjustsFontSizeToFitWidth = YES;
        _targetLabel.textAlignment = NSTextAlignmentCenter;
        _targetLabel.textColor = [UIColor whiteColor];
        [self addSubview:_targetLabel];
        
        _ringView = [[StepRingView_OC alloc] initWithSize:CGSizeMake(self.frame.size.height, self.frame.size.height) center:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) precent:0.3];
        [self addSubview:_ringView];
        
        self.transform = CGAffineTransformMakeRotation(M_PI/3);
    }
    return self;
}

- (void)setStepCount:(int)stepCount{
    _stepCount = stepCount;
    self.text = [NSString stringWithFormat:@"%d",stepCount];
    _ringView.percent = (double)stepCount/(double)targetCount;
    
}

- (void)setSubviewsAlpha:(CGFloat)subviewsAlpha{
    _subviewsAlpha = subviewsAlpha;
    _nameLabel.alpha = subviewsAlpha;
    _targetLabel.alpha = subviewsAlpha;
}
@end
