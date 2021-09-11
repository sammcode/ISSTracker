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
    var cells = [[UITableViewCell](), [UITableViewCell](), [UITableViewCell](), [UITableViewCell](), [UITableViewCell]()]

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
        label.text = "TrackISS v\(appVersion!)\nMade with ❤️"
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

    func configureCells(){
        configureAppearanceCells()
        configureGeneralCells()
        configureMapCells()
        configureResourceCells()
        configureDeveloperCell()
    }

    func configureAppearanceCells(){
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "App Icon"
        cell.imageView?.image = UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell.accessoryType = .disclosureIndicator

        cells[0].append(cell)
    }

    func configureGeneralCells(){
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Reduce Animations"
        cell.imageView?.image = UIImage(systemName: "bolt.slash.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell.selectionStyle = .none

        let switchView = UISwitch(frame: .zero)
        switchView.setOn(UserDefaultsManager.reduceAnimations, animated: true)
        switchView.tag = 1
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView

        cells[1].append(cell)

        let cell1 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell1.textLabel?.text = "Haptics"
        cell1.imageView?.image = UIImage(systemName: "iphone.radiowaves.left.and.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell1.selectionStyle = .none

        let switchView1 = UISwitch(frame: .zero)
        switchView1.setOn(UserDefaultsManager.haptics, animated: true)
        switchView1.tag = 2
        switchView1.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell1.accessoryView = switchView1

        cells[1].append(cell1)
    }

    func configureMapCells(){
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Large Map Annotations"
        cell.imageView?.image = UIImage(systemName: "mappin.and.ellipse", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell.selectionStyle = .none

        let switchView = UISwitch(frame: .zero)
        switchView.setOn(UserDefaultsManager.largeMapAnnotations, animated: true)
        switchView.tag = 0
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView

        cells[2].append(cell)
    }

    func configureResourceCells(){
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "TrackISS Github repo"
        cell.accessoryType = .disclosureIndicator
        cells[3].append(cell)

        let cell1 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell1.textLabel?.text = "Open-Notify API"
        cell1.accessoryType = .disclosureIndicator
        cells[3].append(cell1)

        let cell2 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell2.textLabel?.text = "Where the ISS at? API"
        cell2.accessoryType = .disclosureIndicator
        cells[3].append(cell2)

        let cell3 = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell3.textLabel?.text = "NASA Image and Video Library API"
        cell3.accessoryType = .disclosureIndicator
        cells[3].append(cell3)
    }

    func configureDeveloperCell(){
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Developer"
        cell.imageView?.image = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small))?.withRenderingMode(.alwaysOriginal).withTintColor(Colors.mainBlueYellow)
        cell.accessoryType = .disclosureIndicator
        cells[4].append(cell)
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
        print(cells[section].count)
        return cells[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Appearance"
        case 1:
            return "General"
        case 2:
            return "Map"
        case 3:
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
        case 4:
            var url = URL(string: "")
            switch indexPath.row {
            case 0:
                url = URL(string: "https://github.com/sammcode/ISSTracker")
            case 1:
                url = URL(string: "http://open-notify.org/")
            case 2:
                url = URL(string: "https://wheretheiss.at/")
            case 3:
                url = URL(string: "https://images.nasa.gov/")
            default:
                break
            }
            let safariVC = SFSafariViewController(url: url!)
            safariVC.preferredControlTintColor = Colors.mainBlueYellow
            present(safariVC, animated: true)
        case 5:
            let developerVC = DeveloperVC()
            self.navigationController?.pushViewController(developerVC, animated: true)
        default:
            break
        }
    }
}
