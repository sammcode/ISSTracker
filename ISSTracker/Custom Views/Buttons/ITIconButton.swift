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

    convenience init(symbolColor: UIColor, symbolName: String) {
        self.init(frame: .zero)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: symbolName, withConfiguration: imageConfiguration)
        self.setImage(image, for: .normal)
        self.tintColor = symbolColor
        self.backgroundColor = .clear
    }

    private func configure(){
        layer.cornerRadius = 10
        backgroundColor = .systemGray4
        translatesAutoresizingMaskIntoConstraints = false
    }

    func pulsate() {
        guard !UserDefaultsManager.reduceAnimations else { return }
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
