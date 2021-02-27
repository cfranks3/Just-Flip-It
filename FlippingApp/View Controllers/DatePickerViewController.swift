//
//  DatePickerViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/26/21.
//

import UIKit

protocol DateDataDelegate {
    func passDate(_ date: Date)
}

class DatePickerViewController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: DateDataDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    // MARK: - IBActions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if datePicker.date > Date() {
            let alert = UIAlertController(title: "Invalid Date", message: "Are you a time traveler? Change your date to either today or the past.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            delegate?.passDate(datePicker.date)
            self.dismiss(animated: true, completion: nil)
        }
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
