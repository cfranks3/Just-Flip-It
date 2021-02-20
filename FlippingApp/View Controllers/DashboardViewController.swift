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
    
    // MARK: - IBOutlets
    @IBOutlet weak var profitView: UIView!
    @IBOutlet weak var inventoryView: UIView!
    @IBOutlet weak var soldItemsView: UIView!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var inventoryButton: UIButton!
    @IBOutlet weak var soldItemsButton: UIButton!
    @IBOutlet weak var recordSaleButton: UIButton!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var inventoryValueLabel: UILabel!
    @IBOutlet weak var inventoryQuantityLabel: UILabel!
    @IBOutlet weak var numberOfSalesLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func addItemButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func inventoryButtonTapped(_ sender: UIButton) {
        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "") else { return }
        print("Ping")
    }
    
    @IBAction func soldItemsButtonTapped(_ sender: UIButton) {
    }
    
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
        //itemController.load()
        //itemController.delegate = self
        configureViews()
        //updateViews()
    }
    
    func configureViews() {
        profitView.layer.cornerRadius = 12
        inventoryView.layer.cornerRadius = 12
        soldItemsView.layer.cornerRadius = 12
        inventoryButton.layer.cornerRadius = 12
        soldItemsButton.layer.cornerRadius = 12
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

//extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionViewCategories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemGroupCollectionViewCell
//
//        cell.groupLabel.text = self.collectionViewCategories[indexPath.row]
//        cell.groupLabel.textColor = .white
//        cell.layer.backgroundColor = UIColor(rgb: 0x457b9d).cgColor
//        cell.layer.cornerRadius = 12
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = 128 * collectionViewCategories.count
//        let totalSpacingWidth = 60 * (collectionViewCategories.count - 1)
//
//        let leftInset = (CGFloat(view.frame.size.width) - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selection = collectionViewCategories[indexPath.row]
//        guard let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryVC") as? InventoryViewController else { return}
//        inventoryVC.itemController = itemController
//        if selection == "Inventory" {
//            inventoryVC.searchType = "inventory"
//            inventoryVC.filteredItems = itemController.inventory
//            inventoryVC.viewingSold = false
//            inventoryVC.delegate = self
//            present(inventoryVC, animated: true, completion: nil)
//        } else if selection == "Sales" {
//            inventoryVC.searchType = "soldItems"
//            inventoryVC.filteredItems = itemController.soldItems
//            inventoryVC.viewingSold = true
//            inventoryVC.delegate = self
//            present(inventoryVC, animated: true, completion: nil)
//        } else {
//            NSLog("Error: invalid collection view option tapped.")
//        }
//    }
// }

