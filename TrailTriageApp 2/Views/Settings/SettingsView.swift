//
//  SettingsView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Main settings view!
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false
    @State private var showSupport = false
    @State private var showManageSubscription = false
    
    var body: some View {
        NavigationStack {
            List {
                // Subscription Status Section
                Section {
                    if StoreManager.shared.hasFullAccess {
                        SubscriptionStatusRow()
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Unlock Full Access")
                                        .font(.headline)
                                    
                                    Text("Get unlimited access to all content")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                } header: {
                    Text("Subscription")
                }
                
                // Support Section
                Section {
                    Button {
                        showSupport = true
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Support & Donate")
                                    .foregroundStyle(.primary)
                                
                                Text("Support development or donate to Custer SAR")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Support")
                } footer: {
                    Text("Donations to Friends of Custer Search and Rescue are tax deductible")
                }
                
                // Legal Section
                Section {
                    Link("Terms of Service", destination: URL(string: "https://mrlukealvarez.github.io/blackelkmountainmedicine.com/terms")!)
                    
                    NavigationLink("Privacy Policy") {
                        PrivacyPolicyView()
                    }
                } header: {
                    Text("Legal")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.appVersion ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.buildNumber ?? "1")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                } footer: {
                    VStack(spacing: 8) {
                        Text("Black Elk Mountain Medicine")
                            .font(.caption)
                        
                        Text("TrailTriage: Wilderness Medicine. Built by WFRs, for WFRs.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showSupport) {
                SupportView()
            }
            .manageSubscriptionsSheet(isPresented: $showManageSubscription)
        }
    }
}

// MARK: - Subscription Status Row
private struct SubscriptionStatusRow: View {
    @State private var showManageSubscription = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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

// MARK: - Bundle extensions (appVersion, buildNumber) are defined in Bundle+Extensions.swift

#Preview {
    SettingsView()
}
