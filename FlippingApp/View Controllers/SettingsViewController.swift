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
        itemController?.resetData()
        delegate?.itemWasAdded()
    }

}
