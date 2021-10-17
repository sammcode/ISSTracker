//
//  TipVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 9/11/21.
//

import UIKit

class TipVC: UIViewController {

    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var cells = [UITableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        configureViewController()
        configureTableView()
    }

    func configureViewController() {
        title = "Leave a Tip"
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)

        configureCells()

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        let label = ITTitleLabel(textAlignment: .center, fontSize: 16)
        label.text = "Enjoying the app? If you'd like, you can leave a tip to support the development of the app. It's just me building TrackISS, so anything helps :)"
        label.textColor = .label
        label.numberOfLines = 6
        footerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 150),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])

        tableView.tableFooterView = footerView
    }

    func configureCells() {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "$1.99 - Launchpad Tip"
        cell.imageView?.image = "🌎".image()
        cell.selectionStyle = .none

        cells.append(cell)

        let cell1 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell1.textLabel?.text = "$4.99 - Rocket Tip"
        cell1.imageView?.image = "🚀".image()
        cell1.selectionStyle = .none

        cells.append(cell1)

        let cell2 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell2.textLabel?.text = "$8.99 - Space Tip"
        cell2.imageView?.image = "🛰".image()
        cell2.selectionStyle = .none

        cells.append(cell2)
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }
}

extension TipVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let packages = IAPManager.shared.packages
        print(packages)
        print(packages.count)
        guard packages.count == 1 else { return }
        switch indexPath.row {
        case 0:
            IAPManager.shared.purchase(product: packages[0]) {
                self.presentITAlertOnMainThread(title: "Success!", message: "You left a tip of $1.99. Thanks for your support!", buttonTitle: "Ok")
            }
        case 1:
            IAPManager.shared.purchase(product: packages[1]) {
                self.presentITAlertOnMainThread(title: "Success!", message: "You left a tip of $4.99. Thanks for your support!", buttonTitle: "Ok")
            }
        case 2:
            IAPManager.shared.purchase(product: packages[2]) {
                self.presentITAlertOnMainThread(title: "Success!", message: "You left a tip of $8.99. Thanks for your support!", buttonTitle: "Ok")
            }
        default:
            break
        }
    }

}
