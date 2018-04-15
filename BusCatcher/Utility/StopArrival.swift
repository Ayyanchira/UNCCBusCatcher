//
//  StopArrival.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/14/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation

protocol StopArrivalDelegate {
    func didRecieveBusStopEstimatesFor(busStop: BusStop, stopArrival:StopArrivals)
}

class StopArrival: NSObject {
    var delegate:StopArrivalDelegate?
    func getStopEstimateForBusStop(busStop:BusStop){
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://nextride.uncc.edu/Services/JSONPRelay.svc/GetStopArrivalTimes")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                guard let data = data else { return }
                if let apidata = try? JSONDecoder().decode([StopArrivals].self, from: data){
                    for stopArrival in apidata{
                        if stopArrival.routeStopId == busStop.routeLocation{
                            self.delegate?.didRecieveBusStopEstimatesFor(busStop: busStop, stopArrival: stopArrival)
                        }
                    }
                    //self.delegate?.didRecieveBusStopEstimatesFor(busStop: busStop, stopArrival: <#T##StopArrivals#>)
                }
            }
        })
        
        dataTask.resume()
    }
}
