//
//  PeopleInSpace.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/10/21.
//

import UIKit

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
    let image: UIImage
    let nationality: String
    let role: String
    let biographyURL: String
}
