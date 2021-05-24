//
//  ITNasaImageCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/21/21.
//

import UIKit

class ITNasaImageCell: UICollectionViewCell {
    static let reuseID = "NasaImageCell"

    var nasaImageView = ITNasaImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(image: Item){
        nasaImageView.downloadNasaImage(fromURL: image.links[0].href)
    }

    func configure(){
        nasaImageView.contentMode = .scaleAspectFill
        nasaImageView.clipsToBounds = true
        nasaImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nasaImageView)
        NSLayoutConstraint.activate([
            nasaImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nasaImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nasaImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            nasaImageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])

//        layer.shadowColor = Colors.whiteBlack.cgColor
//        layer.shadowOpacity = 0.5
//        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
//        layer.shadowRadius = 3
    }
}
