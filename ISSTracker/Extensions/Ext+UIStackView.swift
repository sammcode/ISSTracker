//
//  Ext+UIStackView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}
