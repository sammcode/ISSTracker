//
//  HelpfulFunctions.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

enum HelpfulFunctions {
    static func createColumnFlowLayout(in view: UIView, itemHeightConstant: CGFloat, hasHeaderView: Bool, columns: CGFloat) -> UICollectionViewFlowLayout {
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * (columns - 1))
        let itemWidth                   = availableWidth / columns

        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding * 2, left: padding, bottom: padding * 4, right: padding)
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth + itemHeightConstant)

        if hasHeaderView { flowLayout.headerReferenceSize = CGSize(width: width, height: 160) }

        return flowLayout
    }
}
