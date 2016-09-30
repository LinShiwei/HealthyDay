//
//  ViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/23.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import HealthKit
import CoreLocation

class MainViewController: UIViewController {

    let healthManager = HealthManager()
   
    @IBOutlet weak var footStepCountLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func buttonTouch(_ sender: UIButton) {

        footStepCountLabel.text = "clear by button"
        distanceLabel.text = "clear by button"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorize{(success,error) in
            print(error)
            print("HealthKit authorize: \(success)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if !(arch(i386) || arch(x86_64))
            healthManager.readStepCount(periodDataType: .Current){ [unowned self] (counts,error) in
                if counts != nil && error == nil{
                    DispatchQueue.main.async {
                        self.footStepCountLabel.text = "\(counts![0]) Steps"
                    }
                }else{
                    DispatchQueue.main.async {
                        self.footStepCountLabel.text = "0 Step"
                    }
                }
            }
            healthManager.readDistanceWalkingRunning(periodDataType:.Current){ [unowned self] (distances,error) in
                if distances != nil && error == nil{
                    DispatchQueue.main.async {
                        self.distanceLabel.text = "\(distances![0]) Meters"
                    }
                }else{
                    DispatchQueue.main.async {
                        self.distanceLabel.text = "0 Meter"
                    }
                }
            }
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

