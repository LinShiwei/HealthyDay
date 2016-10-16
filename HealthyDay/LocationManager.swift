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
    private let locationManager = CLLocationManager()
    var delegate : CLLocationManagerDelegate?{
        didSet{
            locationManager.delegate = delegate
        }
    }
    internal func authorize(_ completion: @escaping (_ success:Bool) -> Void){
        guard CLLocationManager.locationServicesEnabled() else{
            completion(false)
            print("lsw_Location services disabled. locationservicesEnabled is false")
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
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
    }
    
    internal func startUpdate(){
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    internal func stopUpdate(){
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.stopUpdatingLocation()
    }
    
    private func initLocatingParameter(){
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
    }
}
