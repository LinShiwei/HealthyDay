//
//  RunningViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/9/28.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import MapKit
import CoreData

internal class RunningViewController: UIViewController {

    private let locationManager = LocationManager.sharedLocationManager
    fileprivate var runningCoordiantes = [CLLocationCoordinate2D]()
    
    fileprivate var hasLocated = false
    fileprivate var startRunning = false{
        didSet{
            runningCoordiantes.removeAll()
            if startRunning {
                initTimer()
                runningDistance = 0
                runningDuration = 0
                locationManager.startUpdate()
            }else{
                timer?.invalidate()
                timer = nil
                saveRunningDataToCoreData()
                locationManager.stopUpdate()
            }
        }
    }
    
    fileprivate var gpsNotationView : GPSNotationView!
    
    fileprivate var oldLocation : CLLocation?
    
    private var runningDistance : Double = 0{
        didSet{
            //unit of runningDistance is meter
            guard let text = runningDistanceLabel.attributedText as? NSMutableAttributedString else{return}
            let range = NSMakeRange(0, text.length-2)
            let attributeString = NSAttributedString(string: String(format:"%.2f",runningDistance/1000.0), attributes: [
                NSFontAttributeName:UIFont(name: "DINCondensed-Bold", size: 48)!
                ])
            text.replaceCharacters(in: range, with: attributeString)
            runningDistanceLabel.text = String(format:"%.2f",runningDistance/1000.0) + "公里"
            runningDistanceLabel.attributedText = text
        }
    }
    
    private var runningDuration : Int = 0{
        didSet{
            runningDurationLabel.text = durationFormatter(secondsDuration: runningDuration)
        }
    }
    
    private var durationPerKilometer : Int = 0{
        didSet{
            durationPerKilometerLabel.text = durationPerKilometerFormatter(secondsDurationPK: durationPerKilometer)
        }
    }
    
    private var timer : Timer?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runningInfoView: RunningInfomationView!
    
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
        locationManager.delegate = self
        locationManager.authorize{[unowned self] success in
            self.gpsNotationView = GPSNotationView(frame: CGRect(x: 20, y: 20, width: 200, height: 20), hasEnabled: success)
            self.mapView.addSubview(self.gpsNotationView)
        }
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        runningInfoView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if startRunning == true {
            startRunning = false
        }
        hasLocated = false
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
/*
    fileprivate func updateRunningDistance(withNewLocation location:CLLocation){
        guard (oldLocation != location)&&(oldLocation != nil) else{return}
        runningDistance += location.distance(from: oldLocation!)
        oldLocation = location
    }
  */
    fileprivate func updateRunningDistance(withNewLocations locations:[CLLocation]){
        guard (oldLocation != locations.last)&&(oldLocation != nil) else{return}
//        print("Update \(locations.count) location(s)")
        for location in locations {
            runningDistance += location.distance(from: oldLocation!)
            oldLocation = location
        }
        
    }

    private func saveRunningDataToCoreData(){
        DispatchQueue.global().async{[unowned self] in
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "Running", in:managedContext)
            let distanceObject = NSManagedObject(entity: entity!, insertInto: managedContext)
            distanceObject.setValue(Date().addingTimeInterval(-(Double)(self.runningDuration)), forKey: "date")
            distanceObject.setValue(self.runningDuration, forKey: "duration")
            distanceObject.setValue(self.runningDistance, forKey: "distance")
            distanceObject.setValue(self.durationPerKilometer, forKey: "durationPerKilometer")
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
//MARK: Selector
    internal func updateDurationAndAverageSpeed(_ sender:Timer){
        assert(timer != nil)
        runningDuration += Int(timer!.timeInterval)
        if runningDistance != 0{
            durationPerKilometer = Int(Double(runningDuration) / runningDistance * 1000)
        }
        gpsNotationView.refreshCurrentTime()
    }
}

extension RunningViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else{return}
        if !mapView.isUserLocationVisible {
            mapView.setCenter(location.coordinate, animated: true)
        }

        if !hasLocated {
            let userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0)
            mapView.setRegion(userRegion, animated: true)
            hasLocated = true
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.red
        render.lineWidth = 5.0
        
        return render
    }
}

extension RunningViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            gpsNotationView.hasEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard hasLocated && startRunning else{return}
        drawRoute(withCoordiantes: runningCoordiantes)
        if oldLocation == nil{
            oldLocation = locations.last
        }else{
            updateRunningDistance(withNewLocations: locations)
        }
        for location in locations {
            runningCoordiantes.append(location.coordinate)
        }
    }
}
