//
//  SettingsVC.swift
//  ISSTracker
//
//  Created by Sam McGarry on 4/20/21.
//

import UIKit

class SettingsVC: UIViewController {

    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    var cells = [[UITableViewCell](), [UITableViewCell]()]

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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

        if UserDefaultsManager.appearance == 0 {
            overrideUserInterfaceStyle = .unspecified
            navigationController?.overrideUserInterfaceStyle = .unspecified
        } else if UserDefaultsManager.appearance == 1 {
            overrideUserInterfaceStyle = .light
            navigationController?.overrideUserInterfaceStyle = .light
        } else if UserDefaultsManager.appearance == 2 {
            overrideUserInterfaceStyle = .dark
            navigationController?.overrideUserInterfaceStyle = .dark
        }
    }

    func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        configureCells()
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
        let cell0 = UITableViewCell()
        let items = ["Automatic", "Light", "Dark"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = UserDefaultsManager.appearance
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        cell0.contentView.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.centerYAnchor.constraint(equalTo: cell0.contentView.centerYAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: cell0.contentView.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: tableView.bounds.width * 0.85),
            segmentedControl.heightAnchor.constraint(equalToConstant: cell0.contentView.bounds.height * 0.7),
        ])

        cells[0].append(cell0)

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Large Map Annotations"
        cell.imageView?.image = UIImage(systemName: "map", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)

        let switchView = UISwitch(frame: .zero)
        switchView.setOn(UserDefaultsManager.largeMapAnnotations, animated: true)
        switchView.tag = 0 // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView

        cells[1].append(cell)

        let cell1 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell1.textLabel?.text = "Reduce Animations"
        cell1.imageView?.image = UIImage(systemName: "bolt.slash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)

        let switchView1 = UISwitch(frame: .zero)
        switchView1.setOn(UserDefaultsManager.reduceAnimations, animated: true)
        switchView1.tag = 1 // for detect which row switch Changed
        switchView1.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell1.accessoryView = switchView1

        cells[1].append(cell1)

        let cell2 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell2.textLabel?.text = "Haptics"
        cell2.imageView?.image = UIImage(systemName: "iphone.radiowaves.left.and.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)

        let switchView2 = UISwitch(frame: .zero)
        switchView2.setOn(UserDefaultsManager.haptics, animated: true)
        switchView2.tag = 2 // for detect which row switch Changed
        switchView2.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell2.accessoryView = switchView2

        cells[1].append(cell2)

        let cell3 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell3.textLabel?.text = "App Icon"
        cell3.imageView?.image = UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell3.accessoryType = .disclosureIndicator

        cells[1].append(cell3)
    }

    @objc func switchChanged(_ sender : UISwitch!){
        switch sender.tag {
        case 0:
            UserDefaultsManager.largeMapAnnotations.toggle()
        case 1:
            UserDefaultsManager.reduceAnimations.toggle()
        case 2:
            UserDefaultsManager.haptics.toggle()
        default:
            break
        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Appearance"
        case 1:
            return "General"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let appIconSelectorVC = AppIconSelectorVC()
            self.navigationController?.pushViewController(appIconSelectorVC, animated: true)
        }
    }
}
