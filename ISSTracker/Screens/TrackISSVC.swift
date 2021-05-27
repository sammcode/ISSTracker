//
//  TrackISSVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import MapKit
import AVKit

class TrackISSVC: UIViewController {

    var issLocation: IssLocation!
    var coordinatesView: ITCoordinatesView!

    var anno: MKPointAnnotation!
    var timer: Timer!
    var timer1: Timer!

    var viewOffset: CGFloat = 260
    var coordinatesViewBottomConstraint = NSLayoutConstraint()

    var iconView = MKAnnotationView()

    var pulseLayer = CAShapeLayer()

    var isTrackingModeEnabled = false
    var isOrbitPathEnabled = true
    var isShowingLiveFeed = false

    let player = AVPlayer(url: URL(string: "http://iphone-streaming.ustream.tv/uhls/17074538/streams/live/iphone/playlist.m3u8")!)
    var playerLayer: AVPlayerLayer!
    var playerYCoordinate: CGFloat = 0

    let iconWidth = UserDefaultsManager.largeMapAnnotations ? 90 : 60
    let iconHeight = UserDefaultsManager.largeMapAnnotations ? 60 : 40

    var mapTypeButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var showCoordinatesButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "note.text", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var showLiveFeedButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "video", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var trackingModeButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "binoculars", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var orbitPathButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "location.north.line", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var zoomInButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "plus.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var zoomOutButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "minus.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var exitButton = ITIconButton(backgroundColor: .systemGray, image: (UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))

    var orbitPathButtonLeadingConstraint = NSLayoutConstraint()
    var zoomInButtonLeadingConstraint = NSLayoutConstraint()
    var zoomOutButtonLeadingConstraint = NSLayoutConstraint()

    var trackingModeLabel = ITPaddingLabel(withInsets: 2, 2, 2, 2)
    var trackingModeLabelTopConstraint = NSLayoutConstraint()
    var trackingModeLabelOffset: CGFloat = -100

    var iconImageView = ITImageView(frame: .zero)

