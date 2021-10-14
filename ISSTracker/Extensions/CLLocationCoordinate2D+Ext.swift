//
//  CLLocationCoordinate2D+Ext.swift
//  ISSTracker
//
//  Created by Sam McGarry on 10/13/21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {

    /// Calculates the angular distance between two points using the Haversine formula
    /// - Parameter location: the location from which to measure to self
    /// - Returns: the angular distance in radians
    func angularDistance(to location: CLLocationCoordinate2D) -> Double {

        let lat1 = self.latitude.toRadians
        let lon1 = self.longitude.toRadians
        let lat2 = location.latitude.toRadians
        let lon2 = location.longitude.toRadians

        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        let ahaversin = { (angle: Double) -> Double in
            return 2 * asin(sqrt(angle))
        }

        return ahaversin(haversin(lat2 - lat1) + cos(lat1) * cos(lat2) * haversin(lon2 - lon1))
    }
}
