//
//  StepLineChart.swift
//  HealthyDay
//
//  Created by Sun Haoting on 16/10/8.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepLineChart: UIScrollView {
    
    var currentIndex = 0
    var viewSize : CGSize = CGSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.height * 3.5 / 15.0)

    var stepCountsData = [Int]()
    var maxStepCount = Int()

    var stepEverydayViews = [StepEverydayView]()
    var linesInStepLineChart = [CAShapeLayer]()
    var dotsPosition = [CGPoint]()
    var gradientLayer = CAGradientLayer()
    var gradientMaskView = CAShapeLayer()

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
            path.close()
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


