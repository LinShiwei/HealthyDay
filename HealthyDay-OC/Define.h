//
//  Define.h
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Theme.h"
enum DataSource{
    CoreData,Linshiwei_win
};
@interface Define : NSObject
+ (instancetype)sharedDefine;

@property CGRect windowBounds;
@property NSCalendar *calendar;

@property Theme *theme;
@property enum DataSource dataSource;


- (NSString*)durationFormatterWithSecondsDuration:(int)duration;
- (NSString*)durationPerKilometerFormatterWithDuration:(int)duration;

@end
