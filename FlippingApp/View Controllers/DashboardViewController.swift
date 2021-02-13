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
    let formatter = NumberFormatter()
    let collectionViewCategories: [String] = [
        "Inventory",
        "Sales",
    ]
    
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
        itemController.load()
        updateViews()
    }
    
    func updateViews() {
        formatter.numberStyle = .currency
        profitLabel.text = formatter.string(from: itemController.calculateProfit() as NSNumber)
        inventoryValueLabel.text = formatter.string(from: itemController.calculateInventoryValue() as NSNumber)
        
        formatter.numberStyle = .decimal
        numberOfSalesLabel.text = formatter.string(from: itemController.calculateSales() as NSNumber)
        
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

// MARK: - Protocol methods

extension DashboardViewController: AddItemViewControllerDelegate {
    
    func itemWasAdded() {
        updateViews()
    }
    
}

// MARK: - Collection view delegate & data source

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemGroupCollectionViewCell
        
        cell.groupLabel.text = self.collectionViewCategories[indexPath.row]
        
        cell.layer.borderColor = UIColor(rgb: 0x00B290).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selection = collectionViewCategories[indexPath.row]
        if selection == "Inventory" {
            guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return}
            inventoryVC.itemController = itemController
            
            present(inventoryVC, animated: true, completion: nil)
        } else if selection == "Sales" {
            // TODO
        } else {
            NSLog("Error: invalid collection view option tapped.")
        }
    }
    
}
