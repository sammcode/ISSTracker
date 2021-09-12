//
//  Ext+String.swift
//  ISSTracker
//
//  Created by Sam McGarry on 9/6/21.
//

import UIKit

extension String {

    func safeSearchQuery() -> String {
        let excludedCharacters = CharacterSet(charactersIn: "“”<>‘’&%^{}\\`")
        let components = self.components(separatedBy: excludedCharacters)
        return components.joined(separator: "")
    }

    func image() -> UIImage? {
        let size = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 26)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
