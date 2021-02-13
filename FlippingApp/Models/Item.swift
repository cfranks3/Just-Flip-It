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
    var listingPrice: Double?
    var soldPrice: Double?
    var quantity: Int
    
    // New item
    init(title: String, purchasePrice: Double, listingPrice: Double, quantity: Int) {
        self.title = title
        self.purchasePrice = purchasePrice
        self.listingPrice = listingPrice
        self.quantity = quantity
    }
    
    // Sold item
    init(title: String, purchasePrice: Double, soldPrice: Double, quantity: Int) {
        self.title = title
        self.purchasePrice = purchasePrice
        self.soldPrice = soldPrice
        self.quantity = quantity
    }
    
}
