//
//  SoldItemInfoViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/20/21.
//

import UIKit

class SoldItemInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var item: Item?
    var itemController: ItemController?
    let formatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var soldItemLabel: UILabel!
    @IBOutlet weak var purchasedLabel: UILabel!
    @IBOutlet weak var purchasedPriceLabel: UILabel!
    @IBOutlet weak var soldLabel: UILabel!
    @IBOutlet weak var soldPriceLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var profitMadeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateSoldLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        configureColors()
    }
    
    func updateViews() {
        guard let item = item else { return }
        guard let soldPrice = item.soldPrice else { return }
        
        soldItemLabel.text = item.title
        formatter.numberStyle = .currency
        purchasedPriceLabel.text = formatter.string(from: item.purchasePrice as NSNumber)
        soldPriceLabel.text = formatter.string(from: item.soldPrice as NSNumber? ?? -1)
        let profit = soldPrice - item.purchasePrice
        profitMadeLabel.text = formatter.string(from: profit as NSNumber)
        
        dateFormatter.dateFormat = "EEEE,\nMMM d, yyyy"
        guard let date = item.soldDate else {
            dateSoldLabel.text = "Unknown"
            return
        }
        let dateString = dateFormatter.string(from: date)
        dateSoldLabel.text = dateString
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        soldItemLabel.textColor = UIColor(named: "Text")
        purchasedLabel.textColor = UIColor(named: "Text")
        purchasedPriceLabel.textColor = UIColor(named: "Text")
        soldLabel.textColor = UIColor(named: "Text")
        soldPriceLabel.textColor = UIColor(named: "Text")
        profitLabel.textColor = UIColor(named: "Text")
        profitMadeLabel.textColor = UIColor(named: "Text")
        dateLabel.textColor = UIColor(named: "Text")
        dateSoldLabel.textColor = UIColor(named: "Text")
    }

}
