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
    lightColor:rgbColor(red:147, green:249, blue: 185, alpha: 1),
    thickColor:rgbColor(red: 29, green: 151, blue: 108, alpha: 1)
)


func rgbColor(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)->UIColor{
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0 , alpha: alpha)
}
