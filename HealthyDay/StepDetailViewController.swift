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
    
    internal var stepCounts = [Int](){
        didSet{
            configureView()
        }
    }
    internal var distances = [Int](){
        didSet{
//            print(distances)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "步数详情"
        automaticallyAdjustsScrollViewInsets = false
        configureView() 
    }
    
    private func configureView(){
        if stepCounts.count != 0 {
            if let view = stepDetailView {
                view.stepCountsData = stepCounts
            }
        }
    }
    
}

