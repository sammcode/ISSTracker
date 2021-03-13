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

#warning("make up mind as to whether or not im going to use duration")
struct Response: Codable {
    let risetime, duration: Int
}
