//
//  HelpfulFunctions.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import Foundation

enum HelpfulFunctions {
    static func convertTimestampToString(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))

        let dateFormatter = DateFormatter()

        #warning("fix timezone issue")
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)

        return strDate
    }
}
