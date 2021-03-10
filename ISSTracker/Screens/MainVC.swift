//
//  MainVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit

class MainVC: ITDataLoadingVC {

    let imageData = [Images.iss8, Images.iss1, Images.iss2, Images.iss3, Images.iss4, Images.iss5, Images.iss6, Images.iss7, Images.iss8, Images.iss1]

    var initalScroll = false
    var collectionView: UICollectionView!
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
        configureCollectionView()
        configureImagesDescriptionLabel()
        configureButtonDescriptionLabels()
        configureButtonConstraints()
        configureButtonsStackView()
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
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.38)
        ])
    }

    func configureImagesDescriptionLabel(){
        view.addSubview(imagesDescriptionLabel)
        NSLayoutConstraint.activate([
            imagesDescriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            imagesDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagesDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            imagesDescriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        imagesDescriptionLabel.text = "Recent photos from the ISS"
    }

    func configureButtonDescriptionLabels(){
        trackISSDescriptionLabel.text = "Track the current location of the ISS"
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

        NSLayoutConstraint.activate([
            predictPassesDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            predictPassesDescriptionLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        predictPassesDescriptionLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            peopleInSpaceDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            peopleInSpaceDescriptionLabel.widthAnchor.constraint(equalToConstant: 240)
        ])
        peopleInSpaceDescriptionLabel.numberOfLines = 0
    }

    func configureButtonsStackView(){
        view.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.alignment = .center
        buttonsStackView.axis = .vertical

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: imagesDescriptionLabel.bottomAnchor, constant: 40),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
        ])

        if DeviceType.isiPhone8Standard {
            buttonsStackView.addArrangedSubviews(trackISSButton, predictPassesButton, peopleInSpaceButton)
        }else{
            configureButtonDescriptionLabelConstraints()
            buttonsStackView.addArrangedSubviews(trackISSButton, trackISSDescriptionLabel, predictPassesButton, predictPassesDescriptionLabel, peopleInSpaceButton, peopleInSpaceDescriptionLabel)
        }
    }

    func createHorizontalFlowLayout() -> UICollectionViewFlowLayout{
        let width = view.bounds.width * 0.7
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
        let predictPassesVC = PredictPassesVC()
        let navController = UINavigationController(rootViewController: predictPassesVC)

        self.present(navController, animated: true)
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
                print(gpsLocation.timestamp)
                print(gpsLocation.issPosition.longitude)
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
}

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITImageCell.reuseID, for: indexPath) as! ITImageCell

        let image = imageData[indexPath.row]

        cell.set(img: image!)

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
        case 6:
            collectionView.scrollToItem(at: [0, 1], at: .right, animated: false)
        default:
            break
        }
    }

    #warning("fix so that on scroll it goes to next/previous item, doesn't continue scrolling")
}
