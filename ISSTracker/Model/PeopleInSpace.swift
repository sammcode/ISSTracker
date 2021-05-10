//
//  PeopleInSpace.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/10/21.
//

import Foundation

// MARK: - People In Space
struct PeopleInSpace: Codable {
    let message: String
    let number: Int
    let people: [Person]
}

// MARK: - Person
struct Person: Codable {
    let name, craft: String
}

struct Astronaut {
    let name: String
    let nationality: String
    let mission: String
    let timesInSpace: String
}
