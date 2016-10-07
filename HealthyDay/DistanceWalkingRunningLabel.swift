//
//  swift
//  HealthyDay
//
//  Created by Linsw on 16/10/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class DistanceWalkingRunningLabel: UILabel {
    
    let nameLabel = UILabel()
    var subviewsAlpha : CGFloat = 1{
        didSet{
            for view in subviews {
                view.alpha = subviewsAlpha
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        textAlignment = .center
        textColor = UIColor.white
        adjustsFontSizeToFitWidth = true
        text = "0.00"
        font = UIFont(name: "DINCondensed-Bold", size: 90)
        
        initNameLabel()
    }
    
//    init(size:CGSize, center:CGPoint){
//        super.init(frame: CGRect(origin: CGPoint(x:0,y:0), size: size))
//        self.center = center
//        textAlignment = .center
//        textColor = UIColor.white
//        adjustsFontSizeToFitWidth = true
//        text = "0.00"
//        font = UIFont(name: "DINCondensed-Bold", size: 90)
//        
//        initNameLabel()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initNameLabel(){
        
        guard nameLabel.superview == nil else{return}
        nameLabel.frame = CGRect(x: 0, y: frame.height*0.21, width: frame.width, height: frame.height*0.072)
        nameLabel.text = "今日总里程(公里)"
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        nameLabel.adjustsFontSizeToFitWidth = true
        addSubview(nameLabel)
    }
}
