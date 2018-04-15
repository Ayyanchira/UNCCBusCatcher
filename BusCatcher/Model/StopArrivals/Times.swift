/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Times : Codable {
	let estimateTime : String?
	let isArriving : Bool?
	let isDeparted : Bool?
	let onTimeStatus : Int?
	let scheduledArrivalTime : String?
	let scheduledDepartureTime : String?
	let scheduledTime : String?
	let seconds : Int?
	let text : String?
	let time : String?
	let vehicleId : Int?

	enum CodingKeys: String, CodingKey {

		case estimateTime = "EstimateTime"
		case isArriving = "IsArriving"
		case isDeparted = "IsDeparted"
		case onTimeStatus = "OnTimeStatus"
		case scheduledArrivalTime = "ScheduledArrivalTime"
		case scheduledDepartureTime = "ScheduledDepartureTime"
		case scheduledTime = "ScheduledTime"
		case seconds = "Seconds"
		case text = "Text"
		case time = "Time"
		case vehicleId = "VehicleId"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		estimateTime = try values.decodeIfPresent(String.self, forKey: .estimateTime)
		isArriving = try values.decodeIfPresent(Bool.self, forKey: .isArriving)
		isDeparted = try values.decodeIfPresent(Bool.self, forKey: .isDeparted)
		onTimeStatus = try values.decodeIfPresent(Int.self, forKey: .onTimeStatus)
		scheduledArrivalTime = try values.decodeIfPresent(String.self, forKey: .scheduledArrivalTime)
		scheduledDepartureTime = try values.decodeIfPresent(String.self, forKey: .scheduledDepartureTime)
		scheduledTime = try values.decodeIfPresent(String.self, forKey: .scheduledTime)
		seconds = try values.decodeIfPresent(Int.self, forKey: .seconds)
		text = try values.decodeIfPresent(String.self, forKey: .text)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		vehicleId = try values.decodeIfPresent(Int.self, forKey: .vehicleId)
	}

}
