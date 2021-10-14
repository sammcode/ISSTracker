//
//  LocationCalculator.swift
//  ISSTracker
//
//  Created by Sam McGarry on 10/13/21.
//

import Foundation
import CoreLocation

class LocationCalculator {

    static func intermediateLocationBetween(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D, percentFromStart percent: Double) -> CLLocationCoordinate2D {

        let f = percent

        assert(f >= 0.0)
        assert(f <= 1.0)

        let φ1 = startLocation.latitude.toRadians
        let λ1 = startLocation.longitude.toRadians
        let φ2 = endLocation.latitude.toRadians
        let λ2 = endLocation.longitude.toRadians

        let δ = startLocation.angularDistance(to: endLocation)

        let a = sin((1-f) * δ) / sin(δ)
        let b = sin(f * δ) / sin(δ)
        let x = a * cos(φ1) * cos(λ1) + b * cos(φ2) * cos(λ2)
        let y = a * cos(φ1) * sin(λ1) + b * cos(φ2) * sin(λ2)
        let z = a * sin(φ1) + b * sin(φ2)
        let φi = atan2(z, sqrt((x * x) + (y * y)))
        let λi = atan2(y, x)

        return CLLocationCoordinate2D(latitude: φi.toDegrees, longitude: λi.toDegrees)
    }

    static func getTimestampsForCurrentOrbit() -> [Int64] {
        var timestamps = [Int64]()
        for x in 0..<11{
            let time = (Date() + Double(557 * x)).currentTimeMillis()
            timestamps.append(time)
        }
        return timestamps
    }
}
