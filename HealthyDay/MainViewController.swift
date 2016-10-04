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

    private let stepBarItem = CustomBarBtnItem(buttonFrame: CGRect(x: 50, y: 0, width: 50, height: 22),title:"step", itemType:.right)
    
    private let runningBarItem = CustomBarBtnItem(buttonFrame: CGRect(x: 50, y: 0, width: 50, height: 22),title:"run", itemType:.left)
    
    @IBOutlet weak var stepBarChartView: UIView!
    
    @IBAction func buttonTouch(_ sender: UIButton) {
        
        print("tapButton")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorize{(success,error) in
            print("Error == \(error)")
            print("HealthKit authorize: \(success)")
        }
        initMainInfoView()
     
        runningBarItem.addTarget(self, action:  #selector(MainViewController.swipeRight(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = runningBarItem
        stepBarItem.addTarget(self, action:  #selector(MainViewController.swipeLeft(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = stepBarItem

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
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStepDetailVC"{
            guard let stepDetailVC = segue.destination as? StepDetailViewController else {return}
            #if !(arch(i386) || arch(x86_64))
                healthManager.readStepCount(periodDataType: .Weekly){ [unowned self] (counts,error) in
                    if counts != nil && error == nil{
                        DispatchQueue.main.async {
                            stepDetailVC.stepCounts = counts!
                        }
                    }
                }
                healthManager.readDistanceWalkingRunning(periodDataType: .Weekly){ [unowned self] (distances,error) in
                    if distances != nil && error == nil{
                        DispatchQueue.main.async {
                            stepDetailVC.distances = distances!
                        }
                    }
                }
            #endif
        }
    }
    
    private func initMainInfoView(){
        mainInfoView = MainInformationView(frame:CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height/3))
        view.addSubview(mainInfoView)
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeRight(_:)))
        rightGestureRecognizer.direction = .right
        let leftgestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeLeft(_:)))
        leftgestureRecognizer.direction = .left
        mainInfoView.addGestureRecognizer(rightGestureRecognizer)
        mainInfoView.addGestureRecognizer(leftgestureRecognizer)
    }
    
    func swipeLeft(_ sender:AnyObject){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut,.beginFromCurrentState], animations: {[unowned self] in
            self.mainInfoView.swipeCounterclockwise()

            }, completion:  nil)
        
        print(stepBarChartView.frame)
    }
    
    func swipeRight(_ sender:AnyObject){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut,.beginFromCurrentState], animations: {[unowned self] in
            self.mainInfoView.swipeClockwise()
            
            }, completion:  nil)
    }
}

