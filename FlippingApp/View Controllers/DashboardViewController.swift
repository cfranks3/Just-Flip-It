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
    @IBOutlet weak var recordSaleButton: UIButton!

    
    // MARK: - IBActions
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return }
        inventoryVC.itemController = itemController
        inventoryVC.filteredItems = itemController.inventory
        inventoryVC.viewingSold = false
        inventoryVC.delegate = self
        inventoryVC.searchType = "selling"
        present(inventoryVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemController.load()
        itemController.delegate = self
        updateViews()
    }
    
    func updateViews() {
        formatter.numberStyle = .currency
        profitLabel.text = formatter.string(from: itemController.calculateProfit() as NSNumber)
        inventoryValueLabel.text = formatter.string(from: itemController.calculateInventoryValue() as NSNumber)
        
        formatter.numberStyle = .decimal
        numberOfSalesLabel.text = formatter.string(from: itemController.calculateSales() as NSNumber)

        if UserDefaults.standard.bool(forKey: "gnomes") {
            title = "Gnomeboard"
        } else {
            title = "Dashboard"
        }

        recordSaleButton.backgroundColor = UIColor(rgb: 0x457b9d)
        recordSaleButton.layer.cornerRadius = 12
        recordSaleButton.setTitleColor(.white, for: .normal)
        recordSaleButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)

        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        updateColors()
    }

    func updateColors() {
        
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
        } else if segue.identifier == "ShowPopOver" {
            
        }
    }
    
}

// MARK: - Protocol methods

extension DashboardViewController: AddItemViewControllerDelegate, ItemControllerDelegate, InventoryDelegate, EditItemDelegate {
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
    
}

// MARK: - Collection view delegate & data source

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemGroupCollectionViewCell
        
        cell.groupLabel.text = self.collectionViewCategories[indexPath.row]
        cell.groupLabel.textColor = .white
        cell.layer.backgroundColor = UIColor(rgb: 0x457b9d).cgColor
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 128 * collectionViewCategories.count
        let totalSpacingWidth = 60 * (collectionViewCategories.count - 1)
        
        let leftInset = (CGFloat(view.frame.size.width) - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selection = collectionViewCategories[indexPath.row]
        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return}
        inventoryVC.itemController = itemController
        if selection == "Inventory" {
            inventoryVC.searchType = "inventory"
            inventoryVC.filteredItems = itemController.inventory
            inventoryVC.viewingSold = false
            inventoryVC.delegate = self
            present(inventoryVC, animated: true, completion: nil)
        } else if selection == "Sales" {
            inventoryVC.searchType = "soldItems"
            inventoryVC.filteredItems = itemController.soldItems
            inventoryVC.viewingSold = true
            inventoryVC.delegate = self
            present(inventoryVC, animated: true, completion: nil)
        } else {
            NSLog("Error: invalid collection view option tapped.")
        }
    }
    
}
