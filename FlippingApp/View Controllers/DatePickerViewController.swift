//
//  DatePickerViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/26/21.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureColors()
    }
    
    // MARK: - Methods
    
    func configureViews() {
        saveButton.layer.cornerRadius = 12
    }
    
    func configureColors() {
        view.backgroundColor = UIColor(named: "Background")
        saveButton.backgroundColor = UIColor(named: "Foreground")
    }

}
