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
        default:
            return
        }
        print(CLLocationManager.authorizationStatus().rawValue)
        
        
    }
}
