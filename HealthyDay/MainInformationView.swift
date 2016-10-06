//
//  MainInformationView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/2.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class MainInformationView: UIView{
//MARK: Property
    private let containerView = UIView()
    private var stepCountLabel : StepCountLabel!
    private var distanceWalkingRunningLabel : DistanceWalkingRunningLabel!
    private let dot = UIView()
    private let labelMaskView = UIView()
    private let decorativeView = UIView()

    var stepCount = 0{
        didSet{
            stepCountLabel.stepCount = stepCount
            
        }
    }
    var distance = 0{
        didSet{
            distanceWalkingRunningLabel.text = String(format:"%.2f",Double(distance)/1000)
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
        
        distanceWalkingRunningLabel = DistanceWalkingRunningLabel(size:CGSize(width: frame.width, height: frame.height/2),center:CGPoint(x: 0, y: -radius))
        stepCountLabel = StepCountLabel(size: distanceWalkingRunningLabel.frame.size, center: CGPoint(x: -distanceWalkingRunningLabel.center.y*sin(CGFloat.pi/3), y: distanceWalkingRunningLabel.center.y*sin(CGFloat.pi/6)))
        
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
//MARK: Animation helper
    private func hideDistanceWalkingRunningSublabel(alpha:CGFloat){
        guard distanceWalkingRunningLabel.subviewsAlpha != alpha else {return}
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {[unowned self] in
            self.distanceWalkingRunningLabel.subviewsAlpha = alpha
            }, completion: nil)
        
    }
    
    private func hideStepCountSublabel(alpha:CGFloat){
        guard stepCountLabel.subviewsAlpha != alpha else {return}
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {[unowned self] in
            self.stepCountLabel.subviewsAlpha = alpha
            }, completion: nil)

    }
    
    private func swipeClockwise(){
        containerView.transform = .identity
        dot.center.x = frame.width*2/5
    }
    
    private func swipeCounterclockwise(){
        containerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/3)
        dot.center.x = frame.width*3/5
    }
   
    func panAnimation(process: CGFloat, currentState: MainVCState){
        assert(process >= -1 && process <= 1)
        switch process {
        case 1:
            swipeClockwise()
            hideDistanceWalkingRunningSublabel(alpha: 1)
            hideStepCountSublabel(alpha: 1)
        case -1:
            swipeCounterclockwise()
            hideDistanceWalkingRunningSublabel(alpha: 1)
            hideStepCountSublabel(alpha: 1)
        default:
            switch currentState{
            case .running:
                hideDistanceWalkingRunningSublabel(alpha: 0)
                hideStepCountSublabel(alpha: 1)
                if process > 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*process/2)
                    dot.center.x = frame.width*2/5 //可以去掉吗
                }
                if process < 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*process)
                    dot.center.x = frame.width*2/5-frame.width/5*process
                }
            case .step:
                hideDistanceWalkingRunningSublabel(alpha: 1)
                hideStepCountSublabel(alpha: 0)
                if process > 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*(process-1))
                    dot.center.x = frame.width*3/5-frame.width/5*process
                }
                if process < 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*(process/2-1))
                    dot.center.x = frame.width*3/5
                }
            }
        }
    }
}
