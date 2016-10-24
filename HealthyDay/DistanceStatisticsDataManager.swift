//
//  DistanceStatisticsDataManager.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/24.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation

internal final class DistanceStatisticsDataManager {
    static let shared = DistanceStatisticsDataManager()
    internal var distances : [DistanceDetailItem]?
    private init(){}
    
    internal func getDistanceStatistics(withType type:StatisticsPeriod)->[Double]{
        
        return []
    }
    
    internal func getPeriodDescriptionText(withType type:StatisticsPeriod)->[String]{
        
        return []
    }
    
    internal func getTotalDuration(withType type:StatisticsPeriod)->Double{
        
        return 0
    }
    
    internal func getAverageDurationPerKilometer(withType type:StatisticsPeriod)->Double{
        
        return 0
    }
}
