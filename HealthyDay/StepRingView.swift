//
//  StepRingView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

internal class StepRingView: UIView {
    
    private let dotCount : CGFloat = 60
    private let dotRadius : CGFloat = 1
    private let ringGap : CGFloat = 4
    
    private let maskLayer = CAReplicatorLayer()
    private let strokeLayer = CAShapeLayer()
    private let ringLayer = CALayer()
    
    internal var precent : Double = 0{
        didSet{
            precent = precent > 1 ? 1 : precent
            precent = precent < 0 ? 0 : precent
            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            strokeLayer.strokeEnd = CGFloat(precent)
            strokeEnd.fromValue = 1
            strokeEnd.duration = (1-precent)*1
            strokeLayer.add(strokeEnd, forKey: "strokeEnd")
        }
    }
    
    internal init(size:CGSize, center:CGPoint, precent:Double) {
        let frame = CGRect(origin: CGPoint(x:center.x-size.width/2,y:center.y-size.height/2), size: size)
        super.init(frame:frame)
        self.precent = precent
        
        let dot = CALayer()
        dot.frame = CGRect(x: -dotRadius, y: 0, width: 2*dotRadius, height: 2*dotRadius)
        dot.cornerRadius = dotRadius
        dot.backgroundColor = UIColor.white.cgColor

        maskLayer.frame = CGRect(x: (size.width-size.width/1.41)/2, y: (size.width-size.width/1.41)/2, width: size.width/1.41, height: size.width/1.41)
        maskLayer.instanceCount = Int(dotCount)
        maskLayer.instanceColor = UIColor.darkGray.cgColor
        maskLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi*2/dotCount, 0, 0, 1)
//        maskLayer.transform = CATransform3DMakeRotation(CGFloat.pi/4, 0, 0, 1)
        maskLayer.addSublayer(dot)
        
        let circlePath : CGPath = {
            let path = CGMutablePath()
            path.addArc(center: CGPoint(x:size.width/2,y:size.height/2), radius: size.width/2, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2*3, clockwise: false)
            return path
        }()
        
        strokeLayer.frame = bounds
        strokeLayer.path = circlePath
        strokeLayer.fillColor = nil
        strokeLayer.strokeColor = UIColor.white.cgColor
        strokeLayer.lineWidth = dotRadius*3
        strokeLayer.mask = maskLayer
        strokeLayer.backgroundColor = UIColor.darkGray.cgColor
        
        let angle = dotRadius/(frame.height/2)
        strokeLayer.transform = CATransform3DMakeRotation(-angle, 0, 0, 1)
        maskLayer.transform = CATransform3DMakeRotation(CGFloat.pi/4+angle*2, 0, 0, 1)
        strokeLayer.strokeEnd = 0.3
        
        layer.addSublayer(strokeLayer)
        
        let ringLayer = CALayer()
        ringLayer.frame = CGRect(x: ringGap, y: ringGap, width: bounds.width-ringGap*2, height: bounds.height-ringGap*2)
        ringLayer.borderColor = UIColor(white: 1, alpha: 0.2).cgColor
        ringLayer.borderWidth = 1
        ringLayer.cornerRadius = ringLayer.frame.width/2
        layer.addSublayer(ringLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

