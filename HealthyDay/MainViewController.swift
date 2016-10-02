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
    
    var scrollView : ScrollView!
    var footStepCountView : FootStepCountView!
    var distanceView : DistanceView!
    var viewDisplay : viewDisplayNow = .distanceView
    let healthManager = HealthManager()
    
    @IBAction func buttonTouch(_ sender: UIButton) {

        footStepCountView.footStepCountLabel.text = "clear by button"
        distanceView.distanceLabel.text = "clear by button"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorize{(success,error) in
            print(error)
            print("HealthKit authorize: \(success)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height))
        let oldFrame = scrollView.frame
        
        footStepCountView = FootStepCountView(frame: CGRect(x: view.bounds.width / 2 - 125, y: 100, width: 250, height: 250))
        distanceView = DistanceView(frame: CGRect(x: view.bounds.width / 2 - 125, y: 100, width: 250, height: 250))

        footStepCountView.layer.position = CGPoint(x: view.bounds.width / 2 + 375, y: 600)
        footStepCountView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        view.addSubview(scrollView)
        scrollView.addSubview(footStepCountView)
        scrollView.addSubview(distanceView)
        
        scrollView.layer.anchorPoint = CGPoint(x: 0.25, y: 600 / view.bounds.height)
        scrollView.frame = oldFrame
        footStepCountView.addSubview(footStepCountView.footStepCountLabel)
        distanceView.addSubview(distanceView.distanceLabel)
        footStepCountView.footStepCountLabel.textAlignment = NSTextAlignment.center
        distanceView.distanceLabel.textAlignment = NSTextAlignment.center
        
        scrollView.isUserInteractionEnabled = true
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        view.addGestureRecognizer(swipeRightGesture)
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeftGesture)
        
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
    
    enum viewDisplayNow {
        case footStepCountView
        case distanceView
    }
    
    func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 5, options: [], animations: { [unowned self] in
        let direction = sender.direction
        switch direction {
        case UISwipeGestureRecognizerDirection.left:
            if self.viewDisplay == .footStepCountView{
                return
            } else{
                self.scrollView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                self.viewDisplay = .footStepCountView
                return
            }
        case UISwipeGestureRecognizerDirection.right:
            if self.viewDisplay == .distanceView{
                return
            } else{
                self.scrollView.transform = CGAffineTransform.identity
                self.viewDisplay = .distanceView
                return
            }
        default:
            return
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

