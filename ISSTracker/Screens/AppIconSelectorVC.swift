//
//  AppIconSelectorVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/21/21.
//

import UIKit

class AppIconSelectorVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
    }

    func configureViewController(){
        title = "App Icon"
        view.backgroundColor = .systemBackground

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]

        if UserDefaultsManager.appearance == 0 {
            overrideUserInterfaceStyle = .unspecified
            navigationController?.overrideUserInterfaceStyle = .unspecified
        } else if UserDefaultsManager.appearance == 1 {
            overrideUserInterfaceStyle = .light
            navigationController?.overrideUserInterfaceStyle = .light
        } else if UserDefaultsManager.appearance == 2 {
            overrideUserInterfaceStyle = .dark
            navigationController?.overrideUserInterfaceStyle = .dark
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
