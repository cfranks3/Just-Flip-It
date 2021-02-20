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
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var purchasePriceTextField: UITextField!
    @IBOutlet weak var listingPriceLabel: UILabel!
    @IBOutlet weak var listingPriceTextField: UITextField!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagTextView: UITextView!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
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
        
        if let title = titleTextField.text,
           !title.isEmpty {
            let editedItem = Item(title: title,
                                  purchasePrice: purchasePrice,
                                  listingPrice: listingPrice,
                                  quantity: quantity,
                                  tag: tagTextView.text,
                                  notes: notesTextView.text, listedDate: item.listedDate)
            itemController?.editItem(with: editedItem, replacing: item, at: index)
            delegate?.itemWasEdited()
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        configureColors()
    }
    
    func updateViews() {
        guard let listingPrice = item?.listingPrice else { return }
        guard let purchasePrice = item?.purchasePrice else { return }
        guard let quantity = item?.quantity else { return }
        
        titleTextField.text = item?.title
        quantityTextField.text = "\(quantity)"
        purchasePriceTextField.text = "\(purchasePrice)"
        listingPriceTextField.text = "\(listingPrice)"
        
        tagTextView.text = item?.tag
        tagTextView.layer.cornerRadius = 4
        tagButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 12
        
        if let notes = item?.notes { notesTextView.text = notes }
        notesTextView.layer.cornerRadius = 4
        
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowColor = UIColor(rgb: 0x1d3557).cgColor
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        saveButton.layer.masksToBounds = false
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        titleTextField.backgroundColor = UIColor(named: "Foreground")
        listingPriceTextField.backgroundColor = UIColor(named: "Foreground")
        purchasePriceTextField.backgroundColor = UIColor(named: "Foreground")
        quantityTextField.backgroundColor = UIColor(named: "Foreground")
        notesTextView.backgroundColor = UIColor(named: "Foreground")
        tagTextView.backgroundColor = UIColor(named: "Foreground")
        
        listingPriceLabel.textColor = UIColor(named: "Text")
        notesLabel.textColor = UIColor(named: "Text")
        tagLabel.textColor = UIColor(named: "Text")
        purchasePriceLabel.textColor = UIColor(named: "Text")
        
        tagButton.backgroundColor = UIColor(named: "Foreground")
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
        if segue.identifier == "ShowPopOver" {
            guard let popOverVC = segue.destination as? TagTableViewController else { return }
            popOverVC.itemController = itemController
            popOverVC.preferredContentSize = CGSize(width: 180, height: 240)
            popOverVC.modalPresentationStyle = .popover
            popOverVC.popoverPresentationController?.delegate = self
            popOverVC.popoverPresentationController?.sourceRect = CGRect(origin: tagTextView.center, size: .zero)
            popOverVC.popoverPresentationController?.sourceView = tagTextView
            popOverVC.delegate = self
        }
    }
    
}

extension EditItemViewController: TagDataDelegate {
    func passData(_ tag: String) {
        tagTextView.text = tag
    }
}

extension EditItemViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
