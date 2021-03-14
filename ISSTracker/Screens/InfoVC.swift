//
//  InfoVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/13/21.
//

import UIKit

class InfoVC: UIViewController {

    var titleLabel: ITTitleLabel!
    var welcomeLabel: ITTitleLabel!
    var requirementsIntroLabel: ITDescriptionLabel!
    var requirementsLabel: ITDescriptionLabel!
    var solutionIntroLabel: ITDescriptionLabel!
    var solutionLabel: ITDescriptionLabel!
    var jumpInButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Jump in!")
    var scrollView = UIScrollView()
    var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    /// Calls all configuration methods for the ViewController
    func configure(){
        configureViewController()
        configureJumpInButton()
        configureScrollView()
        configureTitleLabel()
        configureWelcomeLabel()
        configureRequirementsIntroLabel()
        configureRequirementsLabel()
        configureSolutionIntroLabel()
        configureSolutionLabel()
    }

    /// Configures properties for the ViewController
    func configureViewController(){
        view.backgroundColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.pinToEdges(of: scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: jumpInButton.topAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 820)
        ])

    }

    func configureTitleLabel(){
        titleLabel = ITTitleLabel(textAlignment: .left, fontSize: 36)
        contentView.addSubview(titleLabel)
        titleLabel.textColor = Colors.midnightBlue
        titleLabel.numberOfLines = 0
        titleLabel.text = "iOS Coding \nChallenge \ns23NYC"
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 120),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureWelcomeLabel(){
        welcomeLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
        contentView.addSubview(welcomeLabel)
        welcomeLabel.textColor = Colors.darkGray
        welcomeLabel.numberOfLines = 0
        welcomeLabel.text = "Welcome!"
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30),
            welcomeLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureRequirementsIntroLabel(){
        requirementsIntroLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        contentView.addSubview(requirementsIntroLabel)
        requirementsIntroLabel.textColor = Colors.calmBlue
        requirementsIntroLabel.numberOfLines = 0
        requirementsIntroLabel.text = "For this assessment I was tasked with creating creating an app that satisfied the following three requirements:"
        NSLayoutConstraint.activate([
            requirementsIntroLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            requirementsIntroLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            requirementsIntroLabel.heightAnchor.constraint(equalToConstant: 60),
            requirementsIntroLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureRequirementsLabel(){
        requirementsLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        contentView.addSubview(requirementsLabel)
        requirementsLabel.textColor = Colors.darkGray
        requirementsLabel.numberOfLines = 0
        requirementsLabel.text = "1. Displays an endless loop of images \n2. Connect to any REST API that shows something that was returned in a meaningful way \n3. Include a button that triggers the \nrendering of the current GPS coordinates \nof the device"
        NSLayoutConstraint.activate([
            requirementsLabel.topAnchor.constraint(equalTo: requirementsIntroLabel.bottomAnchor, constant: 10),
            requirementsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            requirementsLabel.heightAnchor.constraint(equalToConstant: 160),
            requirementsLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureSolutionIntroLabel(){
        solutionIntroLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        contentView.addSubview(solutionIntroLabel)
        solutionIntroLabel.textColor = Colors.calmBlue
        solutionIntroLabel.numberOfLines = 0
        solutionIntroLabel.text = "To meet these requirements in a fun way, I built an app that:"
        NSLayoutConstraint.activate([
            solutionIntroLabel.topAnchor.constraint(equalTo: requirementsLabel.bottomAnchor, constant: 10),
            solutionIntroLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            solutionIntroLabel.heightAnchor.constraint(equalToConstant: 60),
            solutionIntroLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureSolutionLabel(){
        solutionLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        contentView.addSubview(solutionLabel)
        solutionLabel.textColor = Colors.darkGray
        solutionLabel.numberOfLines = 0
        solutionLabel.text = "1. Displays an endless loop of images \ntaken from the ISS. \n2. Connects to the open-notify.org API and gets data such as the current location of the ISS, how many people are on board, etc, and presents it in various UIViews and even a MapView. \n3. Uses CLLocationManager to get the devices current GPS Coordinates, then connects with the API to predict when the ISS will pass over that inputted location, and finally presents all of this data in a modally-presented ViewController."
        NSLayoutConstraint.activate([
            solutionLabel.topAnchor.constraint(equalTo: solutionIntroLabel.bottomAnchor, constant: 10),
            solutionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            solutionLabel.heightAnchor.constraint(equalToConstant: 280),
            solutionLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureJumpInButton(){
        view.addSubview(jumpInButton)
        addActionToJumpInButton()
        NSLayoutConstraint.activate([
            jumpInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jumpInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            jumpInButton.widthAnchor.constraint(equalToConstant: 200),
            jumpInButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func addActionToJumpInButton(){
        jumpInButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }
}
