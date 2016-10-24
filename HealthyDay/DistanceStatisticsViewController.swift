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

    @IBOutlet weak var distanceStatisticsChart: DistanceStatisticsChartView!
    var distanceDetailItem = [DistanceDetailItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(distanceStatisticsChart.bar?.bar.frame.size)
    }

    @IBAction func StatisticsPeriodChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        default:
            fatalError("SegmentedControl only has 4 segments")
        }
        
    }
    
    private func refreshData(withPeriod period:StatisticsPeriod){
        let periodData = divideData(detailItems: distanceDetailItem, inPeriod: period)
        
    }
    
    private func divideData(detailItems items:[DistanceDetailItem], inPeriod period:StatisticsPeriod)->[DistanceDetailItem]{
        
        return items
    }
}
