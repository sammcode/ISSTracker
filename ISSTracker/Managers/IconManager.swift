//
//  IconManager.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/26/21.
//

import UIKit

class IconManager {
    let application = UIApplication.shared

        // same naming convention in the plist to reference to actual files
        enum AppIcon: String {
            case lightBlueIcon
            case redIcon
            case orangeIcon
            case yellowIcon
            case purpleIcon
            case greenIcon
            case whiteIcon
            case blackIcon
        }

        func changeAppIcon(to appIcon: AppIcon) {
            application.setAlternateIconName(appIcon.rawValue)
        }
}
