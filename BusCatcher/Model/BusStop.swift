//
//  BusStop.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/11/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import Foundation
import CoreLocation

struct BusStop: Codable{
    let name: String
    let location: Location
    let routeLocation: Int
}

