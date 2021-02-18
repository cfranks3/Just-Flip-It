//
//  JFIIAPHandler.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/17/21.
//

import StoreKit
import UIKit

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: - Properties
    
    static let shared = IAPManager()
    
    private var completion: ((Double) -> Void)?
    
    // Add cases here as new IAPs are added
    enum Product: String, CaseIterable {
        case tier1Tip = "JFITierOneTip"
        
        var count: Double {
            switch self {
            case .tier1Tip:
                return 0.99
            }
        }
    }
    
    var products = [SKProduct]()
    
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    func purchase(product: Product, completion: @escaping ((Double) -> Void)) {
        guard SKPaymentQueue.canMakePayments() else { return }
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product.rawValue }) else { return }
        self.completion = completion
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                break
            case .purchased:
                if let product = Product(rawValue: $0.payment.productIdentifier) {
                    completion?(product.count)
                }
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            case .failed:
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    
}