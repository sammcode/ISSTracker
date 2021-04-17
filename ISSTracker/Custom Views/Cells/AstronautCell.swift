//
//  AstronautCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/15/21.
//

import UIKit

class AstronautCell: UICollectionViewCell {
    static let reuseID = "AstronautCell"

    let astronautImageView = ITImageView(frame: .zero)
    let nameLabel = ITTitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(name: String, image: UIImage){
        astronautImageView.image = image
        nameLabel.text = name
    }

    private func configure() {
        addSubviews(astronautImageView, nameLabel)

        nameLabel.numberOfLines = 2

        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            astronautImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            astronautImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            astronautImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            astronautImageView.heightAnchor.constraint(equalTo: astronautImageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: astronautImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
