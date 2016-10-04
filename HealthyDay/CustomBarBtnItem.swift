//
//  CustomBarBtnItem.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/4.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

enum BarBtnItemType{
    case left
    case right
}

class CustomBarBtnItem: UIBarButtonItem {

    private let button = UIButton(type: .custom)
    var enable = true{
        didSet{
            button.isEnabled = enable
        }
    }
    init(buttonFrame frame:CGRect, title:String, itemType type:BarBtnItemType){
        super.init()
        let backView = UIView(frame:CGRect(x: 0, y: 0, width: frame.width+frame.minX, height: 22))
        if type == .left {
            button.frame = frame
        }else{
            let origin = CGPoint(x: backView.frame.width-frame.width-frame.minX, y: backView.frame.minY)
            button.frame = CGRect(origin: origin, size: frame.size)
        }
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.blue, for: .disabled)
        backView.addSubview(button)
        customView = backView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents){
        button.addTarget(target, action: action, for: controlEvents)
    }
}
