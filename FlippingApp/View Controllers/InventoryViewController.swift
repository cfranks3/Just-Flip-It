//
//  InventoryViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var filteredItems: [Item]!
    var saleMode: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        filteredItems = itemController?.inventory
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        cell.itemNameLabel.text = filteredItems[indexPath.row].title
        let formattedQuantity = formatter.string(from: (filteredItems[indexPath.row].quantity) as NSNumber)
        cell.itemQuantityLabel.text = formattedQuantity
        
        formatter.numberStyle = .currency
        let formattedNumber = formatter.string(from: (filteredItems[indexPath.row].listingPrice) as NSNumber)
        cell.valueLabel.text = "\(formattedNumber ?? "-1")"
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let data = itemController?.inventory else { return }
        filteredItems = searchText.isEmpty ? data : data.filter({(item: Item) -> Bool in
            return item.title.range(of: searchText, options: .caseInsensitive) != nil
        })

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
