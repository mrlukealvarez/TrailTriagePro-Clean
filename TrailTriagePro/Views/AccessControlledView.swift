//
//  AccessControlledView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Subscription access control wrapper!
//


import SwiftUI

/// Wraps content and shows paywall if user doesn't have access
struct AccessControlledView<Content: View>: View {
    @State private var showPaywall = false
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        contentView
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .task {
                // Check access status when view appears
                await StoreManager.shared.updatePurchasedProducts()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if StoreManager.shared.hasFullAccess {
            content
        } else {
            LockedContentView {
                showPaywall = true
            }
        }
    }
}

/// View shown when content is locked
fileprivate struct LockedContentView: View {
    let onUnlock: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.fill")
                .font(.system(size: 60))
                .foregroundStyle(.gray)
            
            VStack(spacing: 8) {
                Text("Premium Content")
                    .font(.title.bold())
                
                Text("Unlock full access to all WFR protocols and reference materials")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onUnlock()
            } label: {
                Text("Unlock Now")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}

// MARK: - View Extension
extension View {
    /// Requires full access to view content
    func requiresFullAccess() -> some View {
        AccessControlledView {
            self
        }
    }
}

#Preview("Locked") {
    NavigationStack {
        LockedContentView {
            print("Unlock tapped")
        }
    }
}

#Preview("Has Access") {
    NavigationStack {
        Text("Full Content Available")
            .requiresFullAccess()
    }
}
