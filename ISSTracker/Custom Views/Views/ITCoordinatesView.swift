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
    var latitudeLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)
    var longitudeLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)
    var timestampLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)
    var altitudeLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)
    var velocityLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)

    var issLocation: IssLocation! {
        didSet{
            updateLabels()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(title: String, issLocationData: IssLocation) {
        self.init(frame: .zero)
        titleLabel.text = title
        issLocation = issLocationData
        updateLabels()
    }

    private func configure(){
        configureView()
        configureTitleLabel()
        configureLatitudeLabel()
        configureLongitudeLabel()
        configureTimestampLabel()
        configureAltitudeLabel()
        configureVelocityLabel()
    }

    private func configureView(){
        backgroundColor = .systemGray5
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureTitleLabel(){
        addSubview(titleLabel)
        titleLabel.textColor = .label
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

    private func configureAltitudeLabel(){
        addSubview(altitudeLabel)
        altitudeLabel.textColor = .label
        NSLayoutConstraint.activate([
            altitudeLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 5),
            altitudeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            altitudeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            altitudeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureVelocityLabel(){
        addSubview(velocityLabel)
        velocityLabel.textColor = .label
        NSLayoutConstraint.activate([
            velocityLabel.topAnchor.constraint(equalTo: altitudeLabel.bottomAnchor, constant: 5),
            velocityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            velocityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            velocityLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    func updateLabels(){
        latitudeLabel.text =  "Latitude: \(round(issLocation.latitude * 1000)/1000)°"
        longitudeLabel.text = "Longitude: \(round(issLocation.longitude * 1000)/1000)°"
        timestampLabel.text = "Timestamp: \(issLocation.timestamp.convertTimestampToStringTime())"
        altitudeLabel.text = "Altitude: \(round(issLocation.altitude * 100)/100) km"
        velocityLabel.text = "Velocity: \(round(issLocation.velocity * 100)/100) km/h"
    }
}
