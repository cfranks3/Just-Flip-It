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
    var inventoryValue: Double = 0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var inventoryValueLabel: UILabel!
    @IBOutlet weak var numberOfSalesLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        let helpMessage = """
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemController.loadItems()
        calculateInventoryValue()
    }
    
    // MARK: - Methods
    
    func calculateInventoryValue() {
        inventoryValue = 0
        
        for item in itemController.listedItems {
            if item.quantity > 1 {
                var count = item.quantity
                while count > 0 {
                    inventoryValue += item.listingPrice
                    count -= 1
                }
            } else {
                inventoryValue += item.listingPrice
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let formattedValue = formatter.string(from: inventoryValue as NSNumber) {
            inventoryValueLabel.text = formattedValue
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
            settingsVC.delegate = self
        }
    }
    
}

extension DashboardViewController: AddItemViewControllerDelegate {
    
    func itemWasAdded() {
        calculateInventoryValue()
    }
    
}
