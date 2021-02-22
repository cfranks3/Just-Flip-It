//
//  SettingsViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit
import StoreKit

protocol SettingsDelegate {
    func dataWasErased()
}

struct IAP {
    var name: String
    var handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    var itemController: ItemController?
    var eraseDelegate: SettingsDelegate?
    
    var IAPs = [IAP]()
    var totalTipped: Double {
        return UserDefaults.standard.double(forKey: "tipped")
    }
    
    enum settings: String {
        case whatsNew = "🗞 What's New?"
        case twitter = "🐦 Twitter"
        case tipJar = "💰 Tip Jar"
        case rateTheApp = "⭐️ Rate the App"
        case feedback = "🦻🏻 Feedback"
        case helpfulTips = "🆘 Helpful Tips"
        case privacyPolicy = "⚖️ Privacy Policy"
        case eraseInventory = "🗑 Erase All Inventory"
        case erasesoldItems = "🗑 Erase All Sold Items"
        case eraseCustomTags = "🗑 Erase All Custom Tags"
        case eraseData = "⛔️ Erase All Data"
    }
    
    let sectionOne: [settings] = [
        settings.whatsNew,
        settings.twitter]
    let sectionTwo: [settings] = [
        settings.tipJar,
        settings.rateTheApp,
        settings.feedback,
        settings.helpfulTips]
    let sectionThree: [settings] = [
        settings.eraseInventory,
        settings.erasesoldItems,
        settings.eraseCustomTags,
        settings.eraseData]
    
    let staticSettings: [[String]] = [
        [settings.whatsNew.rawValue,
         settings.twitter.rawValue],
        
        [settings.tipJar.rawValue,
         settings.rateTheApp.rawValue,
         settings.feedback.rawValue,
         settings.helpfulTips.rawValue],
        
        [settings.eraseInventory.rawValue,
         settings.erasesoldItems.rawValue,
         settings.eraseCustomTags.rawValue,
         settings.eraseData.rawValue],
    ]
    
    lazy var numberOfRows = [sectionOne.count,
                             sectionTwo.count,
                             sectionThree.count]

    // MARK: - IBOutlets

    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        appendIAPs()
        updateViews()
        configureColors()
    }

    func updateViews() {
        appVersionLabel.text = "App Version \(UIApplication.appVersion!)"
        appLogoImageView.layer.cornerRadius = 12
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
                - Change: Labels are clearer as to what data they expect.
                - Change: Changed sale icon to a '$' from '+'.
                - Bug Fix: Improved performance of the app.
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
        Begin by taping the '+' icon on the inventory card in your dashboard. Once you've added an item, you can then tap the '+' icon in the sold items card to record a sale. Tap on an item in your inventory to see or change information of the item.
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
            self.eraseDelegate?.dataWasErased()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func eraseSoldItems() {
        let alert = UIAlertController(title: "Warning!", message: "Proceeding will permanently delete all stored user data. This includes all sales, profit, inventory, and tags. This cannot be reversed.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            self.itemController?.eraseAllSoldItems()
            self.eraseDelegate?.dataWasErased()
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
            self.eraseDelegate?.dataWasErased()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    func eraseAllData() {
        let alert = UIAlertController(title: "Warning!",
                                      message: "Proceeding will permanently delete all stored user data. This includes all sales, profit, inventory, and tags. This cannot be reversed."
                                      , preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            UserDefaults.standard.setValue(false, forKey: "gnomes")
            self.itemController?.eraseAllData()
            self.eraseDelegate?.dataWasErased()
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
        if cell.settingTypeLabel.text == settings.eraseData.rawValue {
            cell.settingTypeLabel.textColor = .systemRed
            cell.settingTypeLabel.font = .boldSystemFont(ofSize: 16)
        } else {
            cell.settingTypeLabel.textColor = .white
            cell.settingTypeLabel.font = .boldSystemFont(ofSize: 16)
        }
        cell.backgroundColor = UIColor(named: "Foreground")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch staticSettings[indexPath.section][indexPath.row] {
        case settings.whatsNew.rawValue:
            whatsNew()
        case settings.twitter.rawValue:
            twitter()
        case settings.tipJar.rawValue:
            tipJar()
        case settings.feedback.rawValue:
            feedback()
        case settings.rateTheApp.rawValue:
            rateTheApp()
        case settings.helpfulTips.rawValue:
            helpfulTips()
        case settings.privacyPolicy.rawValue:
            privacyPolicy()
        case settings.eraseInventory.rawValue:
            eraseInventory()
        case settings.erasesoldItems.rawValue:
            eraseSoldItems()
        case settings.eraseCustomTags.rawValue:
            eraseTags()
        case settings.eraseData.rawValue:
            eraseAllData()
        default:
            NSLog("Error occured when attempting to select a settings option.")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
