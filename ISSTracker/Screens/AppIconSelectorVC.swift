//
//  AppIconSelectorVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/21/21.
//

import UIKit

class AppIconSelectorVC: UIViewController {

    var collectionView: UICollectionView!
    var icons = [Images.darkBlueIcon, Images.lightBlueIcon, Images.greenIcon, Images.redIcon, Images.yellowIcon, Images.orangeIcon, Images.purpleIcon, Images.whiteIcon, Images.blackIcon]
    var iconManager = IconManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureCollectionView()
    }

    func configureViewController(){
        title = "App Icon"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: HelpfulFunctions.createThreeColumnFlowLayout(in: view, itemHeightConstant: 0, hasHeaderView: false))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray6
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ITAppIconCell.self, forCellWithReuseIdentifier: ITAppIconCell.reuseID)
    }
}

extension AppIconSelectorVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ITAppIconCell.reuseID, for: indexPath) as! ITAppIconCell
        let image = icons[indexPath.item]
        cell.set(image: image!)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            UIApplication.shared.setAlternateIconName(nil)
        case 1:
            iconManager.changeAppIcon(to: .lightBlueIcon)
        case 2:
            iconManager.changeAppIcon(to: .greenIcon)
        case 3:
            iconManager.changeAppIcon(to: .redIcon)
        case 4:
            iconManager.changeAppIcon(to: .yellowIcon)
        case 5:
            iconManager.changeAppIcon(to: .orangeIcon)
        case 6:
            iconManager.changeAppIcon(to: .purpleIcon)
        case 7:
            iconManager.changeAppIcon(to: .whiteIcon)
        case 8:
            iconManager.changeAppIcon(to: .blackIcon)
        default:
            UIApplication.shared.setAlternateIconName(nil)
        }
    }
}
