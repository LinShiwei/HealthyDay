//
//  MainInformationView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/2.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class MainInformationView: UIView {
    private let dot = UIView()
    private let stepCountLabel = UILabel()
    private let distanceWalkingRunningLabel = UILabel()
    private let containerView = UIView()
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
    
    override init(frame:CGRect){
        super.init(frame:frame)
        backgroundColor = UIColor.yellow
        initContainerView(rotateRadius: frame.width/2+frame.height/4)
//        initContainerView(withSuperView: self, rotateRadius: frame.height/4)
        initDotView()
    }
    
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
        dot.center = CGPoint(x: frame.width*2/5, y: 10)
        dot.layer.cornerRadius = dot.frame.width
        dot.layer.backgroundColor = UIColor.black.cgColor
        addSubview(dot)
    }
    
    func swipeClockwise(){
        containerView.transform = .identity
        dot.center.x = frame.width*2/5
    }
    
    func swipeCounterclockwise(){
        containerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        dot.center.x = frame.width*3/5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
