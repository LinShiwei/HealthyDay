//
//  StepRingView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/6.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepRingView: UIView,CAAnimationDelegate {
    
    private let dotCount : CGFloat = 60
    private let dotRadius : CGFloat = 1
    
    private var dotContainerLayer : CAReplicatorLayer?
    private let backgroundLayer = CAReplicatorLayer()
    private let staticDotContainerLayer = CAReplicatorLayer()
    
    var precent : Double = 0{
        didSet{
            staticDotContainerLayer.instanceCount = Int(Double(dotCount)*precent)
            performRingAnimation()
        }
    }
    
    init(size:CGSize, center:CGPoint, precent:Double) {
        let frame = CGRect(origin: CGPoint(x:center.x-size.width/2,y:center.y-size.height/2), size: size)
        super.init(frame:frame)
        self.precent = precent
        
        let staticDotLayer = CALayer()
        staticDotLayer.frame = CGRect(x: -dotRadius, y: 0, width: dotRadius*2, height: dotRadius*2)
        staticDotLayer.cornerRadius = dotRadius
        staticDotLayer.backgroundColor = UIColor.white.cgColor
        
        staticDotContainerLayer.frame = bounds
        staticDotContainerLayer.instanceCount = Int(Double(dotCount)*precent)
        staticDotContainerLayer.instanceColor = UIColor.white.cgColor
        staticDotContainerLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi*2/dotCount, 0, 0, 1)
        staticDotContainerLayer.transform = CATransform3DMakeRotation(CGFloat.pi/4, 0, 0, 1)
        staticDotContainerLayer.addSublayer(staticDotLayer)

        let backgroundDot = CALayer()
        backgroundDot.frame = CGRect(x: -dotRadius, y: 0, width: 2*dotRadius, height: 2*dotRadius)
        backgroundDot.cornerRadius = dotRadius
        backgroundDot.backgroundColor = UIColor.white.cgColor
        
        backgroundLayer.frame = bounds
        backgroundLayer.instanceCount = Int(dotCount)
        backgroundLayer.instanceColor = UIColor.darkGray.cgColor
        backgroundLayer.instanceTransform = CATransform3DMakeRotation(CGFloat.pi*2/dotCount, 0, 0, 1)
        backgroundLayer.transform = CATransform3DMakeRotation(CGFloat.pi/4, 0, 0, 1)
        backgroundLayer.addSublayer(backgroundDot)

        let ringLayer = CALayer()
        ringLayer.frame = CGRect(x: -size.width/2*0.41+3, y: -size.width/2*0.41+3, width: size.width*1.41-6, height: size.height*1.41-6)
        ringLayer.borderColor = UIColor(white: 1, alpha: 0.2).cgColor
        ringLayer.borderWidth = 1
        ringLayer.cornerRadius = ringLayer.frame.width/2
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(ringLayer)
        layer.addSublayer(staticDotContainerLayer)
        
        performRingAnimation()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("stop")
        guard let dCLayer = dotContainerLayer else{return}
        dCLayer.removeFromSuperlayer()
        dotContainerLayer = nil
    }
    
    func performRingAnimation(){
        guard dotContainerLayer == nil else{return}
        let duration : CGFloat = 1
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.duration = CFTimeInterval(duration)
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 0
        fadeAnimation.delegate = self
        
        let dotLayer = CALayer()
        dotLayer.frame = CGRect(x: -dotRadius, y: 0, width: 2*dotRadius, height: 2*dotRadius)
        dotLayer.cornerRadius = dotRadius
        dotLayer.backgroundColor = UIColor.white.cgColor
        dotLayer.add(fadeAnimation, forKey: "Fade")
        
        dotContainerLayer = CAReplicatorLayer()
        dotContainerLayer!.frame = bounds
        dotContainerLayer!.instanceCount = Int(dotCount)
        dotContainerLayer!.instanceDelay = CFTimeInterval(duration/dotCount)
        dotContainerLayer!.instanceColor = UIColor.white.cgColor
        dotContainerLayer!.instanceTransform = CATransform3DMakeRotation(-CGFloat.pi*2/dotCount, 0, 0, 1)
        dotContainerLayer!.transform = CATransform3DMakeRotation(CGFloat.pi/4+CGFloat.pi*0/3, 0, 0, 1)
        dotContainerLayer!.addSublayer(dotLayer)
        layer.insertSublayer(dotContainerLayer!, above: backgroundLayer)

    }
}
