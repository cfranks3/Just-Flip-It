//
//  SettingsViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit
import StoreKit

struct IAP {
    var name: String
    var handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    var itemController: ItemController?
    var delegate: AddItemViewControllerDelegate?
    
    var IAPs = [IAP]()
    var totalTipped: Double {
        return UserDefaults.standard.double(forKey: "tipped")
    }
    
    let staticSettings: [[String]] = [
        ["🗞 What's New?",
         "🐦 Twitter",
         "💰 Tip Jar"],
        
        ["🆘 Helpful Tips",
         "🦻🏻 Feedback",
         "⭐️ Rate the App",
         "⚖️ Privacy Policy"],
        
        ["🗑 Erase All Inventory",
         "🗑 Erase All Sold Items",
         "🗑 Erase All Custom Tags",
         "⛔️ Erase All Data"],
    ]
    
    let numberOfRows = [3, 4, 4]

    // MARK: - IBOutlets

    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        appendIAPs()
        configureColors()
    }

    func updateViews() {
        appVersionLabel.text = "App Version \(UIApplication.appVersion!)"
        appLogoImageView.layer.cornerRadius = 16
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        appVersionLabel.textColor = UIColor(named: "Text")
        tableView.backgroundColor = UIColor(named: "Background")
        tableView.separatorColor = UIColor(named: "Background")
        
    }

    // MARK: - Methods

    func whatsNew() {
        let alert = UIAlertController(title: "\(UIApplication.appVersion!) Notes", message:
                """
                - Change: Overhauled the app's appearance (again).
                - Feature: Added an inventory counter to the dashboard.
                """
                                      , preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome!", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func twitter() {
        let screenName = "bronsonmullens"
        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = URL(string: "https://twitter.com/\(screenName)")!

        let application = UIApplication.shared

           if application.canOpenURL(appURL as URL) {
                application.open(appURL)
           } else {
                application.open(webURL)
           }
    }

    func tipJar() {
        let alert = UIAlertController(title: "Tip Jar", message: "Thank you for your generosity. All tips go toward the continuous development of my apps.", preferredStyle: .actionSheet)
        let tier1TipAction = UIAlertAction(title: "Small tip ($0.99)", style: .default) { (_) in
            self.IAPs[0].handler()
        }
        let tier2TipAction = UIAlertAction(title: "Generous tip ($4.99)", style: .default) { (_) in
            self.IAPs[1].handler()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(tier1TipAction)
        alert.addAction(tier2TipAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    func appendIAPs() {
        IAPs.append(IAP(name: "Small Tip", handler: {
            IAPManager.shared.purchase(product: .tier1Tip) { [weak self] tipped in
                DispatchQueue.main.async {
                    let currentTipped = self?.totalTipped ?? 0
                    let newTipped = currentTipped + tipped
                    UserDefaults.standard.setValue(newTipped, forKey: "tipped")
                }
            }
        }))
        
        IAPs.append(IAP(name: "Generous Tip", handler: {
            IAPManager.shared.purchase(product: .tier2Tip) { [weak self] tipped in
                DispatchQueue.main.async {
                    let currentTipped = self?.totalTipped ?? 0
                    let newTipped = currentTipped + tipped
                    UserDefaults.standard.setValue(newTipped, forKey: "tipped")
                }
            }
        }))
    }

    func helpfulTips() {
        let helpMessage =
        """
        Begin by adding an item to your inventory. After saving, the item will be added and your inventory value will update. Tap on the report a sale button when one of your items sells. If you'd like to remove or edit your item prior to a sale, open your inventory and locate your item.
        """
        let alert = UIAlertController(title: "How to use this app",
                                      message: helpMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }

    func feedback() {
        let email: String = "bronsonmullens@icloud.com"
        let alert = UIAlertController(title: "Submit Feedback", message: "Whether it's a bug report, feature request, or general feedback, I'd love to hear from you. Send me an email at \(email).", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func rateTheApp() {
        SKStoreReviewController.requestReview()
    }

    func privacyPolicy() {
        let privacyPolicyURL = URL(string: "https://github.com/bronsonmullens/FlippingApp/blob/main/PrivacyPolicy.MD")!
        let application = UIApplication.shared
        application.open(privacyPolicyURL)
    }
    
    func eraseInventory() {
        let alert = UIAlertController(title: "Warning!", message: "Proceeding will permanently delete all stored inventory. This cannot be reversed.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            self.itemController?.eraseAllInventory()
            self.delegate?.itemWasAdded()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func eraseSoldItems() {
        let alert = UIAlertController(title: "Warning!", message: "Proceeding will permanently delete all stored user data. This includes all sales, profit, inventory, and tags. This cannot be reversed.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            UserDefaults.standard.setValue(false, forKey: "gnomes")
            self.itemController?.eraseAllSoldItems()
            self.delegate?.itemWasAdded()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func eraseTags() {
        let alert = UIAlertController(title: "Warning!", message: "Proceeding will permanently delete all stored user data. This includes all sales, profit, inventory, and tags. This cannot be reversed.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            self.itemController?.eraseAllTags()
            self.delegate?.itemWasAdded()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func eraseAllData() {
        let alert = UIAlertController(title: "Warning!", message: "Proceeding will permanently delete all stored user data. This includes all sales, profit, inventory, and tags. This cannot be reversed.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            UserDefaults.standard.setValue(false, forKey: "gnomes")
            self.itemController?.eraseAllData()
            self.delegate?.itemWasAdded()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        staticSettings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsCell
        cell.settingTypeLabel.text = staticSettings[indexPath.section][indexPath.row]
        if cell.settingTypeLabel.text == "⛔️ Erase All Data" {
            cell.settingTypeLabel.textColor = .systemRed
            cell.settingTypeLabel.font = .boldSystemFont(ofSize: 16)
        }
        cell.backgroundColor = UIColor(named: "Foreground")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch staticSettings[indexPath.section][indexPath.row] {
        case "🗞 What's New?":
            whatsNew()
        case "🐦 Twitter":
            twitter()
        case "💰 Tip Jar":
            tipJar()
        case "🆘 Helpful Tips":
            helpfulTips()
        case "🦻🏻 Feedback":
            feedback()
        case "⭐️ Rate the App":
            rateTheApp()
        case "⚖️ Privacy Policy":
            privacyPolicy()
        case "🗑 Erase All Inventory":
            eraseInventory()
        case "🗑 Erase All Sold Items":
            eraseSoldItems()
        case "🗑 Erase All Custom Tags":
            eraseTags()
        case "⛔️ Erase All Data":
            eraseAllData()
        default:
            NSLog("Error occured when attempting to select a settings option.")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
