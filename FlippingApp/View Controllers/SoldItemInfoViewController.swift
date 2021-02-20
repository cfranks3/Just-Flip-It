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
    let numberFormatter = NumberFormatter()
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
    @IBOutlet weak var daysListedLabel: UILabel!
    @IBOutlet weak var daysListedForLabel: UILabel!
    @IBOutlet weak var profitStackView: UIStackView!
    @IBOutlet weak var upperBannerView: UIView!
    @IBOutlet weak var lowerBannerView: UIView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        configureColors()
    }
    
    func updateViews() {
        var profit = 0.0
        profitStackView.layer.cornerRadius = 12
        
        guard let item = item else { return }
        guard let soldPrice = item.soldPrice else { return }
        
        if item.quantity > 1 {
            soldItemLabel.text = "\(item.quantity)x \(item.title)"
            var count = item.quantity
            while count > 0 {
                profit += item.soldPrice! - item.purchasePrice
                count -= 1
            }
        } else {
            soldItemLabel.text = item.title
            profit += soldPrice - item.purchasePrice
        }
        
        numberFormatter.numberStyle = .currency
        purchasedPriceLabel.text = numberFormatter.string(from: item.purchasePrice as NSNumber)
        soldPriceLabel.text = numberFormatter.string(from: item.soldPrice as NSNumber? ?? -1)
        profitMadeLabel.text = numberFormatter.string(from: profit as NSNumber)
        
        dateFormatter.dateFormat = "EEEE,\nMMM d, yyyy"
        
        guard let date = item.soldDate else {
            dateSoldLabel.text = "Unknown"
            return
        }
        
        let dateString = dateFormatter.string(from: date)
        dateSoldLabel.text = dateString
        
        guard let listedDate = item.listedDate else {
            dateSoldLabel.text = "Unknown"
            return
        }
        
        if let diffInDays = Calendar.current.dateComponents([.day], from: listedDate, to: date).day {
            numberFormatter.numberStyle = .none
            daysListedForLabel.text = numberFormatter.string(from: diffInDays as NSNumber)
        } else {
            daysListedForLabel.text = "Unknown"
        }
        
        
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        soldItemLabel.textColor = UIColor(named: "Text")
        purchasedLabel.textColor = UIColor(named: "Text")
        purchasedPriceLabel.textColor = UIColor(named: "Text")
        soldLabel.textColor = UIColor(named: "Text")
        soldPriceLabel.textColor = UIColor(named: "Text")
        profitLabel.textColor = .white
        profitMadeLabel.textColor = .white
        //profitStackView.backgroundColor = UIColor(named: "Foreground")
        dateLabel.textColor = UIColor(named: "Text")
        dateSoldLabel.textColor = UIColor(named: "Text")
        daysListedLabel.textColor = UIColor(named: "Text")
        daysListedForLabel.textColor = UIColor(named: "Text")
        upperBannerView.backgroundColor = UIColor(named: "Foreground")
        lowerBannerView.backgroundColor = UIColor(named: "Foreground")
    }

}
