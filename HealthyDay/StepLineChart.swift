//
//  StepLineChart.swift
//  HealthyDay
//
//  Created by Sun Haoting on 16/10/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepLineChart: UIScrollView {
    
    var stepEverydayViews = [StepEverydayView]()
    
    fileprivate var viewSize : CGSize = CGSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.height * 3.5 / 15.0)
    fileprivate var stepCountsData = [Int]()
    fileprivate var maxStepCount = Int()
    fileprivate var currentIndex = 0
    fileprivate var linesInStepLineChart = [CAShapeLayer]()
    fileprivate var dotsPosition = [CGPoint]()
    fileprivate var gradientLayer = CAGradientLayer()
    fileprivate var gradientMaskView = CAShapeLayer()
    fileprivate var dateLabels = [UILabel]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        initStepEverydayView()
    }
    
    private func initScrollView() {
        //        autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        bounces = true
        isScrollEnabled = true
        clipsToBounds = true
        showsHorizontalScrollIndicator = false
    }
    
    init(frame: CGRect, stepCountsData: [Int], maxStepCount: Int){
        super.init(frame: frame)
        self.stepCountsData = stepCountsData
        self.maxStepCount = maxStepCount
        initScrollView()
        if stepCountsData.count != 0 {
            initStepEverydayView()
            initGradiantLayer()
            initGradientMaskView()
            initLine()
        }
        initDateLabel()
    }
    
    private func dayOfTheWeek(offset: Int) -> String {
        let interval = Date().timeIntervalSince1970 + 8 * 3600
        let days = Int(interval / 86400) + offset
        switch (days - 3) % 7 {
        case 0:
            return "周日"
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        default:
            fatalError("weekday Error")
        }
    }
    
    private func initDateLabel() {
        let currentDate = Date()
        var stepRange = Int()
        if stepCountsData.isEmpty == true {
            stepRange = 6
        } else {
            stepRange = stepCountsData.count + 5
        }
        for day in 0...stepRange {
            let dateDescription = Date(timeInterval: 24*3600*Double(-stepRange + 3 + day), since: currentDate).formatDescription()
            let range = dateDescription.index(dateDescription.startIndex, offsetBy: 8)..<dateDescription.index(dateDescription.startIndex, offsetBy: 10)
            let dayOfWeek = dayOfTheWeek(offset: -stepRange + 3 + day)
            let text = dayOfWeek + "\n" + dateDescription.substring(with: range)
            let dateLabel = UILabel(frame: CGRect(x: viewSize.width * CGFloat(day), y: viewSize.height, width: viewSize.width, height: viewSize.height / 3.5))
            dateLabel.text = text
            dateLabel.textColor = rgbColor(red: 0x9F, green: 0x9F, blue: 0x9F, alpha: 1)
            dateLabel.textAlignment = .center
            dateLabel.numberOfLines = 0
            dateLabel.font = UIFont(name: "STHeitiSC-Light", size: viewSize.width / 4.5)
            dateLabels.append(dateLabel)
            addSubview(dateLabel)
        }
    }
    
    
    
    private func initStepEverydayView() {
        for index in 0..<stepCountsData.count {
            let proportion = CGFloat(stepCountsData[index]) / CGFloat(maxStepCount)
            var isToday = false
            if index == stepCountsData.count - 1 {
                isToday = true
            }
            let stepEverydayView = StepEverydayView(frame: CGRect(x: CGFloat(3+index) * viewSize.width, y: 0, width: viewSize.width, height: viewSize.height),proportion: proportion,stepCount: stepCountsData[index], isToday: isToday )
            stepEverydayViews.append(stepEverydayView)
            stepEverydayView.layer.zPosition = 1
            addSubview(stepEverydayView)
            let dotPosition = CGPoint(x: (3.5 + CGFloat(index)) * viewSize.width, y: stepEverydayView.dotPosition().y)
            dotsPosition.append(dotPosition)
        }
    }
    
    private func initLine() {
        for index in 0..<stepCountsData.count - 1 {
            let path = UIBezierPath()
            path.move(to: dotsPosition[index])
            path.addLine(to: dotsPosition[index + 1])
//            path.close()
            let lineInLineChart = CAShapeLayer()
            lineInLineChart.path = path.cgPath
            lineInLineChart.lineWidth = 3.5
            lineInLineChart.strokeColor = UIColor.gray.cgColor
            lineInLineChart.fillColor = UIColor.gray.cgColor
            layer.addSublayer(lineInLineChart)
        }
    }
    
    private func initGradiantLayer() {
        guard gradientLayer.superlayer == nil else {return}
        gradientLayer.frame = CGRect(x: 3.5 * viewSize.width, y: viewSize.height / 3.5, width: CGFloat(stepCountsData.count - 1) * viewSize.width, height: viewSize.height * 2.5 / 3.5)
        gradientLayer.colors = [lineChart.thickColor.cgColor, lineChart.lightColor.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    private func initGradientMaskView() {
        guard gradientMaskView.superlayer == nil else {return}
        let path = UIBezierPath()
        path.move(to: dotsPosition[0])
        for index in 0..<stepCountsData.count - 1 {
            path.addLine(to: dotsPosition[index + 1])
        }
        path.addLine(to: CGPoint(x: dotsPosition[stepCountsData.count - 1].x, y: 0))
        path.addLine(to: CGPoint(x: dotsPosition[0].x, y: 0))
        path.close()
        gradientMaskView.path = path.cgPath
        gradientMaskView.fillColor = UIColor.white.cgColor
        layer.addSublayer(gradientMaskView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func currentCenter() -> CGPoint {
        let x = contentOffset.x + bounds.width / 2.0
        let y = contentOffset.y
        return CGPoint(x: x, y: y)
    }
    
    func contentOffsetForIndex(_ index: Int) -> CGPoint {
        let centerX = centerForViewAtIndex(index).x
        let x: CGFloat = centerX - self.bounds.width / 2.0
        //        x = max(0, x)
        //        x = min(x, scrollView.contentSize.width)
        return CGPoint(x: x, y: 0)
    }
    
    func centerForViewAtIndex(_ index: Int) -> CGPoint {
        let y = bounds.midY
        let x = CGFloat(index) * viewSize.width + viewSize.width / 2
        return CGPoint(x: x, y: y)
    }
    
    
}
