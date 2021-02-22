//
//  Item.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

class Item: NSObject, Codable {
    
    var title: String
    var purchasePrice: Double
    var listingPrice: Double
    var soldPrice: Double?
    var quantity: Int
    var tag: String?
    var notes: String?
    var soldDate: Date?
    var listedDate: Date?
    
    // New item
    init(title: String, purchasePrice: Double, listingPrice: Double, quantity: Int, tag: String?, notes: String?, listedDate: Date?) {
        self.title = title
        self.purchasePrice = purchasePrice
        self.listingPrice = listingPrice
        self.quantity = quantity
        self.tag = tag
        self.notes = notes ?? ""
        self.listedDate = listedDate
    }
    
    // Sold item
    init(title: String, purchasePrice: Double, listingPrice: Double, soldPrice: Double, quantity: Int, tag: String?, notes: String?, listedDate: Date?, soldDate: Date?) {
        self.title = title
        self.purchasePrice = purchasePrice
        self.listingPrice = listingPrice
        self.soldPrice = soldPrice
        self.quantity = quantity
        self.tag = tag
        self.notes = notes ?? ""
        self.listedDate = listedDate
        self.soldDate = soldDate
    }
    
}
