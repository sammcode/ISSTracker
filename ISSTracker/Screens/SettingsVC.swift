//
//  SettingsVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/20/21.
//

import UIKit
import SafariServices

protocol SettingsVCDelegate: AnyObject{
    func didChangeAnimationPreferences()
}

class SettingsVC: UIViewController {

    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    var cells = [[UITableViewCell](), [UITableViewCell](), [UITableViewCell](), [UITableViewCell]()]

    weak var delegate: SettingsVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: false)
        }
    }

    func configure(){
        configureViewController()
        configureTableView()
    }

    @objc func dismissVC(){
        dismiss(animated: true)
    }

    func configureViewController(){
        title = "Settings"
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NasalizationRg-Regular", size: 20)!]
    }

    func configureTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        configureCells()

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let label = ITTitleLabel(textAlignment: .center, fontSize: 24)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        label.text = "TrackISS v\(appVersion!)\nMade with ❤️ by Sam."
        label.textColor = .label
        label.font = UIFont(name: "NasalizationRg-Regular", size: 18)
        label.numberOfLines = 2
        footerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 50),
            label.widthAnchor.constraint(equalToConstant: 200),
            label.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])

        let logoImageView = ITImageView(frame: .zero)
        footerView.addSubview(logoImageView)
        logoImageView.image = Images.issIcon3?.withTintColor(Colors.mainBlueYellow)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10)
        ])

        tableView.tableFooterView = footerView
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            overrideUserInterfaceStyle = .unspecified
            navigationController?.overrideUserInterfaceStyle = .unspecified
            UserDefaultsManager.appearance = 0
        } else if sender.selectedSegmentIndex == 1 {
            overrideUserInterfaceStyle = .light
            navigationController?.overrideUserInterfaceStyle = .light
            UserDefaultsManager.appearance = 1
        } else if sender.selectedSegmentIndex == 2 {
            overrideUserInterfaceStyle = .dark
            navigationController?.overrideUserInterfaceStyle = .dark
            UserDefaultsManager.appearance = 2
        }
    }

    func configureCells(){
        let cell0 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell0.textLabel?.text = "App Icon"
        cell0.imageView?.image = UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell0.accessoryType = .disclosureIndicator

        cells[0].append(cell0)

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Large Map Annotations"
        cell.imageView?.image = UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell.selectionStyle = .none

        let switchView = UISwitch(frame: .zero)
        switchView.setOn(UserDefaultsManager.largeMapAnnotations, animated: true)
        switchView.tag = 0 // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView

        cells[1].append(cell)

        let cell1 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell1.textLabel?.text = "Reduce Animations"
        cell1.imageView?.image = UIImage(systemName: "bolt.slash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell1.selectionStyle = .none

        let switchView1 = UISwitch(frame: .zero)
        switchView1.setOn(UserDefaultsManager.reduceAnimations, animated: true)
        switchView1.tag = 1 // for detect which row switch Changed
        switchView1.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell1.accessoryView = switchView1

        cells[1].append(cell1)

        let cell2 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell2.textLabel?.text = "Haptics"
        cell2.imageView?.image = UIImage(systemName: "iphone.radiowaves.left.and.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell2.selectionStyle = .none

        let switchView2 = UISwitch(frame: .zero)
        switchView2.setOn(UserDefaultsManager.haptics, animated: true)
        switchView2.tag = 2 // for detect which row switch Changed
        switchView2.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell2.accessoryView = switchView2

        cells[1].append(cell2)

        //RESOURCES
        let cell3 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell3.textLabel?.text = "TrackISS Github repo"
        cell3.accessoryType = .disclosureIndicator
        cells[2].append(cell3)

        let cell4 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell4.textLabel?.text = "Open-Notify API"
        cell4.accessoryType = .disclosureIndicator
        cells[2].append(cell4)

        let cell5 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell5.textLabel?.text = "Where the ISS at? API"
        cell5.accessoryType = .disclosureIndicator
        cells[2].append(cell5)

        //OTHER

        let cell6 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell6.textLabel?.text = "Developer"
        cell6.imageView?.image = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell6.accessoryType = .disclosureIndicator
        cells[3].append(cell6)
    }

    @objc func switchChanged(_ sender : UISwitch!){
        switch sender.tag {
        case 0:
            UserDefaultsManager.largeMapAnnotations.toggle()
        case 1:
            UserDefaultsManager.reduceAnimations.toggle()
            delegate.didChangeAnimationPreferences()
        case 2:
            UserDefaultsManager.haptics.toggle()
        default:
            break
        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Appearance"
        case 1:
            return "General"
        case 2:
            return "Resources"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let appIconSelectorVC = AppIconSelectorVC()
            self.navigationController?.pushViewController(appIconSelectorVC, animated: true)
        case 2:
            var url = URL(string: "")
            switch indexPath.row {
            case 0:
                url = URL(string: "https://github.com/sammcode/ISSTracker")
            case 1:
                url = URL(string: "http://open-notify.org/")
            case 2:
                url = URL(string: "https://wheretheiss.at/")
            default:
                break
            }
            let safariVC = SFSafariViewController(url: url!)
            safariVC.preferredControlTintColor = Colors.mainBlueYellow
            present(safariVC, animated: true)
        case 3:
            let developerVC = DeveloperVC()
            self.navigationController?.pushViewController(developerVC, animated: true)
        default:
            break
        }
    }
}
