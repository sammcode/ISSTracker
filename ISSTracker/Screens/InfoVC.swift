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
    var requirementsLabel: ITBodyLabel!
    var solutionIntroLabel: ITDescriptionLabel!
    var solutionLabel: ITBodyLabel!
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

    /// Constrains scroll between the top of the view and the jump in button on the bottom
    /// Constraints content view to the edges of the scroll view
    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.pinToEdges(of: scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: jumpInButton.topAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 800)
        ])

    }

    /// Configures title label properties, assigns the text to be presented
    /// Constrains title label to the top of the contentView
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

    /// Configures welcome label properties, assigns text to be presented
    /// Constrains welcome label to the bottom of the title label
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

    /// Configures requirements intro label properties, assigns text to be presented
    /// Constrains requirements intro label to the bottom of the welcome label
    func configureRequirementsIntroLabel(){
        requirementsIntroLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        contentView.addSubview(requirementsIntroLabel)
        requirementsIntroLabel.textColor = Colors.calmBlue
        requirementsIntroLabel.numberOfLines = 0
        requirementsIntroLabel.text = "For this assessment I was tasked with creating an app that satisfied the following three requirements:"
        NSLayoutConstraint.activate([
            requirementsIntroLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            requirementsIntroLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            requirementsIntroLabel.heightAnchor.constraint(equalToConstant: 60),
            requirementsIntroLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    /// Configures requirements label properties, assigns text to be presented
    /// Constrains requirements label to the bottom of the requirements intro label
    func configureRequirementsLabel(){
        requirementsLabel = ITBodyLabel(textAlignment: .left)
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

    /// Configures solution intro label properties, assigns text to be presented
    /// Constrains solution intro label to the bottom of the requirements label
    func configureSolutionIntroLabel(){
        solutionIntroLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        contentView.addSubview(solutionIntroLabel)
        solutionIntroLabel.textColor = Colors.calmBlue
        solutionIntroLabel.numberOfLines = 0
        solutionIntroLabel.text = "To meet these requirements in a fun way, I built an app themed around the International Space Station that:"
        NSLayoutConstraint.activate([
            solutionIntroLabel.topAnchor.constraint(equalTo: requirementsLabel.bottomAnchor, constant: 10),
            solutionIntroLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            solutionIntroLabel.heightAnchor.constraint(equalToConstant: 60),
            solutionIntroLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    /// Configures solution label properties, assigns text to be presented
    /// Constrains solution label to the bottom of the solution intro label
    func configureSolutionLabel(){
        solutionLabel = ITBodyLabel(textAlignment: .left)
        contentView.addSubview(solutionLabel)
        solutionLabel.textColor = Colors.darkGray
        solutionLabel.numberOfLines = 0
        solutionLabel.text = "1. Displays an endless loop of 8 images taken from the ISS. \n2. Connects to the open-notify.org API, gets data in the form of JSON objects such as the current location of the ISS, and then presents it in various UIViews and even a MKMapView. \n3. Uses CLLocationManager to get the devices current GPS Coordinates, then connects with the API to predict when the ISS will pass over the user's current location, and finally presents all of this data in a modally-presented UIViewController."
        NSLayoutConstraint.activate([
            solutionLabel.topAnchor.constraint(equalTo: solutionIntroLabel.bottomAnchor, constant: 10),
            solutionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            solutionLabel.heightAnchor.constraint(equalToConstant: 280),
            solutionLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    /// Adds action to jump in button, constrains it to the bottom of the view
    func configureJumpInButton(){
        view.addSubview(jumpInButton)
        addActionToJumpInButton()
        NSLayoutConstraint.activate([
            jumpInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jumpInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            jumpInButton.widthAnchor.constraint(equalToConstant: 200),
            jumpInButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    /// Adds the dismissVC method to the jump in button, for the touchUpInside action
    func addActionToJumpInButton(){
        jumpInButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }

    /// Dismisses the ViewController
    @objc func dismissVC(){
        dismiss(animated: true)
    }
}
