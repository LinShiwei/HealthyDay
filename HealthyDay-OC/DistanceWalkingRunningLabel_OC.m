//
//  DistanceWalkingRunningLabel_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceWalkingRunningLabel_OC.h"

@interface DistanceWalkingRunningLabel_OC ()

@property UILabel *nameLabel;

@end

@implementation DistanceWalkingRunningLabel_OC

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor  = [UIColor whiteColor];
        self.adjustsFontSizeToFitWidth = YES;
        self.text = @"0.00";
        self.font = [UIFont fontWithName:@"DINCondensed-Bold" size:self.frame.size.width*90/320];
        
        [self initNameLabel];
    }
    return self;
}

- (void)setSubviewsAlpha:(CGFloat)subviewsAlpha{
    _subviewsAlpha = subviewsAlpha;
    for (UIView *view in self.subviews) {
        view.alpha = subviewsAlpha;
    }
}

- (void)initNameLabel{
    if (_nameLabel.superview == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.21, self.frame.size.width, self.frame.size.height*0.072)];
        _nameLabel.text = @"今日总里程(公里)";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.font = [UIFont systemFontOfSize:self.frame.size.width*17.0/320];
        [self addSubview:_nameLabel];
    }
}

@end
