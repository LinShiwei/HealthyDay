//
//  StepBar.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/2.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var bar : UIView!
    var dateLabel : UILabel!
    var day = ""{
        didSet{
            dateLabel.text = day
        }
    }
    var stepCount = 0{
        didSet{
            
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        bar = UIView(frame: CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: frame.height*0.8)))
        bar.backgroundColor = UIColor.green
        bar.layer.frame = CGRect(x: 0, y: 20, width: frame.width, height: 30)
        bar.layer.backgroundColor = UIColor.red.cgColor
        dateLabel = UILabel(frame: CGRect(x: frame.minX, y: frame.minY + frame.height*0.8, width: frame.width, height: frame.height*0.2))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
