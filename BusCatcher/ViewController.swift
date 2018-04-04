//
//  ViewController.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/4/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var userLocation:CLLocation?{
        willSet{
            if (newValue != userLocation){
                userLocation = newValue
            }else{
                return
            }
        }
        
        didSet{
            print("called")
            mapview.showsUserLocation = true
            mapview.setUserTrackingMode(.follow, animated: true)
            //locationManager.
        }
    }

    lazy var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapview: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //LocationServiceProvider.getLocationUpdate()
        enableBasicLocationServices()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            enableMyWhenInUseFeatures()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    func enableMyWhenInUseFeatures() {
        print("Enabling when in use feature")
        fetchUserLocation()
    }
    
    func disableMyLocationBasedFeatures() {
        print("Disabling when in use feature")
    }
    
    func fetchUserLocation() {
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 20  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let userLocation = locations.first{
            self.userLocation = userLocation
            print("User is at lat : \(userLocation.coordinate.latitude.description), long : \(userLocation.coordinate.longitude.description)")
        }
    }
    
}

