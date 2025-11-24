//
//  SubscriptionStatusView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Assistant on 11/8/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Subscription status display!
//

import SwiftUI
import StoreKit

struct SubscriptionStatusView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subscriptionManager = SubscriptionManager()
    
    var body: some View {
        NavigationStack {
            List {
                // Current Status Section
                Section {
                    HStack {
                        Image(systemName: subscriptionManager.subscriptionStatus.icon)
                            .foregroundStyle(statusColor)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(subscriptionManager.subscriptionStatus.displayText)
                                .font(.headline)
                            
                            if subscriptionManager.subscriptionStatus == .inTrial {
                                Text("Enjoy your free trial!")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else if subscriptionManager.subscriptionStatus == .subscribed {
                                Text("Thank you for subscribing!")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Subscription Status")
                }
                
                // Features Section
                Section {
                    FeatureStatusRow(
                        icon: "doc.text.fill",
                        title: "Unlimited SOAP Notes",
                        isEnabled: subscriptionManager.hasActiveSubscription
                    )
                    FeatureStatusRow(
                        icon: "heart.text.square.fill",
                        title: "Advanced Assessments",
                        isEnabled: subscriptionManager.hasActiveSubscription
                    )
                    FeatureStatusRow(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Vitals Tracking",
                        isEnabled: subscriptionManager.hasActiveSubscription
                    )
                    FeatureStatusRow(
                        icon: "map.fill",
                        title: "GPS Coordinates",
                        isEnabled: subscriptionManager.hasActiveSubscription
                    )
                    FeatureStatusRow(
                        icon: "square.and.arrow.up.fill",
                        title: "PDF Export",
                        isEnabled: subscriptionManager.hasActiveSubscription
                    )
                } header: {
                    Text("Features")
                }
                
                // Management Section
                Section {
                    if subscriptionManager.hasActiveSubscription {
                        Button {
                            Task {
                                await subscriptionManager.manageSubscription()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "gear")
                                Text("Manage Subscription")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Button {
                            // Show paywall to subscribe
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundStyle(.orange)
                                Text("Subscribe to TrailTriage Pro")
                                Spacer()
                            }
                        }
                    }
                    
                    Button {
                        Task {
                            await subscriptionManager.restorePurchases()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Restore Purchase")
                        }
                    }
                    .disabled(subscriptionManager.isLoading)
                } header: {
                    Text("Actions")
                }
                
                // Info Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About TrailTriage Pro")
                            .font(.headline)
                        
                        Text("TrailTriage Pro gives you unlimited access to professional wilderness first responder documentation tools.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("• 3-day free trial")
                        Text("• $9.99/year after trial")
                        Text("• Cancel anytime")
                        
                        Text("Subscriptions auto-renew unless cancelled at least 24 hours before the end of the current period.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    .font(.caption)
                } header: {
                    Text("Information")
                }
            }
            .navigationTitle("Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .task {
                await subscriptionManager.checkSubscriptionStatus()
            }
        }
    }
    
    private var statusColor: Color {
        switch subscriptionManager.subscriptionStatus {
        case .notSubscribed, .expired:
            return .red
        case .inTrial:
            return .blue
        case .subscribed:
            return .green
        case .unknown:
            return .gray
        }
    }
}

struct FeatureStatusRow: View {
    let icon: String
    let title: String
    let isEnabled: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(isEnabled ? .blue : .gray)
                .frame(width: 24)
            
            Text(title)
                .foregroundStyle(isEnabled ? .primary : .secondary)
            
            Spacer()
            
            Image(systemName: isEnabled ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isEnabled ? .green : .gray)
        }
    }
}

#Preview {
    SubscriptionStatusView()
}
