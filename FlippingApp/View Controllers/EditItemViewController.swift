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
    
    var itemController: ItemController?
    var delegate: EditItemDelegate?
    var item: Item?
    var index: Int?
    var date: Date?
    let dateFormatter = DateFormatter()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingPriceTextField: UITextField!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let item = item else { return }
        guard let index = index else { return }
        
        guard let purchasePrice: Double = Double(purchasePriceTextField.text!) else { rejectInvalidInput(); return }
        guard let listingPrice: Double = Double(listingPriceTextField.text!) else { rejectInvalidInput(); return }
        guard let quantity: Int = Int(quantityTextField.text!) else { rejectInvalidInput(); return }
        
        if purchasePrice > 1000000 || purchasePrice < 0 { rejectOutOfBoundsPurchasePrice(); return }
        if listingPrice > 1000000 || listingPrice < 0 { rejectOutOfBoundsListingPrice(); return }
        if quantity > 100000 || quantity < 0 { rejectOutOfBoundsQuantity(); return }
        
        if let title = titleTextField.text, !title.isEmpty {
            let editedItem = Item(title: title,
                                  purchasePrice: purchasePrice,
                                  listingPrice: listingPrice,
                                  quantity: quantity,
                                  tag: tagTextView.text,
                                  notes: notesTextView.text,
                                  listedDate: date)
            itemController?.editItem(with: editedItem, replacing: item, at: index)
            delegate?.itemWasEdited()
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureColors()
    }
    
    func configureViews() {
        guard let item = item else { return }
        dateFormatter.dateFormat = "MMMM d, yyyy"
        titleTextField.text = item.title
        purchasePriceTextField.text = "\(item.purchasePrice)"
        listingPriceTextField.text = "\(item.listingPrice)"
        quantityTextField.text = "\(item.quantity)"
        tagTextView.text = item.tag
        if let itemDate = item.listedDate {
            self.date = itemDate
            dateTextView.text = dateFormatter.string(from: itemDate)
        } else {
            self.date = Date()
            dateTextView.text = dateFormatter.string(from: Date())
        }
        
        notesTextView.text = item.notes
        
        tagTextView.layer.cornerRadius = 4
        dateTextView.layer.cornerRadius = 4
        notesTextView.layer.cornerRadius = 4
        tagButton.layer.cornerRadius = 10
        dateButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 12
        
        dateButton.layer.shadowOpacity = 0.7
        dateButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        dateButton.layer.shadowRadius = 1
        dateButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        dateButton.layer.masksToBounds = false
        
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        saveButton.layer.masksToBounds = false
        
        tagButton.layer.shadowOpacity = 0.7
        tagButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        tagButton.layer.shadowRadius = 1
        tagButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        tagButton.layer.masksToBounds = false
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        titleTextField.backgroundColor = UIColor(named: "Foreground")
        listingPriceTextField.backgroundColor = UIColor(named: "Foreground")
        purchasePriceTextField.backgroundColor = UIColor(named: "Foreground")
        quantityTextField.backgroundColor = UIColor(named: "Foreground")
        dateTextView.backgroundColor = UIColor(named: "Foreground")
        notesTextView.backgroundColor = UIColor(named: "Foreground")
        tagTextView.backgroundColor = UIColor(named: "Foreground")
        
        listingPriceLabel.textColor = UIColor(named: "Text")
        quantityLabel.textColor = UIColor(named: "Text")
        notesLabel.textColor = UIColor(named: "Text")
        tagLabel.textColor = UIColor(named: "Text")
        dateLabel.textColor = UIColor(named: "Text")
        purchasePriceLabel.textColor = UIColor(named: "Text")
        
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
            guard let popOverVC = segue.destination as? TagTableViewController else { return }
            popOverVC.itemController = itemController
            popOverVC.delegate = self
            popOverVC.modalPresentationStyle = .popover
            popOverVC.preferredContentSize = CGSize(width: 180, height: 240)
            popOverVC.popoverPresentationController?.delegate = self
            popOverVC.popoverPresentationController?.sourceRect = CGRect(origin: tagTextView.center, size: .zero)
            popOverVC.popoverPresentationController?.sourceView = tagTextView
        } else if segue.identifier == "DatePopover" {
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

extension EditItemViewController: TagDataDelegate, DateDataDelegate {
    
    func passDate(_ date: Date) {
        self.date = date
        dateTextView.text = dateFormatter.string(from: date)
    }
    
    func passData(_ tag: String) {
        tagTextView.text = tag
    }
    
}

extension EditItemViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
