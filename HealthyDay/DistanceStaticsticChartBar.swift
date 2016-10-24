//
//  DistanceStaticsticChartBar.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DistanceStatisticsChartBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var barHeightConstraint: NSLayoutConstraint!
    var barHeight = 0{
        didSet{
            barHeightConstraint.constant = CGFloat(barHeight)
            layoutIfNeeded()
        }
    }
    @IBOutlet weak var bar: UIView!
    
    override func layoutSubviews() {
//        print(bar.frame.size)
    }
}
