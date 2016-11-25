//
//  DistanceDetailItem.m
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceDetailItem.h"

@implementation DistanceDetailItem

- (id)initWithDate:(NSDate *)date distance:(double)distance duration:(int)duration durationPerKilometer:(int)durationPerKilometer{
    self = [super init];
    if (self) {
        self.date = date;
        self.distance = distance;
        self.duration = duration;
        self.durationPerKilometer = durationPerKilometer;
    }
    return self;
}
@end
