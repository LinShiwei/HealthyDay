//
//  DistanceStatisticsChartView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit



class DistanceStatisticsChartView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var bar : DistanceStatisticsChartBar?
    
    var type = StatisticsPeriod.Week {
        didSet{
            
        }
    }
    
    override func layoutSubviews() {
        initStatisticsChart(withType: type)
    }
    
    private func initChartBar(){
        guard bar == nil else {return}
        bar = Bundle.main.loadNibNamed("DistanceStatisticsChartBar", owner: self, options: nil)?.first as? DistanceStatisticsChartBar
        if let chartBar = bar {
            chartBar.frame = CGRect(x: 20, y: 60, width: 30, height: 30)
            chartBar.barHeight = 50
            addSubview(chartBar)

        }
        
        
    }
    
    private func initStatisticsChart(withType type:StatisticsPeriod){
        var barCount = 0
        for view in self.subviews where view is DistanceStatisticsChartBar {
            barCount += 1
        }
        switch type {
        case .Week:
            guard barCount != 7 else{return}
        default:
            return
        }
    
        for view in self.subviews where view is DistanceStatisticsChartBar {
            view.removeFromSuperview()
        }
        let barWidth = self.frame.width/7
        for count in 0...6 {
            if let chartBar = Bundle.main.loadNibNamed("DistanceStatisticsChartBar", owner: self, options: nil)?.first as? DistanceStatisticsChartBar {
                chartBar.frame = CGRect(x: CGFloat(count)*barWidth, y: 0, width: barWidth, height: self.frame.height)
                chartBar.barHeight = 50
                addSubview(chartBar)
            }
        }
    }
    
}
