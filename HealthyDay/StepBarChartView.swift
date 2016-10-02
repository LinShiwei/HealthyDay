//
//  StepBarChartView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/1.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepBarChartView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getDateLabelTexts()->[String]{
        let currentDate = Date()
        var texts = [String]()
        for day in 0...6 {
            let dateDescription = Date(timeInterval: -24*3600*Double(day), since: currentDate).description
            let range = dateDescription.index(dateDescription.startIndex, offsetBy: 8)..<dateDescription.index(dateDescription.startIndex, offsetBy: 10)
            texts.append(dateDescription.substring(with: range))
        }
        assert(texts.count == 7)
        return texts
    }
}
