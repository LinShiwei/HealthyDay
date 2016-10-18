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

internal enum MainVCState{
    case running,step
}

internal class MainViewController: UIViewController {
//MARK: Property
    private let healthManager = HealthManager.sharedHealthManager
    private var state = MainVCState.running

    private let stepBarItem = CustomBarBtnItem(buttonFrame: CGRect(x: windowBounds.width/5*2-18-25, y: 0, width: 50, height: 22),title:"记步", itemType:.right)
    private let runningBarItem = CustomBarBtnItem(buttonFrame: CGRect(x: windowBounds.width/5*2-18-25, y: 0, width: 50, height: 22),title:"运动", itemType:.left)
    
    @IBOutlet weak var mainInfoView: MainInformationView!
    @IBOutlet weak var stepBarChartView: StepBarChartView!
    @IBOutlet weak var startRunningBtn: StartRunningButton!

    @IBOutlet var mainInfoViewDistanceLabelTapGesture: UITapGestureRecognizer!
    @IBOutlet var stepBarChartViewTapGesture: UITapGestureRecognizer!
    
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

        mainInfoView.delegate = self
        initStepBarChartView()
        
        runningBarItem.addTarget(self, action:  #selector(MainViewController.swipeRight(_:progress:velocity:)), for: .touchUpInside)
        runningBarItem.enable = false
        self.navigationItem.leftBarButtonItem = runningBarItem
        stepBarItem.addTarget(self, action:  #selector(MainViewController.swipeLeft(_:progress:velocity:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = stepBarItem
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        mainInfoView.refreshAnimations()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCurrentDistance()
        updateCurrentStepCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
                stepDetailVC.stepCounts = [4609,7984,10345,6902,9834,3294,8567]
                stepDetailVC.distances = [1242,4987,5395,10924,2834,1230,4834]
            #endif

        }
    }

//MARK: Subview init
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
    @IBAction func didPanInMainInfoView(_ sender: UIPanGestureRecognizer) {
        let progress = sender.translation(in: mainInfoView).x/mainInfoView.frame.width
        switch sender.state {
        case .ended,.cancelled:
            let velocityX = sender.velocity(in: view).x
            if velocityX > 900{
                swipeRight(sender, progress: progress, velocity: velocityX)
                break
            }
            if velocityX < -900{
                swipeLeft(sender, progress: progress, velocity: velocityX)
                break
            }
            if progress > 0.4 {
                swipeRight(sender, progress: progress, velocity: velocityX)
            }else{
                if progress < -0.4 {
                    swipeLeft(sender, progress: progress, velocity: velocityX)
                }else{
                    if state == .running {
                        swipeRight(sender, progress: progress, velocity: velocityX)
                    }else{
                        swipeLeft(sender, progress: progress, velocity: velocityX)
                    }
                }
            }
        default:
            mainInfoView.panAnimation(progress: progress, currentState: state)
            stepBarChartView.panAnimation(progress: progress, currentState: state)
            startRunningBtn.panAnimation(progress: progress, currentState: state)
            
        }
    }

    internal func swipeLeft(_ sender:AnyObject, progress:CGFloat = -1, velocity:CGFloat){
        let duration : Double = {
            let baseDuration = 0.5
            let pro = Double(abs(progress))
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
            self.mainInfoView.panAnimation(progress: -1, currentState: self.state)
            self.stepBarItem.enable = false
            self.runningBarItem.enable = true
            self.stepBarChartView.panAnimation(progress: -1, currentState: self.state)
            self.startRunningBtn.panAnimation(progress: -1, currentState: self.state)
            }, completion:  nil)
        
        if state == .running{
            updateCurrentStepCount()
        }
        state = .step
    }
    
    internal func swipeRight(_ sender:AnyObject, progress:CGFloat = 1, velocity:CGFloat){
        let duration : Double = {
            let baseDuration = 0.5
            let pro = Double(abs(progress))
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
            self.mainInfoView.panAnimation(progress: 1, currentState: self.state)
            self.stepBarItem.enable = true
            self.runningBarItem.enable = false
            self.stepBarChartView.panAnimation(progress: 1, currentState: self.state)
            self.startRunningBtn.panAnimation(progress: 1, currentState: self.state)
            }, completion:  nil)
        if state == .step{
            updateCurrentDistance() 
        }
        state = .running
    }
    
//MARK: Helper
    private func updateCurrentStepCount(){
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
            #else
            mainInfoView.stepCount = 1000
            
        #endif
    }
    
    private func updateCurrentDistance(){
        #if !(arch(i386) || arch(x86_64))
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
            mainInfoView.distance = 2000
        #endif
    }
}

extension MainViewController:MainInfoViewTapGestureDelegate{
    internal func didTap(inLabel label:UILabel){
        switch label {
        case is StepCountLabel:
            performSegue(withIdentifier: "ShowStepDetailVC", sender: label)
        case is DistanceWalkingRunningLabel:
            performSegue(withIdentifier: "ShowDistanceDetailVC", sender: label)
        default:
            break
        }
    }
}

