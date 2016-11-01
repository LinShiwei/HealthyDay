//
//  Theme.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/29.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit

internal final class Theme {
    
    static let shared = Theme()
    
    let lightThemeColor = rgbColor(red:0x52, green:0xC2, blue: 0x34, alpha: 1)
    let darkThemeColor = rgbColor(red: 0x3C, green: 0xA5, blue: 0x5C, alpha: 1)
    let translucentLightThemeColor = rgbColor(red:0x52, green:0xC2, blue: 0x34, alpha: 0.5)
    
    let lightTextColor = UIColor.lightGray
    let darkTextColor = UIColor.darkGray
    
    let lightLineChartColor = rgbColor(red: 0xFF, green: 0xFF, blue: 0xFF, alpha: 0.5)
    let thickLineChartColor = rgbColor(red: 0x15, green: 0xF9, blue: 0x50, alpha: 0.5)
    
    let lightSplitLineColor = rgbColor(red: 0xE3, green: 0xE3, blue: 0xE3, alpha: 1)
    let thickSplitLineColor = rgbColor(red: 0xDF, green: 0xDF, blue: 0xDF, alpha: 1)
    
    private init(){}
    
    
    
}
