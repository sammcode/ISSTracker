//
//  TrackISSVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import MapKit

class TrackISSVC: UIViewController {

    var issLocation: IssLocation!
    var coordinatesView: ITCoordinatesView!

    var anno: MKPointAnnotation!
    var timer: Timer!

    var viewOffset: CGFloat = 260
    var coordinatesViewBottomConstraint = NSLayoutConstraint()

    var iconView = MKAnnotationView()

    var pulseLayer = CAShapeLayer()
    var isPulseActive = true

    var isTrackingModeEnabled = false

    let iconWidth = UserDefaultsManager.largeMapAnnotations ? 90 : 60
    let iconHeight = UserDefaultsManager.largeMapAnnotations ? 60 : 40

    var mapTypeButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var showCoordinatesButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "note.text", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var pulseButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "target", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var zoomInButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "plus.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var zoomOutButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "minus.magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))
    var trackingModeButton = ITIconButton(backgroundColor: Colors.mainBlueYellow, image: (UIImage(systemName: "binoculars", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal))!.withTintColor(.systemBackground))

    var trackingModeLabel = ITPaddingLabel(withInsets: 2, 2, 2, 2)
    var trackingModeLabelTopConstraint = NSLayoutConstraint()
    var trackingModeLabelOffset: CGFloat = -100

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startUpdating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        Map.mapView.removeFromSuperview()
        Map.mapView.delegate = nil
        Map.mapView.removeAnnotation(anno)
    }

    /// Calls all configuration methods for the ViewController
    func configure(){
        configureViewController()
        configureMapView()
        configureCoordinatesView()
        configurePulseButton()
        configureMapTypeButton()
        configureShowCoordinatesButton()
        configureZoomInButton()
        configureZoomOutButton()
        configureTrackingModeButton()
        configureIconView()

        configureTrackingModeLabel()

        addBackgroundandForegroundObservers()
    }

    func addBackgroundandForegroundObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(clearPulseLayer), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(createPulseLayer), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(clearPulseLayer), name: UIApplication.willResignActiveNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(createPulseLayer), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func clearPulseLayer(){
        pulseLayer.removeAllAnimations()
        pulseLayer.removeFromSuperlayer()
    }

    func configureIconView(){
        iconView.set(image: Images.issIcon2!, with: .label)
        iconView.frame.size = CGSize(width: iconWidth, height: iconHeight)
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.5
        iconView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        iconView.layer.shadowRadius = 5
        createPulse(in: iconView)
    }

    /// Configures properties for the ViewController
    func configureViewController(){
        title = "Track ISS"
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
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
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
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
    }

    func configurePulseButton(){
        view.addSubview(pulseButton)
        addActionToPulseButton()
        NSLayoutConstraint.activate([
            pulseButton.widthAnchor.constraint(equalToConstant: 45),
            pulseButton.heightAnchor.constraint(equalToConstant: 45),
            pulseButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10),
            pulseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    func addActionToPulseButton() {
        pulseButton.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
    }

    @objc
    func pulseButtonTapped() {
        pulseButton.pulsate()
        switch isPulseActive {
        case true:
            clearPulseLayer()
            isPulseActive.toggle()
        case false:
            createPulseLayer()
            isPulseActive.toggle()
        }
    }

    func configureMapTypeButton(){
        view.addSubview(mapTypeButton)
        addActionToMapTypeButton()
        NSLayoutConstraint.activate([
            mapTypeButton.widthAnchor.constraint(equalToConstant: 45),
            mapTypeButton.heightAnchor.constraint(equalToConstant: 45),
            mapTypeButton.leadingAnchor.constraint(equalTo: Map.mapView.leadingAnchor, constant: 10),
            mapTypeButton.topAnchor.constraint(equalTo: pulseButton.bottomAnchor, constant: 10)
        ])
    }

    func addActionToMapTypeButton() {
        mapTypeButton.addTarget(self, action: #selector(mapTypeButtonTapped), for: .touchUpInside)
    }

    @objc
    func mapTypeButtonTapped() {
        mapTypeButton.pulsate()
        switch Map.mapView.mapType {
        case .standard:
            Map.mapView.mapType = .hybrid
            iconView.set(image: Images.issIcon2!, with: .white)
            iconView.frame.size = CGSize(width: iconWidth, height: iconHeight)
        case .hybrid:
            Map.mapView.mapType = .standard
            iconView.set(image: Images.issIcon2!, with: .label)
            iconView.frame.size = CGSize(width: iconWidth, height: iconHeight)
        default:
            Map.mapView.mapType = .standard
        }
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
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        case 260:
            self.viewOffset = 20
            coordinatesViewBottomConstraint.constant = viewOffset
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        default:
            self.viewOffset = 260
            coordinatesViewBottomConstraint.constant = viewOffset
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    func configureZoomInButton(){
        view.addSubview(zoomInButton)
        addActionToZoomInButton()
        NSLayoutConstraint.activate([
            zoomInButton.widthAnchor.constraint(equalToConstant: 45),
            zoomInButton.heightAnchor.constraint(equalToConstant: 45),
            zoomInButton.trailingAnchor.constraint(equalTo: Map.mapView.trailingAnchor, constant: -10),
            zoomInButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
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

        NSLayoutConstraint.activate([
            zoomOutButton.widthAnchor.constraint(equalToConstant: 45),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 45),
            zoomOutButton.trailingAnchor.constraint(equalTo: Map.mapView.trailingAnchor, constant: -10),
            zoomOutButton.topAnchor.constraint(equalTo: zoomInButton.bottomAnchor, constant: 10)
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
            trackingModeButton.topAnchor.constraint(equalTo: showCoordinatesButton.bottomAnchor, constant: 10)
        ])
    }

    func addActionToTrackingModeButton() {
        trackingModeButton.addTarget(self, action: #selector(trackingModeButtonTapped), for: .touchUpInside)
    }

    @objc
    func trackingModeButtonTapped(){
        trackingModeButton.pulsate()
        isTrackingModeEnabled.toggle()

        switch trackingModeLabelOffset {
        case 10:
            self.trackingModeLabelOffset = -100
            trackingModeLabelTopConstraint.constant = trackingModeLabelOffset
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        case -100:
            self.trackingModeLabelOffset = 10
            trackingModeLabelTopConstraint.constant = trackingModeLabelOffset
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        default:
            self.viewOffset = -100
            trackingModeLabelTopConstraint.constant = trackingModeLabelOffset
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }

        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.issLocation.latitude), longitude: CLLocationDegrees(self.issLocation.longitude))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(60000), longitudinalMeters: CLLocationDistance(60000))
        Map.mapView.setRegion(region, animated: true)
    }

    func configureTrackingModeLabel(){
        view.addSubview(trackingModeLabel)
        trackingModeLabel.translatesAutoresizingMaskIntoConstraints = false
        trackingModeLabel.backgroundColor = .systemGreen
        trackingModeLabel.textColor = Colors.whiteBlack
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

    /// Starts a timer that calls the updateMapView method every 5 seconds
    func startUpdating(){
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateMapView), userInfo: nil, repeats: true)
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
                DispatchQueue.main.async {
                    self.issLocation = iss

                    let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.issLocation.latitude), longitude: CLLocationDegrees(self.issLocation.longitude))



                    UIView.animate(withDuration: 10, delay: 0, options: .curveLinear) {
                        self.anno.coordinate = coordinates
                    }

                    if self.isTrackingModeEnabled {
                        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(60000), longitudinalMeters: CLLocationDistance(60000))
                        Map.mapView.animatedZoom(zoomRegion: region, duration: 10)
                    }

                    self.coordinatesView.issLocation = self.issLocation
                }
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
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
            pulseLayer.strokeColor = Colors.mainBlueYellow.cgColor

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
            if pulseLayer.animationKeys() == nil && isPulseActive {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.createPulse(in: self.iconView)
                }
            }
        }
    }
}

extension MKMapView {
    func animatedZoom(zoomRegion:MKCoordinateRegion, duration:TimeInterval) {
        MKMapView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.setRegion(zoomRegion, animated: true)
            }, completion: nil)
    }
}
