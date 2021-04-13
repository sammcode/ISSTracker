//
//  Constants.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit
import MapKit

enum Images {
    static let issIcon = UIImage(named: "ISSIcon")
    static let iss1 = UIImage(named: "ISS1")
    static let iss2 = UIImage(named: "ISS2")
    static let iss3 = UIImage(named: "ISS3")
    static let iss4 = UIImage(named: "ISS4")
    static let iss5 = UIImage(named: "ISS5")
    static let iss6 = UIImage(named: "ISS6")
    static let iss7 = UIImage(named: "ISS7")
    static let iss8 = UIImage(named: "ISS8")
}

enum Colors {
    static let midnightBlue = UIColor(red: 0, green: 0.161, blue: 0.42, alpha: 1)
    static let darkBlue = UIColor(red: 0, green: 0.314, blue: 0.616, alpha: 1)
    static let calmBlue = UIColor(red: 0, green: 0.247, blue: 0.533, alpha: 1)
    static let darkGray = UIColor(red: 0.338, green: 0.3, blue: 0.3, alpha: 1)
    static let deepYellow = UIColor(red: 1, green: 0.835, blue: 0, alpha: 1)
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceType {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale

    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .phone && ScreenSize.maxLength == 1024.0

    static func isiPhoneXAspectRation() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}

enum DF {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateFormat = "HH:mm MM/dd"
        return formatter
    }()
}

enum Map {
    static let mapView = MKMapView()
}

enum Constants {
    static var favoritesCount = 0
}
