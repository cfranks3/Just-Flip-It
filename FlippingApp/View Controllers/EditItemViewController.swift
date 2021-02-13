//
//  EditItemViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/13/21.
//

import UIKit

protocol EditItemDelegate {
    func itemWasEdited()
}

class EditItemViewController: UIViewController {
    
    // MARK: - Properties
    
    var item: Item?
    var itemController: ItemController?
    var delegate: EditItemDelegate?
    var index: Int?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var listingPriceTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let item = item else { return }
        guard let index = index else { return }
        if let quantity = quantityTextField.text,
           !quantity.isEmpty,
           let listingPrice = listingPriceTextField.text,
           !listingPrice.isEmpty {
            let editedItem = Item(title: titleTextField.text ?? item.title,
                                  purchasePrice: item.purchasePrice,
                                  listingPrice: Double(listingPrice) ?? 0,
                                  quantity: Int(quantity) ?? 0)
            itemController?.editItem(with: editedItem, replacing: item, at: index)
            delegate?.itemWasEdited()
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let listingPrice = item?.listingPrice else { return }
        guard let quantity = item?.quantity else { return }
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        titleTextField.text = item?.title
        quantityLabel.text = "Current quantity: \(formatter.string(from: quantity as NSNumber) ?? "-1")"
        quantityTextField.text = "\(quantity)"
        formatter.numberStyle = .currency
        listingPriceTextField.text = "\(listingPrice)"
    }

}
