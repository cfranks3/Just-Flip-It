//
//  AddItemViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class AddItemViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var listingPriceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let title = titleTextField.text,
           !title.isEmpty,
           let purchasePrice = purchasePriceTextField.text,
           !purchasePrice.isEmpty,
           let listingPrice = listingPriceTextField.text,
           !listingPrice.isEmpty,
           let quantity = quantityTextField.text,
           !quantity.isEmpty {
            let item = Item(title: title,
                            purchasePrice: Double(purchasePrice) ?? 0,
                            listingPrice: Double(listingPrice) ?? 0,
                            quantity: Int(quantity) ?? 0)
            itemController?.addListedItem(with: item)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
    }

}
