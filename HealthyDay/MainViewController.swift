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
        runningBarItem.enable = false
        self.navigationItem.leftBarButtonItem = runningBarItem
        stepBarItem.addTarget(self, action:  #selector(MainViewController.swipeLeft(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = stepBarItem

        
    }

    func didPan(_ sender:UIPanGestureRecognizer){
        mainInfoView.animationProcess = sender.translation(in: view).x/windowBounds.width
        switch sender.state {
        case .ended,.cancelled:
            let velocityX = sender.velocity(in: view).x
            if velocityX > 300{
                swipeRight(sender)
                break
            }
            if velocityX < -300{
                swipeLeft(sender)
                break
            }
            if mainInfoView.animationProcess > 0.4 {
                swipeRight(sender)
            }else{
                if mainInfoView.animationProcess < -0.4 {
                    swipeLeft(sender)
                }else{
                    if stepBarItem.enable {
                        swipeRight(sender)
                    }else{
                        swipeLeft(sender)
                    }
                }
            }
            print("ended \(sender.velocity(in: view))")
        default: break
        }
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
                healthManager.readStepCount(periodDataType: .Weekly){(counts,error) in
                    if counts != nil && error == nil{
                        DispatchQueue.main.async {
                            stepDetailVC.stepCounts = counts!
                        }
                    }
                }
                healthManager.readDistanceWalkingRunning(periodDataType: .Weekly){(distances,error) in
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
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPan(_:)))
        mainInfoView = MainInformationView(frame:CGRect(x: 0, y: 66, width: view.frame.width, height: view.frame.height/3))
        mainInfoView.addGestureRecognizer(panGestureRecognizer)
        view.addSubview(mainInfoView)
    }
    
    func swipeLeft(_ sender:AnyObject){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut,.beginFromCurrentState], animations: {[unowned self] in
            self.mainInfoView.swipeCounterclockwise()
            self.stepBarItem.enable = false
            self.runningBarItem.enable = true
            }, completion:  nil)
        
        print(stepBarChartView.frame)
    }
    
    func swipeRight(_ sender:AnyObject){
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState,.curveEaseInOut,.beginFromCurrentState], animations: {[unowned self] in
            self.mainInfoView.swipeClockwise()
            self.stepBarItem.enable = true
            self.runningBarItem.enable = false
            }, completion:  nil)
    }
}

