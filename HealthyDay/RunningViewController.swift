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
    var startRunning = false
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func tapToStartRunning(_ sender: UIButton) {
        startRunning = !startRunning
        runningCoordiantes.removeAll()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.authorize()
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    
    
    fileprivate func drawRoute(withCoordiantes coordinates:[CLLocationCoordinate2D]){
        guard coordinates.count > 1 else{return}
        let overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.removeOverlays(mapView.overlays)
        mapView.add(overlay)

        print(mapView.overlays.count)
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
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        descriptionLabel.text = "\(lat) : \(lon)"
        
        if !hasLocated {
            let userRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0)
            mapView.setRegion(userRegion, animated: true)
            hasLocated = true
        }else{
            if startRunning {
                drawRoute(withCoordiantes: runningCoordiantes)
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
