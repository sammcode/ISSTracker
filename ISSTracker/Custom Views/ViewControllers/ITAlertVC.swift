//
//  ITAlertVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

class ITAlertVC: UIViewController {

    let containerView = ITAlertContainerView()
    let titleLabel = ITTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = ITBodyLabel(textAlignment: .center)
    let actionButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Ok")
    let settingsButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Settings")

    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var settingsButtonNeeded: Bool?

    let padding: CGFloat = 20

    init(title: String, message: String, buttonTitle: String, settingsButtonNeeded: Bool? = nil){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.settingsButtonNeeded = settingsButtonNeeded
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubviews(containerView, titleLabel, actionButton, messageLabel)

        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()

        if settingsButtonNeeded ?? false {
            view.addSubview(settingsButton)
            configureSettingsButton()
        }
    }

    func configureContainerView(){

        let height: CGFloat = (settingsButtonNeeded ?? false ? 260 : 220)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configureMessageLabel(){
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    func configureActionButton(){
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configureSettingsButton(){
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: padding),
            settingsButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            settingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }

    @objc func openSettings(){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
