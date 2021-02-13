//
//  ItemDetailViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var amountSoldTextField: UITextField!
    @IBOutlet weak var soldPriceTextField: UITextField!
    
    // MARK: - IBAction
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        print("Done!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
