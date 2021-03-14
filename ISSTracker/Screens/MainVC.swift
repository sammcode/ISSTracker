//
//  MainVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit
import CoreLocation

class MainVC: ITDataLoadingVC {

    /// Creates an array of images to be used in the collection view
    /// The array begins with an instance of the last image to be shown, and ends with an instance of the first image to be shown
    /// This helps create the perception that there are an infinite loop of images
    let imageData = [Images.iss8, Images.iss1, Images.iss2, Images.iss3, Images.iss4, Images.iss5, Images.iss6, Images.iss7, Images.iss8, Images.iss1]

    var initalScroll = false
    var collectionView: UICollectionView!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D(latitude: 45.570195, longitude: -122.825434)

    var imagesDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var buttonsStackView = UIStackView()

    var trackISSButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Track ISS")
    var trackISSDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var predictPassesButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Predict Pass Times")
    var predictPassesDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.initalScroll {
            self.initalScroll = true
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
    }

    /// Calls all configuration methods for the ViewController
    func configure(){
        configureViewController()
        configureLocationManager()
        configureCollectionView()
        configureImagesDescriptionLabel()
        configureButtons()
        configureButtonsStackView()
    }

    /// Configures properties for the ViewController
    func configureViewController(){
        title = "ISS Tracker"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white

        let infoButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(infoButtonTapped))
        navigationItem.rightBarButtonItem = infoButton
    }


    /// Requests authorization for accessing users location; if granted access, sets properties for location manager, starts updating the users current location
    func configureLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    /// Configures the collection view, sets properties, registers the custom cell to be used, constrains the collection view to the top half of the view
    func configureCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: HelpfulFunctions.createHorizontalFlowLayout())
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


    /// Configures the image description label, constrains it to the bottom of the collection view
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

    /// Configures the button description labels, constrains them to the bottom of their respective buttons
    func configureButtonDescriptionLabels(){
        NSLayoutConstraint.activate([
            trackISSDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            trackISSDescriptionLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        trackISSDescriptionLabel.numberOfLines = 0
        trackISSDescriptionLabel.text = "Track the current location of the International Space Station"

        NSLayoutConstraint.activate([
            predictPassesDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            predictPassesDescriptionLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        predictPassesDescriptionLabel.numberOfLines = 0
        predictPassesDescriptionLabel.text = "Predict times when the ISS will pass over your location"
    }

    /// Adds actions to the buttons, sets the width and height for both of them
    func configureButtons(){
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
    }

    /// Configures the stackview properties, constrains it to the bottom of the image description label
    /// If the current device is a 1st generation iPhone SE, the height is set accordingly and the button description labels aren't added to the stackview, as they take up too much space
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
            configureButtonDescriptionLabels()
            buttonsStackView.addArrangedSubviews(trackISSButton, trackISSDescriptionLabel, predictPassesButton, predictPassesDescriptionLabel)
        }
    }

    /// Adds the getISSLocation method to the trackISSButton, for the touchUpInside action
    func addActionToTrackISSButton(){
        trackISSButton.addTarget(self, action: #selector(getISSLocation), for: .touchUpInside)
    }

    /// Adds the getPassTimes method the the predictPassesButton, for the touchUpInside action
    func addActionToPredictPassesButton(){
        predictPassesButton.addTarget(self, action: #selector(getPassTimes), for: .touchUpInside)
    }

    /// Uses the NetworkManager class to get the current location of the ISS
    /// On success, an instance of the TrackISSVC ViewController is presented with the retrieved data
    /// On failure, a custom alert is presented stating the error in question
    @objc func getISSLocation() {
        //showLoadingView()

        NetworkManager.shared.getISSLocation { [weak self] result in

            guard let self = self else { return }

            //self.dismissLoadingView()

            switch result {
            case .success(let gpsLocation):
                DispatchQueue.main.async {
                    let trackISSVC = TrackISSVC()
                    trackISSVC.gpsLocation = gpsLocation
                    let navController = UINavigationController(rootViewController: trackISSVC)
                    self.present(navController, animated: true)
                }
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    /// Uses the NetworkManager class to get predicted pass times based on the user's location
    /// If location authorization has been denied, a custom alert is presented prompting the user to adjust their settings
    /// If location authorization has not been determined, the location manager requests for authorization from the user
    /// If location authorization is allowed by the user when the app is in use, the NetworkManager class attempts to retrieve the data
    /// On success, an instance of PredictPassesVC ViewController is presented with the retrieved data
    /// On failure, a custom alert is presented stating the error in question
    @objc func getPassTimes(){
        if locationManager.authorizationStatus == .denied {
            self.presentITAlertOnMainThread(title: "Oh no!", message: "Looks like you have location services disabled for this app. Please enable them in settings :)", buttonTitle: "Ok", settingsButtonNeeded: true)
            return
        }else if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        if locationManager.authorizationStatus == .authorizedWhenInUse {
            //showLoadingView()

            NetworkManager.shared.getISSPasstimes(latitude: userLocation.latitude, longitude: userLocation.longitude) { [weak self] result in

                    guard let self = self else { return }

                    //self.dismissLoadingView()

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
                        self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Ok")
                    }
                #warning("Add coordinates view to custom alert")
            }
        }
    }

    @objc func infoButtonTapped(){
        let infoVC = InfoVC()
        let navController = UINavigationController(rootViewController: infoVC)
        self.present(navController, animated: true)
    }
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /// Returns the number of items in the collection view section, which is set to the number of images in the imageData array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }

    /// Returns the custom collection view cell to be used, and sets the image based on the indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITImageCell.reuseID, for: indexPath) as! ITImageCell
        let image = imageData[indexPath.row]
        cell.set(img: image!)
        return cell
    }

    /// Returns the edge insets for the collection view section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    /// When the scroll view stops decelerating, the current cell is calculated by dividing the scroll view contentOffset by the scroll view width
    /// If the current cell int (index) is 0, the scroll view scrolls to the last item in the array
    /// If the current cell int (index) is 7, the scroll view scrolls to the second item in the array (which appears to be the first)
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
}

extension MainVC: CLLocationManagerDelegate {

    /// When the user's location is updated, the new coordinates are assigned to the userLocation variable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coords: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocation = coords
    }
}
