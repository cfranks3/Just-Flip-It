//
//  ItemController.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class ItemController {
    
    // MARK: - Properties
    
    var inventory: [Item] = []
    var soldItems: [Item] = []
    var sales = 0
    
    // MARK: - Methods
    
    func addListedItem(with item: Item) {
        inventory.append(item)
        save()
    }
    
    func removeListedItem(with item: Item) {
        if inventory.contains(item) {
            inventory.removeAll { $0 == item }
        } else {
            NSLog("Error: Nonexistent item could not be removed.")
        }
    }
    
    // Permanently deletes all stored data!
    func resetData() {
        soldItems.removeAll()
        inventory.removeAll()
        save()
    }
    
    // MARK: - Persistence
    
    var inventoryURL: URL? {
        let fm = FileManager.default
        guard let directory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return directory.appendingPathComponent("Inventory.plist")
    }
    
    var soldItemsURL: URL? {
        let fm = FileManager.default
        guard let directory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return directory.appendingPathComponent("SoldItems.plist")
    }
    
    // Saving data
    func save() {
        let encoder = PropertyListEncoder()
        
        do {
            let inventoryData = try encoder.encode(inventory)
            let soldItemData = try encoder.encode(soldItems)
            
            if let inventoryURL = inventoryURL {
                try inventoryData.write(to: inventoryURL)
            }
            
            if let soldItemsURL = soldItemsURL {
                try soldItemData.write(to: soldItemsURL)
            }
            
        } catch {
            NSLog("Error encoding items: \(error.localizedDescription)")
        }
    }
    
    // Loading data
    func load() {
        let decoder = PropertyListDecoder()
        let fm = FileManager.default
        
        guard let inventoryURL = inventoryURL,
              fm.fileExists(atPath: inventoryURL.path) else { return }
        
        guard let soldItemsURL = soldItemsURL, fm.fileExists(atPath: soldItemsURL.path) else { return }
        
        do {
            let inventoryData = try Data(contentsOf: inventoryURL)
            let soldItemsData = try Data(contentsOf: soldItemsURL)
            let decodedInventory = try decoder.decode([Item].self, from: inventoryData)
            let decodedSoldItems = try decoder.decode([Item].self, from: soldItemsData)
            inventory = decodedInventory
            soldItems = decodedSoldItems
        } catch {
            NSLog("Error decoding items: \(error.localizedDescription)")
        }
    }
    
}
