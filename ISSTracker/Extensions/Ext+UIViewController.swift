//
//  Ext+UIViewController.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

extension UIViewController {
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String, settingsButtonNeeded: Bool? = nil){
        DispatchQueue.main.async {
            let alertVC = ITAlertVC(title: title, message: message, buttonTitle: buttonTitle, settingsButtonNeeded: settingsButtonNeeded)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
