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

    static func createThreeColumnFlowLayout(in view: UIView, itemHeightConstant: CGFloat, hasHeaderView: Bool) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 3

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding*4, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + itemHeightConstant)

        if hasHeaderView { flowLayout.headerReferenceSize = CGSize(width: width, height: 160) }

        return flowLayout
    }

    static func createTwoColumnFlowLayout(in view: UIView, itemHeightConstant: CGFloat, hasHeaderView: Bool) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                   = availableWidth / 2

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding*4, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + itemHeightConstant)

        if hasHeaderView { flowLayout.headerReferenceSize = CGSize(width: width, height: 160) }

        return flowLayout
    }
}
