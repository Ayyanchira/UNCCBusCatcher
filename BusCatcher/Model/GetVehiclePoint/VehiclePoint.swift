//
//  VehiclePoint.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/4/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation

struct VehiclePoint :Decodable{
    var groundSpeed:Double
    var heading:Int
    var isDelayed:Bool
    var isOnRoute:Bool
    var latitude:Float
    var longitude:Float
    var name:String
    var routeID:Int
    var seconds:Int
    var timeStamp:String
    var vehicleID:Int
    
    enum CodingKeys: String, CodingKey {
        case groundSpeed = "GroundSpeed"
        case heading = "Heading"
        case isDelayed = "IsDelayed"
        case isOnRoute = "IsOnRoute"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case name = "Name"
        case routeID = "RouteID"
        case seconds = "Seconds"
        case timeStamp = "TimeStamp"
        case vehicleID = "VehicleID"
    }
}
