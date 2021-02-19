//
//  TagTableViewController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/18/21.
//

import UIKit

class TagTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var itemController: ItemController?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell", for: indexPath)

        return cell
    }

}
