//
//  LocationManager.m
//  HealthyDay
//
//  Created by Linsw on 16/11/20.
//  Copyright © 2016年 Linsw. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property CLLocationManager *locationManager;

@end

@implementation LocationManager

+ (instancetype)sharedLocationManager {
    static LocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}

- (id)init{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

#pragma mark Public API
- (void)startUpdate{
    [_locationManager startUpdatingLocation];
    [_locationManager setAllowsBackgroundLocationUpdates:YES];
}

- (void)stopUpdate{
    [_locationManager setAllowsBackgroundLocationUpdates:NO];
    [_locationManager stopUpdatingLocation];
}

//- (void)initLocationParameter{
//    
//}

@end
