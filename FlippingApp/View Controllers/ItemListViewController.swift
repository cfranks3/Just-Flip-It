//
//  InventoryViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var filteredItems: [Item]!
    var searchType: String!
    var viewingSold: Bool?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        preventSelling()
    }
    
    // MARK: - Methods
    
    func preventSelling() {
        if let viewingSold = viewingSold {
            if viewingSold {
                searchBar.placeholder = "Search for a sold item"
                tableView.isUserInteractionEnabled = false
            } else {
                searchBar.placeholder = "Search your inventory"
                tableView.isUserInteractionEnabled = true
            }
        }
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
        cell.itemQuantityLabel.text = "Quantity: \(formattedQuantity ?? "-1")"
        
        formatter.numberStyle = .currency
        if let listingPrice = filteredItems[indexPath.row].listingPrice {
            let formattedNumber = formatter.string(from: listingPrice as NSNumber)
            cell.valueLabel.text = "\(formattedNumber ?? "-1")"
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchType == "inventory" {
            guard let data = itemController?.inventory else { return }
            filteredItems = searchText.isEmpty ? data : data.filter({(item: Item) -> Bool in
                return item.title.range(of: searchText, options: .caseInsensitive) != nil
            })
        } else if searchType == "soldItems" {
            guard let data = itemController?.soldItems else { return }
            filteredItems = searchText.isEmpty ? data : data.filter({(item: Item) -> Bool in
                return item.title.range(of: searchText, options: .caseInsensitive) != nil
            })
        }

        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSegue" {
            guard let detailVC = segue.destination as? ItemDetailViewController else { return }
            if let indexPath = tableView.indexPath(for: sender as! ItemTableViewCell) {
                detailVC.item = filteredItems[indexPath.row]
                detailVC.itemController = itemController
                detailVC.delegate = self
            }
        }
    }

}

extension ItemListViewController: ItemDetailDelegate {
    func saleWasMade() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
