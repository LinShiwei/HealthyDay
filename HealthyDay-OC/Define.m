//
//  Define.m
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "Define.h"

@implementation Define
+ (instancetype)sharedDefine {
    static Define *sharedDefine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedDefine = [[self alloc] init];
    });
    return sharedDefine;
}

- (id)init{
    self = [super init];
    if (self){
        self.windowBounds = [UIScreen mainScreen].bounds;
        self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierRepublicOfChina];
        self.theme = [Theme sharedTheme];
        self.dataSource = CoreData;
    }
    return self;
}


- (NSString*)durationFormatterWithSecondsDuration:(int)duration{
    int seconds = duration%60;
    int minutes = (duration%3600)/60;
    int hours = duration/3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d/公里",hours,minutes,seconds];
}

- (NSString*)durationPerKilometerFormatterWithDuration:(int)duration{
    int seconds = duration%60;
    int minutes = (duration%3600)/60;
    int hours = duration/3600;
    return hours == 0 ? [NSString stringWithFormat:@"%02d'%02d\"/公里",minutes,seconds] : [NSString stringWithFormat:@"%02d:%02d:%02d/公里",hours,minutes,seconds];
}

@end
