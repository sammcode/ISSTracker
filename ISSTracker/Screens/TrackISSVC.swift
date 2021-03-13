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
    var mapView = MKMapView()

    var anno: MKPointAnnotation!
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startUpdating()
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    
    func configure(){
        configureViewController()
        configureCoordinatesView()
        configureMapView()
    }

    func configureViewController(){
        title = "Track ISS"
        view.backgroundColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

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

    func configureMapView(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self

        let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(Float(gpsLocation.issPosition.latitude)!), longitude: CLLocationDegrees(Float(gpsLocation.issPosition.longitude)!))
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(8000000), longitudinalMeters: CLLocationDistance(8000000))
        mapView.setRegion(region, animated: true)

        anno = MKPointAnnotation()
        anno.coordinate = coordinates
        mapView.addAnnotation(anno)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func startUpdating(){
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateMapView), userInfo: nil, repeats: true)
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }

    @objc func updateMapView() {
        NetworkManager.shared.getISSLocation { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let gps):

                DispatchQueue.main.async {
                    self.gpsLocation = gps

                    self.mapView.removeAnnotation(self.anno)

                    let coordinates = CLLocationCoordinate2D(latitude:  CLLocationDegrees(Float(self.gpsLocation.issPosition.latitude)!), longitude: CLLocationDegrees(Float(self.gpsLocation.issPosition.longitude)!))
                    self.anno = MKPointAnnotation()
                    self.anno.coordinate = coordinates

                    self.coordinatesView.latitudeLabel.text = "Latitude: " + self.gpsLocation.issPosition.latitude
                    self.coordinatesView.longitudeLabel.text = "Longitude: " + self.gpsLocation.issPosition.longitude
                    self.coordinatesView.timestampLabel.text = "Timestamp: " + self.gpsLocation.timestamp.convertTimestampToString()

                    self.mapView.addAnnotation(self.anno)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension TrackISSVC: MKMapViewDelegate {

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
        pinView?.image = Images.issIcon
        pinView!.frame.size = CGSize(width: 60, height: 60)
        return pinView
    }
}
