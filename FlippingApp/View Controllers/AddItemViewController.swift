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
    var date = Date()
    let dateFormatter = DateFormatter()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingPriceTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagTextField: UITextView!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Easter egg
        if titleTextField.text == "Gnomes!" {
            UserDefaults.standard.setValue(true, forKey: "gnomes")
        } else if titleTextField.text == "Gnomes Be Gone!" {
            UserDefaults.standard.setValue(false, forKey: "gnomes")
        }
        
        guard let purchasePrice: Double = Double(purchasePriceTextField.text!) else { rejectInvalidInput(); return }
        guard let listingPrice: Double = Double(listingPriceTextField.text!) else { rejectInvalidInput(); return }
        guard let quantity: Int = Int(quantityTextField.text!) else { rejectInvalidInput(); return }
        
        if purchasePrice > 1000000 || purchasePrice < 0 { rejectOutOfBoundsPurchasePrice(); return }
        if listingPrice > 1000000 || listingPrice < 0 { rejectOutOfBoundsListingPrice(); return }
        if quantity > 100000 || quantity < 0 { rejectOutOfBoundsQuantity(); return }
        
        if let title = titleTextField.text,
           !title.isEmpty {
            let item = Item(title: title,
                            purchasePrice: purchasePrice,
                            listingPrice: listingPrice,
                            quantity: quantity,
                            tag: tagTextField.text,
                            notes: notesTextField.text,
                            listedDate: date)
            itemController?.addListedItem(with: item)
            delegate?.itemWasAdded()
            self.dismiss(animated: true, completion: nil)
        } else {
            rejectInvalidInput()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
        configureViews()
        configureColors()
    }
    
    func configureViews() {
        tagTextField.layer.cornerRadius = 4
        dateTextField.layer.cornerRadius = 4
        notesTextField.layer.cornerRadius = 4
        
        tagButton.layer.shadowOpacity = 0.7
        tagButton.layer.cornerRadius = 10
        tagButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        tagButton.layer.shadowRadius = 1
        tagButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        tagButton.layer.masksToBounds = false
        
        dateButton.layer.shadowOpacity = 0.7
        dateButton.layer.cornerRadius = 10
        dateButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        dateButton.layer.shadowRadius = 1
        dateButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        dateButton.layer.masksToBounds = false
        
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.cornerRadius = 12
        saveButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        saveButton.layer.masksToBounds = false
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateTextField.text = "\(dateFormatter.string(from: date))"
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        contentView.backgroundColor = UIColor(named: "Background")
        
        titleTextField.backgroundColor = UIColor(named: "Foreground")
        purchasePriceTextField.backgroundColor = UIColor(named: "Foreground")
        listingPriceTextField.backgroundColor = UIColor(named: "Foreground")
        quantityTextField.backgroundColor = UIColor(named: "Foreground")
        tagTextField.backgroundColor = UIColor(named: "Foreground")
        dateTextField.backgroundColor = UIColor(named: "Foreground")
        notesTextField.backgroundColor = UIColor(named: "Foreground")
        
        titleLabel.textColor = UIColor(named: "Text")
        purchasePriceLabel.textColor = UIColor(named: "Text")
        listingPriceLabel.textColor = UIColor(named: "Text")
        quantityLabel.textColor = UIColor(named: "Text")
        tagLabel.textColor = UIColor(named: "Text")
        dateLabel.textColor = UIColor(named: "Text")
        notesLabel.textColor = UIColor(named: "Text")
        
        tagButton.backgroundColor = UIColor(named: "Foreground")
        dateButton.backgroundColor = UIColor(named: "Foreground")
        saveButton.backgroundColor = UIColor(named: "Foreground")
    }
    
    // MARK: - Methods
    
    func rejectInvalidInput() {
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
        configureColors()
    }
    
    func rejectOutOfBoundsPurchasePrice() {
        let alert = UIAlertController(title: "Invalid purchase price", message: "The purchase price you entered was either below 0 or above $1,000,000.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func rejectOutOfBoundsListingPrice() {
        let alert = UIAlertController(title: "Invalid listing price", message: "The listing price you entered was either below 0 or above $1,000,000.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func rejectOutOfBoundsQuantity() {
        let alert = UIAlertController(title: "Invalid quantity", message: "The quantity you entered was either below 0 or above 100,000.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TagPopover" {
            guard let tagPopoverVC = segue.destination as? TagTableViewController else { return }
            tagPopoverVC.itemController = itemController
            tagPopoverVC.delegate = self
            tagPopoverVC.modalPresentationStyle = .popover
            tagPopoverVC.preferredContentSize = CGSize(width: self.view.bounds.width/2, height: self.view.bounds.height/2.5)
            tagPopoverVC.popoverPresentationController?.delegate = self
            tagPopoverVC.popoverPresentationController?.sourceRect = CGRect(origin: tagTextField.center, size: .zero)
            tagPopoverVC.popoverPresentationController?.sourceView = tagTextField
        } else if segue.identifier == "DatePopover" {
            guard let datePopoverVC = segue.destination as? DatePickerViewController else { return }
            datePopoverVC.delegate = self
            datePopoverVC.modalPresentationStyle = .popover
            datePopoverVC.preferredContentSize = CGSize(width: 340, height: 260)
            datePopoverVC.popoverPresentationController?.delegate = self
            datePopoverVC.popoverPresentationController?.sourceRect = CGRect(origin: dateTextField.center, size: .zero)
            datePopoverVC.popoverPresentationController?.sourceView = dateTextField
        }
    }
    
}

extension AddItemViewController: TagDataDelegate, DateDataDelegate {
    
    func passDate(_ date: Date) {
        dateTextField.text = dateFormatter.string(from: date)
        self.date = date
    }
    
    func passData(_ tag: String) {
        tagTextField.text = tag
    }
    
}

extension AddItemViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
