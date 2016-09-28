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

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func tapToStartRunning(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.authorize()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        print(mapView.userLocation)
        print(mapView.userLocation.location)
        let lat = mapView.userLocation.location?.coordinate.latitude
        let lon = mapView.userLocation.location?.coordinate.longitude
        descriptionLabel.text = "\(lat) : \(lon)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RunningViewController: MKMapViewDelegate{
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        guard let location = userLocation.location else{return}
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        descriptionLabel.text = "\(lat) : \(lon)"
        
        let userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0)
        mapView.region = userRegion
        
    }
}
