//
//  DeveloperVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/13/21.
//

import UIKit
import SafariServices

class DeveloperVC: UIViewController {

    var scrollView = UIScrollView()
    var contentView = UIView()

    var profileImageView = ITImageView(frame: .zero)

    var aboutMeLabel = ITBodyLabel(textAlignment: .left)
    var aboutMeTitleLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
    var aboutMeLabelContainerView = UIView()

    var whyIMadeTrackISSLabel = ITBodyLabel(textAlignment: .left)
    var whyIMadeTrackISSTitleLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
    var whyImadeTrackISSContainerView = UIView()

    var twitterButton = ITButton(backgroundColor: Colors.mainBlueYellow, title: "Twitter")
    var githubButton = ITButton(backgroundColor: Colors.mainBlueYellow, title: "Github")
    var websiteButton = ITButton(backgroundColor: Colors.mainBlueYellow, title: "Website")

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        configureViewController()
        configureScrollView()
        configureProfileImageView()
        configureAboutMeLabelContainerView()
        configureAboutMeTitleLabel()
        configureAboutMeLabel()
        configureWhyIMadeTrackISSLabelContainerView()
        configureWhyIMadeTrackISSTitleLabel()
        configureWhyIMadeTrackISSLabel()
        configureTwitterButton()
        configureGithubButton()
        configureWebsiteButton()
    }

    func configureViewController(){
        title = "Developer"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)
        scrollView.addSubview(contentView)
        contentView.pinToEdges(of: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 880)
        ])
    }

    func configureProfileImageView(){
        contentView.addSubview(profileImageView)
        profileImageView.image = Images.portrait

        profileImageView.layer.shadowColor = Colors.whiteBlack.cgColor
        profileImageView.layer.shadowOpacity = 0.5
        profileImageView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        profileImageView.layer.shadowRadius = 5

        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func configureAboutMeLabelContainerView(){
        contentView.addSubview(aboutMeLabelContainerView)
        aboutMeLabelContainerView.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabelContainerView.backgroundColor = .systemBackground
        aboutMeLabelContainerView.layer.cornerRadius = 10

        aboutMeLabelContainerView.layer.shadowColor = Colors.whiteBlack.cgColor
        aboutMeLabelContainerView.layer.shadowOpacity = 0.5
        aboutMeLabelContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        aboutMeLabelContainerView.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            aboutMeLabelContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutMeLabelContainerView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            aboutMeLabelContainerView.heightAnchor.constraint(equalToConstant: 150),
            aboutMeLabelContainerView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10)
        ])
    }

    func configureAboutMeTitleLabel(){
        contentView.addSubview(aboutMeTitleLabel)
        aboutMeTitleLabel.text = "About me"
        aboutMeTitleLabel.textColor = Colors.mainBlueYellow
        aboutMeTitleLabel.font = UIFont(name: "NasalizationRg-Regular", size: 24)

        NSLayoutConstraint.activate([
            aboutMeTitleLabel.topAnchor.constraint(equalTo: aboutMeLabelContainerView.topAnchor, constant: 8),
            aboutMeTitleLabel.leadingAnchor.constraint(equalTo: aboutMeLabelContainerView.leadingAnchor, constant: 8),
            aboutMeTitleLabel.widthAnchor.constraint(equalToConstant: 120),
            aboutMeTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configureAboutMeLabel(){
        contentView.addSubview(aboutMeLabel)
        aboutMeLabel.numberOfLines = 0
        aboutMeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        aboutMeLabel.textColor = .label
        aboutMeLabel.text = "Hi 👋 My name is Sam. I'm a iOS Developer from Ithaca, NY. I tend to make projects based around ideas that stem from my own life, in the hopes that people with similar interests to me might find them useful."

        let inset: CGFloat = 8
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: aboutMeTitleLabel.bottomAnchor),
            aboutMeLabel.leadingAnchor.constraint(equalTo: aboutMeLabelContainerView.leadingAnchor, constant: inset),
            aboutMeLabel.trailingAnchor.constraint(equalTo: aboutMeLabelContainerView.trailingAnchor, constant: -inset),
            aboutMeLabel.bottomAnchor.constraint(equalTo: aboutMeLabelContainerView.bottomAnchor, constant: -inset)
        ])
    }

    func configureWhyIMadeTrackISSLabelContainerView(){
        contentView.addSubview(whyImadeTrackISSContainerView)
        whyImadeTrackISSContainerView.translatesAutoresizingMaskIntoConstraints = false
        whyImadeTrackISSContainerView.backgroundColor = .systemBackground
        whyImadeTrackISSContainerView.layer.cornerRadius = 10

        whyImadeTrackISSContainerView.layer.shadowColor = Colors.whiteBlack.cgColor
        whyImadeTrackISSContainerView.layer.shadowOpacity = 0.5
        whyImadeTrackISSContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        whyImadeTrackISSContainerView.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            whyImadeTrackISSContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whyImadeTrackISSContainerView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            whyImadeTrackISSContainerView.heightAnchor.constraint(equalToConstant: 300),
            whyImadeTrackISSContainerView.topAnchor.constraint(equalTo: aboutMeLabelContainerView.bottomAnchor, constant: 10)
        ])
    }

    func configureWhyIMadeTrackISSTitleLabel(){
        contentView.addSubview(whyIMadeTrackISSTitleLabel)

        whyIMadeTrackISSTitleLabel.text = "Why I made TrackISS"
        whyIMadeTrackISSTitleLabel.textColor = Colors.mainBlueYellow
        whyIMadeTrackISSTitleLabel.font = UIFont(name: "NasalizationRg-Regular", size: 24)

        NSLayoutConstraint.activate([
            whyIMadeTrackISSTitleLabel.topAnchor.constraint(equalTo: whyImadeTrackISSContainerView.topAnchor, constant: 8),
            whyIMadeTrackISSTitleLabel.leadingAnchor.constraint(equalTo: whyImadeTrackISSContainerView.leadingAnchor, constant: 8),
            whyIMadeTrackISSTitleLabel.widthAnchor.constraint(equalToConstant: 280),
            whyIMadeTrackISSTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    func configureWhyIMadeTrackISSLabel(){
        contentView.addSubview(whyIMadeTrackISSLabel)

        whyIMadeTrackISSLabel.numberOfLines = 0
        whyIMadeTrackISSLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        whyIMadeTrackISSLabel.textColor = .label
        whyIMadeTrackISSLabel.text = "I've been an avid fan of the International Space Station for as long as I can remember, as it is a symbol of human co-operation and a technological marvel (and it's just straight up cool). As it moves at over 27,000 km/h, and orbits the 🌎 every 90 minutes, it can be difficult to keep track of it's location. \n\nTo address this I created a native iOS experience that allows those who are curious like me, to witness where the ISS is in the world at any given time. Hope you enjoy 😃"

        let inset: CGFloat = 8
        NSLayoutConstraint.activate([
            whyIMadeTrackISSLabel.topAnchor.constraint(equalTo: whyIMadeTrackISSTitleLabel.bottomAnchor, constant: 4),
            whyIMadeTrackISSLabel.leadingAnchor.constraint(equalTo: whyImadeTrackISSContainerView.leadingAnchor, constant: inset),
            whyIMadeTrackISSLabel.trailingAnchor.constraint(equalTo: whyImadeTrackISSContainerView.trailingAnchor, constant: -inset),
            whyIMadeTrackISSLabel.bottomAnchor.constraint(equalTo: whyImadeTrackISSContainerView.bottomAnchor, constant: -inset)
        ])
    }

    func configureTwitterButton(){
        contentView.addSubview(twitterButton)
        twitterButton.addTarget(self, action: #selector(twitterButtonTapped), for: .touchUpInside)
        twitterButton.setImage(UIImage(named: "twitterIcon")?.withTintColor(.systemBackground), for: .normal)
        twitterButton.imageView?.contentMode = .scaleAspectFit
        twitterButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        twitterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        twitterButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        twitterButton.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            twitterButton.topAnchor.constraint(equalTo: whyImadeTrackISSContainerView.bottomAnchor, constant: 20),
            twitterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            twitterButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            twitterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureGithubButton(){
        contentView.addSubview(githubButton)
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        githubButton.setImage(UIImage(named: "githubIcon")?.withTintColor(.systemBackground), for: .normal)
        githubButton.imageView?.contentMode = .scaleAspectFit
        githubButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        githubButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        githubButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        githubButton.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            githubButton.topAnchor.constraint(equalTo: twitterButton.bottomAnchor, constant: 10),
            githubButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            githubButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            githubButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureWebsiteButton(){
        contentView.addSubview(websiteButton)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        websiteButton.setImage(UIImage(named: "websiteIcon")?.withTintColor(.systemBackground), for: .normal)
        websiteButton.imageView?.contentMode = .scaleAspectFit
        websiteButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        websiteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        websiteButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        websiteButton.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            websiteButton.topAnchor.constraint(equalTo: githubButton.bottomAnchor, constant: 10),
            websiteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            websiteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            websiteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func twitterButtonTapped(){
        let safariVC = SFSafariViewController(url: URL(string: "https://twitter.com/sammcode")!)
        safariVC.preferredControlTintColor = Colors.mainBlueYellow
        present(safariVC, animated: true)
    }

    @objc func githubButtonTapped(){
        let safariVC = SFSafariViewController(url: URL(string: "https://github.com/sammcode")!)
        safariVC.preferredControlTintColor = Colors.mainBlueYellow
        present(safariVC, animated: true)
    }

    @objc func websiteButtonTapped(){
        let safariVC = SFSafariViewController(url: URL(string: "https://www.sammcgarry.dev/")!)
        safariVC.preferredControlTintColor = Colors.mainBlueYellow
        present(safariVC, animated: true)
    }
}
