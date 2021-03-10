//
//  PeopleInSpace.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import Foundation

struct PeopleInSpace: Codable {
    var number: Int
    var people: [People]
}

struct People: Codable {
    var name: String
    var spacecraft: String
}
