//
//  LocationManager.h
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface LocationManager : NSObject

+ (instancetype)sharedLocationManager;

- (void)authorizeWithCompletion:(void(^)(BOOL))completion;

- (void)startUpdate;
- (void)stopUpdate;

@end
