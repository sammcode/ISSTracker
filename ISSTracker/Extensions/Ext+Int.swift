//
//  Ext+Int.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/13/21.
//

import Foundation

extension Int {
    /// Converts any timestamp (as an Int) to a MM/dd HH:mm format
    /// - Returns: Formatted date as a String
    func convertTimestampToString() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
