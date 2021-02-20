//
//  ItemSaleViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class ItemSaleViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var item: Item?
    var delegate: ItemControllerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var amountSoldTextField: UITextField!
    @IBOutlet weak var soldPriceTextField: UITextField!
    @IBOutlet weak var currentQuantityLabel: UILabel!
    @IBOutlet weak var soldPriceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if let quantitySold = amountSoldTextField.text,
           !quantitySold.isEmpty,
           let soldPrice = soldPriceTextField.text,
           !soldPrice.isEmpty {
            guard let item = item else { return }
            if Int(quantitySold)! > item.quantity {
                let alert = UIAlertController(title: "Invalid quantity", message: "You're attempting to mark \(quantitySold) items as sold, but you only had \(item.quantity) in your inventory. Fix your quantity or edit the original item's quantity before proceeding.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else if Int(quantitySold)! <= 0 {
                let alert = UIAlertController(title: "Invalid quantity", message: "You're attempting to mark too few items as sold.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else {
                guard let soldPrice = Double(soldPrice) else { return }
                guard let quantitySold = Int(quantitySold) else { return }
                let soldItem = Item(title: item.title,
                                    purchasePrice: item.purchasePrice,
                                    soldPrice: soldPrice,
                                    quantity: quantitySold,
                                    tag: item.tag ?? "",
                                    notes: item.notes, soldDate: Date())
                itemController?.processSale(sold: soldItem, listed: item)
                presentingViewController?.dismiss(animated: true, completion: nil)
                delegate?.saleWasMade()
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountSoldTextField.becomeFirstResponder()
        updateViews()
        configureColors()
    }
    
    func updateViews() {
        guard let item = item else { return }
        guard let listingPrice = item.listingPrice else { return }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        titleLabel.text = item.title
        quantityLabel.text = "Quantity: \(formatter.string(from: item.quantity as NSNumber) ?? "-1")"
        amountSoldTextField.placeholder = formatter.string(from: item.quantity as NSNumber)
        
        formatter.numberStyle = .currency
        soldPriceTextField.placeholder = formatter.string(from: listingPrice as NSNumber)
        
        doneButton.layer.cornerRadius = 12
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        titleLabel.textColor = UIColor(named: "Text")
        currentQuantityLabel.textColor = UIColor(named: "Text")
        quantityLabel.textColor = UIColor(named: "Text")
        soldPriceLabel.textColor = UIColor(named: "Text")
        
        amountSoldTextField.backgroundColor = UIColor(named: "Foreground")
        soldPriceTextField.backgroundColor = UIColor(named: "Foreground")
        
        doneButton.backgroundColor = UIColor(named: "Foreground")
        doneButton.tintColor = .white
    }
    
}
