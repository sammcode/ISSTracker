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
    let actionButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "Ok")

    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    var isLongMessage: Bool?

    let padding: CGFloat = 20

    init(title: String, message: String, buttonTitle: String, isLongMessage: Bool? = nil){
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.isLongMessage = isLongMessage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureActionButton()
    }

    func configureContainerView(){
        view.addSubview(containerView)
        let height: CGFloat = (isLongMessage ?? false ? 380 : 220)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        titleLabel.textColor = UIColor.systemIndigo
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configureMessageLabel(){
        view.addSubview(messageLabel)
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .label
        let height: CGFloat = (isLongMessage ?? false ? 240 : 80)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.heightAnchor.constraint(equalToConstant: height)
        ])
    }

    func configureActionButton(){
        view.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }

    @objc func openSettings(){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
