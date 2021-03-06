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

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate, LocationServiceProtocol, StopArrivalDelegate {
    
    
    enum BusRoute :Int{
        case Silver = 16
        case Gold = 14
        case Paratransit = 15
        case Green = 20
    }

    @IBOutlet weak var nearestBusStopLabel: UILabel!
    
    @IBOutlet weak var walkingTimeToReachNearestBusStopLabel: UILabel!
    
    @IBOutlet weak var busTakeTimeLabel: UILabel!
    var nearestBusStop : BusStop?
    var nearestBusStopWalkingTime:Double?
    var allBusStops:[BusStop]?
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
            //calculateDistance()
            loadSilverBusData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationService.delegate = self
        locationService.enableBasicLocationServices()
    }
    
    func loadSilverBusData(){
        
        if let path = Bundle.main.path(forResource: "SilverRoute", ofType: "json") {
            do {
                //let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                allBusStops =  try JSONDecoder().decode([BusStop].self, from: data)
                for busStop in allBusStops!{
                    locationService.calculateDistance(userLocation: userLocation!, busStop: busStop)
                }
            } catch (let e){
                print("Exception occured" + e.localizedDescription)
            }
        }
    }
    
    @IBAction func reloadMaps(_ sender: UIButton) {
        //loadSilverBusData()
        viewDidLoad()
    }
    func estimatedTravelTimeForBusStop(timeInterval: TimeInterval, busStop:BusStop) {
    
        if nearestBusStop == nil && nearestBusStopWalkingTime == nil{
            nearestBusStop = busStop
            nearestBusStopWalkingTime = timeInterval
        }else{
            if let walkingTime = nearestBusStopWalkingTime{
                if timeInterval < walkingTime{
                    nearestBusStop = busStop
                    nearestBusStopWalkingTime = timeInterval
                    print("Updating nearest bus stop. It is \(busStop.name)")
                    self.nearestBusStopLabel.text = busStop.name
                }
            }
        }
        if let lastBusStop = allBusStops?.last{
            if busStop.name == lastBusStop.name {
                //showPath(busStop: nearestBusStop!)
                
                let stopArrival = StopArrival()
                stopArrival.delegate = self
                stopArrival.getStopEstimateForBusStop(busStop: nearestBusStop!)
            }
        }
    }
    
    func showPath(busStop: BusStop, withTimeInfoFrom stopArrival:StopArrivals) {
        print("Show Path is called now")
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: (userLocation?.coordinate)!))
        
        let busStopLocation = CLLocationCoordinate2D(latitude: busStop.location.latitude, longitude: busStop.location.longitude)
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: busStopLocation))
        
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            if error == nil {
                self.directionResponse = response
//                // Get whichever currentRoute you'd like, ex. 0
                self.route = self.directionResponse?.routes[0]
                DispatchQueue.main.async {
                    var userTimeToLeaveFromHisPlace = 0
                    var timeTakenByBus:Int?
                    self.nearestBusStopLabel.text = busStop.name
                    let timeToReachBusStop = Int((self.route?.expectedTravelTime)!/60)
                    self.walkingTimeToReachNearestBusStopLabel.text = "\(timeToReachBusStop) minutes"
                    
                    if let timeTakenByBusOne = stopArrival.times?.first?.seconds{
                        timeTakenByBus = timeTakenByBusOne/60
                    }
                    
                    
                    //if let timeTakenByBusOne = (stopArrival.times?.first?.seconds)!/60
                    if timeTakenByBus != nil,
                    timeTakenByBus! > timeToReachBusStop{
                        self.busTakeTimeLabel.text = "\(timeTakenByBus!) minute(s)"
                        userTimeToLeaveFromHisPlace = timeTakenByBus! - timeToReachBusStop
                        //self.estimatedWalkingTime.text = "Around \(Int((self.route?.expectedTravelTime)!)/60) minute(s) to reach \(busStop.name).
                        self.estimatedWalkingTime.text = "Leave in \(userTimeToLeaveFromHisPlace) minutes"
                    }else{
                        if let timeTakenByBusTwo = (stopArrival.times![1] as Times).seconds{
                            timeTakenByBus = timeTakenByBusTwo/60
                            self.busTakeTimeLabel.text = "\(timeTakenByBus!) minute(s)"
                            userTimeToLeaveFromHisPlace = timeTakenByBus! - timeToReachBusStop
                            //self.estimatedWalkingTime.text = "Around \(Int((self.route?.expectedTravelTime)!)/60) minute(s) to reach \(busStop.name)."
                            self.estimatedWalkingTime.text = "\(userTimeToLeaveFromHisPlace) minute(s)"
                        }
                    }
                    self.mapview.add((self.route?.polyline)!, level: .aboveLabels)
                    //self.getVehicleData()
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
    
//    func getVehicleData() {
//        let vehicleManager = VehicleManager()
//        vehicleManager.delegate = self
//        vehicleManager.requestVehicleData()
//    }
    
    
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
    
//    // MARK: Vehicle Manager Delegate Methods
//    func didFetchVehicleLocation(vehiclePoints: [VehiclePoint]) {
//        for vehicle in vehiclePoints{
//            switch vehicle.routeID{
//            case BusRoute.Gold.rawValue:
//                print("Gold bus")
//
//            case BusRoute.Silver.rawValue:
//                print("Silver route")
//                print("\(vehicle.name) is having time stamp \(vehicle.timeStamp) and heading to point\(vehicle.heading)")
//
//            case BusRoute.Green.rawValue:
//                print("Green route")
//
//            case BusRoute.Paratransit.rawValue:
//                print("Paratransit route")
//
//            default:
//                print("Default case executed")
//            }
//        }
//    }
    
    func didFailedToFetchVehicaleLocation() {
        let alert = UIAlertController(title: "No Bus data available at the moment", message: "Please try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //PRAGMA MARK: Stop Arrival Delegate Methods
    
    func didRecieveBusStopEstimatesFor(busStop: BusStop, stopArrival: StopArrivals){
        if (stopArrival.times?.count)! > 1 {
//            print("Bus arrives at stop in \((stopArrival.times?.first?.seconds)!/60) minutes")
            showPath(busStop: busStop, withTimeInfoFrom:stopArrival)
        }else{
            let alert = UIAlertController(title: "No Buses", message: "No Buses found near you. Please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func refreshScreen(){
        
    }
}

