//
//  PeopleInSpaceVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/13/21.
//

import UIKit
import SafariServices

class PeopleInSpaceVC: ITDataLoadingVC {

    var peopleInSpace: PeopleInSpace!

    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPeopleInSpace()
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
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 38)!]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: HelpfulFunctions.createColumnFlowLayout(in: view, itemHeightConstant: 135, hasHeaderView: false, columns: 2))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ITAstronautCell.self, forCellWithReuseIdentifier: ITAstronautCell.reuseID)
    }

    @objc func openAstronautBio(){
        let name = peopleInSpace.people[0].name
        let astronaut = AstronautData.astronauts[name]
        let safariVC = SFSafariViewController(url: URL(string: astronaut!.biographyURL)!)
        safariVC.preferredControlTintColor = UIColor.systemIndigo
        present(safariVC, animated: true)
    }
    
    @objc func getPeopleInSpace(){
        self.showLoadingView()
        NetworkManager.shared.getPeopleInSpace { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let peopleData):
                DispatchQueue.main.async {
                    self.peopleInSpace = peopleData
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                self.presentITAlertOnMainThread(title: "Oh no!", message: error.rawValue, buttonTitle: "Try again") {
                    self.getPeopleInSpace()
                }
            }
        }
    }
}

extension PeopleInSpaceVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let peopleInSpace = peopleInSpace else { return 0 }
        return peopleInSpace.people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITAstronautCell.reuseID, for: indexPath) as! ITAstronautCell
        let name = peopleInSpace.people[indexPath.row].name
        let astronaut = AstronautData.astronauts[name] ?? Astronaut(name: name, image: Images.iss1!, nationality: "", role: "", biographyURL: "")
        cell.set(astronaut: astronaut)
        cell.delegate = self
        return cell
    }
}

extension PeopleInSpaceVC: ITAstronautCellDelegate {
    func bioButtonTapped(_ cell: ITAstronautCell) {
        guard let index = collectionView.indexPath(for: cell)?.row else { return }
        let name = peopleInSpace.people[index].name
        let astronaut = AstronautData.astronauts[name]
        let safariVC = SFSafariViewController(url: URL(string: astronaut!.biographyURL)!)
        safariVC.preferredControlTintColor = UIColor.systemIndigo
        present(safariVC, animated: true)
    }
}
