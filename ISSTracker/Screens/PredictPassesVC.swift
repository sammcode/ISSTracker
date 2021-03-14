//
//  PredictPassesVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import CoreLocation

class PredictPassesVC: UIViewController {

    var passTime: PassTime!
    var userLocation: CLLocationCoordinate2D!

    var tableView = UITableView()
    var dataHasBeenSet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    /// Calls all configuration methods for the ViewController
    func configure(){
        configureViewController()
        configureTableView()
    }

    /// Configures properties for the ViewController
    func configureViewController(){
        title = "Predict Pass Times"
        view.backgroundColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }


    /// Configures table view properties
    /// Registers the ITPredictedTimeCell for use in the table view
    /// Constraints it to the view
    func configureTableView(){
        view.addSubview(tableView)
        tableView.register(ITPredictedTimeCell.self, forCellReuseIdentifier: ITPredictedTimeCell.reuseID)
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 10, right: 0)
        tableView.allowsSelection = false
        tableView.removeExcessCells()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
        createAndSetTableHeaderView()
    }

    /// Creates and sets a custom header view for the table view section
    /// The created view is a container view that has an ITCoordinatesView displaying the user's current location,
    /// an ITLabel that acts a table view section title, and an ITDescriptionLabel that acts a section subtitle
    func createAndSetTableHeaderView(){
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.9, height: 210))
        containerView.backgroundColor = .white

        let coordinatesView = ITCoordinatesView(title: "Your GPS Coordinates", latitude: "\(Double(round(userLocation.latitude * 10000)/10000))", longitude: "\(Double(round(userLocation.longitude * 10000)/10000))", timestamp: Date().convertTimestampToString())
        containerView.addSubview(coordinatesView)
        NSLayoutConstraint.activate([
            coordinatesView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            coordinatesView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coordinatesView.widthAnchor.constraint(equalToConstant: containerView.bounds.width),
            coordinatesView.heightAnchor.constraint(equalToConstant: 150)
        ])

        let titleLabel = ITTitleLabel(textAlignment: .left, fontSize: 24)
        titleLabel.textColor = Colors.darkGray
        titleLabel.text = "Next 5 Predictions"
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 12),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])

        let bodyLabel = ITDescriptionLabel(textAlignment: .left, fontSize: 18)
        bodyLabel.textColor = Colors.calmBlue
        bodyLabel.text = "When the ISS will pass over your location"
        containerView.addSubview(bodyLabel)
        NSLayoutConstraint.activate([
            bodyLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.heightAnchor.constraint(equalToConstant: 20),
            bodyLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])

        tableView.tableHeaderView = containerView
    }

    /// Dismisses the ViewController
    @objc func dismissVC(){
        dismiss(animated: true)
    }
}

extension PredictPassesVC: UITableViewDelegate, UITableViewDataSource {

    /// Returns the number of rows in the table view section, which is set to 5; the number of returned pass time predictions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    /// Returns the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// Returns the  custom table view cell to be used, and assigns the risetime and duration data from the response array (within the passTime variable) based on the current index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITPredictedTimeCell.reuseID) as! ITPredictedTimeCell
        let risetime = passTime.response[indexPath.row].risetime
        let duration = passTime.response[indexPath.row].duration
        cell.set(risetime: risetime, duration: duration)
        return cell
    }

    ///Returns the height for the table view header, which is set to a pre-determined constant
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 225
    }
}
