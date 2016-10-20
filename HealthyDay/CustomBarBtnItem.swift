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

internal class CustomBarBtnItem: UIBarButtonItem {

    private let button : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor(red:1,green:1,blue:1,alpha:0.7), for: .normal)
        btn.setTitleColor(UIColor.white, for: .disabled)
        return btn
    }()
    internal var enable = true{
        didSet{
            button.isEnabled = enable
        }
    }
    internal init(buttonFrame frame:CGRect, title:String, itemType type:BarBtnItemType){
        super.init()
        let backView = UIView(frame:CGRect(x: 0, y: 0, width: frame.width+frame.minX, height: 22))
        button.setTitle(title, for: .normal)
        if type == .left {
            button.frame = frame
        }else{
            let origin = CGPoint(x: backView.frame.width-frame.width-frame.minX, y: backView.frame.minY)
            button.frame = CGRect(origin: origin, size: frame.size)
        }
        backView.addSubview(button)
        customView = backView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents){
        button.addTarget(target, action: action, for: controlEvents)
    }
}
