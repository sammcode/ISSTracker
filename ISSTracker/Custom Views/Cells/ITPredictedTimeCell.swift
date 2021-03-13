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
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(timestamp: Int){
        let date = Date(timeIntervalSince1970: Double(timestamp))

        let dateFormatter = DateFormatter()

        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yy" //Specify your format that you want
        let strDay = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
        let strTime = dateFormatter.string(from: date)

        dayLabel.text = "Day: " + strDay
        timeLabel.text = "Time: " + strTime
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
