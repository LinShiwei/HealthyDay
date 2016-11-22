//
//  Theme.h
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Theme : NSObject
+(instancetype)sharedTheme;

@property UIColor *lightThemeColor;
@property UIColor *darkThemeColor;
@property UIColor *translucentLightThemeColor;

@property UIColor *lightTextColor;
@property UIColor *darkTextColor;

@property UIColor *lightLineChartColor;
@property UIColor *thickLineChartColor;

@property UIColor *lightSplitLineColor;
@property UIColor *thickSplitLineColor;

- (UIColor*)rgbColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

@end
