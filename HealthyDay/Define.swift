//
//  Define.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/26.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit
internal let windowBounds = UIScreen.main.bounds
internal let calendar = Calendar(identifier: .republicOfChina)
internal let theme = Theme.shared

struct ThemeColor {

    let lightColor: UIColor
    let thickColor: UIColor
}

let lineChart = ThemeColor(
    lightColor:rgbColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 0.5),
    thickColor:rgbColor(red: 0x15, green: 0xF9, blue: 0x50, alpha: 0.5)
)

let splitLine = ThemeColor(
    lightColor:rgbColor(red: 0xE3, green: 0xE3, blue: 0xE3, alpha: 1),
    thickColor:rgbColor(red: 0xDF, green: 0xDF, blue: 0xDF, alpha: 1)
)

internal func rgbColor(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)->UIColor{
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0 , alpha: alpha)
}

extension Date{
    func formatDescription()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
//MARK: Helper func
internal func durationFormatter(secondsDuration duration:Int)->String{
    let seconds = duration%60
    let minutes = (duration%3600)/60
    let hours = duration/3600
    return String(format: "%02d:%02d:%02d", arguments: [hours,minutes,seconds])
}

internal func durationPerKilometerFormatter(secondsDurationPK duration:Int)->String{
    let seconds = duration%60
    let minutes = (duration%3600)/60
    let hours = duration/3600
    if hours == 0 {
        return String(format: "%02d'%02d\"/公里", arguments: [minutes,seconds])
    }else{
        return String(format: "%02d:%02d:%02d/公里", arguments: [hours,minutes,seconds])
    }
}
