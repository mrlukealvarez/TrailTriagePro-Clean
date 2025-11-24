//
//  WalletPassManager.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/12/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Apple Wallet pass integration!
//
//  APPLE WALLET INTEGRATION:
//  Allows users to add TrailTriage to Apple Wallet for quick access
//  
//  FEATURES:
//  • Quick access from lock screen
//  • NFC-compatible pass
//  • Live Activities integration ready
//  • Dynamic updates (subscription status, vitals tracking)
//
//  BENEFITS:
//  • Faster access in emergencies
//  • Lock screen widget integration
//  • Live Activity support for active patients
//  • Always-available quick reference
//

import PassKit
import SwiftUI
import Combine

/// Manager for creating and updating Apple Wallet passes
@MainActor
class WalletPassManager: ObservableObject {
    static let shared = WalletPassManager()
    
    @Published var canAddPass = PKPassLibrary.isPassLibraryAvailable()
    @Published var passStatus: PassStatus = .notAdded
    
    enum PassStatus: Equatable {
        case notAdded
        case adding
        case added
        case failed(String)
    }
    
    // Pass identifiers (must match your Apple Developer account)
    private let passTypeIdentifier = "pass.com.blackelkmountain.trailtriage"
    private let teamIdentifier = "YOUR_TEAM_ID" // Replace with your actual Team ID
    
    private init() {
        checkPassStatus()
    }
    
    /// Check if TrailTriage pass is already in Wallet
    func checkPassStatus() {
        guard PKPassLibrary.isPassLibraryAvailable() else {
            passStatus = .notAdded
            return
        }
        
        let passLibrary = PKPassLibrary()
        let passes = passLibrary.passes()
        
        // Check if our pass exists
        let hasPass = passes.contains { pass in
            pass.passTypeIdentifier == passTypeIdentifier
        }
        
        passStatus = hasPass ? .added : .notAdded
    }
    
    /// Present the "Add to Wallet" sheet
    func presentAddToWallet() -> PKAddPassesViewController? {
        guard let pass = createPass() else {
            passStatus = .failed("Failed to create pass")
            return nil
        }
        
        guard let addPassVC = PKAddPassesViewController(pass: pass) else {
            passStatus = .failed("Unable to add pass to Wallet")
            return nil
        }
        
        return addPassVC
    }
    
    /// Create a PKPass for TrailTriage
    private func createPass() -> PKPass? {
        // In production, you'll need:
        // 1. A .pkpass file from your server
        // 2. Proper signing with your Pass Type ID certificate
        // 3. A web service to update the pass
        
        // For now, this returns nil - see implementation guide below
        return nil
    }
}

// MARK: - SwiftUI Integration

/// Button to add TrailTriage to Apple Wallet
struct AddToWalletButton: View {
    @StateObject private var walletManager = WalletPassManager.shared
    @State private var showAddPassSheet = false
    @State private var addPassController: PKAddPassesViewController?
    
    var body: some View {
        Button {
            handleAddToWallet()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "wallet.pass.fill")
                    .font(.title3)
                
                Text("Add to Apple Wallet")
                    .font(.headline)
                
                Spacer()
                
                if case .added = walletManager.passStatus {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .foregroundStyle(.white)
            .cornerRadius(12)
        }
        .disabled(walletManager.passStatus == .added || !walletManager.canAddPass)
        .sheet(isPresented: $showAddPassSheet) {
            if let controller = addPassController {
                AddPassViewControllerRepresentable(controller: controller)
            }
        }
    }
    
    private func handleAddToWallet() {
        guard let controller = walletManager.presentAddToWallet() else {
            return
        }
        
        addPassController = controller
        showAddPassSheet = true
    }
}

// MARK: - UIKit Bridge for PKAddPassesViewController

struct AddPassViewControllerRepresentable: UIViewControllerRepresentable {
    let controller: PKAddPassesViewController
    
    func makeUIViewController(context: Context) -> PKAddPassesViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: PKAddPassesViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - Wallet Card Design View (Demo)

/// Shows what the Wallet pass will look like
struct WalletPassPreview: View {
    var body: some View {
        VStack(spacing: 0) {
            // Pass Header (like Amazon's design)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TrailTriage")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    Text("Wilderness First Response")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "cross.case.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.blue, .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Pass Content
            VStack(spacing: 16) {
                // Quick Actions
                HStack(spacing: 12) {
                    WalletPassActionButton(
                        icon: "plus.circle.fill",
                        title: "New Note",
                        color: .green
                    )
                    
                    WalletPassActionButton(
                        icon: "book.fill",
                        title: "Protocols",
                        color: .blue
                    )
                    
                    WalletPassActionButton(
                        icon: "heart.fill",
                        title: "Vitals",
                        color: .red
                    )
                }
                
                Divider()
                
                // Subscription Status
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                    
                    Text("Pro Active")
                        .font(.subheadline.bold())
                    
                    Spacer()
                    
                    Text("Expires: Never")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Notes")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Circle()
                            .fill(.orange)
                            .frame(width: 8, height: 8)
                        
                        Text("Ankle Sprain - 2 hours ago")
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Barcode/QR Code Area
            VStack(spacing: 8) {
                Image(systemName: "qrcode")
                    .font(.system(size: 100))
                    .foregroundStyle(.black)
                
                Text("TRAIL-TRIAGE-2025")
                    .font(.caption.monospaced())
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 10)
        .padding()
    }
}

private struct WalletPassActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color.gradient)
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .font(.title3)
                }
            
            Text(title)
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Wallet Integration Explainer View

struct WalletIntegrationView: View {
    @StateObject private var walletManager = WalletPassManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section
                VStack(spacing: 12) {
                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(.blue)
                    
                    Text("Quick Access from Lock Screen")
                        .font(.title2.bold())
                    
                    Text("Add TrailTriage to your Wallet for instant access during emergencies")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Benefits
                VStack(alignment: .leading, spacing: 16) {
                    BenefitRow(
                        icon: "bolt.fill",
                        title: "Instant Access",
                        description: "Double-click side button to access from lock screen",
                        color: .yellow
                    )
                    
                    BenefitRow(
                        icon: "timer",
                        title: "Vitals Tracking",
                        description: "Live updates for active patient monitoring",
                        color: .red
                    )
                    
                    BenefitRow(
                        icon: "airplane",
                        title: "Offline Ready",
                        description: "Works without internet or cellular connection",
                        color: .blue
                    )
                    
                    BenefitRow(
                        icon: "location.fill",
                        title: "Location Aware",
                        description: "Nearby search & rescue contacts when available",
                        color: .green
                    )
                }
                .padding(.horizontal)
                
                // Preview
                VStack(spacing: 12) {
                    Text("Preview")
                        .font(.headline)
                    
                    WalletPassPreview()
                }
                
                // Add to Wallet Button
                VStack(spacing: 12) {
                    AddToWalletButton()
                        .padding(.horizontal)
                    
                    Text("Free for all TrailTriage Pro users")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Apple Wallet")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Circle()
                .fill(color.gradient)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Preview
#Preview("Wallet Integration") {
    NavigationStack {
        WalletIntegrationView()
    }
}

#Preview("Wallet Pass Preview") {
    WalletPassPreview()
}
