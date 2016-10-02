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
    
    private let healthManager = HealthManager()
    
    private var mainInfoView : MainInformationView!
    
    @IBAction func buttonTouch(_ sender: UIButton) {
        print("tapButton")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorize{(success,error) in
            print(error)
            print("HealthKit authorize: \(success)")
        }
        
        mainInfoView = MainInformationView(frame:CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height/3))
        view.addSubview(mainInfoView)
        let gestureRecognizer1 = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeRight(_:)))
        gestureRecognizer1.direction = .right
        let gestureRecognizer2 = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeLeft(_:)))
        gestureRecognizer2.direction = .left
        mainInfoView.addGestureRecognizer(gestureRecognizer1)
        mainInfoView.addGestureRecognizer(gestureRecognizer2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        #if !(arch(i386) || arch(x86_64))
            healthManager.readStepCount(periodDataType: .Current){ [unowned self] (counts,error) in
                if counts != nil && error == nil{
                    DispatchQueue.main.async {
                        self.mainInfoView.stepCount = counts![0]
                    }
                }else{
                    DispatchQueue.main.async {
                        self.mainInfoView.stepCount = 0
                    }
                }
            }
            healthManager.readDistanceWalkingRunning(periodDataType:.Current){ [unowned self] (distances,error) in
                if distances != nil && error == nil{
                    DispatchQueue.main.async {
                        self.mainInfoView.distance = distances![0]
                    }
                }else{
                    DispatchQueue.main.async {
                        self.mainInfoView.distance = 0
                    }
                }
            }
        #endif
    }
        
    func swipeLeft(_ sender:UISwipeGestureRecognizer){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut,.beginFromCurrentState], animations: {[unowned self] in
            self.mainInfoView.swipeCounterclockwise()

            }, completion:  nil)
    }
    
    func swipeRight(_ sender:UISwipeGestureRecognizer){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut,.beginFromCurrentState], animations: {[unowned self] in
            self.mainInfoView.swipeClockwise()
            
            }, completion:  nil)
    }
}

