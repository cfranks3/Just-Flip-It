//
//  SettingsViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var delegate: AddItemViewControllerDelegate?
    
    // MARK: - IBActions
    
    @IBAction func resetDataButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Warning!", message: "Proceeding will permanently delete all stored user data. This includes all sales, profit, and inventory. This cannot be reversed.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I Understand", style: .destructive) { (_) in
            UserDefaults.standard.setValue(false, forKey: "gnomes")
            self.itemController?.resetData()
            self.delegate?.itemWasAdded()
        }
        let cancel = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
}
