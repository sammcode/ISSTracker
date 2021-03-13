//
//  HelpfulFunctions.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

#warning("delete if no other functions are added")
enum HelpfulFunctions {
    static func createHorizontalFlowLayout() -> UICollectionViewFlowLayout{
        let width = ScreenSize.width * 0.8
        let height = ScreenSize.height * 0.3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
}
