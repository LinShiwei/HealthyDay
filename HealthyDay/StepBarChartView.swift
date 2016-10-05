//
//  StepBarChartView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/1.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepBarChartView: UIView {

    var distinationStepCount = 10000
    
    var stepCounts = [Int](){
        didSet{
            assert(stepCounts.count == 7)
            assert(stepBars.count == 7)
            for index in 0...6 {
                stepBars[index].stepCount = stepCounts[index]
            }
        }
    }
    
    private var stepBars = [StepBar]()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.yellow

    }
  
    override func draw(_ rect: CGRect) {
        addStepBars()

    }
    private func getDateLabelTexts()->[String]{
        let currentDate = Date()
        var texts = [String]()
        for day in 0...6 {
            let dateDescription = Date(timeInterval: -24*3600*Double(day), since: currentDate).description
            let range = dateDescription.index(dateDescription.startIndex, offsetBy: 8)..<dateDescription.index(dateDescription.startIndex, offsetBy: 10)
            texts.append(dateDescription.substring(with: range)+" 日")
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
    
    func hide(){
        alpha = 0
    }
    
    func show(){
        alpha = 1
    }
}
