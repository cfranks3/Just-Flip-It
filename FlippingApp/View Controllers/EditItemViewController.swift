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
        if let quantity = quantityTextField.text,
           !quantity.isEmpty,
           let listingPrice = listingPriceTextField.text,
           !listingPrice.isEmpty {
            let editedItem = Item(title: titleTextField.text ?? item.title,
                                  purchasePrice: item.purchasePrice,
                                  listingPrice: Double(listingPrice) ?? 0,
                                  quantity: Int(quantity) ?? 0,
                                  tag: tagTextView.text,
                                  notes: notesTextView.text)
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
        guard let quantity = item?.quantity else { return }
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        titleTextField.text = item?.title
        quantityTextField.text = "\(quantity)"
        formatter.numberStyle = .currency
        listingPriceTextField.text = "\(listingPrice)"
        
        tagTextView.text = item?.tag
        tagTextView.layer.cornerRadius = 4
        tagButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 12
        
        if let notes = item?.notes { notesTextView.text = notes }
        notesTextView.layer.cornerRadius = 4
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        titleTextField.backgroundColor = UIColor(named: "Foreground")
        listingPriceTextField.backgroundColor = UIColor(named: "Foreground")
        quantityTextField.backgroundColor = UIColor(named: "Foreground")
        notesTextView.backgroundColor = UIColor(named: "Foreground")
        tagTextView.backgroundColor = UIColor(named: "Foreground")
        
        listingPriceLabel.textColor = UIColor(named: "Text")
        notesLabel.textColor = UIColor(named: "Text")
        tagLabel.textColor = UIColor(named: "Text")
        
        tagButton.backgroundColor = UIColor(named: "Foreground")
        saveButton.backgroundColor = UIColor(named: "Foreground")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopOver" {
            guard let popOverVC = segue.destination as? TagTableViewController else { return }
            popOverVC.itemController = itemController
            popOverVC.preferredContentSize = CGSize(width: 150, height: 150)
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
        print(tag)
        tagTextView.text = tag
    }
}

extension EditItemViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
