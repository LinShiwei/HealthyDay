//
//  StepBarChartView.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/1.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepBarChartView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.yellow
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
