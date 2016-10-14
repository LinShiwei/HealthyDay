//
//  StartRunningButton.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StartRunningButton: UIButton {

    private let buttonDiameter : CGFloat = 100 //buttonRadius, should change in main.storyboard
    private let ringGap : CGFloat = 5

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = buttonDiameter/2
        layer.backgroundColor = theme.lightColor.cgColor
        tintColor = UIColor.white
        
        let ringLayer = CALayer()
        ringLayer.frame = CGRect(x: -ringGap, y: -ringGap, width: buttonDiameter+ringGap*2, height: buttonDiameter+ringGap*2)
        ringLayer.cornerRadius = buttonDiameter/2+ringGap
        ringLayer.borderColor = theme.lightColor.cgColor
        ringLayer.borderWidth = 1
        layer.addSublayer(ringLayer)
    }
//MARK: Animation helper    
    private func hide(progress:CGFloat){
        alpha = 1 - progress
        let scaleTransform = CGAffineTransform(scaleX: 1-0.5*progress, y: 1-0.5*progress)
        let scaleShiftTransform = scaleTransform.translatedBy(x: 0, y: (buttonDiameter/2+30)*progress)
        
        transform = scaleShiftTransform
    }
    
    private func show(progress:CGFloat){
        alpha = progress
        let scaleTransform = CGAffineTransform(scaleX: 0.5+0.5*progress, y: 0.5+0.5*progress)
        let scaleShiftTransform = scaleTransform.translatedBy(x: 0, y: (buttonDiameter/2+30)*(1-progress))
        
        transform = scaleShiftTransform
    }
    
    func panAnimation(progress:CGFloat, currentState:MainVCState){
        assert(progress >= -1 && progress <= 1)
        switch progress {
        case 1:
            show(progress: 1)
        case -1:
            hide(progress: 1)
        default:
            switch currentState{
            case .step:
                if progress > 0{
                    show(progress: progress)
                }
            case .running:
                if progress < 0{
                    hide(progress: -progress)
                }
            }
        }
    }
}
