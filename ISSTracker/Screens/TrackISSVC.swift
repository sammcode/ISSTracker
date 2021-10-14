//
//  TrackISSVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import MapKit

class TrackISSVC: UIViewController {

    var currentCoordinate: CLLocationCoordinate2D!
    var currentOrbitLocations: [IssLocation]!

    var coordinatesView: ITCoordinatesView!

    var iconAnnotation: MKPointAnnotation!
    var timer: Timer!

    var viewOffset: CGFloat = 260
    var coordinatesViewBottomConstraint = NSLayoutConstraint()

    var iconView = MKAnnotationView()

    var pulseLayer = CAShapeLayer()

    var isOrbitPathEnabled = true

    let iconWidth = UserDefaultsManager.largeMapAnnotations ? 90 : 60
    let iconHeight = UserDefaultsManager.largeMapAnnotations ? 60 : 40

    var mapTypeButton = ITIconButton(backgroundColor: UIColor.systemIndigo, image: (UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))
    var showCoordinatesButton = ITIconButton(backgroundColor: UIColor.systemIndigo, image: (UIImage(systemName: "note.text", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))
    var orbitPathButton = ITIconButton(backgroundColor: UIColor.systemIndigo, image: (UIImage(systemName: "location.north.line", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))
    var zoomInButton = ITIconButton(backgroundColor: UIColor.systemIndigo, image: (UIImage(systemName: "plus.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))
    var zoomOutButton = ITIconButton(backgroundColor: UIColor.systemIndigo, image: (UIImage(systemName: "minus.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))
    var exitButton = ITIconButton(backgroundColor: .systemGray, image: (UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.white))

    var orbitPathButtonLeadingConstraint = NSLayoutConstraint()
    var zoomInButtonLeadingConstraint = NSLayoutConstraint()
    var zoomOutButtonLeadingConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startUpdating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        Map.mapView.removeFromSuperview()
        Map.mapView.delegate = nil
        Map.mapView.removeAnnotation(iconAnnotation)
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
        configureOrbitPathButton()
        configureZoomInButton()
        configureZoomOutButton()
        configureIconView()

        addBackgroundandForegroundObservers()
    }

    func addBackgroundandForegroundObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func willEnterForeground(){
        if !UserDefaultsManager.reduceAnimations { createPulseLayer() }
        let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
        Map.mapView.setRegion(region, animated: true)
        if isOrbitPathEnabled { updateOrbitPathOverlays()}
    }

    @objc func didEnterBackground(){
        clearPulseLayer()
    }

    @objc func clearPulseLayer(){
        pulseLayer.removeAllAnimations()
        pulseLayer.removeFromSuperlayer()
    }

    func configureIconView(){
        if Map.mapView.mapType == .satelliteFlyover {
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
        coordinatesView = ITCoordinatesView(title: "ISS Data", issLocationData: currentOrbitLocations[0])
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
        Map.mapView.mapType = .satelliteFlyover
        Map.mapView.translatesAutoresizingMaskIntoConstraints = false
        Map.mapView.delegate = self

        currentCoordinate = currentOrbitLocations.first!.getCoordinate()

        let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: CLLocationDistance(15000000), longitudinalMeters: CLLocationDistance(15000000))
        Map.mapView.setRegion(region, animated: true)

        iconAnnotation = MKPointAnnotation()
        iconAnnotation.coordinate = currentCoordinate

        Map.mapView.addAnnotation(iconAnnotation)

        if self.isOrbitPathEnabled { self.updateOrbitPathOverlays() }

        NSLayoutConstraint.activate([
            Map.mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            Map.mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            Map.mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            Map.mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        updateOrbitPathOverlays()
        switch Map.mapView.mapType {
        case .standard:
            Map.mapView.mapType = .satelliteFlyover
            iconView.set(image: Images.issIcon2!, with: .white)
        case .satelliteFlyover:
            Map.mapView.mapType = .standard
            iconView.set(image: Images.issIcon2!, with: .label)
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
        let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: CLLocationDistance(800000), longitudinalMeters: CLLocationDistance(800000))
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
        let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
        Map.mapView.setRegion(region, animated: true)
    }

    func configureOrbitPathButton(){
        view.addSubview(orbitPathButton)
        addActionToOrbitPathButton()

        orbitPathButtonLeadingConstraint = orbitPathButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            orbitPathButton.widthAnchor.constraint(equalToConstant: 45),
            orbitPathButton.heightAnchor.constraint(equalToConstant: 45),
            orbitPathButton.topAnchor.constraint(equalTo: showCoordinatesButton.bottomAnchor, constant: 10),
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

    /// Starts a timer that calls the updateMapView method every 1 seconds
    func startUpdating(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateMapView), userInfo: nil, repeats: true)
    }

    /// Dismisses the ViewController
    @objc func dismissVC(){
        dismiss(animated: true)
    }

    /// Uses the NetworkManager class to attempt to get the updated location of the ISS
    /// On success, the coordinates view is updated with the retrieved data, and the map view annotation is moved to the updated coordinates
    /// On failure, a custom alert is presented stating the error in question
    @objc func updateMapView() {

        let currentTime = Date()
        let currentOrbitEndTime = currentOrbitLocations.last!.timestamp.toDate()

        if currentTime > currentOrbitEndTime {
            getNewISSLocationsAndUpdateCurrentCoordinate(currentTime: currentTime)
        } else {
            calculateAndUpdateCurrentCoordinate(currentTime: currentTime)
        }
    }

    func getNewISSLocationsAndUpdateCurrentCoordinate(currentTime: Date) {
        NetworkManager.shared.getIssLocations(for: LocationCalculator.getTimestampsForCurrentOrbit()) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let issLocations):
                self.currentOrbitLocations = issLocations
                self.currentCoordinate = issLocations.first!.getCoordinate()
                DispatchQueue.main.async {
                    if self.isOrbitPathEnabled { self.updateOrbitPathOverlays() }
                    UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                        self.iconAnnotation.coordinate = self.currentCoordinate
                    }
                }
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func calculateAndUpdateCurrentCoordinate(currentTime: Date) {
        var intervalStartLocation: IssLocation!
        var intervalEndLocation: IssLocation!

        // Determine current location interval

        for i in 0..<currentOrbitLocations.count - 1 {
            let startTime = currentOrbitLocations[i].timestamp.toDate()
            let endTime = currentOrbitLocations[i+1].timestamp.toDate()

            if currentTime > startTime && currentTime < endTime {
                intervalStartLocation = currentOrbitLocations[i]
                intervalEndLocation = currentOrbitLocations[i + 1]
                break
            }
        }

        let intervalStartTime = intervalStartLocation.timestamp.toDate()
        let intervalEndTime = intervalEndLocation.timestamp.toDate()

        // Determine percent completion of the current time interval

        let percentCompletion = (currentTime - intervalStartTime) / (intervalEndTime - intervalStartTime)

        currentCoordinate = LocationCalculator.intermediateLocationBetween(startLocation: intervalStartLocation.getCoordinate(), endLocation: intervalEndLocation.getCoordinate(), percentFromStart: percentCompletion)

        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                self.iconAnnotation.coordinate = self.currentCoordinate
            }
        }
    }

    func updateOrbitPathOverlays(){
        var polylines = [MKGeodesicPolyline]()
        for i in 0..<currentOrbitLocations.count - 1 {
            let startCoordinate = currentOrbitLocations[i].getCoordinate()
            let endCoordinate = currentOrbitLocations[i + 1].getCoordinate()
            let polyline = MKGeodesicPolyline(coordinates: [startCoordinate, endCoordinate], count: 2)
            polylines.append(polyline)
        }
        DispatchQueue.main.async {
            Map.mapView.removeOverlays(Map.mapView.overlays)
            Map.mapView.addOverlays(polylines)
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
            pulseLayer.strokeColor = UIColor.systemIndigo.cgColor

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
            if pulseLayer.animationKeys() == nil && !UserDefaultsManager.reduceAnimations {
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
