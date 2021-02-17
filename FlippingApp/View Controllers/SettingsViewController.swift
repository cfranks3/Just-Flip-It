//
//  SettingsViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    var itemController: ItemController?
    var delegate: AddItemViewControllerDelegate?
    var settings: [String] = [
        "What's New?",
        "Twitter",
        "Change Colors",
        "Tip Jar",
        "Helpful tips",
        "Feedback",
        "Rate the app",
        "Privacy policy",
        "Erase data",
    ]

    // MARK: - IBOutlets

    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        appVersionLabel.text = "App Version \(UIApplication.appVersion!)"
        appLogoImageView.layer.cornerRadius = 16
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsCell
        cell.settingTypeLabel.text = settings[indexPath.row]
        if cell.settingTypeLabel.text == "Erase data" {
            cell.settingTypeLabel.textColor = .systemRed
        }
        return cell
    }
    
}
