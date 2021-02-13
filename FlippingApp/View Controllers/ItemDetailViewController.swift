//
//  ItemDetailViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

protocol ItemDetailDelegate {
    func saleWasMade()
}

class ItemDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var item: Item?
    var delegate: ItemDetailDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var amountSoldTextField: UITextField!
    @IBOutlet weak var soldPriceTextField: UITextField!
    
    // MARK: - IBAction
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
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
            } else {
                guard let soldPrice = Double(soldPrice) else { return }
                guard let quantitySold = Int(quantitySold) else { return }
                let soldItem = Item(title: item.title,
                                    purchasePrice: item.purchasePrice,
                                    soldPrice: soldPrice,
                                    quantity: quantitySold)
                itemController?.processSale(sold: soldItem, listed: item)
                presentingViewController?.dismiss(animated: true, completion: nil)
                delegate?.saleWasMade()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountSoldTextField.becomeFirstResponder()
        updateViews()
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
    }

}
