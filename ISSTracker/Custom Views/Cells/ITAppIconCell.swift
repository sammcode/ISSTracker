//
//  ITAppIconCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/26/21.
//

import UIKit

class ITAppIconCell: UICollectionViewCell {
    static let reuseID = "AppIconCell"

    let appIconImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(image: UIImage){
        appIconImageView.image = image
    }

    private func configure() {
        backgroundColor = .clear
        addSubview(appIconImageView)
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        appIconImageView.layer.cornerCurve = CALayerCornerCurve.continuous
        appIconImageView.layer.cornerRadius = 25
        appIconImageView.backgroundColor = .clear
        appIconImageView.clipsToBounds = true
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            appIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            appIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            appIconImageView.heightAnchor.constraint(equalTo: appIconImageView.widthAnchor),
        ])
    }
}
