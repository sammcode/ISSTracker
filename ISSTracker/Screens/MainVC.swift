//
//  MainVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit
import CoreLocation

class MainVC: ITDataLoadingVC {

    let imageData = [Images.iss8, Images.iss1, Images.iss2, Images.iss3, Images.iss4, Images.iss5, Images.iss6, Images.iss7, Images.iss8, Images.iss1]
    var userLocation: CLLocationCoordinate2D!

    var initalScroll = false
    var collectionView: UICollectionView!
    var locationManager = CLLocationManager()
    var imagesDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var buttonsStackView = UIStackView()

    var trackISSButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Track ISS")
    var trackISSDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var predictPassesButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Predict Pass Times")
    var predictPassesDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var peopleInSpaceButton = ITButton(backgroundColor: Colors.midnightBlue, title: "People In Space")
    var peopleInSpaceDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ISS Tracker🛰"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white

        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !self.initalScroll {
            self.initalScroll = true
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }

    func configure(){
        configureLocationManager()
        configureCollectionView()
        configureImagesDescriptionLabel()
        configureButtonDescriptionLabels()
        configureButtonConstraints()
        configureButtonsStackView()
    }

    func configureLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: createHorizontalFlowLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ITImageCell.self, forCellWithReuseIdentifier: ITImageCell.reuseID)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.15),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.42)
        ])
    }

    func configureImagesDescriptionLabel(){
        view.addSubview(imagesDescriptionLabel)
        NSLayoutConstraint.activate([
            imagesDescriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            imagesDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagesDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            imagesDescriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        imagesDescriptionLabel.text = "Recent photos from the ISS"
    }

    func configureButtonDescriptionLabels(){
        trackISSDescriptionLabel.text = "Track the current location of the International Space Station"
        predictPassesDescriptionLabel.text = "Predict times when the ISS will pass over your location"
        peopleInSpaceDescriptionLabel.text = "How many people are in space? Who are they?"
    }

    func configureButtonConstraints(){

        addActionToTrackISSButton()
        NSLayoutConstraint.activate([
            trackISSButton.heightAnchor.constraint(equalToConstant: 60),
            trackISSButton.widthAnchor.constraint(equalToConstant: 240)
        ])

        addActionToPredictPassesButton()
        NSLayoutConstraint.activate([
            predictPassesButton.heightAnchor.constraint(equalToConstant: 60),
            predictPassesButton.widthAnchor.constraint(equalToConstant: 240)
        ])

        addActionToPeopleInSpaceButton()
        NSLayoutConstraint.activate([
            peopleInSpaceButton.heightAnchor.constraint(equalToConstant: 60),
            peopleInSpaceButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }

    func configureButtonDescriptionLabelConstraints(){
        NSLayoutConstraint.activate([
            trackISSDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            trackISSDescriptionLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        trackISSDescriptionLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            predictPassesDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            predictPassesDescriptionLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        predictPassesDescriptionLabel.numberOfLines = 0
    }

    func configureButtonsStackView(){
        view.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.alignment = .center
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 10

        let height: CGFloat = (DeviceType.isiPhoneSE ? 140 : 240)

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: imagesDescriptionLabel.bottomAnchor, constant: view.bounds.height * 0.03),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            buttonsStackView.heightAnchor.constraint(equalToConstant: height)
        ])

        if DeviceType.isiPhoneSE {
            buttonsStackView.addArrangedSubviews(trackISSButton, predictPassesButton)
        }else{
            configureButtonDescriptionLabelConstraints()
            buttonsStackView.addArrangedSubviews(trackISSButton, trackISSDescriptionLabel, predictPassesButton, predictPassesDescriptionLabel)
        }
    }

    func createHorizontalFlowLayout() -> UICollectionViewFlowLayout{
        let width = view.bounds.width * 0.8
        let height = view.bounds.height * 0.3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }

    func addActionToTrackISSButton(){
        trackISSButton.addTarget(self, action: #selector(issButtonTapped), for: .touchUpInside)
    }

    @objc func issButtonTapped(){
        getISSLocation()
    }

    func addActionToPredictPassesButton(){
        predictPassesButton.addTarget(self, action: #selector(predictPassesButtonTapped), for: .touchUpInside)
    }

    @objc func predictPassesButtonTapped(){
        getPassTimes()
    }

    func addActionToPeopleInSpaceButton(){
        peopleInSpaceButton.addTarget(self, action: #selector(issButtonTapped), for: .touchUpInside)
    }

    @objc func peopleInSpaceButtonTapped(){
        let peopleInSpaceVC = PeopleInSpaceVC()
        let navController = UINavigationController(rootViewController: peopleInSpaceVC)

        self.present(navController, animated: true)
    }

    func getISSLocation() {
        showLoadingView()

        NetworkManager.shared.getISSLocation { [weak self] result in

            guard let self = self else { return }

            self.dismissLoadingView()

            switch result {
            case .success(let gpsLocation):
                DispatchQueue.main.async {
                    let trackISSVC = TrackISSVC()
                    trackISSVC.gpsLocation = gpsLocation
                    let navController = UINavigationController(rootViewController: trackISSVC)
                    self.present(navController, animated: true)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func getPassTimes(){
        if locationManager.authorizationStatus == .denied {
            self.presentGFAlertOnMainThread(title: "Oh no!", message: "Looks like you have location services disabled for this app. Please enable them in settings :)", buttonTitle: "Ok", settingsButtonNeeded: true)
            return
        }else if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        if locationManager.authorizationStatus == .authorizedWhenInUse {
            showLoadingView()

            NetworkManager.shared.getISSPasstimes(latitude: userLocation.latitude, longitude: userLocation.longitude) { [weak self] result in

                    guard let self = self else { return }

                    self.dismissLoadingView()

                    switch result {
                    case .success(let passes):
                        DispatchQueue.main.async {
                            let predictPassesVC = PredictPassesVC()
                            predictPassesVC.userLocation = self.userLocation
                            predictPassesVC.passTime = passes
                            let navController = UINavigationController(rootViewController: predictPassesVC)

                            self.present(navController, animated: true)
                        }
                    case .failure(let error):
                        self.presentGFAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
                    }
            }
        }
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITImageCell.reuseID, for: indexPath) as! ITImageCell

        let image = imageData[indexPath.row]

        DispatchQueue.main.async {
            cell.set(img: image!)
        }

        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentCellFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
        let currentCellInt = Int(round(currentCellFloat))

        switch currentCellInt {
        case 0:
            collectionView.scrollToItem(at: [0, 8], at:  .left, animated: false)
        case 7:
            collectionView.scrollToItem(at: [0, 1], at: .right, animated: false)
        default:
            break
        }
    }
    #warning("fix so that on scroll it goes to next/previous item, doesn't continue scrolling")
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coords: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocation = coords
    }
}
