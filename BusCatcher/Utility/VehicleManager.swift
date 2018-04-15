//
//  VehicleManager.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/4/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation
import UIKit

protocol VehicleManagerDelegate {
    func didFetchVehicleLocation(vehiclePoints: [VehiclePoint])
    func didFailedToFetchVehicaleLocation()
}

class VehicleManager: NSObject {
    var delegate:VehicleManagerDelegate?
    func requestVehicleData() {
        let request = NSMutableURLRequest(url: NSURL(string: "http://nextride.uncc.edu/Services/JSONPRelay.svc/GetMapVehiclePoints")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription ?? "Error Occurred in fetching Vehicle points from Next Ride Server")
            } else {
                guard let data = data else { return }
                if let apidata = try? JSONDecoder().decode([VehiclePoint].self, from: data){
                    self.delegate?.didFetchVehicleLocation(vehiclePoints: apidata)
                }
            }
        })
    
        dataTask.resume()
    }
    
    
}
