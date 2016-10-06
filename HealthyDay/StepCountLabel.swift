//
//  swift
//  HealthyDay
//
//  Created by Linsw on 16/10/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepCountLabel: UILabel {

    let nameLabel = UILabel()
    var subviewsAlpha : CGFloat = 1{
        didSet{
            for view in subviews {
                view.alpha = subviewsAlpha
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size:CGSize, center:CGPoint){
        super.init(frame: CGRect(origin: CGPoint(x:0,y:0), size: size))
        self.center = center
        textAlignment = .center
        textColor = UIColor.white
        adjustsFontSizeToFitWidth = true
        transform = CGAffineTransform(rotationAngle: CGFloat.pi/3)
//        backgroundColor = UIColor.blue
        text = "0"
        font = UIFont(name: "DINCondensed-Bold", size: 90)

        nameLabel.frame = CGRect(x: 0, y: 0, width: size.width, height: 50)
        nameLabel.text = "今日步数"
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        addSubview(nameLabel)

    }
}
