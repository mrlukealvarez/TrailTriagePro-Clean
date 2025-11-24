//
//  StoreManager.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: StoreKit 2 purchase management for subscriptions and lifetime access!
//

import Foundation
import StoreKit

/// Manages all in-app purchases, subscriptions, and donations
@MainActor
@Observable
final class StoreManager {
    static let shared = StoreManager()
    
    // MARK: - Product IDs
    // Replace these with your actual product IDs from App Store Connect
    enum ProductID {
        // Your app subscriptions/purchases
        static let lifetimePurchase = "com.wfr.trailtriage.lifetime"
        static let monthlySubscription = "com.wfr.trailtriage.monthly"
        
        // Donation tiers for Friends of Custer Search and Rescue
        static let donationSmall = "com.wfr.trailtriage.donation.small"  // $5
        static let donationMedium = "com.wfr.trailtriage.donation.medium" // $10
        static let donationLarge = "com.wfr.trailtriage.donation.large"   // $25
        static let donationXLarge = "com.wfr.trailtriage.donation.xlarge" // $50
        
        // Tip jar for developer
        static let tipSmall = "com.wfr.trailtriage.tip.small"   // $2.99
        static let tipMedium = "com.wfr.trailtriage.tip.medium" // $4.99
        static let tipLarge = "com.wfr.trailtriage.tip.large"   // $9.99
    }
    
    // MARK: - State
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var subscriptionStatus: Product.SubscriptionInfo.Status?
    var isLoading = false
    var loadError: Error?
    
    // Trial tracking
    private let trialDurationDays = 7
    private let trialStartKey = "trialStartDate"
    
    // Convenience computed properties
    var hasLifetimeAccess: Bool {
        purchasedProductIDs.contains(ProductID.lifetimePurchase)
    }
    
    var hasActiveSubscription: Bool {
        guard let status = subscriptionStatus else { return false }
        return status.state == .subscribed || status.state == .inGracePeriod
    }
    
    var isInActiveTrial: Bool {
        guard let trialStart = UserDefaults.standard.object(forKey: trialStartKey) as? Date else {
            // No trial started yet, start it now
            UserDefaults.standard.set(Date(), forKey: trialStartKey)
            return true
        }
        
        let daysElapsed = Calendar.current.dateComponents([.day], from: trialStart, to: Date()).day ?? 0
        return daysElapsed < trialDurationDays
    }
    
    var trialDaysRemaining: Int {
        guard let trialStart = UserDefaults.standard.object(forKey: trialStartKey) as? Date else {
            return trialDurationDays
        }
        
        let daysElapsed = Calendar.current.dateComponents([.day], from: trialStart, to: Date()).day ?? 0
        return max(0, trialDurationDays - daysElapsed)
    }
    
    var hasFullAccess: Bool {
        hasLifetimeAccess || hasActiveSubscription || isInActiveTrial
    }
    
    // Free trial status
    var isInFreeTrial: Bool {
        guard let status = subscriptionStatus else { return false }
        if status.state == .subscribed,
           case .verified(let transaction) = status.transaction,
           transaction.offer?.type == .introductory {
            return true
        }
        return false
    }
    
    // MARK: - Update Listener Task
    private var updateListenerTask: Task<Void, Never>?
    
    private init() {
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    // MARK: - Load Products
    func loadProducts() async {
        isLoading = true
        loadError = nil
        
        do {
            let productIDs = [
                ProductID.lifetimePurchase,
                ProductID.monthlySubscription,
                ProductID.donationSmall,
                ProductID.donationMedium,
                ProductID.donationLarge,
                ProductID.donationXLarge,
                ProductID.tipSmall,
                ProductID.tipMedium,
                ProductID.tipLarge
            ]
            
            products = try await Product.products(for: productIDs)
            print("✅ Loaded \(products.count) products")
            print("📦 Products: \(products.map { "\($0.id): \($0.displayName)" })")
        } catch {
            loadError = error
            print("❌ Failed to load products: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Purchase
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            // Update purchased products
            await updatePurchasedProducts()
            
            // Always finish the transaction
            await transaction.finish()
            
            return true
            
        case .userCancelled:
            return false
            
        case .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async throws {
        try await AppStore.sync()
        await updatePurchasedProducts()
    }
    
    // MARK: - Update Purchased Products
    func updatePurchasedProducts() async {
        var newPurchasedIDs: Set<String> = []
        
        // Check for lifetime purchase and consumables
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.productType == .nonConsumable {
                // Lifetime purchase
                newPurchasedIDs.insert(transaction.productID)
            }
            
            // Note: Consumables (tips and donations) don't grant entitlements
            // They are processed and finished immediately
        }
        
        // Check subscription status
        if let product = products.first(where: { $0.id == ProductID.monthlySubscription }),
           let subscription = product.subscription {
            let statuses = try? await subscription.status
            
            if let status = statuses?.first {
                subscriptionStatus = status
                
                // If subscribed, add to purchased IDs
                if status.state == .subscribed || status.state == .inGracePeriod {
                    newPurchasedIDs.insert(ProductID.monthlySubscription)
                }
            }
        }
        
        purchasedProductIDs = newPurchasedIDs
    }
    
    // MARK: - Listen for Transactions
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            // Listen for transaction updates
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else {
                    continue
                }
                
                await self?.updatePurchasedProducts()
                await transaction.finish()
            }
        }
    }
    
    // MARK: - Verify Transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Product Accessors
    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }
    
    var lifetimeProduct: Product? {
        product(for: ProductID.lifetimePurchase)
    }
    
    var monthlyProduct: Product? {
        product(for: ProductID.monthlySubscription)
    }
    
    var donationProducts: [Product] {
        [
            ProductID.donationSmall,
            ProductID.donationMedium,
            ProductID.donationLarge,
            ProductID.donationXLarge
        ].compactMap { product(for: $0) }
    }
    
    var tipProducts: [Product] {
        [
            ProductID.tipSmall,
            ProductID.tipMedium,
            ProductID.tipLarge
        ].compactMap { product(for: $0) }
    }
}

// MARK: - Store Errors
enum StoreError: Error {
    case failedVerification
    case productNotFound
}
