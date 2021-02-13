//
//  InventoryViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = itemController?.inventory.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        cell.itemNameLabel.text = itemController?.inventory[indexPath.row].title
        let formattedQuantity = formatter.string(from: (itemController?.inventory[indexPath.row].quantity ?? 0) as NSNumber)
        cell.itemQuantityLabel.text = formattedQuantity
        
        formatter.numberStyle = .currency
        let formattedNumber = formatter.string(from: (itemController?.inventory[indexPath.row].listingPrice ?? 0) as NSNumber)
        cell.valueLabel.text = "\(formattedNumber ?? "-1")"
        
        return cell
    }

}
