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

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, VehicleManagerDelegate {
    
    enum BusRoute :Int{
        case Silver = 16
        case Gold = 14
        case Paratransit = 15
        case Green = 20
    }
    
    func didFetchVehicleLocation(vehiclePoints: [VehiclePoint]) {
        for vehicle in vehiclePoints{
            switch vehicle.routeID{
            case BusRoute.Gold.rawValue:
                print("Gold bus")
                
            case BusRoute.Silver.rawValue:
                print("Silver route")
                
            case BusRoute.Green.rawValue:
                print("Green route")
                
            case BusRoute.Paratransit.rawValue:
                print("Paratransit route")
    
            default:
            print("Default case executed")
        }
    }
    }
    
    func didFailedToFetchVehicaleLocation() {
        let alert = UIAlertController(title: "No Bus data available at the moment", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBOutlet weak var estimatedWalkingTime: UILabel!
    var directionResponse:MKDirectionsResponse?
    var route:MKRoute?
    var userLocation:CLLocation?{
        willSet{
            
        }
        
        didSet{
            print("called")
            mapview.showsUserLocation = true
            mapview.setUserTrackingMode(.follow, animated: true)
            calculateDistance()
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
    
    func calculateDistance() {
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: (userLocation?.coordinate)!))
        
//        35.312211, -80.741745
        let dukeCentennial = CLLocationCoordinate2D(latitude: 35.312211, longitude: -80.741745)
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: dukeCentennial))
        
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            if error == nil {
                self.directionResponse = response
//                // Get whichever currentRoute you'd like, ex. 0
                self.route = self.directionResponse?.routes[0]
                DispatchQueue.main.async {
                    self.estimatedWalkingTime.text = "Around \(Int((self.route?.expectedTravelTime)!)/60) minute(s)."
                    self.mapview.add((self.route?.polyline)!, level: .aboveLabels)
                    self.getVehicleData()
                }
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeLineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        routeLineRenderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        routeLineRenderer.lineWidth = 4
        return routeLineRenderer
        
    }
    
    func getVehicleData() {
        let vehicleManager = VehicleManager()
        vehicleManager.delegate = self
        vehicleManager.requestVehicleData()
    }
    
}

