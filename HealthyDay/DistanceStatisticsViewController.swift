//
//  DistanceStatisticsViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/18.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

enum StatisticsPeriod{
    case Week,Month,Year,All
}

class DistanceStatisticsViewController: UIViewController {

    @IBOutlet weak var statisticsPeriodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var currentPeriodLabel: UILabel!
    @IBOutlet weak var distanceStatisticsChart: DistanceStatisticsChartView!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var totalCalorieLabel: UILabel!
    @IBOutlet weak var averageDurationPerKilometerLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    
    var distanceDetailItem = [DistanceDetailItem](){
        didSet{
            statisticeManager.distances = distanceDetailItem
            
//            let mock1 = DistanceDetailItem(date: Date().addingTimeInterval(-60), distance: 1000, duration: 200, durationPerKilometer: 200)
//            let mock2 = DistanceDetailItem(date: Date().addingTimeInterval(-3600*24), distance: 500, duration: 100, durationPerKilometer: 200)
//            let mock3 = DistanceDetailItem(date: Date().addingTimeInterval(-3600*24*4), distance: 500, duration: 100, durationPerKilometer: 200)
//            statisticeManager.distances = [mock3,mock2,mock1]
        }
    }
    
    private var totalDistance = 0.0{
        didSet{
            guard let text = totalDistanceLabel.attributedText as? NSMutableAttributedString else{return}
            let range = NSMakeRange(0, text.length-2)
            let attributeString = NSAttributedString(string: String(format:"%.2f",totalDistance/1000.0), attributes: [
                NSFontAttributeName:UIFont(name: "DINCondensed-Bold", size: 37)!
//                NSForegroundColorAttributeName:UIColor.red
                ])
            text.replaceCharacters(in: range, with: attributeString)
            totalDistanceLabel.text = String(format:"%.2f",totalDistance/1000.0) + "公里"
            totalDistanceLabel.attributedText = text

        }
    }
    
    private var currentPeriodDescription = ""{
        didSet{
            currentPeriodLabel.textAlignment = .right
            let text = NSMutableAttributedString(string: "I", attributes: [
                NSFontAttributeName:UIFont(name: "DINCondensed-Bold", size: 37)!,
                NSForegroundColorAttributeName:UIColor.clear
                ])
            let attributedStringSuffix = NSMutableAttributedString(string: currentPeriodDescription, attributes: [
                NSFontAttributeName:UIFont.systemFont(ofSize: 14)
                ])
            text.append(attributedStringSuffix)
            currentPeriodLabel.text = "I\(currentPeriodDescription)"
            currentPeriodLabel.attributedText = text
        }
    }
    
    private var totalDuration = 0{
        didSet{
            let seconds = totalDuration%60
            let minutes = (totalDuration%3600)/60
            let hours = totalDuration/3600
            totalDurationLabel.text = String(format: "%02d:%02d:%02d", arguments: [hours,minutes,seconds])
        }
    }
    
    private var averageDurationPerKilometer = 0{
        didSet{
            let seconds = averageDurationPerKilometer%60
            let minutes = (averageDurationPerKilometer%3600)/60
            let hours = averageDurationPerKilometer/3600
            if hours == 0 {
                averageDurationPerKilometerLabel.text = String(format: "%02d'%02d\"/公里", arguments: [minutes,seconds])
            }else{
                averageDurationPerKilometerLabel.text = String(format: "%02d:%02d:%02d/公里", arguments: [hours,minutes,seconds])
            }
        }
    }
    
    private var averageSpeed = 0.0{
        didSet{
            averageSpeedLabel.text = String(format: "%.2f公里/时", Double(averageSpeed*3600)/1000.0)
        }
    }

    private let statisticeManager = DistanceStatisticsDataManager.shared
    private let calendar = Calendar(identifier: .republicOfChina)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statisticsPeriodChanged(statisticsPeriodSegmentedControl)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func statisticsPeriodChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            statisticeManager.type = .Week
            currentPeriodDescription = "本周"
        case 1:
            statisticeManager.type = .Month
            currentPeriodDescription = "\(calendar.component(.year, from: Date())+1911)年\(calendar.component(.month, from: Date()))月"
        case 2:
            statisticeManager.type = .Year
            currentPeriodDescription = "\(calendar.component(.year, from: Date())+1911)年"
        case 3:
            statisticeManager.type = .All
            currentPeriodDescription = ""
        default:
            fatalError("SegmentedControl only has 4 segments")
        }
        distanceStatisticsChart.type = statisticeManager.type
        distanceStatisticsChart.distanceStatistics = statisticeManager.getDistanceStatistics()
        refreshData()
    }
    
    private func refreshData(){
        totalDistance = statisticeManager.getTotalDistance()
        totalDuration = statisticeManager.getTotalDuration()
        averageDurationPerKilometer = statisticeManager.getAverageDurationPerKilometer()
        averageSpeed = statisticeManager.getAverageSpeed()
    }
}
