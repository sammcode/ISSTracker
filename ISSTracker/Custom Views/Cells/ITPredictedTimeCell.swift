//
//  ITPredictedTimeCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/11/21.
//

import UIKit

class ITPredictedTimeCell: UITableViewCell {

    static let reuseID = "PredictedTimeCell"
    let risetimeLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 24)
    let durationLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 24)
    let dayImageView = ITImageView(frame: .zero)
    let timeImageView = ITImageView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(risetime: Int, duration: Int){
        risetimeLabel.text = risetime.convertTimestampToStringDate() + ", " + risetime.convertTimestampToStringTime()
        durationLabel.text = "\(duration) seconds"
    }

    private func configure(){
        contentView.backgroundColor = Colors.mainBlueYellow
        contentView.layer.cornerRadius = 10
        contentView.addSubviews(risetimeLabel, durationLabel, dayImageView, timeImageView)
        risetimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        durationLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        dayImageView.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBackground)
        timeImageView.image = UIImage(systemName: "stopwatch", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(.systemBackground)
        dayImageView.layer.cornerRadius = 0

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([
            dayImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            dayImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            dayImageView.widthAnchor.constraint(equalToConstant: 30),
            dayImageView.heightAnchor.constraint(equalToConstant: 30),

            timeImageView.topAnchor.constraint(equalTo: dayImageView.bottomAnchor),
            timeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            timeImageView.widthAnchor.constraint(equalToConstant: 30),
            timeImageView.heightAnchor.constraint(equalToConstant: 30),

            risetimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            risetimeLabel.leadingAnchor.constraint(equalTo: dayImageView.trailingAnchor, constant: padding),
            risetimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            risetimeLabel.heightAnchor.constraint(equalToConstant: 30),

            durationLabel.topAnchor.constraint(equalTo: risetimeLabel.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: padding),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            durationLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
