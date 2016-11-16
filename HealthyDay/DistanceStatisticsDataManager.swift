//
//  DistanceStatisticsDataManager.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/24.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation

internal final class DistanceStatisticsDataManager {
//MARK: Internal property
    //Should set distances and type before using manager.
    static let shared = DistanceStatisticsDataManager()
    internal var distances = [DistanceDetailItem]()
    internal var type = StatisticsPeriod.Week{
        didSet{
            dateInterval = getDateInterval(withType: type)
        }
    }

//MARK: Private property
    private var currentDate : Date{
        get{
            return Date()
        }
    }
    private var dateInterval = DateInterval()
    private init(){}
    
//MARK: Internal interface
    internal func getPeriodDescriptionText()->[String]{
        switch type {
        case .Week:
            return ["日","一","二","三","四","五","六"]
        case .Month:
            var dayOfMonth = [String]()
            let range = calendar.range(of: .day, in: .month, for: currentDate)!
            for day in range.lowerBound..<range.upperBound{
                if day == 1 || day%5 == 0{
                    dayOfMonth.append(String(day))
                }else{
                    dayOfMonth.append("·")
                }
            }
            return dayOfMonth
        case .Year:
            return ["1","2","3","4","5","6","7","8","9","10","11","12"]
        case .All:
            guard distances.count > 0 else{
                return [String(1911+calendar.component(.year, from: Date()))]
            }
            let firstYear = calendar.component(.year, from: distances.first!.date)
            let lastYear = calendar.component(.year, from: distances.last!.date)
            assert(firstYear <= lastYear)
            var years = [String]()
            for year in firstYear...lastYear{
                years.append(String(year+1911))
            }
            return years
        }
    }
    
    internal func getDistanceStatistics()->[Double]{
        switch type {
        case .Week:
            return getWeekDistanceStatistics()
        case .Month:
            return getMonthDistanceStatistics()

        case .Year:
            return getYearDistanceStatistics()

        case .All:
            return getAllDistanceStatistics()
        }

    }
    
    internal func getTotalDistance()->Double{
        var totalDistance = 0.0
        for item in distances where dateInterval.contains(item.date){
            totalDistance += item.distance
        }
        return totalDistance
    }
    
    internal func getTotalDuration()->Int{
        var totalDuration = 0
        for item in distances where dateInterval.contains(item.date){
            totalDuration += item.duration
        }
        return totalDuration
    }
    
    internal func getAverageDurationPerKilometer()->Int{
        var dataCount = 0
        var totalDuration = 0
        for item in distances where dateInterval.contains(item.date){
            totalDuration += item.durationPerKilometer
            dataCount += 1
        }
        if dataCount != 0{
            totalDuration = totalDuration/dataCount
        }
        return totalDuration
    }
    
    internal func getAverageSpeed()->Double{
        let durationPerKilometer = getAverageDurationPerKilometer()
        if durationPerKilometer == 0{
            return 0.0
        }else{
            return 1000.0/Double(getAverageDurationPerKilometer())
        }
    }
    
//MARK: Private func
    private func getDateInterval(withType type:StatisticsPeriod)->DateInterval{
        switch type {
        case .Week:
            return calendar.dateInterval(of: .weekOfMonth, for: currentDate)!
        case .Month:
            return calendar.dateInterval(of: .month, for: currentDate)!
        case .Year:
            return calendar.dateInterval(of: .year, for: currentDate)!
        case .All:
            return DateInterval(start: Date(timeIntervalSinceReferenceDate: 0), end: currentDate)
        }
    }
    
    private func getWeekDistanceStatistics()->[Double]{
        var results = [Double]()
        var distance = 0.0
        var focusDay = dateInterval.start
        for item in distances where dateInterval.contains(item.date){
            if calendar.isDate(item.date, inSameDayAs: focusDay){
                distance += item.distance
            }else{
                repeat{
                    results.append(distance)
                    distance = 0.0
                    focusDay.addTimeInterval(3600*24)
                }while !calendar.isDate(item.date, inSameDayAs: focusDay)
                distance += item.distance
            }
        }
        results.append(distance)
        while results.count < 7{
            results.append(0.0)
        }
        assert(results.count == 7)
        return results
    }
    
    private func getMonthDistanceStatistics()->[Double]{
        var results = [Double]()
        var distance = 0.0
        var focusDay = dateInterval.start
        for item in distances where dateInterval.contains(item.date){
            if calendar.isDate(item.date, inSameDayAs: focusDay){
                distance += item.distance
            }else{
                repeat{
                    results.append(distance)
                    distance = 0.0
                    focusDay.addTimeInterval(3600*24)
                }while !calendar.isDate(item.date, inSameDayAs: focusDay)
                distance += item.distance
            }
        }
        results.append(distance)
        while results.count < calendar.range(of: .day, in: .month, for: currentDate)!.upperBound-1{
            results.append(0.0)
        }
        assert(results.count == calendar.range(of: .day, in: .month, for: currentDate)!.upperBound-1)
        return results
    }
    
    private func getYearDistanceStatistics()->[Double]{
        var results = [Double]()
        var distance = 0.0
        var focusMonth = dateInterval.start
        for item in distances where dateInterval.contains(item.date){
            if calendar.isDate(item.date, equalTo: focusMonth, toGranularity: .month){
                distance += item.distance
            }else{
                repeat{
                    results.append(distance)
                    distance = 0.0
                    focusMonth = calendar.date(byAdding: .month, value: 1, to: focusMonth)!
                }while !calendar.isDate(item.date, equalTo: focusMonth, toGranularity: .month)
                distance += item.distance
            }
        }
        results.append(distance)
        while results.count < 12{
            results.append(0.0)
        }
        assert(results.count == 12)
        return results
    }
    
    private func getAllDistanceStatistics()->[Double]{
        guard distances.count > 0 else {
            return [0.0]
        }
        var results = [Double]()
        var distance = 0.0
        let year = calendar.component(.year, from: distances.first!.date)
        var focusYear = calendar.date(bySetting: .year, value: year, of: dateInterval.start)!
        
        for item in distances where dateInterval.contains(item.date){
            if calendar.isDate(item.date, equalTo: focusYear, toGranularity: .year){
                distance += item.distance
            }else{
                repeat{
                    results.append(distance)
                    distance = 0.0
                    focusYear = calendar.date(byAdding: .year, value: 1, to: focusYear)!
                }while !calendar.isDate(item.date, equalTo: focusYear, toGranularity: .year)
                distance += item.distance
            }
        }
        results.append(distance)
        guard distances.count > 0 else {
            return results
        }
        while results.count < calendar.component(.year, from: distances.last!.date)-calendar.component(.year, from: distances.first!.date)+1{
            results.append(0.0)
        }
        assert(results.count == calendar.component(.year, from: distances.last!.date)-calendar.component(.year, from: distances.first!.date)+1)
        return results
    }

}
