//
//  StepBarChartView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/1.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

internal class StepBarChartView: UIView {

    internal var distinationStepCount = 10000
    
    internal var stepCounts = [Int](){
        didSet{
            assert(stepCounts.count == 7)
            assert(stepBars.count == 7)
            for index in 0...6 {
                stepBars[index].stepCount = stepCounts[index]
            }
        }
    }
    
    private var stepBars = [StepBar]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addStepBars()
    }
    
    private func getDateLabelTexts()->[String]{
        let currentDate = Date()
        var texts = [String]()
        for day in 0...6 {
            let date = calendar.date(byAdding: .day, value: -day, to: currentDate)!
            texts.append(String(calendar.component(.day, from: date))+" 日")
        }
        assert(texts.count == 7)
        return texts
    }
    
    private func addStepBars(){
        guard stepBars.count == 0 else {return}
        let barTexts = getDateLabelTexts()
        let barInterval = frame.width/7
        let barWidth : CGFloat = 6
        for barNumber in 1...7 {
            let stepBar = StepBar(frame: CGRect(x: barInterval*CGFloat(barNumber)-barInterval/2-barWidth/2, y: 0, width: barWidth, height: frame.height))
            stepBar.day = barTexts[7-barNumber]
            stepBars.append(stepBar)
            addSubview(stepBar)
        }

    }
//MARK: Animation helper  
    private func hide(progress:CGFloat){
        transform = CGAffineTransform(translationX: 0, y: 20*progress)
        alpha = 1 - progress
    }
    
    private func show(progress:CGFloat){
        transform = CGAffineTransform(translationX: 0, y: 20*(1-progress))
        alpha = progress
    }
    
    internal func panAnimation(progress:CGFloat, currentState:MainVCState){
        assert(progress >= -1 && progress <= 1)
        switch progress {
        case 1:
            hide(progress: 1)
        case -1:
            show(progress: 1)
        default:
            switch currentState{
            case .step:
                if progress > 0{
                    hide(progress: progress)
                }
            case .running:
                if progress < 0{
                    show(progress: -progress)
                }
            }

        }
    }
}
