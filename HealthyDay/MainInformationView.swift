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
    private let gradientLayer = CAGradientLayer()
    private var bottomDecorativeCurveView : UIView?

    let bottomDecorativeCurveRotateDegree : CGFloat = CGFloat.pi/180*2
    
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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initGradientLayer()
        initContainerView(rotateRadius: frame.height)
        initDotView()
        initBottomDecorativeView()
    }
    
//MARK: Custom View
    private func initGradientLayer(){
        guard gradientLayer.superlayer == nil else {return}
        gradientLayer.frame = bounds
        gradientLayer.colors = [theme.lightColor.cgColor,theme.thickColor.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    private func initContainerView(rotateRadius radius:CGFloat){
        guard containerView.superview == nil else{return}

        containerView.center = CGPoint(x: frame.width/2, y: frame.height/2+radius)
        
        distanceWalkingRunningLabel = DistanceWalkingRunningLabel(frame:CGRect(x: -containerView.center.x, y: -containerView.center.y+frame.height*0.17, width: frame.width, height: frame.height*0.6))
        stepCountLabel = StepCountLabel(size: CGSize(width:frame.width,height:frame.height*0.47), center: CGPoint(x: radius*sin(CGFloat.pi/3), y: -radius*sin(CGFloat.pi/6)))
        
        containerView.addSubview(stepCountLabel)
        containerView.addSubview(distanceWalkingRunningLabel)

        addSubview(containerView)
    }
    
    private func initDotView(){
        guard dot.superview == nil else{return}
        dot.frame.size = CGSize(width: 10, height: 10)
        dot.center = CGPoint(x: frame.width*2/5, y: 66)
        dot.layer.cornerRadius = dot.frame.width
        dot.layer.backgroundColor = UIColor.white.cgColor
        addSubview(dot)
    }

    private func initBottomDecorativeView(){
        guard decorativeView.superview == nil else{return}
        let height = frame.height*0.24
        let width = frame.width
        
        decorativeView.frame = CGRect(x: 0, y: frame.height-height, width: width, height: height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addCurve(to: CGPoint(x: width, y:height), controlPoint1: CGPoint(x:width/3,y:height/2), controlPoint2: CGPoint(x:width/3*2,y:height/2))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        
        decorativeView.layer.addSublayer(shapeLayer)
        if bottomDecorativeCurveView == nil {
            bottomDecorativeCurveView = createBottomDecorativeCurve(withBottomDecorativeViewSize: CGSize(width: width, height: height))
            decorativeView.addSubview(bottomDecorativeCurveView!)
        }
        addSubview(decorativeView)
        
    }
    
    private func createBottomDecorativeCurve(withBottomDecorativeViewSize size:CGSize)-> UIView{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: size.height))
        path.addCurve(to: CGPoint(x: size.width, y:size.height), controlPoint1: CGPoint(x:size.width/3,y:size.height/2), controlPoint2: CGPoint(x:size.width/3*2,y:size.height/2))
        
        let shapeLayer = CAShapeLayer()
        let shapeLayerTwo = CAShapeLayer()

        for layer in [shapeLayer,shapeLayerTwo] {
            layer.path = path.cgPath
            layer.lineWidth = 1
            layer.fillColor = nil
            let strokingPath = CGPath(__byStroking: layer.path!, transform: nil, lineWidth: 1, lineCap: .round, lineJoin: .miter, miterLimit: 1)
            layer.bounds = (strokingPath?.boundingBoxOfPath)!
            layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        }
        shapeLayer.strokeColor = UIColor(white: 1, alpha: 0.5).cgColor
        shapeLayerTwo.strokeColor = UIColor(white: 1, alpha: 0.3).cgColor
        
        shapeLayerTwo.transform = CATransform3DMakeRotation(2*CGFloat.pi/180, 0, 0, 1)
        
        let shapeLayerTwoAnimation = CABasicAnimation(keyPath: "position.y")
        shapeLayerTwoAnimation.fromValue = shapeLayer.position.y+3
        shapeLayerTwoAnimation.toValue = shapeLayer.position.y-3
        shapeLayerTwoAnimation.repeatCount = Float(Int.max)
        shapeLayerTwoAnimation.autoreverses = true
        shapeLayerTwoAnimation.duration = 5
        shapeLayerTwo.add(shapeLayerTwoAnimation, forKey: "positionYAnimation")
        
        let shapeLayerAnimation = CABasicAnimation(keyPath: "position.y")
        shapeLayerAnimation.fromValue = shapeLayer.position.y-3
        shapeLayerAnimation.toValue = shapeLayer.position.y+3
        shapeLayerAnimation.repeatCount = Float(Int.max)
        shapeLayerAnimation.autoreverses = true
        shapeLayerAnimation.duration = 5
        shapeLayer.add(shapeLayerAnimation, forKey: "positionYAnimation")

        let curveView = UIView()
        curveView.frame.origin = CGPoint(x:frame.width/2,y:size.height-shapeLayer.frame.height-3)
        curveView.layer.addSublayer(shapeLayer)
        curveView.layer.addSublayer(shapeLayerTwo)
        return curveView
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
        bottomDecorativeCurveView?.transform = .identity
    }
    
    private func swipeCounterclockwise(){
        containerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/3)
        dot.center.x = frame.width*3/5
        bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: -bottomDecorativeCurveRotateDegree)
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
                    bottomDecorativeCurveView?.transform = .identity
                }
                if process < 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*process)
                    dot.center.x = frame.width*2/5-frame.width/5*process
                    bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: bottomDecorativeCurveRotateDegree*process)
                }
            case .step:
                hideDistanceWalkingRunningSublabel(alpha: 1)
                hideStepCountSublabel(alpha: 0)
                if process > 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*(process-1))
                    dot.center.x = frame.width*3/5-frame.width/5*process
                    bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: -bottomDecorativeCurveRotateDegree*(1-process))
                }
                if process < 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*(process/2-1))
                    dot.center.x = frame.width*3/5
                    bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: -bottomDecorativeCurveRotateDegree)
                }
            }
        }
    }
}
