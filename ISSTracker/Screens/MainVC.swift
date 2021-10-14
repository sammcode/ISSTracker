//
//  MainVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit
import CoreLocation
import AVKit
import AVFoundation

class MainVC: ITDataLoadingVC {

    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    let generator = UINotificationFeedbackGenerator()

    var buttonsStackView = UIStackView()
    var trackISSButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "Track ISS")
    var searchImagesButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "Search Images")
    var peopleInSpaceButton = ITButton(backgroundColor: UIColor.systemIndigo, title: "People In Space")
    var titleLabel = ITTitleLabel(textAlignment: .center, fontSize: 48)

    var playerLooper: AVPlayerLooper?
    var playerLayer: AVPlayerLayer!
    let player = AVQueuePlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addBackgroundandForegroundObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()

        let session = AVAudioSession.sharedInstance()

        do {
            try session.setCategory(.ambient, mode: .default, options: [])
            try session.setActive(true)
        } catch let error {
            print("Error, unable to continue music: \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        view.alpha = 0.0
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            trackISSButton.layer.shadowColor = UIColor.label.cgColor
            searchImagesButton.layer.shadowColor = UIColor.label.cgColor
            peopleInSpaceButton.layer.shadowColor = UIColor.label.cgColor
        }
    }

    func addBackgroundandForegroundObservers() {
        // background event
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.didEnterBackgroundNotification, object: nil)

        // foreground event
        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.willEnterForegroundNotification, object: nil)

        // add these 2 notifications to prevent freeze on long Home button press and back
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayerLayerToNil), name: UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(reinitializePlayerLayer), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func playVideo() {
        guard let path = Bundle.main.path(forResource: "planetearthCropped", ofType:"mp4") else {
            debugPrint("planetearthCropped.mov not found")
            return
        }

        playerLayer = AVPlayerLayer(player: player)
        let playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        let width = view.bounds.width * 0.6
        let yConstant: CGFloat = DeviceType.isiPhoneSE ? 150 : 200
        playerLayer.frame = CGRect(x: view.center.x - width/2, y: view.center.y - yConstant, width: width, height: width)
        playerLayer.cornerRadius = playerLayer.bounds.width/2
        playerLayer.masksToBounds = true
        playerLayer.videoGravity = .resizeAspectFill
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false

        if player.timeControlStatus == .paused && !UserDefaultsManager.reduceAnimations {
            player.playImmediately(atRate: 1.0)
        }

        view.layer.insertSublayer(playerLayer, at: 0)

        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.alpha = 1.0
        }, completion: nil)
    }

    @objc fileprivate func setPlayerLayerToNil(){
        player.pause()
    }

    @objc fileprivate func reinitializePlayerLayer(){
        if !UserDefaultsManager.reduceAnimations { player.play() }
    }

    /// Calls all configuration methods for the ViewController
    func configure(){
        configureViewController()
        configureTitleLabel()
        configureButtons()
        configureButtonsStackView()
    }

    /// Configures properties for the ViewController
    func configureViewController(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.systemIndigo
        view.backgroundColor = .systemBackground
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .medium)), style: .plain, target: self, action: #selector(presentSettingsVC))
        infoButton.tintColor = UIColor.systemIndigo
        navigationItem.rightBarButtonItem = infoButton
    }

    /// Configures the title label, constains it to the top of the view
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "NasalizationRg-Regular", size: 48)
        titleLabel.textColor = .label
        titleLabel.text = "TrackISS"

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 260),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1)
        ])
    }

    /// Adds actions to the buttons, sets the width and height for both of them
    func configureButtons(){

        let height: CGFloat = DeviceType.isiPhoneSE ? 40 : 60

        addActionToTrackISSButton()
        NSLayoutConstraint.activate([
            trackISSButton.heightAnchor.constraint(equalToConstant: height),
            trackISSButton.widthAnchor.constraint(equalToConstant: 260)
        ])

        addActionToSearchImagesButton()
        NSLayoutConstraint.activate([
            searchImagesButton.heightAnchor.constraint(equalToConstant: height),
            searchImagesButton.widthAnchor.constraint(equalToConstant: 260)
        ])

        addActionToPeopleInSpaceButton()
        NSLayoutConstraint.activate([
            peopleInSpaceButton.heightAnchor.constraint(equalToConstant: height),
            peopleInSpaceButton.widthAnchor.constraint(equalToConstant: 260)
        ])
    }

    /// Configures the stackview properties, constrains it to the bottom of the image description label
    /// If the current device is a 1st generation iPhone SE, the height is set accordingly and the button description labels aren't added to the stackview, as they take up too much space
    func configureButtonsStackView(){
        view.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.alignment = .center
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 15

        let height: CGFloat = DeviceType.isiPhoneSE ? 160 : 225
        let bottomConstant : CGFloat = DeviceType.isiPhoneSE ? -40 : -60

        NSLayoutConstraint.activate([
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            buttonsStackView.heightAnchor.constraint(equalToConstant: height)
        ])

        buttonsStackView.addArrangedSubviews(trackISSButton, searchImagesButton, peopleInSpaceButton)
    }

    /// Adds the getISSLocation method to the trackISSButton, for the touchUpInside action
    func addActionToTrackISSButton(){
        trackISSButton.addTarget(self, action: #selector(getISSLocationsAndPresentTrackISSVC), for: .touchUpInside)
    }

    func addActionToSearchImagesButton(){
        searchImagesButton.addTarget(self, action: #selector(openSearchImagesVC), for: .touchUpInside)
    }

    /// Adds the getPeopleInSpace method to the peopleInSpaceButton, for the touchUpInside action
    func addActionToPeopleInSpaceButton(){
        peopleInSpaceButton.addTarget(self, action: #selector(getPeopleInSpaceAndPresentPeopleInSpaceVC), for: .touchUpInside)
    }

    /// Uses the NetworkManager class to get the current location of the ISS
    /// On success, an instance of the TrackISSVC ViewController is presented with the retrieved data
    /// On failure, a custom alert is presented stating the error in question
    @objc func getISSLocationsAndPresentTrackISSVC() {
        trackISSButton.pulsate()
        showLoadingView()

        NetworkManager.shared.getIssLocations(for: LocationCalculator.getTimestampsForCurrentOrbit()) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()

            switch result {
            case .success(let issLocations):
                if UserDefaultsManager.haptics { self.generator.notificationOccurred(.success) }
                DispatchQueue.main.async {
                    let trackISSVC = TrackISSVC()
                    trackISSVC.currentOrbitLocations = issLocations
                    let navController = UINavigationController(rootViewController: trackISSVC)
                    self.present(navController, animated: true)
                }
            case .failure(let error):
                if UserDefaultsManager.haptics { self.generator.notificationOccurred(.error) }
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    @objc func openSearchImagesVC() {
        searchImagesButton.pulsate()
        self.showLoadingView()

        let q = "international%20space%20station%20\(Date().monthYear)"

        NetworkManager.shared.conductNASAImageSearch(for: q, page: 1) { [weak self] result in
            guard let self = self else { return }

            self.dismissLoadingView()

            switch result {
            case .success(let searchResults):
                if UserDefaultsManager.haptics { self.generator.notificationOccurred(.success) }
                DispatchQueue.main.async {
                    let searchImagesVC = SearchImagesVC()
                    searchImagesVC.imageData = searchResults.collection.items
                    searchImagesVC.currentQ = q
                    let navController = UINavigationController(rootViewController: searchImagesVC)
                    self.present(navController, animated: true)
                }
            case .failure(let error):
                if UserDefaultsManager.haptics { self.generator.notificationOccurred(.error) }
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }

    }

    @objc func getPeopleInSpaceAndPresentPeopleInSpaceVC(){
        peopleInSpaceButton.pulsate()
        showLoadingView()
        NetworkManager.shared.getPeopleInSpace { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let peopleData):
                if UserDefaultsManager.haptics { self.generator.notificationOccurred(.success) }
                DispatchQueue.main.async {
                    let peopleInSpaceVC = PeopleInSpaceVC()
                    peopleInSpaceVC.peopleInSpace = peopleData
                    let navController = UINavigationController(rootViewController: peopleInSpaceVC)

                    self.present(navController, animated: true)
                }
            case .failure(let error):
                if UserDefaultsManager.haptics { self.generator.notificationOccurred(.error) }
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    @objc func presentSettingsVC(){
        let settingsVC = SettingsVC()
        settingsVC.delegate = self
        let navController = UINavigationController(rootViewController: settingsVC)
        self.present(navController, animated: true)
    }
}

extension MainVC: SettingsVCDelegate {
    func didChangeAnimationPreferences() {
        if UserDefaultsManager.reduceAnimations {
            player.pause()
        }else if !UserDefaultsManager.reduceAnimations {
            player.play()
        }
    }
}
