//
//  ITCoordinatesView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

class ITCoordinatesView: UIView {

    var container: UIView!
    var titleLabel: ITTitleLabel!
    var latitudeLabel: ITTitleLabel!
    var longitudeLabel: ITTitleLabel!
    var timestampLabel: ITTitleLabel!

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
        backgroundColor = Colors.midnightBlue
        layer.cornerRadius = 12
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false

        configureTitleLabel()
        configureLatitudeLabel()
        configureLongitudeLabel()
        configureTimestampLabel()
    }

    private func configureTitleLabel(){
        titleLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
        titleLabel.textColor = Colors.deepYellow
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    private func configureLatitudeLabel(){
        latitudeLabel = ITTitleLabel()
        latitudeLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        latitudeLabel.textAlignment = .left
        latitudeLabel.textColor = .white
        addSubview(latitudeLabel)

        NSLayoutConstraint.activate([
            latitudeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            latitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            latitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            latitudeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureLongitudeLabel(){
        longitudeLabel = ITTitleLabel()
        longitudeLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        longitudeLabel.textAlignment = .left
        longitudeLabel.textColor = .white
        addSubview(longitudeLabel)

        NSLayoutConstraint.activate([
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 5),
            longitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            longitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            longitudeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureTimestampLabel(){
        timestampLabel = ITTitleLabel()
        timestampLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        timestampLabel.textAlignment = .left
        timestampLabel.textColor = .white
        addSubview(timestampLabel)

        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 5),
            timestampLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timestampLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            timestampLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
