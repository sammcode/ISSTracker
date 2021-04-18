//
//  TrackISSVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import MapKit

class TrackISSVC: UIViewController {

    var gpsLocation: GPSLocation!
    var coordinatesView: ITCoordinatesView!
    var descriptionLabel: ITDescriptionLabel!

    var anno: MKPointAnnotation!
    var timer: Timer!

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
        configureCoordinatesView()
        configureDescriptionLabel()
        configureMapView()
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
        coordinatesView = ITCoordinatesView(title: "ISS GPS Coordinates", latitude: gpsLocation.issPosition.latitude, longitude: gpsLocation.issPosition.longitude, timestamp: gpsLocation.timestamp.convertTimestampToString())
        view.addSubview(coordinatesView)
        NSLayoutConstraint.activate([
            coordinatesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coordinatesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            coordinatesView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            coordinatesView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    /// Configures the properties for the description label for the coordinates view
    /// Constrains it to the bottom of the coordinates view
    func configureDescriptionLabel(){
        descriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 18)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "ISS location updated every 5 seconds."
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30)
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

        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(gpsLocation.issPosition.latitude)!), longitude: CLLocationDegrees(Float(gpsLocation.issPosition.longitude)!))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
        Map.mapView.setRegion(region, animated: true)

        anno = MKPointAnnotation()
        anno.coordinate = coordinates

        Map.mapView.addAnnotation(anno)

        NSLayoutConstraint.activate([
            Map.mapView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            Map.mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            Map.mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            Map.mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// Starts a timer that calls the updateMapView method every 5 seconds
    func startUpdating(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateMapView), userInfo: nil, repeats: true)
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
            case .success(let gps):
                DispatchQueue.main.async {
                    self.gpsLocation = gps

                    let coordinates = CLLocationCoordinate2D(latitude:  CLLocationDegrees(Float(self.gpsLocation.issPosition.latitude)!), longitude: CLLocationDegrees(Float(self.gpsLocation.issPosition.longitude)!))

                    UIView.animate(withDuration: 0.3) {
                        self.anno.coordinate = coordinates
                    }

                    self.coordinatesView.latitudeLabel.text = "Latitude: " + self.gpsLocation.issPosition.latitude
                    self.coordinatesView.longitudeLabel.text = "Longitude: " + self.gpsLocation.issPosition.longitude
                    self.coordinatesView.timestampLabel.text = "Timestamp: " + self.gpsLocation.timestamp.convertTimestampToString()

                }
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension TrackISSVC: MKMapViewDelegate {

    /// Returns the custom MKAnnotationView for map view annotations, which is set to the ISS icon image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if(pinView == nil) {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
        }

        pinView?.set(image: Images.issIcon2!, with: .label)
        pinView!.frame.size = CGSize(width: 75, height: 50)

        return pinView
    }
}
