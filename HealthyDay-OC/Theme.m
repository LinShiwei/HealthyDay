//
//  Theme.m
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "Theme.h"

@implementation Theme
+(instancetype)sharedTheme{
    static Theme *sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedTheme = [[self alloc] init];
    });
    return sharedTheme;
}

-(id)init{
    self = [super init];
    if (self){
        self.lightThemeColor = [self rgbColorWithRed:0x52 Green:0xC2 Blue:0x34 Alpha:1];
        self.darkThemeColor  = [self rgbColorWithRed:0x3C Green:0xC2 Blue:0x5C Alpha:1];
        self.translucentLightThemeColor = [self rgbColorWithRed:0x52 Green:0xC2 Blue:0x34 Alpha:0.5];
        
        self.lightTextColor  = [UIColor lightGrayColor];
        self.darkTextColor   = [UIColor darkGrayColor];
        
        self.lightLineChartColor = [self rgbColorWithRed:0xFF Green:0xFF Blue:0xFF Alpha:0.5];
        self.thickLineChartColor = [self rgbColorWithRed:0x15 Green:0xF9 Blue:0x50 Alpha:0.5];
        
        self.lightSplitLineColor = [self rgbColorWithRed:0xE3 Green:0xE3 Blue:0xE3 Alpha:1];
        self.thickSplitLineColor = [self rgbColorWithRed:0xDF Green:0xDF Blue:0xDF Alpha:1];
    }
    return self;
}

- (UIColor*)rgbColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
