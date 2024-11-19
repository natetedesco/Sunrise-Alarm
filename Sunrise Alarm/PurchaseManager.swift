//
//  PurchaseManager.swift
//  Sunrise Alarm
//  Created by Developer on 4/27/24.
//


import StoreKit
import SwiftUI

@Observable class PurchaseManager {
    static let shared = PurchaseManager()
    private(set) var proAccess: Bool {
        get {
            UserDefaults.standard.bool(forKey: "ProAccess")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ProAccess")
        }
    }
    
    let productIds = ["sunrise_alarm_pro_yearly"]
    var productsLoaded = false
    var updates: Task<Void, Never>? = nil
    
    var selectedProduct: Product? = nil
    var products: [Product] = []
    var purchasedProductIDs = Set<String>()
    
    private init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.selectedProduct = products[0]
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case .success(.unverified):
            print("Purchase success but unverified")
        case .pending:
            print("Purchase pending")
        case .userCancelled:
            print("Purchase cancelled")
        @unknown default:
            print("Unknown purchase result")
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
                proAccess = true
                print("Pro access granted")
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
                proAccess = false
                print("Pro access revoked")
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}
