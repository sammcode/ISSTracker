//
//  MainTabBarVC.swift
//  ISSTracker
//
//  Created by Samuel McGarry on 2021. 10. 16..
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let trackISSVC = TrackISSVC()
        let searchImagesVC = SearchImagesVC()
        let peopleInSpaceVC = PeopleInSpaceVC()
        let settingsVC = SettingsVC()
        
        let trackISSVCIcon = UITabBarItem(title: "Track", image: UIImage(systemName: "globe.americas"), selectedImage: UIImage(systemName: "globe.americas.fill"))
        let searchImagesVCIcon = UITabBarItem(title: "Images", image: UIImage(systemName: "photo.on.rectangle"), selectedImage: UIImage(systemName: "photo.on.rectangle.fill"))
        let peopleInSpaceVCIcon = UITabBarItem(title: "People", image: UIImage(systemName: "person.2"), selectedImage: UIImage(systemName: "person.2.fill"))
        let settingsVCIcon = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear.circle"), selectedImage: UIImage(named: "gear.circle.fill"))
        
        trackISSVC.tabBarItem = trackISSVCIcon
        searchImagesVC.tabBarItem = searchImagesVCIcon
        peopleInSpaceVC.tabBarItem = peopleInSpaceVCIcon
        settingsVC.tabBarItem = settingsVCIcon
        
        let controllers = [trackISSVC, searchImagesVC, peopleInSpaceVC, settingsVC]
        
        self.viewControllers = controllers
    }

}
