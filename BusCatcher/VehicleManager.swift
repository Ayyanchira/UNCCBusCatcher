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
    //let mapVehiclePoints:MapVehiclePoints?
    var parentView:UIViewController?
    var delegate:VehicleManagerDelegate?
    func requestVehicleData() {
//        let headers = [
//            "Cache-Control": "no-cache",
//            "Postman-Token": "7943b73f-dec6-4053-97ae-29069a2bd828"
//        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://nextride.uncc.edu/Services/JSONPRelay.svc/GetMapVehiclePoints")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        //request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error?.localizedDescription)
            } else {
                guard let data = data else { return }
                //let dataAsString = String(data: data, encoding: .utf8)
                
                if let apidata = try? JSONDecoder().decode([VehiclePoint].self, from: data){
                    self.delegate?.didFetchVehicleLocation(vehiclePoints: apidata)
                }
                print("Data  is ")
                
            }
        })
    
        dataTask.resume()
    }
    
    
}
