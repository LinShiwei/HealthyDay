//
//  StepEverydayView.swift
//  HealthyDay
//
//  Created by Sun Haoting on 16/10/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//


import UIKit

class StepEverydayView: UIView {
    
    let stepLabel = UILabel()
    
    private var isToday = false
    private let dot = CALayer()
    private var dotRadius = CGFloat()
    private var proportion = CGFloat()
    private var stepCount = Int()
    
    init(frame: CGRect,proportion: CGFloat,stepCount: Int, isToday: Bool) {
        super.init(frame: frame)
        self.proportion = proportion
        self.stepCount = stepCount
        self.isToday = isToday
        initDotLayer()
        initStepLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initDotLayer() {
        guard superview == nil else{return}
        let lineChartHeight = frame.height * 2.5 / 3.5
        if isToday {
            dotRadius = 3
            dot.borderWidth = 1.5
            dot.borderColor = UIColor.green.cgColor
            dot.backgroundColor = UIColor.white.cgColor
        } else {
            dotRadius = 6
            dot.borderWidth = 2
            dot.borderColor = UIColor.white.cgColor
            dot.backgroundColor = UIColor.green.cgColor
        }
        let dotY = frame.height - lineChartHeight * proportion - dotRadius
        dot.position = CGPoint(x: frame.width / 2 - dotRadius, y: dotY)
        dot.frame.size = CGSize(width: dotRadius * 2, height: dotRadius * 2)
        dot.cornerRadius = CGFloat(dotRadius)
        layer.addSublayer(dot)
    }
    
    internal func dotPosition() -> CGPoint {
        return dot.position
    }
    
    private func initStepLabel() {
        stepLabel.frame = CGRect(x: frame.width * 0.1, y: dotPosition().y - frame.height / 3.5, width: frame.width * 0.8, height: frame.height / 4)
        stepLabel.text = "\(stepCount)"
        stepLabel.textAlignment = .center
        stepLabel.textColor = UIColor.black
        stepLabel.adjustsFontSizeToFitWidth = true
        stepLabel.alpha = isToday ? 1 : 0
        addSubview(stepLabel)
    }
}
