//
//  ITNumberOfPeopleView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/16/21.
//

import UIKit

class ITNumberOfPeopleView: UICollectionReusableView {

    static let reuseID = "NumberOfPeopleView"

    var numberLabel = ITTitleLabel(textAlignment: .right, fontSize: 80)
    var secondaryLabel = ITTitleLabel(textAlignment: .left, fontSize: 80)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(number: Int) {
        self.init(frame: .zero)
        numberLabel.text = "\(number)"
    }

    func set(number: Int){
        numberLabel.text = "\(number)"
    }

    func configure() {
        configureNumberLabel()
        configureSecondaryLabel()
    }

    func configureNumberLabel(){
        addSubview(numberLabel)
        numberLabel.font = UIFont(name: "NasalizationRg-Regular", size: 140)
        numberLabel.textColor = Colors.mainBlueYellow
        numberLabel.text = "0"

        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -75),
            numberLabel.widthAnchor.constraint(equalToConstant: 150),
            numberLabel.heightAnchor.constraint(equalToConstant: 150),
            numberLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
    }

    func configureSecondaryLabel(){
        addSubview(secondaryLabel)
        secondaryLabel.font = UIFont(name: "NasalizationRg-Regular", size: 24)
        secondaryLabel.textColor = Colors.mainBlueYellow
        secondaryLabel.text = "people are currently in space"
        secondaryLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            secondaryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 65),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 120),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 150),
            secondaryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
    }
}
