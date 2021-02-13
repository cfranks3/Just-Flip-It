//
//  InventoryViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

protocol InventoryDelegate {
    func itemWasDeleted()
}

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var filteredItems: [Item]!
    var searchType: String!
    var viewingSold: Bool?
    var readyToSell: Bool?
    var delegate: InventoryDelegate?
    
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
        } else {
            if let soldPrice = filteredItems[indexPath.row].soldPrice {
                let formattedNumber = formatter.string(from: soldPrice as NSNumber)
                cell.valueLabel.text = "\(formattedNumber ?? "-1")"
            }
            
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if let viewingSold = viewingSold {
                if !viewingSold {
                    itemController?.deleteItem(with: filteredItems[indexPath.row])
                    filteredItems.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .bottom)
                    delegate?.itemWasDeleted()
                }
            }
        if filteredItems.count == 0 {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let readyToSell = readyToSell {
            if readyToSell {
                guard let saleVC = storyboard?.instantiateViewController(identifier: "SaleVC") as? ItemSaleViewController else { return }
                saleVC.item = filteredItems[indexPath.row]
                saleVC.delegate = self
                saleVC.itemController = itemController
                present(saleVC, animated: true, completion: nil)
            } else {
                guard let editVC = storyboard?.instantiateViewController(identifier: "EditVC") as? EditItemViewController else { return }
                editVC.item = filteredItems[indexPath.row]
                editVC.itemController = itemController
                editVC.delegate = self
                editVC.index = indexPath.row
                present(editVC, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - Protocol methods

extension InventoryViewController: ItemControllerDelegate {
    func saleWasMade() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension InventoryViewController: EditItemDelegate {
    func itemWasEdited() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
