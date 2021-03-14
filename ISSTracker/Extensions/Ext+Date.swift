//
//  Ext+Date.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/13/21.
//

import UIKit

extension Date {

    /// Converts any date object to a MM/dd HH:mm format
    /// - Returns: Formatted date as string
    func convertTimestampToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
