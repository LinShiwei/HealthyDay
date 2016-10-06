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

enum MainVCState{
    case running,step
}

class MainViewController: UIViewController {
//MARK: Property
    private let healthManager = HealthManager()
    
    private var mainInfoView : MainInformationView!

    private let stepBarItem = CustomBarBtnItem(buttonFrame: CGRect(x: 85, y: 0, width: 50, height: 22),title:"记步", itemType:.right)
    private let runningBarItem = CustomBarBtnItem(buttonFrame: CGRect(x: 85, y: 0, width: 50, height: 22),title:"运动", itemType:.left)
    
    private var state = MainVCState.running
    
    @IBOutlet weak var stepBarChartView: StepBarChartView!
    @IBOutlet weak var startRunningBtn: StartRunningButton!

//MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        healthManager.authorize{(success,error) in
            print("Error == \(error)")
            print("HealthKit authorize: \(success)")
        }
        
        initMainInfoView()
        initStepBarChartView()
        
        runningBarItem.addTarget(self, action:  #selector(MainViewController.swipeRight(_:process:velocity:)), for: .touchUpInside)
        runningBarItem.enable = false
        self.navigationItem.leftBarButtonItem = runningBarItem
        stepBarItem.addTarget(self, action:  #selector(MainViewController.swipeLeft(_:process:velocity:)), for: .touchUpInside)
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
            #else
            mainInfoView.stepCount = 5000
            mainInfoView.distance = 2000
        #endif
    }
    
//MARK: Segue
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
                #else
//                stepDetailVC.stepCounts = [Int](repeatElement(4000, count: 7))
//                stepDetailVC.distances = [Int](repeatElement(1200, count: 7))
            #endif

        }
    }

//MARK: Subview init
    private func initMainInfoView(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPan(_:)))
        mainInfoView = MainInformationView(frame:CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/5*4))
        mainInfoView.addGestureRecognizer(panGestureRecognizer)
        view.insertSubview(mainInfoView, at: 0)
    }
    
    private func initStepBarChartView(){
        stepBarChartView.alpha = 0
        #if !(arch(i386) || arch(x86_64))
        healthManager.readStepCount(periodDataType: .Weekly){[unowned self](counts,error) in
            if counts != nil && error == nil{
                DispatchQueue.main.async {
                    self.stepBarChartView.stepCounts = counts!
                }
            }
        }
            #else
            
//            stepBarChartView.stepCounts = [Int](repeatElement(3000, count: 7))
//            
        #endif
    }
    
//MARK: Selector
    func didPan(_ sender:UIPanGestureRecognizer){
        let process = sender.translation(in: mainInfoView).x/mainInfoView.frame.width
        switch sender.state {
        case .ended,.cancelled:
            let velocityX = sender.velocity(in: view).x
            if velocityX > 900{
                swipeRight(sender, process: process, velocity: velocityX)
                break
            }
            if velocityX < -900{
                swipeLeft(sender, process: process, velocity: velocityX)
                break
            }
            if process > 0.4 {
                swipeRight(sender, process: process, velocity: velocityX)
            }else{
                if process < -0.4 {
                    swipeLeft(sender, process: process, velocity: velocityX)
                }else{
                    if state == .running {
                        swipeRight(sender, process: process, velocity: velocityX)
                    }else{
                        swipeLeft(sender, process: process, velocity: velocityX)
                    }
                }
            }
        default:
            mainInfoView.panAnimation(process: process, currentState: state)
            stepBarChartView.panAnimation(process: process, currentState: state)
            startRunningBtn.panAnimation(process: process, currentState: state)

        }
    }
    
    func swipeLeft(_ sender:AnyObject, process:CGFloat = -1, velocity:CGFloat){
        let duration : Double = {
            let baseDuration = 0.5
            let pro = Double(abs(process))
            let vel = Double(abs(velocity))
            if vel > 900{
                switch state{
                case .step:
                    return baseDuration*pro*900/vel
                case .running:
                    return (baseDuration - baseDuration*pro)*900/vel
                }
            }else{
                switch state{
                case .step:
                    return baseDuration*pro
                case .running:
                    return baseDuration - baseDuration*pro
                }
            }
        }()
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState,.curveEaseOut], animations: {[unowned self] in
            self.mainInfoView.panAnimation(process: -1, currentState: self.state)
            self.stepBarItem.enable = false
            self.runningBarItem.enable = true
            self.stepBarChartView.panAnimation(process: -1, currentState: self.state)
            self.startRunningBtn.panAnimation(process: -1, currentState: self.state)
            }, completion:  nil)
        state = .step
    }
    
    func swipeRight(_ sender:AnyObject, process:CGFloat = 1, velocity:CGFloat){
        let duration : Double = {
            let baseDuration = 0.5
            let pro = Double(abs(process))
            let vel = Double(abs(velocity))
            if vel > 900{
                switch state{
                case .step:
                    return baseDuration*pro*900/vel
                case .running:
                    return (baseDuration - baseDuration*pro)*900/vel
                }
            }else{
                switch state{
                case .step:
                    return baseDuration - baseDuration*pro
                case .running:
                    return baseDuration*pro
                    }
            }
        }()
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState,.curveEaseOut], animations: {[unowned self] in
            self.mainInfoView.panAnimation(process: 1, currentState: self.state)
            self.stepBarItem.enable = true
            self.runningBarItem.enable = false
            self.stepBarChartView.panAnimation(process: 1, currentState: self.state)
            self.startRunningBtn.panAnimation(process: 1, currentState: self.state)
            }, completion:  nil)
        state = .running
    }
}

