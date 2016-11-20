//
//  DistanceDetailItem.h
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceDetailItem : NSObject
@property NSDate *date;
@property double distance;
@property int duration;
@property int durationPerKilometer;
- (id)initWithDate:(NSDate *)date distance:(double)distance duration:(int)duration durationPerKilometer:(int)durationPerKilometer;
@end
