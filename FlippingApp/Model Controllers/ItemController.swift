//
//  ItemController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class ItemController {
    
    // MARK: - Properties
    
    var listedItems: [Item] = []
    var soldItems: [Item] = []
    
    // MARK: - Methods
    
    func addListedItem(with item: Item) {
        listedItems.append(item)
        saveItems()
    }
    
    func removeListedItem(with item: Item) {
        if listedItems.contains(item) {
            listedItems.removeAll { $0 == item }
        } else {
            NSLog("Error: Nonexistent item could not be removed.")
        }
    }
    
    // Permanently deletes all stored data!
    func resetData() {
        soldItems.removeAll()
        listedItems.removeAll()
        saveItems()
    }
    
    // MARK: - Persistence
    
    // Documents directory
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Data file path
    func dataFilePath() -> URL {
        documentsDirectory().appendingPathComponent("Items.plist")
    }
    
    // Saving data
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(listedItems)
            try data.write(to: dataFilePath(), options: .atomic)
        } catch {
            NSLog("Error encoding items: \(error.localizedDescription)")
        }
    }
    
    // Loading data
    func loadItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                listedItems = try decoder.decode([Item].self, from: data)
            } catch {
                NSLog("Error decoding items: \(error.localizedDescription)")
            }
        }
    }
    
}
