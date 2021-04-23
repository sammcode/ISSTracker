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
        risetimeLabel.text = "Risetime: " + risetime.convertTimestampToString()
        durationLabel.text = "Duration: \(duration) seconds"
    }

    private func configure(){
        contentView.backgroundColor = Colors.mainBlueYellow
        contentView.layer.cornerRadius = 10
        contentView.addSubviews(risetimeLabel, durationLabel)
        risetimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        durationLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([
            risetimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            risetimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            risetimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            risetimeLabel.heightAnchor.constraint(equalToConstant: 30),

            durationLabel.topAnchor.constraint(equalTo: risetimeLabel.bottomAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            durationLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

}
