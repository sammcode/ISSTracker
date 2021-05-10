//
//  ITPassTimeStatusView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/27/21.
//

import UIKit
import AVFoundation
import AVKit

class ITPassTimeStatusView: UIView {

    var passTime: PassTime!

    var container: UIView!
    var countDownLabel = ITTitleLabel(textAlignment: .left, fontSize: 48)
    var descriptionLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)
    var locationLabel = ITTitleLabel(textAlignment: .left, fontSize: 18)

    var statusLabelContainer = UIView()
    var statusLabelContainerWidthConstraint: NSLayoutConstraint!
    var statusLabel = ITSecondaryTitleLabel(textAlignment: .left, fontSize: 18)

    var issImageView = ITImageView(frame: .zero)

    var timeInterval: TimeInterval = 0
    var timer: Timer!

    var nextPassTime: Date!

    var isCurrentlyPassing: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(passtime: PassTime) {
        self.init(frame: .zero)
        passTime = passtime
        nextPassTime = Date(timeIntervalSince1970: Double(passTime.response[0].risetime))

        //TEST
        //nextPassTime = Date() + 30
        countDownLabel.text = calculateTimeDifference()
        runTimer()
    }

    private func configure(){
        configureView()
        configureLocationLabel()
        configureStatusLabelContainer()
        configureStatusLabel()
        configureCountDownLabel()
        configureDescriptionLabel()
        //configureISSImageView()
    }

    private func configureView(){
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false

        layer.shadowColor = Colors.whiteBlack.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 5
    }

    private func configureCountDownLabel(){
        addSubview(countDownLabel)
        countDownLabel.textColor = Colors.mainBlueYellow
        countDownLabel.font = UIFont(name: "NasalizationRg-Regular", size: 24)
        NSLayoutConstraint.activate([
            countDownLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            countDownLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            countDownLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            countDownLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureDescriptionLabel(){
        addSubview(descriptionLabel)
        descriptionLabel.textColor = Colors.mainBlueYellow
        descriptionLabel.text = "Next pass in..."
        descriptionLabel.font = UIFont(name: "NasalizationRg-Regular", size: 18)
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: countDownLabel.topAnchor, constant: -5),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureLocationLabel(){
        addSubview(locationLabel)
        locationLabel.textColor = .label
        locationLabel.text = "Ithaca, NY"
        locationLabel.font = UIFont(name: "NasalizationRg-Regular", size: 32)
        locationLabel.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            locationLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func configureStatusLabelContainer() {
        addSubview(statusLabelContainer)
        statusLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        statusLabelContainer.backgroundColor = .orange
        statusLabelContainer.layer.cornerRadius = 10

        statusLabelContainerWidthConstraint = statusLabelContainer.widthAnchor.constraint(equalToConstant: 160)
        NSLayoutConstraint.activate([
            statusLabelContainer.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            statusLabelContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            statusLabelContainer.heightAnchor.constraint(equalToConstant: 35),
            statusLabelContainerWidthConstraint
        ])
    }

    private func configureStatusLabel() {
        statusLabelContainer.addSubview(statusLabel)
        statusLabel.textColor = .white
        statusLabel.text = "Not Overhead"
        statusLabel.font = UIFont(name: "NasalizationRg-Regular", size: 18)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: statusLabelContainer.topAnchor, constant: 5),
            statusLabel.leadingAnchor.constraint(equalTo: statusLabelContainer.leadingAnchor, constant: 5),
            statusLabel.trailingAnchor.constraint(equalTo: statusLabelContainer.trailingAnchor, constant: -5),
            statusLabel.bottomAnchor.constraint(equalTo: statusLabelContainer.bottomAnchor, constant: -5)
        ])
    }

    private func configureISSImageView(){
        addSubview(issImageView)
        issImageView.image = Images.issIcon3?.withTintColor(.lightGray)

        NSLayoutConstraint.activate([
            issImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            issImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            issImageView.widthAnchor.constraint(equalToConstant: 160),
            issImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func calculateTimeDifference() -> String{

        //let difference = date.timeIntervalSince(Date())
        let differenceDate = nextPassTime.offsetFrom(date: Date())

        //DF.dateFormatter.dateFormat = "H:mm:ss"
        //print(DF.dateFormatter.string(from: date))

        //let hours = Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0

        //return DF.dateFormatter.string(from: differenceDate)

        return differenceDate
    }

    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDownLabel), userInfo: nil, repeats: true)
    }

    @objc func updateCountDownLabel(){
//        timeInterval -= 1
//        if timeInterval == 0 { timer.invalidate() }
//        let differenceDate = Date(timeIntervalSince1970: timeInterval)
//        DF.dateFormatter.dateFormat = "H:mm:ss"
//        countDownLabel.text = DF.dateFormatter.string(from: differenceDate)

        let timeDifference = self.calculateTimeDifference()

        DispatchQueue.main.async {
            if timeDifference == "1s" {
                self.timer.invalidate()
                self.countDownLabel.text = "1s"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.countDownLabel.text = "0s"
                    self.nextPassTime = Date() + Double(self.passTime.response[0].duration)
                    self.runTimer()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isCurrentlyPassing.toggle()
                    self.updateViewBasedOnPassStatus()
                }
            }else{
                self.countDownLabel.text = timeDifference
            }
        }
    }

    func updateViewBasedOnPassStatus(){
        DispatchQueue.main.async {
            if self.isCurrentlyPassing {
                self.statusLabelContainerWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.5) {
                    self.statusLabelContainer.layoutIfNeeded()
                    self.statusLabelContainer.backgroundColor = .systemGreen
                }
                UIView.transition(with: self.statusLabel,
                              duration: 0.5,
                               options: .transitionCrossDissolve,
                            animations: { [weak self] in
                                self?.statusLabel.text = "Passing Overhead!"
                         }, completion: nil)
                UIView.transition(with: self.statusLabel,
                              duration: 0.5,
                               options: .transitionCrossDissolve,
                            animations: { [weak self] in
                                self?.descriptionLabel.text = "Pass ending in..."
                         }, completion: nil)
            }else{
                self.statusLabelContainerWidthConstraint.constant = 200
                UIView.animate(withDuration: 0.5) {
                    self.statusLabelContainer.layoutIfNeeded()
                    self.statusLabelContainer.backgroundColor = .systemGreen
                }
                UIView.transition(with: self.statusLabel,
                              duration: 0.5,
                               options: .transitionCrossDissolve,
                            animations: { [weak self] in
                                self?.statusLabel.text = "Passing Overhead!"
                         }, completion: nil)
                UIView.transition(with: self.statusLabel,
                              duration: 0.5,
                               options: .transitionCrossDissolve,
                            animations: { [weak self] in
                                self?.descriptionLabel.text = "Pass ending in..."
                         }, completion: nil)
            }
        }
    }

    func checkIfCurrentlyPassing() {
        let delta = Date() - nextPassTime
        if delta > 0 {
            isCurrentlyPassing = true
        }
    }
}
