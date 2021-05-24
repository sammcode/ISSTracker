//
//  AstronautCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/15/21.
//

import UIKit
import SafariServices

protocol ITAstronautCellDelegate: AnyObject {
    func bioButtonTapped(_ cell: ITAstronautCell)
}

class ITAstronautCell: UICollectionViewCell {
    static let reuseID = "AstronautCell"
    var astro: Astronaut?

    weak var delegate: ITAstronautCellDelegate?

    let astronautImageView = ITImageView(frame: .zero)
    let nameLabel = ITTitleLabel(textAlignment: .left, fontSize: 16)
    let nationalityLabel = ITBodyLabel(textAlignment: .left)
    let roleLabel = ITBodyLabel(textAlignment: .left)
    let bioButton = ITButton(backgroundColor: Colors.mainBlueYellow, title: "Bio")

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(astronaut: Astronaut){
        astro = astronaut
        astronautImageView.image = astronaut.image
        nameLabel.text = astronaut.name
        nationalityLabel.text = astronaut.nationality
        roleLabel.text = astronaut.role
    }

    private func configure() {
        addSubviews(astronautImageView, nameLabel, nationalityLabel, roleLabel, bioButton)

        nameLabel.numberOfLines = 2
        nameLabel.textColor = Colors.mainBlueYellow
        nameLabel.adjustsFontSizeToFitWidth = true

        nationalityLabel.textColor = .label
        roleLabel.textColor = .label

        astronautImageView.layer.cornerRadius = 20

        bioButton.layer.shadowOpacity = 0
        bioButton.addTarget(self, action: #selector(bioButtonTapped), for: .touchUpInside)

        layer.shadowColor = Colors.whiteBlack.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 5

        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        contentView.isUserInteractionEnabled = false

        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            astronautImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            astronautImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            astronautImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            astronautImageView.heightAnchor.constraint(equalTo: astronautImageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: astronautImageView.bottomAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 35),

            nationalityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            nationalityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nationalityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nationalityLabel.heightAnchor.constraint(equalToConstant: 20),

            roleLabel.topAnchor.constraint(equalTo: nationalityLabel.bottomAnchor, constant: 0),
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            roleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            roleLabel.heightAnchor.constraint(equalToConstant: 20),

            bioButton.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 15),
            bioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            bioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            bioButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func bioButtonTapped(){
        bioButton.pulsate()
        delegate?.bioButtonTapped(self)
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            DispatchQueue.main.async {
                self.layer.shadowColor = Colors.whiteBlack.cgColor
            }
        }
    }
}
