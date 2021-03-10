//
//  GPSLocation.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

struct GPSLocation: Codable {
    let timestamp: Int
    let issPosition: IssPosition

    enum CodingKeys: String, CodingKey {
        case timestamp
        case issPosition = "iss_position"
    }
}

struct IssPosition: Codable {
    let latitude, longitude: String
}
