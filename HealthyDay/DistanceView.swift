//
//  DistanceView.swift
//  HealthyDay
//
//  Created by Sun Haoting on 16/9/30.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DistanceView: UIView {
    
    let distanceLabel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 100))
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(distanceLabel)
        self.backgroundColor = UIColor.blue
        distanceLabel.text = "Distance"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
