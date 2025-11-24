//
//  SupportView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Support & donations!
//

import SwiftUI
import StoreKit

struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SupportTab = .donate
    
    enum SupportTab {
        case donate
        case tip
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Tab Picker
                    Picker("Support Type", selection: $selectedTab) {
                        Text("Donate to SAR").tag(SupportTab.donate)
                        Text("Tip Developer").tag(SupportTab.tip)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    // Content
                    if selectedTab == .donate {
                        DonationView()
                    } else {
                        TipView()
                    }
                }
            }
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Donation View (Custer SAR)
private struct DonationView: View {
    @State private var storeManager = StoreManager.shared
    @State private var isPurchasing = false
    @State private var showThankYou = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo/Header
            VStack(spacing: 16) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.red)
                
                Text("Friends of Custer Search and Rescue")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                
                Text("501(c)(3) Nonprofit Organization")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // About Section
            VStack(alignment: .leading, spacing: 12) {
                Text("About Friends of Custer SAR")
                    .font(.headline)
                
                Text("""
                Friends of Custer Search and Rescue is a non-profit organization dedicated to supporting the \
                lifesaving work of Custer County Search and Rescue teams in the Black Hills of South Dakota.
                
                Our mission is to provide financial support for training, equipment, and operational costs that \
                enable our volunteer SAR team to respond to emergencies in our community's wilderness areas.
                
                Your donation helps fund:
                • Advanced wilderness rescue training and certifications
                • Critical rescue equipment and safety gear
                • Communications and GPS technology
                • Vehicle maintenance and fuel costs
                • Medical supplies and first aid equipment
                
                100% of your donation goes directly to supporting search and rescue operations in the Black Hills region.
                """)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Donation Amounts
            VStack(spacing: 12) {
                Text("Select Donation Amount")
                    .font(.headline)
                
                if storeManager.isLoading {
                    ProgressView("Loading donation options...")
                        .padding()
                } else if let error = storeManager.loadError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text("Unable to load donation options")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await storeManager.loadProducts()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if storeManager.donationProducts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No donation options available")
                            .font(.headline)
                        Text("Please check your internet connection and try again.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await storeManager.loadProducts()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else {
                    ForEach(storeManager.donationProducts, id: \.id) { product in
                        DonationButton(
                            amount: product.displayPrice,
                            description: donationDescription(for: product),
                            isPurchasing: isPurchasing
                        ) {
                            await makeDonation(product)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Tax Deductible Notice
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(.blue)
                    Text("Tax Deductible")
                        .font(.subheadline.bold())
                }
                
                Text("Friends of Custer Search and Rescue is a 501(c)(3) organization. Your donation may be tax deductible.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Contact Information
            VStack(spacing: 8) {
                Text("Learn More")
                    .font(.headline)
                
                // Note: Replace with actual contact info when available
                VStack(alignment: .leading, spacing: 4) {
                    Text("For more information about Friends of Custer Search and Rescue:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Link("Visit Website", destination: URL(string: "https://www.example.com")!)
                        .font(.caption)
                    
                    // Email placeholder - update with actual email
                    Text("Email: info@friendsofcustersar.org")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .padding(.bottom, 30)
        }
        .alert("Thank You!", isPresented: $showThankYou) {
            Button("OK") { }
        } message: {
            Text("Your donation to Friends of Custer Search and Rescue helps save lives in the Black Hills. Thank you for your generosity!")
        }
        .task {
            // Reload products if they haven't loaded yet
            if storeManager.products.isEmpty && !storeManager.isLoading {
                await storeManager.loadProducts()
            }
        }
    }
    
    private func donationDescription(for product: Product) -> String {
        // You can customize descriptions based on amount
        switch product.id {
        case StoreManager.ProductID.donationSmall:
            return "Helps fund basic supplies"
        case StoreManager.ProductID.donationMedium:
            return "Supports equipment maintenance"
        case StoreManager.ProductID.donationLarge:
            return "Funds training programs"
        case StoreManager.ProductID.donationXLarge:
            return "Enables major equipment purchases"
        default:
            return ""
        }
    }
    
    private func makeDonation(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let success = try await StoreManager.shared.purchase(product)
            if success {
                showThankYou = true
            }
        } catch {
            print("Donation failed: \(error)")
        }
    }
}

// MARK: - Tip View (Developer)
private struct TipView: View {
    @State private var storeManager = StoreManager.shared
    @State private var isPurchasing = false
    @State private var showThankYou = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 16) {
                Image("BlackElkMountainMedicineLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                Text("Support the Developer")
                    .font(.title2.bold())
                
                Text("Help keep TrailTriage updated and ad-free")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Developer Message
            VStack(alignment: .leading, spacing: 12) {
                Text("From the Developer")
                    .font(.headline)
                
                Text("""
                Hi! I'm Luke, a Wilderness First Responder and outdoor enthusiast who created TrailTriage to \
                make wilderness medicine knowledge more accessible.
                
                This app is built with care by a solo developer (me!) who is passionate about outdoor safety \
                and emergency preparedness. Your tips help me:
                
                • Continue updating content with the latest WFR protocols
                • Add new features based on your feedback
                • Keep the app maintained and bug-free
                • Cover development and hosting costs
                • Keep the app ad-free forever
                
                Every tip, no matter the size, is deeply appreciated and helps me dedicate more time to \
                making TrailTriage the best wilderness medicine app available.
                
                Thank you for your support! 🏔️
                """)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Tip Amounts
            VStack(spacing: 12) {
                Text("Buy Me a...")
                    .font(.headline)
                
                if storeManager.isLoading {
                    ProgressView("Loading tip options...")
                        .padding()
                } else if let error = storeManager.loadError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text("Unable to load tip options")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await storeManager.loadProducts()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else if storeManager.tipProducts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No tip options available")
                            .font(.headline)
                        Text("Please check your internet connection and try again.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await storeManager.loadProducts()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else {
                    ForEach(storeManager.tipProducts, id: \.id) { product in
                        TipButton(
                            amount: product.displayPrice,
                            description: tipDescription(for: product),
                            icon: tipIcon(for: product),
                            isPurchasing: isPurchasing
                        ) {
                            await sendTip(product)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .alert("Thank You! 🙏", isPresented: $showThankYou) {
            Button("You're Welcome!") { }
        } message: {
            Text("Your support means the world to me and helps keep TrailTriage going strong. Safe travels!")
        }
        .task {
            // Reload products if they haven't loaded yet
            if storeManager.products.isEmpty && !storeManager.isLoading {
                await storeManager.loadProducts()
            }
        }
    }
    
    private func tipDescription(for product: Product) -> String {
        switch product.id {
        case StoreManager.ProductID.tipSmall:
            return "Coffee ☕️"
        case StoreManager.ProductID.tipMedium:
            return "Trail Lunch 🥪"
        case StoreManager.ProductID.tipLarge:
            return "Climbing Rope 🧗"
        default:
            return "Tip"
        }
    }
    
    private func tipIcon(for product: Product) -> String {
        switch product.id {
        case StoreManager.ProductID.tipSmall:
            return "cup.and.saucer.fill"
        case StoreManager.ProductID.tipMedium:
            return "fork.knife"
        case StoreManager.ProductID.tipLarge:
            return "figure.climbing"
        default:
            return "heart.fill"
        }
    }
    
    private func sendTip(_ product: Product) async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let success = try await StoreManager.shared.purchase(product)
            if success {
                showThankYou = true
            }
        } catch {
            print("Tip failed: \(error)")
        }
    }
}

// MARK: - Donation Button
private struct DonationButton: View {
    let amount: String
    let description: String
    let isPurchasing: Bool
    let action: () async -> Void
    
    @State private var isProcessing = false
    
    var body: some View {
        Button {
            Task {
                isProcessing = true
                await action()
                isProcessing = false
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(amount)
                        .font(.title3.bold())
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isProcessing {
                    ProgressView()
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                }
            }
            .foregroundStyle(.primary)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .disabled(isPurchasing || isProcessing)
    }
}

// MARK: - Tip Button
private struct TipButton: View {
    let amount: String
    let description: String
    let icon: String
    let isPurchasing: Bool
    let action: () async -> Void
    
    @State private var isProcessing = false
    
    var body: some View {
        Button {
            Task {
                isProcessing = true
                await action()
                isProcessing = false
            }
        } label: {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(description)
                        .font(.headline)
                    
                    Text(amount)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isProcessing {
                    ProgressView()
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
            .foregroundStyle(.primary)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .disabled(isPurchasing || isProcessing)
    }
}

#Preview {
    SupportView()
}
