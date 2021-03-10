//
//  PassTime.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import Foundation

struct PassTime: Codable {
    let response: [Response]
}

struct Response: Codable {
    let risetime, duration: Int
}
