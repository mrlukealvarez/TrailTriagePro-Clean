//
//  PaywallView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Subscription purchase UI!
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    headerSection
                    
                    // Features
                    featuresSection
                    
                    // Pricing Options
                    pricingSection
                    
                    // Restore Purchases
                    restorePurchasesButton
                    
                    // Legal Links
                    legalLinksSection
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if isPurchasing {
                    purchasingOverlay
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    showError = false
                }
            } message: {
                Text(errorMessage ?? "An error occurred")
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "cross.case.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
            
            Text("Unlock Full Access")
                .font(.title.bold())
            
            Text("Get unlimited access to all WFR protocols and reference materials")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top)
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            PaywallFeatureItem(
                icon: "checkmark.circle.fill",
                title: "Complete WFR Reference",
                description: "80+ hours of wilderness medicine content"
            )
            
            PaywallFeatureItem(
                icon: "wifi.slash",
                title: "100% Offline Access",
                description: "Available everywhere, even in the backcountry"
            )
            
            PaywallFeatureItem(
                icon: "arrow.triangle.2.circlepath",
                title: "Regular Updates",
                description: "Content updated with latest WFR standards"
            )
            
            PaywallFeatureItem(
                icon: "star.fill",
                title: "Bookmark & Favorites",
                description: "Quick access to your most-used protocols"
            )
        }
        .padding(.horizontal)
    }
    
    private var pricingSection: some View {
        VStack(spacing: 16) {
            Text("Choose Your Plan")
                .font(.headline)
            
            // Lifetime Purchase - Best Value
            if let lifetimeProduct = StoreManager.shared.lifetimeProduct {
                PaywallPricingCard(
                    title: "Lifetime Access",
                    subtitle: "One-time purchase",
                    price: lifetimeProduct.displayPrice,
                    badge: "BEST VALUE",
                    badgeColor: .green,
                    isPopular: true
                ) {
                    await purchaseProduct(lifetimeProduct)
                }
            }
            
            // Monthly Subscription with Free Trial
            if let monthlyProduct = StoreManager.shared.monthlyProduct {
                PaywallPricingCard(
                    title: "Monthly",
                    subtitle: "3-day free trial, then \(monthlyProduct.displayPrice)/month",
                    price: "Try Free",
                    badge: nil,
                    badgeColor: .blue,
                    isPopular: false
                ) {
                    await purchaseProduct(monthlyProduct)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var restorePurchasesButton: some View {
        Button {
            Task {
                do {
                    try await StoreManager.shared.restorePurchases()
                    if StoreManager.shared.hasFullAccess {
                        dismiss()
                    } else {
                        errorMessage = "No previous purchases found"
                        showError = true
                    }
                } catch {
                    errorMessage = "Failed to restore purchases"
                    showError = true
                }
            }
        } label: {
            Text("Restore Purchases")
                .font(.subheadline)
                .foregroundStyle(.blue)
        }
    }
    
    private var legalLinksSection: some View {
        HStack(spacing: 20) {
            NavigationLink("Terms of Service") {
                TermsOfServiceView()
            }
            .font(.caption)
            
            Text("•")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            NavigationLink("Privacy Policy") {
                PrivacyPolicyView()
            }
            .font(.caption)
        }
        .padding(.bottom)
    }
    
    private var purchasingOverlay: some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .overlay {
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
            }
    }
    
    // MARK: - Actions
    
    private func purchaseProduct(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let success = try await StoreManager.shared.purchase(product)
            if success {
                try? await Task.sleep(nanoseconds: 500_000_000)
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Supporting Views

private struct PaywallFeatureItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct PaywallPricingCard: View {
    let title: String
    let subtitle: String
    let price: String
    let badge: String?
    let badgeColor: Color
    let isPopular: Bool
    let action: () async -> Void
    
    @State private var isPurchasing = false
    
    var body: some View {
        Button {
            Task {
                isPurchasing = true
                await action()
                isPurchasing = false
            }
        } label: {
            VStack(spacing: 0) {
                if let badge = badge {
                    Text(badge)
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(badgeColor)
                        .clipShape(Capsule())
                        .offset(y: -10)
                }
                
                VStack(spacing: 12) {
                    VStack(spacing: 4) {
                        Text(title)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(price)
                        .font(.title.bold())
                        .foregroundStyle(.blue)
                    
                    if isPurchasing {
                        ProgressView()
                            .padding(.vertical, 8)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(
                            color: isPopular ? .blue.opacity(0.3) : .black.opacity(0.1),
                            radius: isPopular ? 12 : 8
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isPopular ? Color.blue : Color.clear, lineWidth: isPopular ? 2 : 0)
                )
            }
        }
        .disabled(isPurchasing)
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview {
    PaywallView()
}
