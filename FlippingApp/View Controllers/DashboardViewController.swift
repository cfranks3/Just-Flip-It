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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemController.loadItems()
        calculateInventoryValue()
        updateViews()
    }
    
    func updateViews() {
        inventoryValueLabel.text = "$\(inventoryValue)"
    }
    
    // MARK: - Methods
    
    func calculateInventoryValue() {
        inventoryValue = 0
        for item in itemController.listedItems {
            inventoryValue += item.listingPrice
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            guard let addItemVC = segue.destination as? AddItemViewController else { return }
            addItemVC.itemController = itemController
            addItemVC.delegate = self
        }
    }

}

extension DashboardViewController: AddItemViewControllerDelegate {
    
    func itemWasAdded() {
        calculateInventoryValue()
        updateViews()
    }

}
