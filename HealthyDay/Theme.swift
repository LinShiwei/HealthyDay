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
    
    private init(){}
    
    
    
}