    var coords = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startUpdating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        timer1.invalidate()
        Map.mapView.removeFromSuperview()
        Map.mapView.delegate = nil
        Map.mapView.removeAnnotation(anno)
        Map.mapView.removeAnnotations(Map.mapView.annotations)
        Map.mapView.removeOverlays(Map.mapView.overlays)
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configureIconView()
            }
        }
    }

    /// Calls all configuration methods for the ViewController
    func configure(){
        configureViewController()
        configureMapView()
        configureExitButton()
        configureCoordinatesView()
        configureMapTypeButton()
        configureShowCoordinatesButton()
        configureShowLiveFeedButton()
        configureTrackingModeButton()
        configureOrbitPathButton()
        configureZoomInButton()
        configureZoomOutButton()
        configureIconView()
        configureIconImageView()
        getFutureLocations()

        configureTrackingModeLabel()

        addBackgroundandForegroundObservers()

        playVideo()
    }

    func playVideo() {

        player.allowsExternalPlayback = true
        playerLayer = AVPlayerLayer(player: player)
        let width = view.bounds.width
        playerYCoordinate = view.center.y + (view.bounds.width * 0.21) + 260
        playerLayer.frame = CGRect(x: view.center.x - width/2, y: playerYCoordinate, width: width, height: 260)
        playerLayer.masksToBounds = true
        playerLayer.cornerRadius = 20
        playerLayer.borderWidth = 2
        playerLayer.borderColor = Colors.mainBlueYellow.cgColor
        playerLayer.videoGravity = .resizeAspectFill
        player.automaticallyWaitsToMinimizeStalling = false

        view.layer.insertSublayer(playerLayer, at: 1)

        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.alpha = 1.0
        }, completion: nil)
    }

    func addBackgroundandForegroundObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func willEnterForeground(){
        if !UserDefaultsManager.reduceAnimations { createPulseLayer() }
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(issLocation.latitude), longitude: CLLocationDegrees(issLocation.longitude))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
        Map.mapView.setRegion(region, animated: true)
        if isShowingLiveFeed { player.play() }
        updateOrbitPathOverlays()
    }

    @objc func didEnterBackground(){
        clearPulseLayer()
        isTrackingModeEnabled = false
        player.pause()
    }

    @objc func clearPulseLayer(){
        pulseLayer.removeAllAnimations()
        pulseLayer.removeFromSuperlayer()
    }

    func configureIconView(){
        if Map.mapView.mapType == .hybrid {
            iconView.set(image: Images.issIcon2!, with: .white)
        }else{
            iconView.set(image: Images.issIcon2!, with: .label)
        }
        iconView.frame.size = CGSize(width: iconWidth, height: iconHeight)
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.5
        iconView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        iconView.layer.shadowRadius = 5
        if !UserDefaultsManager.reduceAnimations { createPulse(in: iconView) }
    }

    func configureIconImageView(){
        view.addSubview(iconImageView)
        if Map.mapView.mapType == .hybrid {
            iconImageView.image = Images.issIcon2?.withTintColor(.white)
        }else{
            iconImageView.image = Images.issIcon2?.withTintColor(.label)
        }
        iconImageView.isHidden = true
        iconImageView.layer.cornerRadius = 0
        iconImageView.contentMode = .scaleToFill
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowOpacity = 0.5
        iconImageView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        iconImageView.layer.shadowRadius = 5
        iconImageView.clipsToBounds = false

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: CGFloat(iconWidth)),
            iconImageView.heightAnchor.constraint(equalToConstant: CGFloat(iconHeight) * 1.01),
            iconImageView.centerYAnchor.constraint(equalTo: Map.mapView.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: Map.mapView.centerXAnchor)
        ])
    }

    /// Configures properties for the ViewController
    func configureViewController(){
        title = "Track ISS"
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    /// Configures the coordinates view
    /// Sets the data based on the gpsLocation variable
    /// Constrains it to the top of the view
    func configureCoordinatesView(){
        coordinatesView = ITCoordinatesView(title: "ISS Data", issLocationData: issLocation)
        coordinatesViewBottomConstraint = coordinatesView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: viewOffset)
        view.addSubview(coordinatesView)
        NSLayoutConstraint.activate([
            coordinatesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coordinatesView.widthAnchor.constraint(equalTo: view.widthAnchor),
            coordinatesView.heightAnchor.constraint(equalToConstant: 260),
            coordinatesViewBottomConstraint
        ])
    }

    /// Configures the map view properties
    /// Adds a custom annotation (representing the location of the ISS)
    /// Sets the region to be centered around the added annotation
    /// Constraints it to the bottom of the description label
    func configureMapView(){
        view.addSubview(Map.mapView)
        Map.mapView.translatesAutoresizingMaskIntoConstraints = false
        Map.mapView.delegate = self

        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(issLocation.latitude), longitude: CLLocationDegrees(issLocation.longitude))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(15000000), longitudinalMeters: CLLocationDistance(15000000))
        Map.mapView.setRegion(region, animated: true)

        anno = MKPointAnnotation()
        anno.coordinate = coordinates

        Map.mapView.addAnnotation(anno)

        NSLayoutConstraint.activate([
            Map.mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            Map.mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            Map.mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            Map.mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        switch UserDefaultsManager.defaultMapType {
        case 0:
            Map.mapView.mapType = .standard
        case 1:
            Map.mapView.mapType = .hybrid
        default:
            break
        }
    }

    func configureExitButton(){
        view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        exitButton.layer.cornerRadius = 45/2

        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 45),
            exitButton.heightAnchor.constraint(equalToConstant: 45),
            exitButton.trailingAnchor.constraint(equalTo: Map.mapView.trailingAnchor, constant: -10),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    func configureMapTypeButton(){
        view.addSubview(mapTypeButton)
        addActionToMapTypeButton()
        NSLayoutConstraint.activate([
            mapTypeButton.widthAnchor.constraint(equalToConstant: 45),
            mapTypeButton.heightAnchor.constraint(equalToConstant: 45),
            mapTypeButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10),
            mapTypeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    func addActionToMapTypeButton() {
        mapTypeButton.addTarget(self, action: #selector(mapTypeButtonTapped), for: .touchUpInside)
    }

    @objc
    func mapTypeButtonTapped() {
        mapTypeButton.pulsate()
        if !isTrackingModeEnabled { updateOrbitPathOverlays() }
        switch Map.mapView.mapType {
        case .standard:
            Map.mapView.mapType = .hybrid
            iconView.set(image: Images.issIcon2!, with: .white)
            iconImageView.image = Images.issIcon2?.withTintColor(.white)
        case .hybrid:
            Map.mapView.mapType = .standard
            iconView.set(image: Images.issIcon2!, with: .label)
            iconImageView.image = Images.issIcon2?.withTintColor(.label)
        default:
            Map.mapView.mapType = .standard
        }
        iconView.frame.size = CGSize(width: iconWidth, height: iconHeight)
        clearPulseLayer()
        createPulseLayer()
    }

    func configureShowCoordinatesButton(){
        view.addSubview(showCoordinatesButton)
        addActionToShowCoordinatesButton()
        NSLayoutConstraint.activate([
            showCoordinatesButton.widthAnchor.constraint(equalToConstant: 45),
            showCoordinatesButton.heightAnchor.constraint(equalToConstant: 45),
            showCoordinatesButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10),
            showCoordinatesButton.topAnchor.constraint(equalTo: mapTypeButton.bottomAnchor, constant: 10)
        ])
    }

    func addActionToShowCoordinatesButton() {
        showCoordinatesButton.addTarget(self, action: #selector(showCoordinatesButtonTapped), for: .touchUpInside)
    }

    @objc
    func showCoordinatesButtonTapped() {
        showCoordinatesButton.pulsate()
        switch viewOffset {
        case 20:
            self.viewOffset = 260
            coordinatesViewBottomConstraint.constant = viewOffset
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        case 260:
            self.viewOffset = 20
            coordinatesViewBottomConstraint.constant = viewOffset
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        default:
            self.viewOffset = 260
            coordinatesViewBottomConstraint.constant = viewOffset
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func configureShowLiveFeedButton(){
        view.addSubview(showLiveFeedButton)
        addActionToShowLiveFeedButton()
        NSLayoutConstraint.activate([
            showLiveFeedButton.widthAnchor.constraint(equalToConstant: 45),
            showLiveFeedButton.heightAnchor.constraint(equalToConstant: 45),
            showLiveFeedButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10),
            showLiveFeedButton.topAnchor.constraint(equalTo: showCoordinatesButton.bottomAnchor, constant: 10)
        ])
    }

    func addActionToShowLiveFeedButton(){
        showLiveFeedButton.addTarget(self, action: #selector(showLiveFeedButtonTapped), for: .touchUpInside)
    }

    @objc func showLiveFeedButtonTapped(){
        showLiveFeedButton.pulsate()
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            switch self.isShowingLiveFeed {
            case false:
                self.playerYCoordinate = self.view.center.y + (self.view.bounds.width * 0.21) + 20
                self.playerLayer.frame = CGRect(x: self.view.center.x - (self.view.bounds.width/2), y: self.playerYCoordinate, width: self.view.bounds.width, height: 260)
                self.player.play()
            case true:
                self.playerYCoordinate = self.view.center.y + (self.view.bounds.width * 0.21) + 265
                self.playerLayer.frame = CGRect(x: self.view.center.x - (self.view.bounds.width/2), y: self.playerYCoordinate, width: self.view.bounds.width, height: 260)
            }
        }
        isShowingLiveFeed.toggle()
    }

    func configureZoomInButton(){
        view.addSubview(zoomInButton)
        addActionToZoomInButton()

        zoomInButtonLeadingConstraint = zoomInButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            zoomInButton.widthAnchor.constraint(equalToConstant: 45),
            zoomInButton.heightAnchor.constraint(equalToConstant: 45),
            zoomInButton.topAnchor.constraint(equalTo: orbitPathButton.bottomAnchor, constant: 10),
            zoomInButtonLeadingConstraint
        ])
    }

    func addActionToZoomInButton() {
        zoomInButton.addTarget(self, action: #selector(zoomInButtonTapped), for: .touchUpInside)
    }

    @objc
    func zoomInButtonTapped() {
        zoomInButton.pulsate()
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(issLocation.latitude), longitude: CLLocationDegrees(issLocation.longitude))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(800000), longitudinalMeters: CLLocationDistance(800000))
        Map.mapView.setRegion(region, animated: true)
    }

    func configureZoomOutButton(){
        view.addSubview(zoomOutButton)
        addActionToZoomOutButton()

        zoomOutButtonLeadingConstraint = zoomOutButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            zoomOutButton.widthAnchor.constraint(equalToConstant: 45),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 45),
            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 10),
            zoomOutButtonLeadingConstraint
        ])
    }

    func addActionToZoomOutButton() {
        zoomOutButton.addTarget(self, action: #selector(zoomOutButtonTapped), for: .touchUpInside)
    }

    @objc
    func zoomOutButtonTapped() {
        zoomOutButton.pulsate()
        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(issLocation.latitude), longitude: CLLocationDegrees(issLocation.longitude))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
        Map.mapView.setRegion(region, animated: true)
    }

    func configureTrackingModeButton(){
        view.addSubview(trackingModeButton)
        addActionToTrackingModeButton()

        NSLayoutConstraint.activate([
            trackingModeButton.widthAnchor.constraint(equalToConstant: 45),
            trackingModeButton.heightAnchor.constraint(equalToConstant: 45),
            trackingModeButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10),
            trackingModeButton.topAnchor.constraint(equalTo: showLiveFeedButton.bottomAnchor, constant: 10)
        ])
    }

    func addActionToTrackingModeButton() {
        trackingModeButton.addTarget(self, action: #selector(trackingModeButtonTapped), for: .touchUpInside)
    }

    @objc
    func trackingModeButtonTapped(){
        trackingModeButton.pulsate()
        if !UserDefaults.standard.bool(forKey: "trackingModeEnabledBefore") {
            presentITAlertOnMainThread(title: "Tracking Mode", message: "This awesome feature will follow the ISS autonomously 🤯. As the map is continuously animating while in Tracking Mode, be weary that CPU usage can be as high as 50%. \n\n -Sam 👨‍💻", buttonTitle: "Ok", isLongMessage: true)
            UserDefaults.standard.set(true, forKey: "trackingModeEnabledBefore")
        } else {
            isTrackingModeEnabled.toggle()

            let coordinates: CLLocationCoordinate2D!
            let region: MKCoordinateRegion!
            switch trackingModeLabelOffset {
            case 10:
                self.trackingModeLabelOffset = -100
                trackingModeLabelTopConstraint.constant = trackingModeLabelOffset
                zoomInButtonLeadingConstraint.constant = 10
                zoomOutButtonLeadingConstraint.constant = 10
                orbitPathButtonLeadingConstraint.constant = 10
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                createPulseLayer()
                coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.issLocation.latitude), longitude: CLLocationDegrees(self.issLocation.longitude))
                region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
                Map.mapView.setRegion(region, animated: true)
                updateOrbitPathOverlays()
                Map.mapView.view(for: self.anno)?.isHidden = false
                iconImageView.isHidden = true
            case -100:
                self.trackingModeLabelOffset = 10
                trackingModeLabelTopConstraint.constant = trackingModeLabelOffset
                zoomInButtonLeadingConstraint.constant = -80
                zoomOutButtonLeadingConstraint.constant = -80
                orbitPathButtonLeadingConstraint.constant = -80
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                clearPulseLayer()
                coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.issLocation.latitude), longitude: CLLocationDegrees(self.issLocation.longitude))
                region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(60000), longitudinalMeters: CLLocationDistance(60000))
                Map.mapView.setRegion(region, animated: true)
                Map.mapView.removeOverlays(Map.mapView.overlays)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self else { return }
                    if self.isTrackingModeEnabled {
                        Map.mapView.view(for: self.anno)?.isHidden = true
                        self.iconImageView.isHidden = false
                    }
                }
            default:
                break
            }
        }
    }

    func configureTrackingModeLabel(){
        view.addSubview(trackingModeLabel)
        trackingModeLabel.translatesAutoresizingMaskIntoConstraints = false
        trackingModeLabel.backgroundColor = .systemGreen
        trackingModeLabel.textColor = .white
        trackingModeLabel.textAlignment = .center
        trackingModeLabel.font = UIFont(name: "NasalizationRg-Regular", size: 18)
        trackingModeLabel.text = "Tracking Mode: ON"
        trackingModeLabel.layer.cornerRadius = 10
        trackingModeLabel.layer.masksToBounds = true

        trackingModeLabelTopConstraint = trackingModeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: trackingModeLabelOffset)
        NSLayoutConstraint.activate([
            trackingModeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingModeLabel.widthAnchor.constraint(equalToConstant: 200),
            trackingModeLabel.heightAnchor.constraint(equalToConstant: 35),
            trackingModeLabelTopConstraint
        ])
    }

    func configureOrbitPathButton(){
        view.addSubview(orbitPathButton)
        addActionToOrbitPathButton()

        orbitPathButtonLeadingConstraint = orbitPathButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            orbitPathButton.widthAnchor.constraint(equalToConstant: 45),
            orbitPathButton.heightAnchor.constraint(equalToConstant: 45),
            orbitPathButton.topAnchor.constraint(equalTo: trackingModeButton.bottomAnchor, constant: 10),
            orbitPathButtonLeadingConstraint
        ])
    }

    func addActionToOrbitPathButton(){
        orbitPathButton.addTarget(self, action: #selector(orbitPathButtonTapped), for: .touchUpInside)
    }

    @objc func orbitPathButtonTapped(){
        orbitPathButton.pulsate()
        switch isOrbitPathEnabled {
        case false:
            updateOrbitPathOverlays()
        case true:
            Map.mapView.removeOverlays(Map.mapView.overlays)
        }
        isOrbitPathEnabled.toggle()
    }

    /// Starts a timer that calls the updateMapView method every 10 seconds
    func startUpdating(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateMapView), userInfo: nil, repeats: true)
        timer1 = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.getFutureLocations), userInfo: nil, repeats: true)
    }

    /// Dismisses the ViewController
    @objc func dismissVC(){
        dismiss(animated: true)
    }

    /// Uses the NetworkManager class to attempt to get the updated location of the ISS
    /// On success, the coordinates view is updated with the retrieved data, and the map view annotation is moved to the updated coordinates
    /// On failure, a custom alert is presented stating the error in question
    @objc func updateMapView() {
        NetworkManager.shared.getISSLocation { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let iss):
                DispatchQueue.main.async { [self] in
                    self.issLocation = iss

                    let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.issLocation.latitude), longitude: CLLocationDegrees(self.issLocation.longitude))

                    UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
                        self.anno.coordinate = coordinates
                    }

                    if self.isTrackingModeEnabled {
                        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(60000), longitudinalMeters: CLLocationDistance(60000))
                        Map.mapView.animatedZoom(zoomRegion: region, duration: 2)
                    }

                    self.coordinatesView.issLocation = self.issLocation
                }
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    @objc func getFutureLocations(){
        guard !isTrackingModeEnabled else { return }
        var timestamps = [Int64]()
        for x in 1..<11{
            let time = (Date() + Double(557 * x)).currentTimeMillis()
            timestamps.append(time)
        }
        NetworkManager.shared.getIssLocations(for: timestamps) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let issLocations):
                self.coords = [CLLocationCoordinate2D]()
                for location in issLocations {
                    let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
                    self.coords.append(coordinates)
                }
                self.updateOrbitPathOverlays()
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func updateOrbitPathOverlays(){
        let polyline = MKGeodesicPolyline(coordinates: [self.anno.coordinate, coords[0]], count: 2)
        let polyline1 = MKGeodesicPolyline(coordinates: [coords[0], coords[1]], count: 2)
        let polyline2 = MKGeodesicPolyline(coordinates: [coords[1], coords[2]], count: 2)
        let polyline3 = MKGeodesicPolyline(coordinates: [coords[2], coords[3]], count: 2)
        let polyline4 = MKGeodesicPolyline(coordinates: [coords[3], coords[4]], count: 2)
        let polyline5 = MKGeodesicPolyline(coordinates: [coords[4], coords[5]], count: 2)
        let polyline6 = MKGeodesicPolyline(coordinates: [coords[5], coords[6]], count: 2)
        let polyline7 = MKGeodesicPolyline(coordinates: [coords[6], coords[7]], count: 2)
        let polyline8 = MKGeodesicPolyline(coordinates: [coords[7], coords[8]], count: 2)
        let polyline9 = MKGeodesicPolyline(coordinates: [coords[8], coords[9]], count: 2)
        DispatchQueue.main.async {
            Map.mapView.removeOverlays(Map.mapView.overlays)
            Map.mapView.addOverlays([polyline, polyline1, polyline2, polyline3, polyline4, polyline5, polyline6, polyline7, polyline8, polyline9])
        }
    }

    @objc func createPulseLayer(){
        createPulse(in: iconView)
    }

    @objc func createPulse(in view: MKAnnotationView) {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/4.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 4.0
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.lineCap = CAShapeLayerLineCap.round
        pulseLayer.position = CGPoint(x: view.frame.size.width/2.1, y: view.frame.size.width/2.1)
        view.layer.addSublayer(pulseLayer)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.animatePulse()
            }

        }

        @objc func animatePulse() {
            if Map.mapView.mapType == .hybrid { pulseLayer.strokeColor = Colors.deepYellow.cgColor }
            else{ pulseLayer.strokeColor = Colors.mainBlueYellow.cgColor }

            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 3.0
            scaleAnimation.fromValue = 0.0
            scaleAnimation.toValue = 0.9
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            pulseLayer.add(scaleAnimation, forKey: "scale")

            let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            opacityAnimation.duration = 3.0
            opacityAnimation.fromValue = 0.9
            opacityAnimation.toValue = 0.0
            opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            opacityAnimation.repeatCount = .greatestFiniteMagnitude
            pulseLayer.add(opacityAnimation, forKey: "opacity")
        }
}

extension TrackISSVC: MKMapViewDelegate {

    /// Returns the custom MKAnnotationView for map view annotations, which is set to the ISS icon image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return iconView
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let visibleRect = Map.mapView.visibleMapRect
        let annos = Map.mapView.annotations(in: visibleRect)
        if annos.isEmpty {
            clearPulseLayer()
        }else {
            if pulseLayer.animationKeys() == nil && !UserDefaultsManager.reduceAnimations && !isTrackingModeEnabled{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.createPulse(in: self.iconView)
                }
            }
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 3.0
            renderer.alpha = 0.7
            renderer.strokeColor = .systemGreen

            return renderer
        }

        return MKOverlayRenderer()
    }
}

extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
            }, completion: nil)
    }
}
