//
//  ItemSaleViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit
import SwiftConfettiView

class ItemSaleViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var item: Item?
    var delegate: ItemControllerDelegate?
    var date: Date = Date()
    let dateFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentQuantityLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var amountSoldTextField: UITextField!
    @IBOutlet weak var soldPriceLabel: UILabel!
    @IBOutlet weak var soldPriceTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
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
                                    listingPrice: item.listingPrice,
                                    soldPrice: soldPrice,
                                    quantity: quantitySold,
                                    tag: item.tag ?? "",
                                    notes: item.notes,
                                    listedDate: item.listedDate,
                                    soldDate: date)
                itemController?.processSale(sold: soldItem, listed: item)
                presentingViewController?.dismiss(animated: true, completion: nil)
                delegate?.saleWasMade()
            }
        }
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountSoldTextField.becomeFirstResponder()
        updateViews()
        confetti()
    }
    
    func updateViews() {
        guard let item = item else { return }
        dateFormatter.dateFormat = "MMMM d, yyyy"
        numberFormatter.numberStyle = .decimal
        
        titleLabel.text = item.title
        quantityLabel.text = "Quantity: \(numberFormatter.string(from: item.quantity as NSNumber) ?? "-1")"
        amountSoldTextField.text = "\(item.quantity)"
        soldPriceTextField.text = "\(item.listingPrice)"
        
        doneButton.layer.cornerRadius = 12
        dateButton.layer.cornerRadius = 10
        
        dateTextView.layer.cornerRadius = 4
        dateTextView.text = dateFormatter.string(from: date)
        
        configureColors()
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        titleLabel.textColor = UIColor(named: "Text")
        dateTextView.textColor = .white
        currentQuantityLabel.textColor = UIColor(named: "Text")
        quantityLabel.textColor = UIColor(named: "Text")
        soldPriceLabel.textColor = UIColor(named: "Text")
        dateLabel.textColor = UIColor(named: "Text")
        
        amountSoldTextField.backgroundColor = UIColor(named: "Foreground")
        soldPriceTextField.backgroundColor = UIColor(named: "Foreground")
        dateTextView.backgroundColor = UIColor(named: "Foreground")
        
        doneButton.backgroundColor = UIColor(named: "Foreground")
        dateButton.backgroundColor = UIColor(named: "Foreground")
        doneButton.tintColor = .white
        dateButton.tintColor = .white
    }
    
    // MARK: - Methods
    
    func confetti() {
        let confettiView = SwiftConfettiView(frame: self.view.bounds)
        if UserDefaults.standard.bool(forKey: "gnomes") {
            guard let image = UIImage(named: "gnome") else { return }
            let targetSize = CGSize(width: 8, height: 12)
            let widthScaleRatio = targetSize.width / image.size.width
            let heightScaleRatio = targetSize.height / image.size.height
            let scaleFactor = min(widthScaleRatio, heightScaleRatio)
            let scaledImageSize = CGSize(width: image.size.width * scaleFactor,
                                         height: image.size.height * scaleFactor)
            let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
            let scaledImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
            }
            confettiView.intensity = 0.4
            confettiView.layer.opacity = 0.3
            confettiView.type = .image(scaledImage)
        } else {
            confettiView.type = .confetti
            confettiView.intensity = 1
            confettiView.colors = [UIColor.systemRed, UIColor.systemGreen, UIColor.systemBlue]
        }
        
        confettiView.isUserInteractionEnabled = false
        
        self.view.addSubview(confettiView)
        confettiView.startConfetti()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DatePopover" {
            guard let datePopoverVC = segue.destination as? DatePickerViewController else { return }
            datePopoverVC.delegate = self
            datePopoverVC.modalPresentationStyle = .popover
            datePopoverVC.preferredContentSize = CGSize(width: 340, height: 260)
            datePopoverVC.popoverPresentationController?.delegate = self
            datePopoverVC.popoverPresentationController?.sourceRect = CGRect(origin: dateTextView.center, size: .zero)
            datePopoverVC.popoverPresentationController?.sourceView = dateTextView
        }
    }
}

extension ItemSaleViewController: DateDataDelegate {
    
    func passDate(_ date: Date) {
        self.date = date
        dateTextView.text = dateFormatter.string(from: date)
    }
    
}

extension ItemSaleViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
