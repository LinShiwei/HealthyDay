//
//  DistanceInfo.m
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "DistanceInfo.h"

@implementation DistanceInfo

- (id)initWithMonth:(NSString *)month count:(int)count{
    self = [super init];
    if (self) {
        self.month = month;
        self.count = count;
    }
    return self;
}

@end
