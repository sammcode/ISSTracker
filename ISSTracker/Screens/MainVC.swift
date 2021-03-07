//
//  MainVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit

class MainVC: UIViewController {

    let imageData = [Images.iss8, Images.iss1, Images.iss2, Images.iss3, Images.iss4, Images.iss5, Images.iss6, Images.iss7, Images.iss8, Images.iss1]

    var initalScroll = false
    var collectionView: UICollectionView!
    var imagesDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var buttonsStackView = UIStackView()

    var trackISSButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Track ISS")
    var trackISSDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var predictPassesButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Track ISS")
    var predictPassesDescriptionLabel = ITDescriptionLabel(textAlignment: .center, fontSize: 14)

    var peopleInSpaceButton = ITButton(backgroundColor: Colors.midnightBlue, title: "Track ISS")


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ISSTracker🛰"
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
            collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.35)
        ])
    }

    func configureImagesDescriptionLabel(){
        view.addSubview(imagesDescriptionLabel)
        NSLayoutConstraint.activate([
            imagesDescriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            imagesDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imagesDescriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            imagesDescriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        imagesDescriptionLabel.text = "Recent Photos From the ISS"
    }

    func createHorizontalFlowLayout() -> UICollectionViewFlowLayout{
        let width = view.bounds.width * 0.7
        let height = view.bounds.height * 0.3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        return layout
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
}
