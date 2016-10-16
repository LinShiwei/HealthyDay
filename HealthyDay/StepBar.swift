//
//  StepBar.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/2.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

internal class StepBar: UIView {

    private let dateLabelSize = CGSize(width: 24, height: 12)
        
    private var bar : UIView!
    private var dateLabel : UILabel!
    internal var day = ""{
        didSet{
            dateLabel.text = day
        }
    }
    internal var stepCount = 0{
        didSet{
            assert(bar.layer.sublayers!.count == 1)
            assert(superview is StepBarChartView)
            guard let barLayer = bar.layer.sublayers?.first else{return}
            guard let superView = superview as? StepBarChartView else {return}
            let height = stepCount > superView.distinationStepCount ? bar.frame.height : bar.frame.height*CGFloat(stepCount)/CGFloat(superView.distinationStepCount)
            barLayer.frame.size = CGSize(width: frame.width, height: height)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        bar = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-dateLabelSize.height))
        bar.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        bar.layer.backgroundColor = UIColor(white: 0.9, alpha: 1).cgColor
        bar.layer.cornerRadius = 5
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        barLayer.backgroundColor = theme.thickColor.cgColor
        barLayer.cornerRadius = 5
        bar.layer.addSublayer(barLayer)
        dateLabel = UILabel(frame: CGRect(x: (frame.width-dateLabelSize.width)/2, y: frame.height-dateLabelSize.height, width: dateLabelSize.width, height: dateLabelSize.height))
        dateLabel.textAlignment = .center
        dateLabel.textColor = theme.thickColor
        dateLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(bar)
        addSubview(dateLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
