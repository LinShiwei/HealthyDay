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

- (void)setDelegate:(id<CLLocationManagerDelegate>)delegate{
    _delegate = delegate;
    _locationManager.delegate = delegate;
}
#pragma mark Public API

- (void)authorizeWithCompletion:(void (^)(BOOL))completion{
    if ([CLLocationManager locationServicesEnabled]){
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                [_locationManager requestWhenInUseAuthorization];
                completion(NO);
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            case kCLAuthorizationStatusAuthorizedAlways:
                completion(YES);
                break;
            default:
                completion(NO);
                break;
        }
    }else{
        completion(NO);
        NSLog(@"lsw_location services disable. locationservicesEnabled is false");
    }
}

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
