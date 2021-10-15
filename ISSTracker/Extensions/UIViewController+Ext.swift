//
//  UIViewController+Ext.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import UIKit

extension UIViewController {
    /// Presents an ITAlertVC on the main thread, displaying a custom message to the user
    /// - Parameters:
    ///   - title: Title of the error message to be displayed
    ///   - message: The custom error message displayed to the user
    ///   - buttonTitle: Title of the button that is on the custom alert
    ///   - settingsButtonNeeded: Bool that indicates whether or not the alert should have a button that deep links to the settings for the app
    func presentITAlertOnMainThread(title: String, message: String, buttonTitle: String, isLongMessage: Bool? = nil){
        DispatchQueue.main.async {
            let alertVC = ITAlertVC(title: title, message: message, buttonTitle: buttonTitle, isLongMessage: isLongMessage)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
