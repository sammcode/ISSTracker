//
//  ITError.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import Foundation

enum ITError: String, Error {
    case unableToComplete   = "Unable to complete your request. Please check your internet connection."
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
    case locationServicesTurnedOff = "Unable to predict pass times for your current location because location services are disabled for this app. Please enable them in Settings."
}
