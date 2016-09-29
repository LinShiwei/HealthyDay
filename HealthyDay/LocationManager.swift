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
    
    func authorize(){
        guard CLLocationManager.locationServicesEnabled() else{
            print("lsw_Location services disabled. locationservicesEnabled is false")
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
//            stopUpdate()
            
        default:
            return
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
