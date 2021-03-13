//
//  ITPredictedTimeCell.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/11/21.
//

import UIKit

class ITPredictedTimeCell: UITableViewCell {

    static let reuseID = "PredictedTimeCell"
    let dayLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
    let timeLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(risetime: Int, duration: Int){
        dayLabel.text = "Risetime: " + risetime.convertTimestampToString()
        timeLabel.text = "Duration: \(duration) seconds"
    }

    private func configure(){
        contentView.backgroundColor = Colors.midnightBlue
        contentView.layer.cornerRadius = 10
        contentView.addSubviews(dayLabel, timeLabel)
        dayLabel.textColor = .white
        timeLabel.textColor = .white

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            dayLabel.heightAnchor.constraint(equalToConstant: 30),

            timeLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            timeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

}
