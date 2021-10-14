//
//  Double+Ext.swift
//  ISSTracker
//
//  Created by Sam McGarry on 10/13/21.
//

import Foundation

extension Double {

    var toRadians: Double {
        return Double(self) * (Double.pi / 180.0)
    }

    var toDegrees: Double {
        return (Double(self) * 180.0) / Double.pi
    }
}
