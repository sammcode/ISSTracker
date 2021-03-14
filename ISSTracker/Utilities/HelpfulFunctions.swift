//
//  HelpfulFunctions.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

enum HelpfulFunctions {

    /// Creates a horizontal UICollectionViewFlowLayout with a predetermined width and height, calculated based on the size of the device screen
    /// - Returns: UICollectionViewFlowLayout
    static func createHorizontalFlowLayout() -> UICollectionViewFlowLayout{
        let width = ScreenSize.width * 0.8
        let height = ScreenSize.height * 0.3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
}
