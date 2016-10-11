//
//  StepsDetailViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/3.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

class StepDetailViewController: UIViewController {
    
    @IBOutlet weak var stepDetailView: StepDetailView!
    
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
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
}
