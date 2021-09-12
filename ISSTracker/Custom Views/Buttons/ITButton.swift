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
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(backgroundColor: UIColor, title: String){
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }

    func pulsate() {
        if UserDefaultsManager.reduceAnimations { return }
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 1.0
        pulse.toValue = 0.9
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        pulse.autoreverses = true

        layer.add(pulse, forKey: nil)
    }
}
