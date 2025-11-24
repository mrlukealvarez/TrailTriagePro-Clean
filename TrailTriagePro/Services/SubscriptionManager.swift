//
//  SubscriptionManager.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/8/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Subscription status tracking and entitlement management!
//

import Foundation
import StoreKit

/// Manages StoreKit 2 subscriptions for TrailTriage Pro
@Observable
class SubscriptionManager {
    // MARK: - Published Properties
    
    /// Whether the user has an active subscription
    var hasActiveSubscription = false
    
    /// Available subscription products from App Store
    var products: [Product] = []
    
    /// Current subscription status
    var subscriptionStatus: SubscriptionStatus = .notSubscribed
    
    /// Loading state
    var isLoading = false
    
    /// Error message if purchase fails
    var errorMessage: String?
    
    // MARK: - Product IDs
    
    // Note: This is a legacy implementation. StoreManager.swift is the primary subscription manager.
    // Product ID format matches App Store Connect configuration.
    private let yearlySubscriptionID = "com.trailtriage.pro.yearly"
    
    // MARK: - Subscription Status
    
    enum SubscriptionStatus: Equatable {
        case notSubscribed
        case inTrial
        case subscribed
        case expired
        case unknown
        
        var displayText: String {
            switch self {
            case .notSubscribed: return "Not Subscribed"
            case .inTrial: return "Free Trial Active"
            case .subscribed: return "Active Subscription"
            case .expired: return "Subscription Expired"
            case .unknown: return "Unknown Status"
            }
        }
        
        var icon: String {
            switch self {
            case .notSubscribed: return "xmark.circle"
            case .inTrial: return "clock.fill"
            case .subscribed: return "checkmark.circle.fill"
            case .expired: return "exclamationmark.triangle.fill"
            case .unknown: return "questionmark.circle"
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        // Start listening for transaction updates
        Task {
            await listenForTransactions()
        }
        
        // Load products and check subscription status
        Task {
            await loadProducts()
            await checkSubscriptionStatus()
        }
    }
    
    // MARK: - Product Loading
    
    /// Load available subscription products from App Store
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Fetch products from App Store
            let products = try await Product.products(for: [yearlySubscriptionID])
            
            await MainActor.run {
                self.products = products.sorted { $0.price < $1.price }
            }
        } catch {
            print("Failed to load products: \(error)")
            await MainActor.run {
                self.errorMessage = "Unable to load subscription options. Please try again."
            }
        }
    }
    
    // MARK: - Subscription Status Check
    
    /// Check current subscription status from StoreKit
    func checkSubscriptionStatus() async {
        // Check for active entitlements
        var hasValidSubscription = false
        var isInTrial = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                // User has a verified transaction
                hasValidSubscription = true
                
                // Check if it's in trial period
                if let expirationDate = transaction.expirationDate {
                    let purchaseDate = transaction.purchaseDate
                    let trialDuration = expirationDate.timeIntervalSince(purchaseDate)
                    // If trial is 3-4 days, consider it a trial
                    if trialDuration <= (4 * 24 * 60 * 60) {
                        isInTrial = true
                    }
                }
                
                // Finish the transaction
                await transaction.finish()
            }
        }
        
        // Update status on main thread
        await MainActor.run {
            self.hasActiveSubscription = hasValidSubscription
            
            if hasValidSubscription {
                self.subscriptionStatus = isInTrial ? .inTrial : .subscribed
            } else {
                self.subscriptionStatus = .notSubscribed
            }
        }
    }
    
    // MARK: - Purchase
    
    /// Purchase a subscription product
    func purchase(_ product: Product) async -> Bool {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Check verification result
                switch verification {
                case .verified(let transaction):
                    // Successful purchase
                    await transaction.finish()
                    await checkSubscriptionStatus()
                    return true
                    
                case .unverified(_, let error):
                    // Transaction failed verification
                    await MainActor.run {
                        self.errorMessage = "Purchase verification failed: \(error.localizedDescription)"
                    }
                    return false
                }
                
            case .userCancelled:
                // User cancelled the purchase
                return false
                
            case .pending:
                // Purchase is pending (e.g., Ask to Buy)
                await MainActor.run {
                    self.errorMessage = "Purchase is pending approval."
                }
                return false
                
            @unknown default:
                await MainActor.run {
                    self.errorMessage = "Unknown purchase result."
                }
                return false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Purchase failed: \(error.localizedDescription)"
            }
            return false
        }
    }
    
    // MARK: - Restore Purchases
    
    /// Restore previous purchases
    func restorePurchases() async -> Bool {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            try await AppStore.sync()
            await checkSubscriptionStatus()
            return hasActiveSubscription
        } catch {
            await MainActor.run {
                self.errorMessage = "Restore failed: \(error.localizedDescription)"
            }
            return false
        }
    }
    
    // MARK: - Transaction Listener
    
    /// Listen for transaction updates (purchases, renewals, etc.)
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                // Transaction updated (renewal, etc.)
                await transaction.finish()
                await checkSubscriptionStatus()
            }
        }
    }
    
    // MARK: - Manage Subscription
    
    /// Open the App Store subscription management page
    func manageSubscription() async {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            do {
                try await AppStore.showManageSubscriptions(in: scene)
            } catch {
                print("Failed to show manage subscriptions: \(error)")
            }
        }
    }
}
