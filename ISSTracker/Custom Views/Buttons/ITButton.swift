//
//  ITButton.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit

class ITButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }

    private func configure(){
        layer.cornerRadius = 10
        titleLabel?.font = UIFont(name: "NasalizationRg-Regular", size: 24)
        setTitleColor(.systemBackground, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 5
    }

    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
