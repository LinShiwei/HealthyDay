//
//  swift
//  HealthyDay
//
//  Created by Linsw on 16/10/5.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

internal class StepCountLabel: UILabel {

    private let nameLabel = UILabel()
    private let targetLabel = UILabel()
    private var ringView : StepRingView!
    private let targetCount = 10000
    
    internal var stepCount : Int = 0 {
        didSet{
            text = "\(stepCount)"
            ringView.precent = Double(stepCount)/Double(targetCount)
        }
    }
    
    internal var subviewsAlpha : CGFloat = 1{
        didSet{
            nameLabel.alpha = subviewsAlpha
            targetLabel.alpha = subviewsAlpha
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
        text = "0"
        font = UIFont(name: "DINCondensed-Bold", size: 70/320*frame.width)

        nameLabel.frame = CGRect(x: 0, y: frame.height*0.184, width: size.width, height: frame.height*0.1)
        nameLabel.text = "今日步数"
        nameLabel.font = UIFont.systemFont(ofSize: 14/320*frame.width)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        addSubview(nameLabel)
        
        targetLabel.frame = CGRect(x: 0, y: frame.height*0.71, width: size.width, height: frame.height*0.1)
        targetLabel.text = "目标 \(targetCount)步"
        targetLabel.font = UIFont.systemFont(ofSize: 14/320*frame.width)
        targetLabel.adjustsFontSizeToFitWidth = true
        targetLabel.textAlignment = .center
        targetLabel.textColor = UIColor.white
        addSubview(targetLabel)
        

        ringView = StepRingView(size: CGSize(width:frame.height,height:frame.height), center: CGPoint(x:frame.width/2, y:frame.height/2), precent: 0.3)

        addSubview(ringView)
    
        transform = CGAffineTransform(rotationAngle: CGFloat.pi/3)
    }
}
