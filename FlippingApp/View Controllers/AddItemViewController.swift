//
//  AddItemViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

protocol AddItemViewControllerDelegate {
    func itemWasAdded()
}

class AddItemViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var delegate: AddItemViewControllerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var listingPriceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if titleTextField.text == "Gnomes!" {
            UserDefaults.standard.setValue(true, forKey: "gnomes")
        } else if titleTextField.text == "Gnomes Be Gone!" {
            UserDefaults.standard.setValue(false, forKey: "gnomes")
        }

        if let title = titleTextField.text,
           !title.isEmpty,
           let purchasePrice = purchasePriceTextField.text,
           !purchasePrice.isEmpty,
           let listingPrice = listingPriceTextField.text,
           !listingPrice.isEmpty,
           let quantity = quantityTextField.text,
           !quantity.isEmpty {
            let item = Item(title: title,
                            purchasePrice: Double(purchasePrice) ?? -1,
                            listingPrice: Double(listingPrice) ?? -1,
                            quantity: Int(quantity) ?? -1)
            itemController?.addListedItem(with: item)
            delegate?.itemWasAdded()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Hold on there...", message: "Are you sure you gave each text field a valid input? Check and try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            UIView.animate(withDuration: 5) {
                if self.titleTextField.text == "" {
                    self.titleTextField.backgroundColor = .systemRed
                    self.titleTextField.backgroundColor = .none
                }
                if self.purchasePriceTextField.text == "" {
                    self.purchasePriceTextField.backgroundColor = .systemRed
                    self.purchasePriceTextField.backgroundColor = .none
                }
                if self.listingPriceTextField.text == "" {
                    self.listingPriceTextField.backgroundColor = .systemRed
                    self.listingPriceTextField.backgroundColor = .none
                }
                if self.quantityTextField.text == "" {
                    self.quantityTextField.backgroundColor = .systemRed
                    self.quantityTextField.backgroundColor = .none
                }
            }
            
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
        if self.traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.barTintColor = .black
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0x457b9d)]
    }
    
}
