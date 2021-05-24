//
//  ITNasaImageView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/21/21.
//

import UIKit

class ITNasaImageView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeholderImage = UIImage(named: "NasaAstronaut")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadNasaImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }

}
