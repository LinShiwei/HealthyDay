//
//  Define.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/26.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import Foundation
import UIKit
let windowBounds = UIScreen.main.bounds

struct ThemeColor {

    let lightColor: UIColor
    let thickColor: UIColor
}

let theme = ThemeColor(
    lightColor:rgbColor(red:0x52, green:0xC2, blue: 0x34, alpha: 1),
    thickColor:rgbColor(red: 0x3C, green: 0xA5, blue: 0x5C, alpha: 1)
)


func rgbColor(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)->UIColor{
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0 , alpha: alpha)
}
