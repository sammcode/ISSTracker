//
//  Constants.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit
import MapKit
import AVFoundation

enum Images {
    static let issIcon = UIImage(named: "ISSIcon")
    static let issIcon2 = UIImage(named: "ISSIcon2")
    static let iss1 = UIImage(named: "ISS1")
    static let iss2 = UIImage(named: "ISS2")
    static let iss3 = UIImage(named: "ISS3")
    static let iss4 = UIImage(named: "ISS4")
    static let iss5 = UIImage(named: "ISS5")
    static let iss6 = UIImage(named: "ISS6")
    static let iss7 = UIImage(named: "ISS7")
    static let iss8 = UIImage(named: "ISS8")
    static let soyuz = UIImage(named: "Soyuz")
    static let crewDragon = UIImage(named: "CrewDragon")
}

enum Colors {
    static let midnightBlue = UIColor(red: 0, green: 0.161, blue: 0.42, alpha: 1)
    static let darkBlue = UIColor(red: 0, green: 0.314, blue: 0.616, alpha: 1)
    static let calmBlue = UIColor(red: 0, green: 0.247, blue: 0.533, alpha: 1)
    static let darkGray = UIColor(red: 0.338, green: 0.3, blue: 0.3, alpha: 1)
    static let deepYellow = UIColor(red: 1, green: 0.835, blue: 0, alpha: 1)

    static let mainBlueYellow = UIColor(named: "MainBlueYellow") ?? Colors.midnightBlue
    static let mainYellowBlue = UIColor(named: "MainYellowBlue") ?? Colors.deepYellow
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

enum Spacecraft {
    static let names = [
        "ISS" : "International Space Station",
        "CrewDragon" : "Crew Dragon",
        "Soyuz MS-17" : "Soyuz MS-17"
    ]
}

enum Astronauts {
    static let portraits = [
        "Sergey Ryzhikov" : UIImage(named: "SergeyRyzhikov"),
        "Kate Rubins" : UIImage(named: "KateRubins"),
        "Sergey Kud-Sverchkov" : UIImage(named: "SergeyKudSverchkov"),
        "Mike Hopkins" : UIImage(named: "MikeHopkins"),
        "Victor Glover" : UIImage(named: "VictorGlover"),
        "Shannon Walker" : UIImage(named: "ShannonWalker"),
        "Soichi Noguchi" : UIImage(named: "SoichiNoguchi"),
        "Mark Vande Hei" : UIImage(named: "MarkVandeHei"),
        "Oleg Novitskiy" : UIImage(named: "OlegNovitskiy"),
        "Pyotr Dubrov" : UIImage(named: "PyotrDubrov"),

        //Crew-2
        "Shane Kimbrough" : Images.iss1,
        "Megan McArthur" : Images.iss1,
        "Akihiko Hoshide" : Images.iss1,
        "Thomas Pesquet" : Images.iss1,

        //Inspiration4
        "Jared Isaacman" : Images.iss1,
        "Hayley Arceneaux" : Images.iss1,
        "Chris Sembroski" : Images.iss1,
        "Dr. Sian Proctor" : Images.iss1,

        //Starliner
        "Mike Fincke" : Images.iss1,
        "Nicole Mann" : Images.iss1,
        "Barry Wilmore" : Images.iss1,

        //Soyuz mission
        "Anton Shkaplerov" : Images.iss1,
        "Klim Shipenko" : Images.iss1,
        "unnamed" : Images.iss1,

        //Crew-3
        "Raja Chari" : Images.iss1,
        "Thomas Marshburn" : Images.iss1,
        "Matthias Maurer" : Images.iss1,
        "unnamed2" : Images.iss1,

    ]
}
