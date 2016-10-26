//
//  DistanceStaticsticChartBar.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/21.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DistanceStatisticsChartBar: UIView {

    @IBOutlet weak var barHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var barInfoLabel: UILabel!
    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var barBottom: UIView!
    @IBOutlet weak var barTitleLabel: UILabel!
    
    var barInfo = ""{
        didSet{
            barInfoLabel.text = barInfo
        }
    }
    var barHeight : CGFloat = 0{
        didSet{
            barHeightConstraint.constant = barHeight
            layoutIfNeeded()
            barBottom.backgroundColor = barHeight == 0 ? theme.lightColor : theme.thickColor
        }
    }
    
    var barTitle = ""{
        didSet{
            barTitleLabel.text = barTitle
        }
    }
    
    override func awakeFromNib() {
        bar.backgroundColor = theme.thickColor
    }
}
