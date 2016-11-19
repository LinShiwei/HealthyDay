//
//  NSDate+NSDate_formatDescription.m
//  HealthyDay
//
//  Created by Linsw on 16/11/19.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "NSDate+NSDate_formatDescription.h"

@implementation NSDate (NSDate_formatDescription)
- (NSString*)formatDescription{
    NSDateFormatter *formatter = [NSDateFormatter init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:self];
}
@end
