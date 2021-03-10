//
//  ITTimestampView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/10/21.
//

import UIKit

class ITTimestampView: UIView {

    var dayLabel: ITTitleLabel!
    var timeLabel: ITTitleLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(day: String, time: String) {
        self.init(frame: .zero)
        dayLabel.text =  "Day: " + day
        timeLabel.text = "Time: " + time
    }

    private func configure(){
        backgroundColor = Colors.midnightBlue
        layer.cornerRadius = 12
        layer.borderWidth = 2
        translatesAutoresizingMaskIntoConstraints = false

        configureLatitudeLabel()
        configureLongitudeLabel()
    }

    private func configureLatitudeLabel(){
        dayLabel = ITTitleLabel()
        dayLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        dayLabel.textAlignment = .left
        dayLabel.textColor = .white
        addSubview(dayLabel)

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            dayLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureLongitudeLabel(){
        timeLabel = ITTitleLabel()
        timeLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        timeLabel.textAlignment = .left
        timeLabel.textColor = .white
        addSubview(timeLabel)

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            timeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
