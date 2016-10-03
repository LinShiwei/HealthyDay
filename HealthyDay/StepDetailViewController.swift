//
//  StepsDetailViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/3.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepDetailViewController: UIViewController {

    var stepCounts = [Int](){
        didSet{
            print(stepCounts)
        }
    }
    var distances = [Int](){
        didSet{
            print(distances)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
