//
//  RunningViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/28.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import MapKit

class RunningViewController: UIViewController {

    let locationManager = LocationManager()
    var runningCoordiantes = [CLLocationCoordinate2D]()
    
    var hasLocated = false
    var startRunning = false{
        didSet{
            runningCoordiantes.removeAll()
            if startRunning {
                initTimer()
                runningDuration = 0
            }else{
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    var gpsNotationView : GPSNotationView!
    
    var oldLocation : CLLocation?
    
    var runningDistance : Double = 0{
        didSet{
            //unit of runningDistance is meter
            guard let text = runningDistanceLabel.attributedText as? NSMutableAttributedString else{return}
            let range = NSMakeRange(0, 4)
            let attributeString = NSAttributedString(string: String(format:"%.2f",runningDistance/1000.0), attributes: [
                "NSFontAttributeName":UIFont(name: "DINCondensed-Bold", size: 17)
                ])
            text.replaceCharacters(in: range, with: attributeString)
            runningDistanceLabel.text = String(format:"%.2f",runningDistance/1000.0) + "公里"
            runningDistanceLabel.attributedText = text
        }
    }
    
    var runningDuration : Int = 0{
        didSet{
            let seconds = runningDuration%60
            let minutes = (runningDuration%3600)/60
            let hours = runningDuration/3600
            runningDurationLabel.text = String(format: "%02d:%02d:%02d", arguments: [hours,minutes,seconds])
        }
    }
    
    var durationPerKilometer : Int = 0{
        didSet{
            let seconds = durationPerKilometer%60
            let minutes = (durationPerKilometer%3600)/60
            let hours = durationPerKilometer/3600
            if hours == 0 {
                durationPerKilometerLabel.text = String(format: "%02d'%02d\"", arguments: [minutes,seconds])
            }else{
                durationPerKilometerLabel.text = String(format: "%02d:%02d:%02d", arguments: [hours,minutes,seconds])
            }
        }
    }
    
    var timer : Timer?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var runningDistanceLabel: UILabel!
    @IBOutlet weak var runningDurationLabel: UILabel!
    @IBOutlet weak var durationPerKilometerLabel: UILabel!
    
    @IBAction func tapToStartRunning(_ sender: UIButton) {
        startRunning = !startRunning
        print("running start == \(startRunning)")
        
    }
//MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.authorize{[unowned self] success in
            if success {
                self.mapView.delegate = self
                self.mapView.showsUserLocation = true
            }
            
            self.gpsNotationView = GPSNotationView(frame: CGRect(x: 20, y: 20, width: 200, height: 20), hasEnabled: success)
            self.mapView.addSubview(self.gpsNotationView)
        }
    }
//MARK: Custom func & Helper
    private func initTimer(){
        guard timer == nil || timer?.isValid == false else{ return}
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RunningViewController.updateDurationAndAverageSpeed(_:)), userInfo: nil, repeats: true)
    }
  
    fileprivate func drawRoute(withCoordiantes coordinates:[CLLocationCoordinate2D]){
        guard coordinates.count > 1 else{return}
        let overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.removeOverlays(mapView.overlays)
        mapView.add(overlay)
    }
    
    fileprivate func updateRunningDistance(withNewLocation location:CLLocation){
        guard (oldLocation != location)&&(oldLocation != nil) else{return}
        runningDistance += location.distance(from: oldLocation!)
        oldLocation = location
        print(runningDistance)
    }
    
    private func formatTime(withSeconds sumSeconds:Int)->String{
        let seconds = sumSeconds%60
        let minutes = (sumSeconds%3600)/60
        let hours = sumSeconds/3600
        return String(format: "%02d:%02d:%02d", arguments: [hours,minutes,seconds])
    }
    
//MARK: Selector
    func updateDurationAndAverageSpeed(_ sender:Timer){
        assert(timer != nil)
        runningDuration += Int(timer!.timeInterval)
        if runningDistance != 0{
            durationPerKilometer = Int(Double(runningDuration) / runningDistance * 1000)
        }
    }
}

extension RunningViewController: MKMapViewDelegate{
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else{return}
        if !mapView.isUserLocationVisible {
            mapView.setCenter(location.coordinate, animated: true)
        }
        
//        let lat = location.coordinate.latitude
//        let lon = location.coordinate.longitude
        
        if !hasLocated {
            let userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0)
            mapView.setRegion(userRegion, animated: true)
            hasLocated = true
        }else{
            if startRunning {
                drawRoute(withCoordiantes: runningCoordiantes)
                if oldLocation == nil{
                    oldLocation = location
                }else{
                    updateRunningDistance(withNewLocation: location)
                }
                runningCoordiantes.append(location.coordinate)
            }else{
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.fillColor = UIColor.blue
        render.strokeColor = UIColor.red
        render.lineWidth = 5.0
        
        return render
    }
}
