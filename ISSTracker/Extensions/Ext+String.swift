//
//  Ext+String.swift
//  ISSTracker
//
//  Created by Sam McGarry on 9/6/21.
//

import Foundation

extension String {

    func safeSearchQuery() -> String {
        let excludedCharacters = CharacterSet(charactersIn: "“”<>‘’&%^{}\\`")
        let components = self.components(separatedBy: excludedCharacters)
        return components.joined(separator: "")
    }
}
