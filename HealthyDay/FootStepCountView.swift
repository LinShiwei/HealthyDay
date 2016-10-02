//
//  FootStepCountView.swift
//  HealthyDay
//
//  Created by Sun Haoting on 16/9/30.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class FootStepCountView: UIView {
    
    let footStepCountLabel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 100))
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(footStepCountLabel)
        self.backgroundColor = UIColor.blue
        footStepCountLabel.text = "StepCount"
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
