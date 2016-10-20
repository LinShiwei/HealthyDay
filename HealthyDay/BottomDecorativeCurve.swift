//
//  BottomDecorativeCurve.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/18.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class BottomDecorativeCurve: UIView {

    private let shapeLayer = CAShapeLayer()
    private let shapeLayerTwo = CAShapeLayer()
    private let shapeLayerTwoAnimation = CABasicAnimation(keyPath: "position.y")
    private let shapeLayerAnimation = CABasicAnimation(keyPath: "position.y")

    private override init(frame:CGRect){
        super.init(frame:frame)
    }
    
    init(withMainInfoViewFrame frame:CGRect, andBottomDecorativeViewSize size:CGSize){
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: size.height))
        path.addCurve(to: CGPoint(x: size.width, y:size.height), controlPoint1: CGPoint(x:size.width/3,y:size.height/2), controlPoint2: CGPoint(x:size.width/3*2,y:size.height/2))
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
        
        shapeLayerTwoAnimation.fromValue = shapeLayer.position.y+3
        shapeLayerTwoAnimation.toValue = shapeLayer.position.y-3
        shapeLayerTwoAnimation.repeatCount = Float(Int.max)
        shapeLayerTwoAnimation.autoreverses = true
        shapeLayerTwoAnimation.duration = 5
        
        shapeLayerAnimation.fromValue = shapeLayer.position.y-3
        shapeLayerAnimation.toValue = shapeLayer.position.y+3
        shapeLayerAnimation.repeatCount = Float(Int.max)
        shapeLayerAnimation.autoreverses = true
        shapeLayerAnimation.duration = 5
        
        super.init(frame: CGRect(origin: CGPoint(x:frame.width/2,y:size.height-shapeLayer.frame.height-3), size: CGSize(width: 0, height: 0)))
        refreshAnimation()
        layer.addSublayer(shapeLayer)
        layer.addSublayer(shapeLayerTwo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAnimation(){
        shapeLayer.removeAllAnimations()
        shapeLayerTwo.removeAllAnimations()
        shapeLayer.add(shapeLayerAnimation, forKey: "positionYAnimation")
        shapeLayerTwo.add(shapeLayerTwoAnimation, forKey: "positionYAnimation")
    }
}
