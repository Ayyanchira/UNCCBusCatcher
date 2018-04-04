//
//  LocationServiceProvider.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/4/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation
import CoreLocation

class LocationServiceProvider:NSObject, CLLocationManagerDelegate {
    
    lazy var locationManager = CLLocationManager()
    
    static func getLocationUpdate(){
        print("Hello")
    }
    
    public func enableBasicLocationServices(view:CLLocationManagerDelegate) {
        locationManager.delegate = view
        
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
    }
    
    func disableMyLocationBasedFeatures() {
        print("Disabling when in use feature")
    }
}
