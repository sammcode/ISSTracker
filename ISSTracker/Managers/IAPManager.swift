//
//  IAPManager.swift
//  ISSTracker
//
//  Created by Sam McGarry on 9/11/21.
//

import Purchases

class IAPManager {
    static let shared = IAPManager()

    var packages: [Purchases.Package] = []
    var inPaymentProgress: Bool = false

    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "JzcFNIVGyIDMVGOFyrLHEpIWFpByZkpe")
        Purchases.shared.offerings { (offerings, _) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
            }
        }
    }

    func purchase(product: Purchases.Package, completion: @escaping () -> Void) {
        guard !inPaymentProgress else { return }
        inPaymentProgress = true
        Purchases.shared.purchasePackage(product) { (_, purchaserInfo, _, _) in
            self.inPaymentProgress = false
        }
    }
}


