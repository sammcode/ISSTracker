//
//  ITAlertContainerView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

class ITAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(){
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = Colors.mainBlueYellow.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
