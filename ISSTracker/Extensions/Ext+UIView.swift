//
//  Ext+UIView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
