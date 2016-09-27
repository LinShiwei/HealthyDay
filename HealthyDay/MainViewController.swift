//
//  ViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/23.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import HealthKit


class MainViewController: UIViewController {

    let healthManager = HealthManager()
    
    @IBOutlet weak var footStepCountLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func buttonTouch(_ sender: UIButton) {

       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorize(nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if !(arch(i386) || arch(x86_64))
        healthManager.readCurrentStepCount{ [unowned self] (count,error) in
            if count != nil && error == nil{
                DispatchQueue.main.async {
                    self.footStepCountLabel.text = "\(count!) Steps"
                }
            }else{
                DispatchQueue.main.async {
                    self.footStepCountLabel.text = "0 Step"
                }
            }
        }
        healthManager.readDistanceWlakingRunning{ [unowned self] (distance,error) in
            if distance != nil && error == nil{
                DispatchQueue.main.async {
                    self.distanceLabel.text = "\(distance!) Meters"
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

