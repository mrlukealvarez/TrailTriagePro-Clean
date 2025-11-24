# IMMEDIATE FIX FOR COMPILATION ERRORS

## Problem
The new view files haven't been added to your Xcode project yet, causing "Ambiguous use of init()" errors.

## Solution: Temporary SettingsView (Until New Files Added)

Until you add all the new view files to your Xcode project, use this simplified SettingsView that only uses existing views:

```swift
//
//  SettingsView.swift (TEMPORARY - Safe Version)
//  WFR TrailTriage
//
//  Created by Luke Alvarez on 11/10/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showPaywall = false
    @State private var showSupport = false
    @State private var showManageSubscription = false
    #if DEBUG
    @State private var showDebugMenu = false
    #endif
    
    var body: some View {
        NavigationStack {
            List {
                // Subscription Status Section - Prominent at top
                Section {
                    if StoreManager.shared.hasFullAccess {
                        SubscriptionStatusRow()
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image(systemName: "lock.open.fill")
                                            .foregroundStyle(.white)
                                            .font(.title3)
                                    }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Unlock Full Access")
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text("Get unlimited access to all content")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // Premium Features & Support
                Section {
                    // Donate & Tips
                    Button {
                        showSupport = true
                    } label: {
                        SettingsRow(
                            icon: "heart.fill",
                            iconColor: .red,
                            title: "Donate & Tips",
                            subtitle: "Support development or Custer SAR"
                        )
                    }
                    
                    // Manage Subscription (if subscribed)
                    if StoreManager.shared.hasFullAccess {
                        Button {
                            showManageSubscription = true
                        } label: {
                            SettingsRow(
                                icon: "creditcard.fill",
                                iconColor: .blue,
                                title: "Manage Subscription",
                                subtitle: "View and manage your plan"
                            )
                        }
                        .manageSubscriptionsSheet(isPresented: $showManageSubscription)
                    } else {
                        // Upgrade Options
                        Button {
                            showPaywall = true
                        } label: {
                            SettingsRow(
                                icon: "star.fill",
                                iconColor: .orange,
                                title: "Upgrade Options",
                                subtitle: "View all subscription plans"
                            )
                        }
                    }
                } header: {
                    Text("Premium")
                }
                
                // Contact & Support
                Section {
                    Link(destination: URL(string: "https://mrlukealvarez.github.io/blackelkmountainmedicine.com/")!) {
                        HStack {
                            SettingsRow(
                                icon: "globe",
                                iconColor: .cyan,
                                title: "Visit Website",
                                subtitle: nil
                            )
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "mailto:support@blackelkmountainmedicine.com")!) {
                        HStack {
                            SettingsRow(
                                icon: "envelope.fill",
                                iconColor: .orange,
                                title: "Contact Support",
                                subtitle: nil
                            )
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Support")
                }
                
                #if DEBUG
                // Developer Section (DEBUG only)
                Section {
                    Button {
                        showDebugMenu = true
                    } label: {
                        SettingsRow(
                            icon: "hammer.fill",
                            iconColor: .orange,
                            title: "🐛 Debug Menu",
                            subtitle: "Developer tools"
                        )
                    }
                } header: {
                    Text("Developer")
                }
                #endif
                
                // App Version Info
                Section {
                    HStack {
                        Text("Version")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(Bundle.main.appVersion ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(Bundle.main.buildNumber ?? "1")
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    VStack(spacing: 8) {
                        Text("© 2025 Black Elk Mountain Medicine")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("TrailTriage: Professional SOAP note documentation for wilderness first responders")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showSupport) {
                SupportView()
            }
            #if DEBUG
            .sheet(isPresented: $showDebugMenu) {
                NavigationStack {
                    List {
                        Section("Onboarding") {
                            Button("Reset Onboarding") {
                                UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                                UserDefaults.standard.removeObject(forKey: "userID")
                            }
                        }
                        
                        Section("Subscription") {
                            Button("Check Status") {
                                Task {
                                    await StoreManager.shared.updatePurchasedProducts()
                                }
                            }
                            
                            Button("Restore Purchases") {
                                Task {
                                    try? await StoreManager.shared.restorePurchases()
                                }
                            }
                        }
                        
                        Section("Info") {
                            HStack {
                                Text("Has Full Access")
                                Spacer()
                                Text(StoreManager.shared.hasFullAccess ? "✅" : "❌")
                            }
                            
                            HStack {
                                Text("In Free Trial")
                                Spacer()
                                Text(StoreManager.shared.isInFreeTrial ? "✅" : "❌")
                            }
                        }
                    }
                    .navigationTitle("Debug Menu")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showDebugMenu = false
                            }
                        }
                    }
                }
            }
            #endif
        }
    }
}

// MARK: - Settings Row Component
private struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with colored background
            Circle()
                .fill(iconColor.gradient)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                }
            
            // Title & Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Subscription Status Row
private struct SubscriptionStatusRow: View {
    @State private var showManageSubscription = false
    
    var body: some View {
        VStack(alignment: leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(statusTitle)
                        .font(.headline)
                    
                    Text(statusSubtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            if StoreManager.shared.hasActiveSubscription {
                Button {
                    showManageSubscription = true
                } label: {
                    Text("Manage Subscription")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .cornerRadius(8)
                }
                .manageSubscriptionsSheet(isPresented: $showManageSubscription)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var statusTitle: String {
        if StoreManager.shared.hasLifetimeAccess {
            return "Lifetime Access"
        } else if StoreManager.shared.isInFreeTrial {
            return "Free Trial Active"
        } else if StoreManager.shared.hasActiveSubscription {
            return "Subscription Active"
        } else {
            return "Full Access"
        }
    }
    
    private var statusSubtitle: String {
        if StoreManager.shared.hasLifetimeAccess {
            return "You have unlimited access"
        } else if StoreManager.shared.isInFreeTrial {
            return "Enjoying your trial? Subscription starts after trial ends"
        } else if StoreManager.shared.hasActiveSubscription {
            return "Thank you for your support!"
        } else {
            return "All content unlocked"
        }
    }
}

// MARK: - Bundle Extensions
extension Bundle {
    var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}

#Preview {
    SettingsView()
}
```

## Steps to Fix:

### 1. Replace SettingsView.swift with the code above (TEMPORARY)
This will let your app compile while you're adding the new files.

### 2. Add all the new view files to your Xcode project:
- PreferencesView.swift
- ExportBackupView.swift
- AdvancedSettingsView.swift
- FAQView.swift
- AboutView.swift (if not already there)
- TermsOfServiceView.swift
- PrivacyPolicyView.swift
- SubscriptionStatusView.swift
- AppearanceManager.swift

### 3. Once all files are added, replace SettingsView with the full-featured version

## Quick Test:
After replacing SettingsView with the temporary version above, press ⌘B to build. It should compile successfully!
