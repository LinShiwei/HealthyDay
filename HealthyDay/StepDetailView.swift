//
//  StepDetailView.swift
//  HealthyDay
//
//  Created by Sun Haoting on 16/10/9.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepDetailView: UIView {
    
    var currentIndex = 0
    var stepLineChart : StepLineChart!
    var label = UILabel()
    var stepCountsData = [2000, 4500, 6000, 3500, 12000]
    var maxStepCount = 10000
    var targetCount = 10000
    var viewSize = CGSize()
    let centerGradientLayer = CAGradientLayer()
    var spliteLines = [CALayer]()
    var maxStepCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initStepLineChart()
        initCenterGradientLayer()
    }
    override func layoutSubviews() {
//        initLabel()
        initMaxStepCount()
        initStepLineChart()
        initCenterGradientLayer()
        initSplitLines()
        initMaxStepCountLabel()
    }
    
    private func initStepLineChart() {
        let totalDataCount = stepCountsData.count
        var lineChartColumn = totalDataCount + 6
        if totalDataCount == 0 {
            lineChartColumn = 7
        }
        let lineChartWidth = CGFloat(lineChartColumn) * frame.width / 7
        viewSize = CGSize(width: frame.width / 7, height: frame.height)
        stepLineChart = StepLineChart(frame: CGRect(x: 0, y: frame.height * 2.5 / 15.0, width: frame.width, height: frame.height*0.3), stepCountsData: stepCountsData, maxStepCount: maxStepCount)
        stepLineChart.contentSize = CGSize(width: lineChartWidth, height: 0)
        stepLineChart.contentOffset = CGPoint(x: lineChartWidth - frame.width, y: 0)
        stepLineChart.delegate = self
        addSubview(stepLineChart)
    }
    
    private func initMaxStepCount() {
        let stepCount = stepCountsData.max()
        guard stepCount != nil else {return}
        maxStepCount = max(stepCount!, targetCount)
    }
    
    func hideStepEverydayViewLabel(index: Int, alpha: CGFloat){
        guard stepLineChart.stepEverydayViews[index].stepLabel.alpha != alpha else {return}
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {[unowned self] in
            self.stepLineChart.stepEverydayViews[index].stepLabel.alpha = alpha
            }, completion: nil)
    }
    
    private func initMaxStepCountLabel() {
        maxStepCountLabel.frame = CGRect(x: 0, y: 100, width: 20, height: 20)
        maxStepCountLabel.text = "\(maxStepCount)"
        maxStepCountLabel.textAlignment = .center
        maxStepCountLabel.backgroundColor = UIColor.black
        maxStepCountLabel.adjustsFontSizeToFitWidth = true
        maxStepCountLabel.font = UIFont(name: "DINCondensed-Bold", size: 70/320*frame.width)
        addSubview(maxStepCountLabel)
    }
    
    private func initCenterGradientLayer() {
        guard centerGradientLayer.superlayer == nil else {return}
        centerGradientLayer.frame = CGRect(x: frame.width * 3 / 7, y: frame.height * 3.5 / 15.0, width: frame.width / 7, height: frame.height * 3.5 / 15.0)
        centerGradientLayer.colors = [lineChart.lightColor.cgColor, lineChart.thickColor.cgColor]
        layer.addSublayer(centerGradientLayer)
    }
    
    private func initSplitLines() {
        spliteLines.append(SplitLine(frame: CGRect(x: 0, y: 500, width: 100, height: 10)))
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}

extension StepDetailView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCenterX = stepLineChart.currentCenter().x
        currentIndex = Int(round((currentCenterX - viewSize.width / 2) / viewSize.width))
        guard currentIndex >= 3 && currentIndex - 2 <= stepLineChart.stepEverydayViews.count else {return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 0)
        guard stepLineChart.contentOffset.x == 0 || abs(stepLineChart.contentOffset.x - (stepLineChart.contentSize.width - frame.width)) < 0.12 else{return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 1)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            stepLineChart.setContentOffset(stepLineChart.contentOffsetForIndex(currentIndex), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        stepLineChart.setContentOffset(stepLineChart.contentOffsetForIndex(currentIndex), animated: true)
        guard currentIndex >= 3 && currentIndex - 2 <= stepLineChart.stepEverydayViews.count else {return}
        guard stepLineChart.contentOffset.x == 0 || abs(stepLineChart.contentOffset.x - (stepLineChart.contentSize.width - frame.width)) < 0.12 else{return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 1)
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard currentIndex >= 3 && currentIndex - 2 <= stepLineChart.stepEverydayViews.count else {return}
        hideStepEverydayViewLabel(index: currentIndex - 3, alpha: 1)
    }
    

}

class SplitLine: CALayer {
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.borderColor = UIColor.gray.cgColor
        self.borderWidth = 1
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


    

