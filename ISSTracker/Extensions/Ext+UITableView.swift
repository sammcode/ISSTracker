//
//  Ext+UITableView.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/13/21.
//

import UIKit

extension UITableView {
    func removeExcessCells(){
        tableFooterView = UIView(frame: .zero)
    }
}
