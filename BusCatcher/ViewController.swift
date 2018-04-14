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

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, VehicleManagerDelegate, LocationServiceProtocol {
    enum BusRoute :Int{
        case Silver = 16
        case Gold = 14
        case Paratransit = 15
        case Green = 20
    }

    @IBOutlet weak var estimatedWalkingTime: UILabel!
    lazy var locationManager = CLLocationManager()
    @IBOutlet weak var mapview: MKMapView!
    let locationService = LocationService()
    var directionResponse:MKDirectionsResponse?
    var route:MKRoute?
    var userLocation:CLLocation?{
        didSet{
            mapview.showsUserLocation = true
            mapview.setUserTrackingMode(.follow, animated: true)
            calculateDistance()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //LocationServiceProvider.getLocationUpdate()
        //enableBasicLocationServices()
        locationService.delegate = self
        locationService.enableBasicLocationServices()
        
        loadSilverBusData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadSilverBusData(){
        
        if let path = Bundle.main.path(forResource: "SilverRoute", ofType: "json") {
            do {
                //let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let jsonResult = try JSONDecoder().decode(BusStop.self, from: data)
                print("Json data found and decoded...")
                //TODO: map to obejcts used by tableview...
               // if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["person"] as? [Any] {
                    // do stuff
            } catch (let e){
                // handle error
                
                print("Exception occured" + e.localizedDescription)
            }
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
    
    
    //PRAGMA MARK: Location service delegate methods
    func didRecieveLocationAccessAuthorization() {
        print("Is Authorized")
        locationService.fetchUserLocation()
    }
    
    func didRecieveLocationAccessDenial() {
        print("Is Denied of location access")
    }
    
    func didRecieveUserLocation(location: CLLocation) {
        print("User is at lat : \(location.coordinate.latitude.description), long : \(location.coordinate.longitude.description)")
        userLocation = location
    }
    
    // MARK: Vehicle Manager Delegate Methods
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
    
    
    
}

