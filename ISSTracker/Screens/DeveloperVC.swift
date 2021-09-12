//
//  DeveloperVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 5/13/21.
//

import UIKit
import SafariServices

class DeveloperVC: UIViewController {

    var aboutMeLabel = ITBodyLabel(textAlignment: .left)
    var aboutMeTitleLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
    var aboutMeLabelContainerView = UIView()

    var twitterButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "Twitter")
    var githubButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "Github")
    var websiteButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "Website")

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        configureViewController()
        configureAboutMeLabelContainerView()
        configureAboutMeTitleLabel()
        configureAboutMeLabel()
        configureTwitterButton()
        configureGithubButton()
        configureWebsiteButton()
    }

    func configureViewController(){
        title = "Developer"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureAboutMeLabelContainerView(){
        view.addSubview(aboutMeLabelContainerView)
        aboutMeLabelContainerView.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabelContainerView.backgroundColor = .systemGray5
        aboutMeLabelContainerView.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            aboutMeLabelContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutMeLabelContainerView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            aboutMeLabelContainerView.heightAnchor.constraint(equalToConstant: 150),
            aboutMeLabelContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        ])
    }

    func configureAboutMeTitleLabel(){
        view.addSubview(aboutMeTitleLabel)
        aboutMeTitleLabel.text = "About me"
        aboutMeTitleLabel.textColor = .label
        aboutMeTitleLabel.font = UIFont(name: "NasalizationRg-Regular", size: 24)

        NSLayoutConstraint.activate([
            aboutMeTitleLabel.topAnchor.constraint(equalTo: aboutMeLabelContainerView.topAnchor, constant: 10),
            aboutMeTitleLabel.leadingAnchor.constraint(equalTo: aboutMeLabelContainerView.leadingAnchor, constant: 8),
            aboutMeTitleLabel.widthAnchor.constraint(equalToConstant: 120),
            aboutMeTitleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configureAboutMeLabel(){
        view.addSubview(aboutMeLabel)
        aboutMeLabel.numberOfLines = 0
        aboutMeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        aboutMeLabel.textColor = .label
        aboutMeLabel.text = "Hi 👋 My name is Sam. I'm a iOS Developer from Ithaca, NY. I tend to make projects based around ideas that stem from my own life, in the hopes that people with similar interests to me might find them useful."

        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: aboutMeTitleLabel.bottomAnchor),
            aboutMeLabel.leadingAnchor.constraint(equalTo: aboutMeLabelContainerView.leadingAnchor, constant: inset),
            aboutMeLabel.trailingAnchor.constraint(equalTo: aboutMeLabelContainerView.trailingAnchor, constant: -inset),
            aboutMeLabel.bottomAnchor.constraint(equalTo: aboutMeLabelContainerView.bottomAnchor, constant: -inset)
        ])
    }

    func configureTwitterButton(){
        view.addSubview(twitterButton)
        twitterButton.addTarget(self, action: #selector(twitterButtonTapped), for: .touchUpInside)
        twitterButton.setImage(UIImage(named: "twitterIcon")?.withTintColor(.white), for: .normal)
        twitterButton.imageView?.contentMode = .scaleAspectFit
        twitterButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        twitterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        twitterButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        twitterButton.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            twitterButton.topAnchor.constraint(equalTo: aboutMeLabelContainerView.bottomAnchor, constant: 15),
            twitterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            twitterButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            twitterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureGithubButton(){
        view.addSubview(githubButton)
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        githubButton.setImage(UIImage(named: "githubIcon")?.withTintColor(.white), for: .normal)
        githubButton.imageView?.contentMode = .scaleAspectFit
        githubButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        githubButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        githubButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        githubButton.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            githubButton.topAnchor.constraint(equalTo: twitterButton.bottomAnchor, constant: 15),
            githubButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            githubButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            githubButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configureWebsiteButton(){
        view.addSubview(websiteButton)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        websiteButton.setImage(UIImage(named: "websiteIcon")?.withTintColor(.white), for: .normal)
        websiteButton.imageView?.contentMode = .scaleAspectFit
        websiteButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        websiteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        websiteButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        websiteButton.layer.shadowRadius = 3

        NSLayoutConstraint.activate([
            websiteButton.topAnchor.constraint(equalTo: githubButton.bottomAnchor, constant: 15),
            websiteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            websiteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            websiteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func twitterButtonTapped(){
        let safariVC = SFSafariViewController(url: URL(string: "https://twitter.com/sammcode")!)
        safariVC.preferredControlTintColor = UIColor.systemIndigo
        present(safariVC, animated: true)
    }

    @objc func githubButtonTapped(){
        let safariVC = SFSafariViewController(url: URL(string: "https://github.com/sammcode")!)
        safariVC.preferredControlTintColor = UIColor.systemIndigo
        present(safariVC, animated: true)
    }

    @objc func websiteButtonTapped(){
        let safariVC = SFSafariViewController(url: URL(string: "https://www.sammcgarry.dev/")!)
        safariVC.preferredControlTintColor = UIColor.systemIndigo
        present(safariVC, animated: true)
    }
}
