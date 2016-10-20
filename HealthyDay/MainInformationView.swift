//
//  MainInformationView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/2.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

internal protocol MainInfoViewTapGestureDelegate {
    func didTap(inLabel label:UILabel)
}

internal class MainInformationView: UIView{
//MARK: Property
    private var stepCountLabel : StepCountLabel!
    private var distanceWalkingRunningLabel : DistanceWalkingRunningLabel!
    
    private let containerView = UIView()
    private let dot = UIView()
    private let labelMaskView = UIView()
    private let decorativeView = UIView()
    private let gradientLayer = CAGradientLayer()
    private var bottomDecorativeCurveView : BottomDecorativeCurve?

    private let bottomDecorativeCurveRotateDegree : CGFloat = CGFloat.pi/180*2
    
    internal var stepCount = 0{
        didSet{
            stepCountLabel.stepCount = stepCount
        }
    }
    internal var distance = 0{
        didSet{
            distanceWalkingRunningLabel.text = String(format:"%.2f",Double(distance)/1000)
        }
    }
    
    internal var delegate : MainInfoViewTapGestureDelegate?
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
        addGestureToSelf()
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
            bottomDecorativeCurveView = BottomDecorativeCurve(withMainInfoViewFrame: frame, andBottomDecorativeViewSize: CGSize(width: width, height: height))
            decorativeView.addSubview(bottomDecorativeCurveView!)
        }
        addSubview(decorativeView)
        
    }
    
//MARK: Gesture Helper
    private func addGestureToSelf(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainInformationView.didTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    internal func didTap(_ sender: UITapGestureRecognizer){
        if pointIsInLabelText(point:sender.location(in: stepCountLabel), label:stepCountLabel){
            delegate?.didTap(inLabel: stepCountLabel)
        }
        
        if pointIsInLabelText(point: sender.location(in: distanceWalkingRunningLabel), label: distanceWalkingRunningLabel){
            delegate?.didTap(inLabel: distanceWalkingRunningLabel)
        }
    }
    
    private func pointIsInLabelText(point:CGPoint, label:UILabel)->Bool{
        if (abs(point.x-label.bounds.width/2) < label.textRect(forBounds: label.bounds, limitedToNumberOfLines: 0).width/2)&&(abs(point.y-label.bounds.height/2) < label.textRect(forBounds: label.bounds, limitedToNumberOfLines: 0).height/2){
            return true
        }else{
            return false
        }
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
   
    internal func panAnimation(progress: CGFloat, currentState: MainVCState){
        assert(progress >= -1 && progress <= 1)
        switch progress {
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
                if progress > 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*progress/2)
                    dot.center.x = frame.width*2/5 //可以去掉吗
                    bottomDecorativeCurveView?.transform = .identity
                }
                if progress < 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*progress)
                    dot.center.x = frame.width*2/5-frame.width/5*progress
                    bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: bottomDecorativeCurveRotateDegree*progress)
                }
            case .step:
                hideDistanceWalkingRunningSublabel(alpha: 1)
                hideStepCountSublabel(alpha: 0)
                if progress > 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*(progress-1))
                    dot.center.x = frame.width*3/5-frame.width/5*progress
                    bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: -bottomDecorativeCurveRotateDegree*(1-progress))
                }
                if progress < 0 {
                    containerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3*(progress/2-1))
                    dot.center.x = frame.width*3/5
                    bottomDecorativeCurveView?.transform = CGAffineTransform(rotationAngle: -bottomDecorativeCurveRotateDegree)
                }
            }
        }
    }
    
    internal func refreshAnimations(){
        bottomDecorativeCurveView?.refreshAnimation()
    }
}
