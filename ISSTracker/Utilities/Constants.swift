//
//  Constants.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/7/21.
//

import UIKit
import MapKit
import AVFoundation

let generator = UINotificationFeedbackGenerator()

enum Images {
    static let issIcon = UIImage(named: "ISSIcon")
    static let issIcon2 = UIImage(named: "ISSIcon2")
    static let issIcon3 = UIImage(named: "ISSIcon3")
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

    static let darkBlueIcon = UIImage(named: "darkBlueIcon")
    static let blackIcon = UIImage(named: "blackIcon")
    static let greenIcon = UIImage(named: "greenIcon")
    static let yellowIcon = UIImage(named: "yellowIcon")
    static let whiteIcon = UIImage(named: "whiteIcon")
    static let lightBlueIcon = UIImage(named: "lightBlueIcon")
    static let orangeIcon = UIImage(named: "orangeIcon")
    static let purpleIcon = UIImage(named: "purpleIcon")
    static let redIcon = UIImage(named: "redIcon")

    static let portrait = UIImage(named: "portrait")
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
        formatter.dateFormat = "MMMMM d"
        return formatter
    }()
}

enum Map {
    static let mapView = MKMapView()
}

enum Spacecraft {
    static let names = [
        "ISS" : "International Space Station",
        "CrewDragon" : "Crew Dragon",
        "Soyuz MS-17" : "Soyuz MS-17"
    ]
}

enum AstronautData {
    static let astronauts = [

        //Expedition 65/Crew 2
        "Mark Vande Hei" : Astronaut(name: "Mark Vande Hei", image: (UIImage(named: "MarkVandeHei") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Flight Engineer", biographyURL: "https://www.nasa.gov/astronauts/biographies/mark-t-vande-hei/biography"),
        "Oleg Novitskiy" : Astronaut(name: "Oleg Novitskiy", image: (UIImage(named: "OlegNovitskiy") ?? Images.iss1)!, nationality: "Russia 🇷🇺", role: "Flight Engineer", biographyURL: "http://en.roscosmos.ru/1614/"),
        "Pyotr Dubrov" : Astronaut(name: "Pyotr Dubrov", image: (UIImage(named: "PyotrDubrov") ?? Images.iss1)!, nationality: "Russia 🇷🇺", role: "Flight Engineer", biographyURL: "http://www.gctc.ru/main.php?id=1704"),

        "Shane Kimbrough" : Astronaut(name: "Shane Kimbrough", image: (UIImage(named: "ShaneKimbrough") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Flight Engineer", biographyURL: "https://www.nasa.gov/astronauts/biographies/robert-shane-kimbrough/biography"),
        "Megan McArthur" : Astronaut(name: "Megan McArthur", image: (UIImage(named: "MeganMcArthur") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Flight Engineer", biographyURL: "https://www.nasa.gov/astronauts/biographies/k-megan-mcarthur/biography"),
        "Akihiko Hoshide" : Astronaut(name: "Akihiko Hoshide", image: (UIImage(named: "AkihikoHoshide") ?? Images.iss1)!, nationality: "Japan 🇯🇵", role: "Commander", biographyURL: "https://iss.jaxa.jp/en/astro/biographies/hoshide/index.html"),
        "Thomas Pesquet" : Astronaut(name: "Thomas Pesquet", image: (UIImage(named: "ThomasPesquet") ?? Images.iss1)!, nationality: "France 🇫🇷", role: "Flight Engineer", biographyURL: "https://www.esa.int/Science_Exploration/Human_and_Robotic_Exploration/Astronauts/Thomas_Pesquet"),

        //Inspiration4
        "Jared Isaacman" : Astronaut(name: "Jared Isaacman", image: (UIImage(named: "JaredIsaacman") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Commander", biographyURL: "https://inspiration4.com/crew"),
        "Hayley Arceneaux" : Astronaut(name: "Hayley Arceneaux", image: (UIImage(named: "HayleyArceneaux") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Civilian", biographyURL: "https://inspiration4.com/crew"),
        "Chris Sembroski" : Astronaut(name: "Chris Sembroski", image: (UIImage(named: "ChrisSembroski") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Civilian", biographyURL: "https://inspiration4.com/crew"),
        "Dr. Sian Proctor" : Astronaut(name: "Dr. Sian Proctor", image: (UIImage(named: "Dr. Sian Proctor") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Civilian", biographyURL: "https://inspiration4.com/crew"),

        //Tiangong
        "Nie Haisheng" : Astronaut(name: "Nie Haisheng", image: (UIImage(named: "NieHaisheng") ?? Images.iss1)!, nationality: "China 🇨🇳", role: "Flight Engineer", biographyURL: "https://en.wikipedia.org/wiki/Nie_Haisheng"),
        "Liu Boming" : Astronaut(name: "Liu Boming", image: (UIImage(named: "LiuBoming") ?? Images.iss1)!, nationality: "China 🇨🇳", role: "Flight Engineer", biographyURL: "https://en.wikipedia.org/wiki/Liu_Boming_(astronaut)"),
        "Tang Hongbo" : Astronaut(name: "Tang Hongbo", image: (UIImage(named: "TangHongbo") ?? Images.iss1)!, nationality: "China 🇨🇳", role: "Flight Engineer", biographyURL: "https://en.wikipedia.org/wiki/Tang_Hongbo"),

        //Soyuz-19 mission
        "Anton Shkaplerov" : Astronaut(name: "Anton Shkaplerov", image: (UIImage(named: "AntonShkaplerov") ?? Images.iss1)!, nationality: "Russia 🇷🇺", role: "Commander", biographyURL: "https://en.wikipedia.org/wiki/Anton_Shkaplerov"),
        "Klim Shipenko" : Astronaut(name: "Klim Shipenko", image: (UIImage(named: "KlimShipenko") ?? Images.iss1)!, nationality: "Russia 🇷🇺", role: "Spaceflight Participant", biographyURL: "https://en.wikipedia.org/wiki/Klim_Shipenko"),
        "Yulia Peresild" : Astronaut(name: "Yulia Peresild", image: (UIImage(named: "YuliaPeresild") ?? Images.iss1)!, nationality: "Russia 🇷🇺", role: "Spaceflight Participant", biographyURL: "https://en.wikipedia.org/wiki/Yulia_Peresild"),

//        //Crew-3
        "Raja Chari" : Astronaut(name: "Raja Chari", image: (UIImage(named: "RajaChari") ?? Images.iss1)!, nationality: "Commander", role: "USA 🇺🇸", biographyURL: "https://www.nasa.gov/content/astronaut-raja-chari"),
        "Thomas Marshburn" : Astronaut(name: "Thomas Marshburn", image: (UIImage(named: "ThomasMarshburn") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Flight Engineer", biographyURL: "https://www.nasa.gov/astronauts/biographies/thomas-h-marshburn/biography"),
        "Matthias Maurer" : Astronaut(name: "Matthias Maurer", image: (UIImage(named: "MatthiasMaurer") ?? Images.iss1)!, nationality: "Germany 🇩🇪", role: "Flight Engineer", biographyURL: "https://blogs.esa.int/exploration/category/astronauts/matthias-maurer/"),
        "Kayla Barron" : Astronaut(name: "Kayla Barron", image: (UIImage(named: "KaylaBarron") ?? Images.iss1)!, nationality: "USA 🇺🇸", role: "Flight Engineer", biographyURL: "https://www.nasa.gov/content/astronaut-kayla-barron")
    ]
}
