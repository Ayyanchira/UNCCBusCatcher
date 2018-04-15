//
//  LocationService.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/14/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationServiceProtocol {
    
    func didRecieveLocationAccessAuthorization()
    func didRecieveLocationAccessDenial()
    func didRecieveUserLocation(location: CLLocation)
    func estimatedTravelTimeForBusStop(timeInterval:TimeInterval, busStop:BusStop)
}


class LocationService :NSObject, CLLocationManagerDelegate {
    
    var delegate:LocationServiceProtocol?
    lazy var locationManager = CLLocationManager()
    
    public func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            //disableMyLocationBasedFeatures()
            delegate?.didRecieveLocationAccessDenial()
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
            //enableMyWhenInUseFeatures()
            delegate?.didRecieveLocationAccessAuthorization()
            break
        }
    }
    
    
    // PRAGMA MARK: Location Manager delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            delegate?.didRecieveLocationAccessDenial()
            //disableMyLocationBasedFeatures()
            break
            
        case .authorizedWhenInUse:
            //enableMyWhenInUseFeatures()
            delegate?.didRecieveLocationAccessAuthorization()
            break
            
        case .notDetermined, .authorizedAlways:
            break
        }
    }
    
    
    public func fetchUserLocation() {
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 20  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let userLocation = locations.first{
            delegate?.didRecieveUserLocation(location: userLocation)
            //self.userLocation = userLocation
            print("User is at lat : \(userLocation.coordinate.latitude.description), long : \(userLocation.coordinate.longitude.description)")
        }
    }
    
    func calculateDistance(userLocation: CLLocation, busStop : BusStop) {
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: (userLocation.coordinate)))
        let busStopLocation = CLLocationCoordinate2D(latitude: busStop.location.latitude, longitude: busStop.location.longitude)
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: busStopLocation))
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            if error == nil {
                let directionResponse:MKDirectionsResponse? = response
                let route:MKRoute? = directionResponse?.routes[0]
                self.delegate?.estimatedTravelTimeForBusStop(timeInterval: (route?.expectedTravelTime)!, busStop: busStop)
            }else{
                print(error.debugDescription)
            }
        }
    }
}
