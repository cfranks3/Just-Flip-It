//
//  Item.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/12/21.
//

import UIKit

struct Item: Codable, Equatable {
    
    // MARK: - Properties
    
    var title: String
    var purchasePrice: Double
    var listingPrice: Double
    var quantity: Int
    
}
