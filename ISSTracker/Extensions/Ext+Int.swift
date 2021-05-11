//
//  Ext+Int.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/13/21.
//

import Foundation

extension Int {
    /// Converts any timestamp (as an Int) to a MMMM d format
    /// - Returns: Formatted date as a String
    func convertTimestampToStringDate() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        DF.dateFormatter.dateFormat = "MMMM d"
        return DF.dateFormatter.string(from: date)
    }

    /// Converts any timestamp (as an Int) to a MMMM d format
    /// - Returns: Formatted date as a String
    func convertTimestampToStringTime() -> String {
        let date = Date(timeIntervalSince1970: Double(self))
        DF.dateFormatter.dateFormat = "h:mm a"
        return DF.dateFormatter.string(from: date)
    }
}
