//
//  PeopleInSpaceVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/13/21.
//

import UIKit

class PeopleInSpaceVC: UIViewController {

    var peopleInSpace: PeopleInSpace!

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure(){
        configureViewController()
        configureCollectionView()
    }

    func configureViewController(){
        title = "People In Space"
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: HelpfulFunctions.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AstronautCell.self, forCellWithReuseIdentifier: AstronautCell.reuseID)
        collectionView.register(ITNumberOfPeopleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ITNumberOfPeopleView.reuseID)
    }
}

extension PeopleInSpaceVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peopleInSpace.people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AstronautCell.reuseID, for: indexPath) as! AstronautCell
        let name = peopleInSpace.people[indexPath.row].name
        let image = Astronauts.portraits[name] ?? Images.iss7
        cell.set(name: name, image: image!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ITNumberOfPeopleView.reuseID, for: indexPath as IndexPath) as! ITNumberOfPeopleView

        headerView.set(number: peopleInSpace.number)

        headerView.frame.size.height = 160

        return headerView
    }
}
