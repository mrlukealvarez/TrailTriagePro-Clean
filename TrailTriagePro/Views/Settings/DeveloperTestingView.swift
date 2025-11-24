//
//  DeveloperTestingView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Developer testing utilities!
//
//  TESTING TOOLS:
//  Comprehensive testing interface for all app flows
//  
//  FEATURES:
//  • Subscription testing (purchase, cancel, restore)
//  • Onboarding flow testing
//  • All screen navigation
//  • StoreKit transaction management
//  • Quick reset tools
//
//  ACCESS:
//  Add to Settings → Developer Tools (only show in debug builds)
//

import SwiftUI
import StoreKit

/// Developer-only testing tools
/// Add this to your Settings view during development
struct DeveloperTestingView: View {
    @State private var showPaywall = false
    @State private var showOnboarding = false
    @State private var showAllScreens = false
    @State private var testStatus = ""
    @State private var showAlert = false
    
    var body: some View {
        List {
            // Subscription Status Section
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    StatusRow(
                        title: "Has Full Access",
                        value: StoreManager.shared.hasFullAccess,
                        icon: "checkmark.seal.fill"
                    )
                    
                    StatusRow(
                        title: "Has Lifetime",
                        value: StoreManager.shared.hasLifetimeAccess,
                        icon: "infinity"
                    )
                    
                    StatusRow(
                        title: "Has Subscription",
                        value: StoreManager.shared.hasActiveSubscription,
                        icon: "arrow.triangle.2.circlepath"
                    )
                    
                    StatusRow(
                        title: "In Free Trial",
                        value: StoreManager.shared.isInFreeTrial,
                        icon: "gift.fill"
                    )
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack {
                        Text("Products Loaded:")
                            .font(.subheadline)
                        Spacer()
                        Text("\(StoreManager.shared.products.count)")
                            .font(.subheadline.bold())
                            .foregroundStyle(StoreManager.shared.products.isEmpty ? .red : .green)
                    }
                    
                    HStack {
                        Text("Purchased IDs:")
                            .font(.subheadline)
                        Spacer()
                        Text("\(StoreManager.shared.purchasedProductIDs.count)")
                            .font(.subheadline.bold())
                    }
                }
            } header: {
                Text("Current Status")
            }
            
            // Quick Actions Section
            Section {
                Button {
                    Task {
                        await StoreManager.shared.updatePurchasedProducts()
                        testStatus = "✅ Refreshed subscription status"
                        showAlert = true
                    }
                } label: {
                    Label("Refresh Subscription Status", systemImage: "arrow.clockwise")
                }
                
                Button {
                    Task {
                        do {
                            try await StoreManager.shared.restorePurchases()
                            testStatus = "✅ Restored purchases"
                        } catch {
                            testStatus = "❌ Failed: \(error.localizedDescription)"
                        }
                        showAlert = true
                    }
                } label: {
                    Label("Restore Purchases", systemImage: "arrow.down.circle")
                }
                
                Button {
                    showPaywall = true
                } label: {
                    Label("Show Paywall", systemImage: "creditcard")
                }
                
                Button {
                    showOnboarding = true
                } label: {
                    Label("Show Onboarding", systemImage: "hand.wave")
                }
            } header: {
                Text("Quick Actions")
            }
            
            // StoreKit Testing Section
            Section {
                Button {
                    openStoreKitTransactionManager()
                } label: {
                    Label("Open StoreKit Transaction Manager", systemImage: "list.bullet.clipboard")
                }
                
                Button {
                    clearAllTransactions()
                } label: {
                    Label("Clear All Transactions", systemImage: "trash")
                }
                .foregroundStyle(.red)
            } header: {
                Text("StoreKit Testing")
            } footer: {
                Text("Use Transaction Manager in Xcode: Debug → StoreKit → Manage Transactions")
                    .font(.caption)
            }
            
            // Navigation Testing Section
            Section {
                Button {
                    showAllScreens = true
                } label: {
                    Label("View All Screens", systemImage: "square.grid.3x3")
                }
            } header: {
                Text("Screen Testing")
            }
            
            // Product Details Section
            Section {
                ForEach(StoreManager.shared.products, id: \.id) { product in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(product.displayName)
                                .font(.subheadline.bold())
                            
                            Spacer()
                            
                            Text(product.displayPrice)
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                        
                        Text(product.id)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if StoreManager.shared.purchasedProductIDs.contains(product.id) {
                            Label("PURCHASED", systemImage: "checkmark.circle.fill")
                                .font(.caption.bold())
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("Available Products")
            }
        }
        .navigationTitle("Developer Testing")
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showOnboarding) {
            OnboardingView(isPresented: $showOnboarding)
        }
        .sheet(isPresented: $showAllScreens) {
            AllScreensNavigator()
        }
        .alert("Test Result", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(testStatus)
        }
    }
    
    private func openStoreKitTransactionManager() {
        testStatus = """
        To manage transactions:
        
        1. While app is running in Xcode
        2. Menu: Debug → StoreKit → Manage Transactions
        3. You can:
           • View all purchases
           • Cancel subscriptions
           • Expire subscriptions
           • Clear all transactions
           • Speed up renewal for testing
        """
        showAlert = true
    }
    
    private func clearAllTransactions() {
        testStatus = """
        ⚠️ To clear transactions:
        
        1. Stop the app
        2. Xcode: Debug → StoreKit → Manage Transactions
        3. Click "Delete All"
        4. Rebuild and run
        
        This will reset all purchases for testing.
        """
        showAlert = true
    }
}

// MARK: - Status Row
private struct StatusRow: View {
    let title: String
    let value: Bool
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(value ? .green : .gray)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(value ? .green : .gray)
        }
    }
}

// MARK: - All Screens Navigator
struct AllScreensNavigator: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Core Screens") {
                    NavigationLink("Paywall") {
                        PaywallView()
                    }
                    
                    NavigationLink("Settings") {
                        SettingsView()
                    }
                    
                    NavigationLink("Support (Donations & Tips)") {
                        SupportView()
                    }
                }
                
                Section("Reference Screens") {
                    NavigationLink("Reference Book") {
                        ReferenceBookView()
                    }
                    
                    NavigationLink("Glossary") {
                        GlossaryView()
                    }
                    
                    NavigationLink("FAQ") {
                        FAQView()
                    }
                    
                    NavigationLink("About") {
                        AboutView()
                    }
                }
                
                Section("Legal") {
                    NavigationLink("Terms of Service") {
                        TermsOfServiceView()
                    }
                    
                    NavigationLink("Privacy Policy") {
                        PrivacyPolicyView()
                    }
                }
                
                Section("Notes") {
                    NavigationLink("New Note") {
                        NewNoteView()
                    }
                    
                    NavigationLink("My Notes") {
                        NotesListView()
                    }
                }
            }
            .navigationTitle("All Screens")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Placeholder Views (to be implemented)
// Note: These stubs are only used for testing when real implementations don't exist yet

struct ReferenceBookView: View {
    var body: some View {
        Text("Reference Book")
            .navigationTitle("Reference Book")
    }
}

// Note: All placeholders below have real implementations in separate files
// Real implementations: GlossaryView, NewNoteView, FAQView, AboutView, TermsOfServiceView, OnboardingView, NotesListView, SupportView, PrivacyPolicyView

// MARK: - Preview
#Preview {
    NavigationStack {
        DeveloperTestingView()
    }
}
