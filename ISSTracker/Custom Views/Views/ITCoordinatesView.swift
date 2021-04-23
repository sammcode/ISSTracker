//
//  ITCoordinatesView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

class ITCoordinatesView: UIView {

    var container: UIView!
    var titleLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
    var latitudeLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 24)
    var longitudeLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 24)
    var timestampLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 24)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String, latitude: String, longitude: String, timestamp: String) {
        self.init(frame: .zero)
        titleLabel.text = title
        latitudeLabel.text =  "Latitude: " + latitude
        longitudeLabel.text = "Longitude: " + longitude
        timestampLabel.text = "Timestamp: " + timestamp
    }

    private func configure(){
        configureView()
        configureTitleLabel()
        configureLatitudeLabel()
        configureLongitudeLabel()
        configureTimestampLabel()
    }

    private func configureView(){
        backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = Colors.mainBlueYellow.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureTitleLabel(){
        addSubview(titleLabel)
        titleLabel.textColor = Colors.mainBlueYellow
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    private func configureLatitudeLabel(){
        addSubview(latitudeLabel)
        latitudeLabel.textColor = .label
        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            latitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            latitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            latitudeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureLongitudeLabel(){
        addSubview(longitudeLabel)
        longitudeLabel.textColor = .label
        NSLayoutConstraint.activate([
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 5),
            longitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            longitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            longitudeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureTimestampLabel(){
        addSubview(timestampLabel)
        timestampLabel.textColor = .label
        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 5),
            timestampLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            timestampLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            timestampLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
