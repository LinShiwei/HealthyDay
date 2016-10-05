//
//  MainInformationView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/2.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

enum MainInfoViewState{
    case step
    case distance
}

class MainInformationView: UIView{
//MARK: Property
    
    private let containerView = UIView()
    private let stepCountLabel = UILabel()
    private let distanceWalkingRunningLabel = UILabel()
    private let dot = UIView()
    private let labelMaskView = UIView()
    private let decorativeView = UIView()
    
    private var state = MainInfoViewState.distance
    
    var animationProcess : CGFloat = 0{
        didSet{
            switch state{
            case .distance:
                if 0<animationProcess&&animationProcess<=1{
                    dot.center.x = frame.width*2/5
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2*animationProcess/2)
                }else{
                    if -1<=animationProcess&&animationProcess<0{
                        dot.center.x = frame.width*2/5-frame.width/5*animationProcess
                        containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2*animationProcess)
                    }else{
                        return
                    }
                }
            case .step:
                if 0<animationProcess&&animationProcess<=1{
                    dot.center.x = frame.width*3/5-frame.width/5*animationProcess
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2*(animationProcess-1))
                }else{
                    if -1<=animationProcess&&animationProcess<0{
                        dot.center.x = frame.width*3/5
                        containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2*(animationProcess/2-1))
                    }else{
                        return
                    }
                }
            }         
        }
    }
    var stepCount = 0{
        didSet{
            stepCountLabel.text = "\(stepCount) Steps"
        }
    }
    var distance = 0{
        didSet{
            distanceWalkingRunningLabel.text = "\(distance) Meters"
        }
    }
//MARK: View
    override init(frame:CGRect){
        super.init(frame:frame)
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [theme.lightColor.cgColor,theme.thickColor.cgColor]
        layer.addSublayer(gradientLayer)
        
        initContainerView(rotateRadius: frame.width/2+frame.height/4)
        initDotView()
        initLabelMaskView()
        initButtomDecorativeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: Custom View
    private func initContainerView(rotateRadius radius:CGFloat){
        containerView.center = CGPoint(x: frame.width/2, y: frame.height/2+radius)
        
        distanceWalkingRunningLabel.frame.size = CGSize(width: frame.width/2, height: frame.height/2)
        distanceWalkingRunningLabel.center = CGPoint(x: 0, y: -radius)
        distanceWalkingRunningLabel.textAlignment = .center
        distanceWalkingRunningLabel.adjustsFontSizeToFitWidth = true
        distanceWalkingRunningLabel.backgroundColor = UIColor.green
        distanceWalkingRunningLabel.text = "0 Meters"
        
        stepCountLabel.frame.size = distanceWalkingRunningLabel.frame.size
        stepCountLabel.center = CGPoint(x: -distanceWalkingRunningLabel.center.y, y: 0)
        stepCountLabel.textAlignment = .center
        stepCountLabel.adjustsFontSizeToFitWidth = true
        stepCountLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        stepCountLabel.backgroundColor = UIColor.blue
        stepCountLabel.text = "0 Steps"
        
        containerView.addSubview(stepCountLabel)
        containerView.addSubview(distanceWalkingRunningLabel)
        addSubview(containerView)
    }
    
    private func initDotView(){
        dot.frame.size = CGSize(width: 10, height: 10)
        dot.center = CGPoint(x: frame.width*2/5, y: 66)
        dot.layer.cornerRadius = dot.frame.width
        dot.layer.backgroundColor = UIColor.white.cgColor
        addSubview(dot)
    }

    private func initLabelMaskView(){
        labelMaskView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: windowBounds.height-frame.height)
        labelMaskView.backgroundColor = UIColor.white
        addSubview(labelMaskView)
    }
    
    private func initButtomDecorativeView(){
        let height = frame.height/10
        let width = frame.width
        decorativeView.frame = CGRect(x: 0, y: frame.height-height, width: width, height: height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addCurve(to: CGPoint(x: width, y:height), controlPoint1: CGPoint(x:width/3,y:0), controlPoint2: CGPoint(x:width/3*2,y:0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        
        decorativeView.layer.addSublayer(shapeLayer)
        addSubview(decorativeView)
    }
    
    func swipeClockwise(){
        containerView.transform = .identity
        dot.center.x = frame.width*2/5
        state = .distance
    }
    
    func swipeCounterclockwise(){
        containerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        dot.center.x = frame.width*3/5
        state = .step
    }
   
}
