//
//  HealthManager.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/26.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import HealthKit
internal class HealthManager{
    fileprivate let store = HKHealthStore()
    
    func authorize(_ completion: ((_ success:Bool, _ error:Error?) -> Void)?){
        let typesToRead : Set = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
            ]
        
        if !HKHealthStore.isHealthDataAvailable(){
            completion?(false, nil)
            return
        }
        store.requestAuthorization(toShare: nil, read: typesToRead){(success, error) in
            completion?(success,error)
        }
    }
    
    func readCurrentStepCount(_ completion:((Int?,Error?)->Void)!){
        var stepCount = 0
        let sampleQuery = currentQuantitySampleQuery(typeIdentifier: .stepCount, completion: {(query, samples, error) in
            guard error == nil && samples != nil else{
                completion(nil,error)
                return
            }
            for sample in samples!{
                
                stepCount += Int((sample as! HKQuantitySample).quantity.doubleValue(for: HKUnit.count()))
                
            }
            completion(stepCount,nil)
        })
        store.execute(sampleQuery)
    }
    
    func readDistanceWlakingRunning(_ completion:((Int?,Error?)->Void)!){
        var totalDistance = 0
        let sampleQuery = currentQuantitySampleQuery(typeIdentifier: .distanceWalkingRunning, completion: {(query, samples, error) in
            guard error == nil && samples != nil else{
                completion(nil,error)
                return
            }
            for sample in samples!{
                
                totalDistance += Int((sample as! HKQuantitySample).quantity.doubleValue(for: HKUnit.meter()))
                
            }
            completion(totalDistance,nil)
        })
        store.execute(sampleQuery)
    }
    
    private func currentQuantitySampleQuery(typeIdentifier identifier:HKQuantityTypeIdentifier, completion:((HKSampleQuery,[HKSample]?,Error?)->Void)!)->HKSampleQuery{
        let nowDate = Date()
        let todayDate : Date = {
            let secondOffset = TimeZone.current.secondsFromGMT()
            let interval = Int(nowDate.timeIntervalSince1970)%(24*3600)
            return Date(timeInterval: Double(-secondOffset - interval), since: nowDate)
        }()
        let readingType = HKQuantityType.quantityType(forIdentifier: identifier)!
        let currentDayPredicate = HKQuery.predicateForSamples(withStart: todayDate, end: nowDate, options: HKQueryOptions())
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        return HKSampleQuery(sampleType: readingType, predicate: currentDayPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor], resultsHandler: completion)
    }
    
}
