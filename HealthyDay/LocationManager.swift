//
//  LocationManager.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/28.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import CoreLocation

internal class LocationManager {
    let locationManager = CLLocationManager()
    
    func authorize(_ completion: @escaping (_ success:Bool) -> Void){
        guard CLLocationManager.locationServicesEnabled() else{
            completion(false)
            print("lsw_Location services disabled. locationservicesEnabled is false")
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse || CLLocationManager.authorizationStatus() != .authorizedAlways{
                completion(false)
            }else{
                completion(true)
            }
        case .authorizedWhenInUse, .authorizedAlways:
            completion(true)
        default:
            completion(false)
        }
        print(CLLocationManager.authorizationStatus().rawValue)
    }
    
    func startUpdate(){
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdate(){
        locationManager.stopUpdatingLocation()
    }
    
    private func initLocatingParameter(){
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
    }
}
