//
//  ISSLocation.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/12/21.
//

import Foundation
import CoreLocation

struct IssLocation: Codable {
    let name: String
    let id: Int
    let latitude, longitude, altitude, velocity: Double
    let visibility: String
    let footprint: Double
    let timestamp: Int
    let daynum, solarLat, solarLon: Double
    let units: String
}

extension IssLocation {
    func getCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}

typealias IssLocations = [IssLocation]
