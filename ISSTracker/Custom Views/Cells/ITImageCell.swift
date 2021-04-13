//
//  ITImageCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit

class ITImageCell: UICollectionViewCell {

    static let reuseID = "ImageCell"
    let imageView = ITImageView(frame: .zero)
    let favoriteButton = UIButton()
    var isFavorited = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    func set(img: UIImage){
        imageView.image = img
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(imageView)

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 5
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])

        //setUpButton()
    }

    private func setUpButton(){
        addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.backgroundColor = .white
        favoriteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 60),
            favoriteButton.heightAnchor.constraint(equalToConstant: 60),
            favoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            favoriteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
        ])
    }

    @objc func buttonTapped(){
        isFavorited.toggle()
        favoriteButton.backgroundColor = isFavorited ? .yellow : .white

        if isFavorited {
            Constants.favoritesCount += 1
        } else {
            Constants.favoritesCount -= 1
        }
    }

}
