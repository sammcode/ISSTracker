//
//  PeopleInSpaceVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/13/21.
//

import UIKit
import SafariServices

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

    func addBackgroundandForegroundObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func willEnterForeground(){

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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: HelpfulFunctions.createTwoColumnFlowLayout(in: view, itemHeightConstant: 80, hasHeaderView: false))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ITAstronautCell.self, forCellWithReuseIdentifier: ITAstronautCell.reuseID)
    }
}

extension PeopleInSpaceVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peopleInSpace.people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITAstronautCell.reuseID, for: indexPath) as! ITAstronautCell
        let name = peopleInSpace.people[indexPath.row].name
        let astronaut = AstronautData.astronauts[name]
        cell.set(astronaut: astronaut!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = peopleInSpace.people[indexPath.row].name
        let astronaut = AstronautData.astronauts[name]
        let safariVC = SFSafariViewController(url: URL(string: astronaut!.biographyURL)!)
        safariVC.preferredControlTintColor = Colors.mainBlueYellow
        present(safariVC, animated: true)
    }
}
