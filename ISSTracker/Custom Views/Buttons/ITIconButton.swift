//
//  ITIconButton.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/20/21.
//

import UIKit

class ITIconButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(backgroundColor: UIColor, image: UIImage) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setImage(image, for: .normal)
    }

    private func configure(){
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 5
    }

    func set(backgroundColor: UIColor, image: UIImage){
        self.backgroundColor = backgroundColor
        setImage(image, for: .normal)
    }

    func pulsate() {
        if UserDefaultsManager.reduceAnimations { return }
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 1.0
        pulse.toValue = 0.85
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        pulse.autoreverses = true

        layer.add(pulse, forKey: nil)
    }
}
