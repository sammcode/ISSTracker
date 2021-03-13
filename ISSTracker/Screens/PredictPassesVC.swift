//
//  PredictPassesVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit
import CoreLocation

class PredictPassesVC: UIViewController {

    var coordinatesView: ITCoordinatesView!
    var passTime: PassTime!
    var userLocation: CLLocationCoordinate2D!

    var stackView = UIStackView()
    var tableView = UITableView()
    var dataHasBeenSet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure(){
        configureViewController()
        configureTableView()
    }

    func configureViewController(){
        title = "Predict Pass Times"
        view.backgroundColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    func configureTableView(){
        view.addSubview(tableView)
        tableView.register(ITPredictedTimeCell.self, forCellReuseIdentifier: ITPredictedTimeCell.reuseID)
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 10, right: 0)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.heightAnchor.constraint(equalToConstant: view.bounds.height),
            tableView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9)
        ])
    }

    func configureCoordinatesView(){

        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yy HH:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)

        coordinatesView = ITCoordinatesView(title: "Your GPS Coordinates", latitude: "\(Double(round(userLocation.latitude * 10000)/10000))", longitude: "\(Double(round(userLocation.longitude * 10000)/10000))", timestamp: strDate)
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

    @objc func dismissVC(){
        dismiss(animated: true)
    }

    func getPassTimes(){
        //showLoadingView()

        NetworkManager.shared.getISSPasstimes(latitude: userLocation.latitude, longitude: userLocation.longitude) { [weak self] result in

                guard let self = self else { return }

                //self.dismissLoadingView()

                switch result {
                case .success(let passes):
                    self.passTime = passes
                    self.dataHasBeenSet = true
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.configure()
                    }

                    print(self.passTime.response[0].risetime)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
                }
        }
    }
}

extension PredictPassesVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITPredictedTimeCell.reuseID) as! ITPredictedTimeCell
        let timestamp = passTime.response[indexPath.row].risetime
        cell.set(timestamp: timestamp)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.9, height: 195))
        returnedView.backgroundColor = .white

        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let strDate = dateFormatter.string(from: date)

        let coordinatesView = ITCoordinatesView(title: "Your GPS Coordinates", latitude: "\(Double(round(userLocation.latitude * 10000)/10000))", longitude: "\(Double(round(userLocation.longitude * 10000)/10000))", timestamp: strDate)
        returnedView.addSubview(coordinatesView)

        NSLayoutConstraint.activate([
            coordinatesView.centerXAnchor.constraint(equalTo: returnedView.centerXAnchor),
            coordinatesView.topAnchor.constraint(equalTo: returnedView.topAnchor),
            coordinatesView.widthAnchor.constraint(equalToConstant: returnedView.bounds.width),
            coordinatesView.heightAnchor.constraint(equalToConstant: 150)
        ])

        let label = ITTitleLabel(textAlignment: .left, fontSize: 24)

        returnedView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: returnedView.centerXAnchor),
            label.topAnchor.constraint(equalTo: coordinatesView.bottomAnchor, constant: 12),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.widthAnchor.constraint(equalTo: returnedView.widthAnchor)
        ])



        label.textColor = Colors.darkGray
        label.text = "Next 5 Predictions"


        return returnedView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 195
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
