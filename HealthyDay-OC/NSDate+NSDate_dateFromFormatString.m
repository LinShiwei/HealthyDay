//
//  NSDate+NSDate_dateFromFormatString.m
//  HealthyDay
//
//  Created by Linsw on 16/11/27.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "NSDate+NSDate_dateFromFormatString.h"

@implementation NSDate (NSDate_dateFromFormatString)

+ (instancetype)dateFromFormatString:(NSString *)formatString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter dateFromString:formatString];
}

@end
