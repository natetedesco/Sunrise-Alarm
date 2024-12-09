//
//  PurchaseManager.swift
//  Sunrise Alarm
//  Created by Developer on 4/27/24.
//

import StoreKit
import SwiftUI

class Purchases: ObservableObject {
    static let shared = Purchases()
    
    @AppStorage("proAccess") var proAccess: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @Published var showPaywall = false

    @Published var updates: Task<Void, Never>? = nil
    @Published var productsLoaded = false
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()
    @Published var selectedProduct: Product? = nil
    
    let productIds = ["sunrise_alarm_pro_yearly"]
    
    private init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        products = try await Product.products(for: productIds)
        selectedProduct = products[0]
        productsLoaded = true
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
                purchasedProductIDs.insert(transaction.productID)
                proAccess = true
                print("Pro access granted")
            } else {
                purchasedProductIDs.remove(transaction.productID)
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
