//
//  MainTabBarVC.swift
//  ISSTracker
//
//  Created by Samuel McGarry on 2021. 10. 17..
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let trackISSVC = TrackISSVC()
        let searchImagesVC = UINavigationController(rootViewController: SearchImagesVC())
        let peopleInSpaceVC = UINavigationController(rootViewController: PeopleInSpaceVC())
        let settingsVC = UINavigationController(rootViewController: SettingsVC())
        
        let trackISSVCIcon = UITabBarItem(title: "Track", image: UIImage(systemName: "globe.americas"), selectedImage: UIImage(systemName: "globe.americas.fill"))
        let searchImagesVCIcon = UITabBarItem(title: "Image Search", image: UIImage(systemName: "photo.on.rectangle"), selectedImage: UIImage(systemName: "photo.on.rectangle.fill"))
        let peopleInSpaceVCIcon = UITabBarItem(title: "People", image: UIImage(systemName: "person.2"), selectedImage: UIImage(systemName: "person.2.fill"))
        let settingsVCIcon = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear.circle"), selectedImage: UIImage(named: "gear.circle.fill"))
        
        trackISSVC.tabBarItem = trackISSVCIcon
        searchImagesVC.tabBarItem = searchImagesVCIcon
        peopleInSpaceVC.tabBarItem = peopleInSpaceVCIcon
        settingsVC.tabBarItem = settingsVCIcon
        
        let controllers = [trackISSVC, searchImagesVC, peopleInSpaceVC, settingsVC]
        
        self.viewControllers = controllers
        self.tabBar.backgroundColor = .systemGray6
        self.tabBar.tintColor = .systemIndigo
    }

}

final class ITTabBarItem: UITabBarItem {

    override var title: String? {
        get { return nil }
        set { super.title = newValue }
    }

    override var imageInsets: UIEdgeInsets {
        get { return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
        set { super.imageInsets = newValue }
    }

    convenience init(image: UIImage? , selectedImage: UIImage?) {
        self.init()

        self.image = image
        self.selectedImage = image
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
