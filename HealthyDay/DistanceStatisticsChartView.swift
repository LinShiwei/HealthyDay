//
//  DistanceStatisticsChartView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DistanceStatisticsChartView: UIView {
//MARK: Property
    internal var distanceStatistics = [Double](){
        didSet{
            maxDistance = 0.0
            for value in distanceStatistics{
                if maxDistance < value {
                    maxDistance = value
                }
            }
            initStatisticsChart(withStatisticsData: distanceStatistics)
        }
    }
    internal var type = StatisticsPeriod.Week
    
    private var maxDistance = 0.0
    private let statisticeManager = DistanceStatisticsDataManager.shared
//MARK: init func
    private func initStatisticsChart(withStatisticsData data:[Double]){
        var barCount = 0
        for view in self.subviews where view is DistanceStatisticsChartBar {
            barCount += 1
        }
        guard barCount != data.count || type == .Year else {return}
        checkTypeAndDataMatching(data: data)
        for view in self.subviews where view is DistanceStatisticsChartBar {
            view.removeFromSuperview()
        }
        let titles = statisticeManager.getPeriodDescriptionText()
        assert(titles.count == data.count)
        
        var barWidth : CGFloat
        var startXPosition : CGFloat
        if type == .All {
            barWidth = self.frame.width/CGFloat(data.count + 4)
            startXPosition = barWidth*2
        }else{
            barWidth = self.frame.width/CGFloat(data.count)
            startXPosition = 0
        }
        for count in 0...data.count-1 {
            if let chartBar = Bundle.main.loadNibNamed("DistanceStatisticsChartBar", owner: self, options: nil)?.first as? DistanceStatisticsChartBar {
                chartBar.frame = CGRect(x: startXPosition + CGFloat(count)*barWidth, y: 0, width: barWidth, height: self.frame.height)
                if maxDistance == 0.0 || data[count] == 0{
                    chartBar.barHeight = 0
                }else{
                    chartBar.barHeight = (self.frame.height-22-5)*CGFloat(data[count]/maxDistance)
                }
                chartBar.barTitle = titles[count]
                chartBar.barInfo = ""
                if chartBar.barTitle == "·"{
                    insertSubview(chartBar, at: 0)
                }else{
                    addSubview(chartBar)
                }
            }
        }
    }
    
    private func checkTypeAndDataMatching(data:[Double]){
        switch type {
        case .Week:
            assert(data.count == 7)
        case .Month:
            assert(data.count > 27&&data.count<32)
        case .Year:
            assert(data.count == 12)
        default:
            break
        }
    }
}
