//
//  PredictPassesVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import CoreLocation

class PredictPassesVC: ITDataLoadingVC {

    var coordinatesView: ITCoordinatesView!
    var passTime: PassTime!
    var userLocation: CLLocationCoordinate2D!

    var locationManager = CLLocationManager()
    var stackView = UIStackView()

    var tableView = UITableView()

    let dateView1 = ITTimestampView()
    let dateView2 = ITTimestampView()
    let dateView3 = ITTimestampView()
    let dateView4 = ITTimestampView()
    let dateView5 = ITTimestampView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Predict Pass Times"
        view.backgroundColor = .white

        configure()
    }

    func configure(){
        //configureCoordinatesView()
        configureTableView()
        configureLocationManager()
    }

    func configureTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.9),
            tableView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])

        coordinatesView = ITCoordinatesView(title: "Your GPS Coordinates", latitude: "", longitude: "", timestamp: "")
        tableView.setTableHeaderView(headerView: coordinatesView)
    }

    func configureCoordinatesView(){
        coordinatesView = ITCoordinatesView(title: "Your GPS Coordinates", latitude: "", longitude: "", timestamp: "")
        view.addSubview(coordinatesView)

        NSLayoutConstraint.activate([
            coordinatesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coordinatesView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            coordinatesView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9),
            coordinatesView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    func configureStackView(){
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: 300),
            stackView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }




    func configureLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func getPassTimes(){
        //showLoadingView()

        NetworkManager.shared.getISSPasstimes(latitude: userLocation.latitude, longitude: userLocation.longitude) { [weak self] result in

                guard let self = self else { return }

                //self.dismissLoadingView()

                switch result {
                case .success(let passes):
                    self.passTime = passes
                    print(self.passTime.response[0].risetime)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
                }
        }
    }
}

extension PredictPassesVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coords: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocation = coords

        DispatchQueue.main.async {
            self.coordinatesView.latitudeLabel.text = "Latitude: \(Double(round(coords.latitude * 10000)/10000))"
            self.coordinatesView.longitudeLabel.text = "Longitude: \(Double(round(coords.longitude * 10000)/10000))"

            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM/dd/yy HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)


            self.coordinatesView.timestampLabel.text = "Timestamp: " + strDate

            self.getPassTimes()


//            for time in self.passTime.response {
//                let date = Date(timeIntervalSince1970: Double(time.risetime))
//
//                let dateFormatter = DateFormatter()
//
//                dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
//                dateFormatter.locale = NSLocale.current
//                dateFormatter.dateFormat = "MM/dd/yy" //Specify your format that you want
//                let strDay = dateFormatter.string(from: date)
//                dateFormatter.dateFormat = "HH:mm" //Specify your format that you want
//                let strTime = dateFormatter.string(from: date)
//                let v = ITTimestampView(day: strDay, time: strTime)
//
//                NSLayoutConstraint.activate([
//                    v.heightAnchor.constraint(equalToConstant: 60),
//                    v.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.9)
//                ])
//
//                self.stackView.addArrangedSubview(v)
//            }


        }
        //getISSPasstimes(latitude: coords.latitude, longitude: coords.longitude)
    }
}

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setTableHeaderView(headerView: UIView) {
            headerView.translatesAutoresizingMaskIntoConstraints = false

            self.tableHeaderView = headerView

            // ** Must setup AutoLayout after set tableHeaderView.
            headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        }
}
