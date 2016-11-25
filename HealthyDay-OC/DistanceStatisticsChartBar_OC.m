//
//  DistanceStatisticsChartBar_OC.m
//  HealthyDay
//
//  Created by Linsw on 16/11/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceStatisticsChartBar_OC.h"
@interface DistanceStatisticsChartBar_OC ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barHeightContraint;

@property (weak, nonatomic) IBOutlet UILabel *barInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *bar;
@property (weak, nonatomic) IBOutlet UIView *barBottom;
@property (weak, nonatomic) IBOutlet UILabel *barTitleLabel;


@end


@implementation DistanceStatisticsChartBar_OC

- (void)awakeFromNib{
    [super awakeFromNib];
    _bar.backgroundColor = [Theme sharedTheme].lightThemeColor;
}

- (void)setBarInfo:(NSString *)barInfo{
    _barInfo = barInfo;
    _barInfoLabel.text = barInfo;
}

- (void)setBarHeight:(CGFloat)barHeight{
    _barHeight = barHeight;
    _barHeightContraint.constant = barHeight;
    [self layoutIfNeeded];
    _barBottom.backgroundColor = barHeight == 0 ? [Theme sharedTheme].translucentLightThemeColor : [Theme sharedTheme].lightThemeColor;
}

- (void)setBarTitle:(NSString *)barTitle{
    _barTitle = barTitle;
    _barTitleLabel.text = barTitle;
}

@end
