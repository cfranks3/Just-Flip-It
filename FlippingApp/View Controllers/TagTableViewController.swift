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
    
}
