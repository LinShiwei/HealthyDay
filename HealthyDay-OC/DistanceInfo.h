//
//  DistanceInfo.h
//  HealthyDay
//
//  Created by Linsw on 16/11/22.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DistanceInfo : NSObject

@property NSString *month;
@property int count;

- (id)initWithMonth:(NSString *)month count:(int)count;

    
@end
