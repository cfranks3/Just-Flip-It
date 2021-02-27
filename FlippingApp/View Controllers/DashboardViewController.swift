//
//  DashboardViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - Properties
    
    let itemController = ItemController()
    let numberFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profitView: UIView!
    @IBOutlet weak var inventoryView: UIView!
    @IBOutlet weak var soldItemsView: UIView!
    @IBOutlet weak var recentSalesView: UIView!
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var inventoryButton: UIButton!
    @IBOutlet weak var recordSaleButton: UIButton!
    @IBOutlet weak var soldItemsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var inventoryValueLabel: UILabel!
    @IBOutlet weak var inventoryQuantityLabel: UILabel!
    @IBOutlet weak var numberOfSalesLabel: UILabel!
    @IBOutlet weak var recentlyAddedLabel: UILabel!
    @IBOutlet weak var recentItemNameLabel: UILabel!
    @IBOutlet weak var recentItemPriceLabel: UILabel!
    @IBOutlet weak var oldestItemLabel: UILabel!
    @IBOutlet weak var oldestItemNameLabel: UILabel!
    @IBOutlet weak var oldestItemDaysLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func inventoryButtonTapped(_ sender: UIButton) {
        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return }
        inventoryVC.itemController = itemController
        inventoryVC.delegate = self
        inventoryVC.filteredItems = itemController.inventory
        inventoryVC.viewingSold = false
        inventoryVC.searchType = "inventory"
        present(inventoryVC, animated: true, completion: nil)
    }
    
    @IBAction func soldItemsButtonTapped(_ sender: UIButton) {
        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return }
        inventoryVC.itemController = itemController
        inventoryVC.delegate = self
        inventoryVC.filteredItems = itemController.soldItems
        inventoryVC.viewingSold = true
        inventoryVC.searchType = "soldItems"
        present(inventoryVC, animated: true, completion: nil)
    }
    
    @IBAction func recordSaleButtonTapped(_ sender: UIButton) {
        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return }
        inventoryVC.itemController = itemController
        inventoryVC.delegate = self
        inventoryVC.filteredItems = itemController.inventory
        inventoryVC.viewingSold = false
        inventoryVC.searchType = "selling"
        present(inventoryVC, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        itemController.delegate = self
        updateViews()
        configureViews()
        configureColors()
    }
    
    // MARK: - View configuration
    
    func updateViews() {
        numberFormatter.numberStyle = .currency
        let inventoryValue = itemController.calculateInventoryValue()
        recordSaleButton.setTitle("$", for: .normal)
        recordSaleButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        recordSaleButton.setTitleColor(UIColor(named: "Text"), for: .normal)
        profitLabel.text = numberFormatter.string(from: itemController.calculateProfit() as NSNumber)
        if  inventoryValue > 2147483647 {
            inventoryValueLabel.text = "Too High!"
            inventoryValueLabel.textColor = .systemYellow
        } else if inventoryValue >= 1 {
            inventoryValueLabel.text = numberFormatter.string(from: inventoryValue as NSNumber)
            inventoryValueLabel.textColor = .systemGreen
        } else {
            inventoryValueLabel.text = numberFormatter.string(from: inventoryValue as NSNumber)
            inventoryValueLabel.textColor = .white
        }
        
        numberFormatter.numberStyle = .decimal
        let numberOfSales = itemController.calculateSales()
        numberOfSalesLabel.text = numberFormatter.string(from: numberOfSales as NSNumber)
        
        if itemController.inventory.isEmpty {
            for constraint in recentSalesView.constraints {
                if constraint.identifier == "salesViewHeight" {
                    constraint.constant = 100
                }
            }
            oldestItemLabel.isHidden = true
            oldestItemNameLabel.isHidden = true
            oldestItemDaysLabel.isHidden = true
            recentItemPriceLabel.isHidden = true
            recentItemNameLabel.text = "Add an item to begin"
        } else {
            for constraint in recentSalesView.constraints {
                if constraint.identifier == "salesViewHeight" {
                    constraint.constant = 200
                }
            }
            
            oldestItemLabel.isHidden = false
            oldestItemNameLabel.isHidden = false
            oldestItemDaysLabel.isHidden = false
            recentItemPriceLabel.isHidden = false
            
            numberFormatter.numberStyle = .currency
            let recentlyListedPrice = itemController.calculateRecentlyListedPrice()
            if let recentlyListedPrice = recentlyListedPrice {
                recentItemPriceLabel.text = numberFormatter.string(from: recentlyListedPrice as NSNumber)
                recentItemNameLabel.text = itemController.inventory.last?.title
            }
            
            numberFormatter.numberStyle = .decimal
            if let oldestItem = itemController.findOldestItem(){
                oldestItemNameLabel.text = oldestItem.title
                if let oldestItemDate = oldestItem.listedDate {
                    let differenceInDays = Calendar.current.dateComponents([.day], from: oldestItemDate, to: Date()).day
                    oldestItemDaysLabel.text = "\(numberFormatter.string(from: differenceInDays! as NSNumber) ?? "") days"
                } else {
                    oldestItemDaysLabel.text = "Unknown"
                }
            }
        }
        
        inventoryQuantityLabel.text = numberFormatter.string(from: itemController.calculateInventoryQuantity() as NSNumber)
        
        // Easter egg
        if UserDefaults.standard.bool(forKey: "gnomes") {
            titleLabel.text = "Gnomeboard"
        } else {
            titleLabel.text = "Dashboard"
        }
    }
    
    func configureViews() {
        profitView.layer.cornerRadius = 12
        inventoryView.layer.cornerRadius = 12
        soldItemsView.layer.cornerRadius = 12
        recentSalesView.layer.cornerRadius = 12
        
        inventoryButton.layer.cornerRadius = 12
        soldItemsButton.layer.cornerRadius = 12
        settingsButton.layer.cornerRadius = 25
        addItemButton.layer.cornerRadius = 25
        recordSaleButton.layer.cornerRadius = 25
        
        profitView.layer.shadowOpacity = 0.7
        profitView.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        profitView.layer.shadowRadius = 4
        profitView.layer.shadowOffset = CGSize(width: 0, height: 8)
        profitView.layer.masksToBounds = false
        
        inventoryView.layer.shadowOpacity = 0.7
        inventoryView.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        inventoryView.layer.shadowRadius = 4
        inventoryView.layer.shadowOffset = CGSize(width: 0, height: 8)
        inventoryView.layer.masksToBounds = false
        
        soldItemsView.layer.shadowOpacity = 0.7
        soldItemsView.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        soldItemsView.layer.shadowRadius = 4
        soldItemsView.layer.shadowOffset = CGSize(width: 0, height: 8)
        soldItemsView.layer.masksToBounds = false
        
        recentSalesView.layer.shadowOpacity = 0.7
        recentSalesView.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        recentSalesView.layer.shadowRadius = 4
        recentSalesView.layer.shadowOffset = CGSize(width: 0, height: 8)
        recentSalesView.layer.masksToBounds = false
        
        addItemButton.layer.shadowOpacity = 0.7
        addItemButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        addItemButton.layer.shadowRadius = 1
        addItemButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        addItemButton.layer.masksToBounds = false
        
        recordSaleButton.layer.shadowOpacity = 0.7
        recordSaleButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        recordSaleButton.layer.shadowRadius = 1
        recordSaleButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        recordSaleButton.layer.masksToBounds = false
        
        inventoryButton.layer.shadowOpacity = 0.7
        inventoryButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        inventoryButton.layer.shadowRadius = 1
        inventoryButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        inventoryButton.layer.masksToBounds = false
        
        soldItemsButton.layer.shadowOpacity = 0.7
        soldItemsButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        soldItemsButton.layer.shadowRadius = 1
        soldItemsButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        soldItemsButton.layer.masksToBounds = false
        
        settingsButton.layer.shadowOpacity = 0.7
        settingsButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        settingsButton.layer.shadowRadius = 1
        settingsButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        settingsButton.layer.masksToBounds = false
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        topBannerView.backgroundColor = UIColor(named: "Background")
        contentView.backgroundColor = UIColor(named: "Background")
        profitView.backgroundColor = UIColor(named: "Foreground")
        inventoryView.backgroundColor = UIColor(named: "Foreground")
        soldItemsView.backgroundColor = UIColor(named: "Foreground")
        recentSalesView.backgroundColor = UIColor(named: "Foreground")
        
        inventoryButton.backgroundColor = UIColor(named: "Background")
        soldItemsButton.backgroundColor = UIColor(named: "Background")
        addItemButton.backgroundColor = UIColor(named: "Background")
        recordSaleButton.backgroundColor = UIColor(named: "Background")
        settingsButton.backgroundColor = UIColor(named: "Foreground")
        
        titleLabel.textColor = UIColor(named: "Text")
        
        inventoryButton.setTitleColor(UIColor(named: "Text"), for: .normal)
        soldItemsButton.setTitleColor(UIColor(named: "Text"), for: .normal)
        addItemButton.tintColor = UIColor(named: "Text")
        recordSaleButton.tintColor = UIColor(named: "Text")
        settingsButton.setTitleColor(UIColor(named: "Text"), for: .normal)
        
        if itemController.calculateProfit() > 0 {
            profitLabel.textColor = .systemGreen
        } else if itemController.calculateProfit() < 0 {
            profitLabel.textColor = .systemRed
        } else {
            profitLabel.textColor = .white
        }
    }
    
    // MARK: - Methods
    
    func load() {
        let loaded = itemController.load()
        if !loaded {
            let alert = UIAlertController(title: "Error loading", message: "Something went wrong when trying to load saved data. Try reloading the app. If this issue persists, send me an email at bronsonmullens@icloud.com or a tweet @bronsonmullens.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            NSLog("Loaded data successfully")
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            guard let addItemVC = segue.destination as? AddItemViewController else { return }
            addItemVC.itemController = itemController
            addItemVC.delegate = self
        } else if segue.identifier == "SettingsSegue" {
            guard let settingsVC = segue.destination as? SettingsViewController else { return }
            settingsVC.itemController = itemController
            settingsVC.eraseDelegate = self
        }
    }

}

// MARK: - Protocol methods

extension DashboardViewController: AddItemViewControllerDelegate, ItemControllerDelegate, InventoryDelegate, EditItemDelegate, SettingsDelegate {
    
    func itemWasEdited() {
        updateViews()
    }

    func saleWasMade() {
        updateViews()
    }

    func itemWasDeleted() {
        updateViews()
    }

    func itemWasAdded() {
        updateViews()
    }
    
    func dataWasErased() {
        updateViews()
    }

}
