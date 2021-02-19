//
//  TagViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/18/21.
//

import UIKit

protocol TagDataDelegate {
    func passData(_ tag: String)
}

class TagTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var addTagButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func addTagTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add New Tag", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your tag name here"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            if let newTag = alertController.textFields![0].text {
                if newTag.isEmpty { return }
                if let tagWasAdded = self.itemController?.addTag(with: newTag) {
                    if !tagWasAdded {
                        let alert = UIAlertController(title: "Tag already exists", message: "The tag you've created already exists.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    var itemController: ItemController?
    var delegate: TagDataDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemController?.tags.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)
        cell.textLabel?.text = itemController?.tags[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tags = itemController?.tags {
            delegate?.passData(tags[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let tagToDelete = itemController?.tags[indexPath.row] {
            itemController?.deleteTag(with: tagToDelete)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}
