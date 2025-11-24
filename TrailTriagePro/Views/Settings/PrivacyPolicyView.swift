//
//  PrivacyPolicyView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Privacy policy!
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                
                Group {
                    Text("Last Updated: November 10, 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                    
                    PolicySection(title: "Our Commitment to Privacy") {
                        Text("Black Elk Mountain Medicine is committed to protecting your privacy. This Privacy Policy explains how TrailTriage handles your information.")
                    }
                    
                    PolicySection(title: "Information We Don't Collect") {
                        Text("TrailTriage is designed with privacy in mind. We do not collect, store, or transmit any personal information, medical data, or usage statistics. All app functionality operates locally on your device.")
                    }
                    
                    PolicySection(title: "Data Storage") {
                        Text("Any preferences or settings you configure in TrailTriage are stored locally on your device using iOS standard storage mechanisms. This data never leaves your device and is not accessible to us or any third parties.")
                    }
                    
                    PolicySection(title: "Apple StoreKit") {
                        Text("TrailTriage uses Apple's StoreKit framework to handle subscriptions and purchases. Your payment information is processed entirely by Apple and is governed by Apple's Privacy Policy. We do not have access to your payment information.")
                    }
                    
                    PolicySection(title: "No Third-Party Analytics") {
                        Text("TrailTriage does not use any third-party analytics, tracking, or advertising services. Your usage of the app is completely private.")
                    }
                    
                    PolicySection(title: "No Account Required") {
                        Text("TrailTriage does not require you to create an account or provide any personal information such as email addresses, names, or contact information.")
                    }
                    
                    PolicySection(title: "Medical Information") {
                        Text("TrailTriage provides educational medical information for wilderness first responders. This content is stored within the app and does not collect or transmit any information about how you use this content.")
                    }
                    
                    PolicySection(title: "Children's Privacy") {
                        Text("TrailTriage does not knowingly collect any information from anyone, including children under 13. The app is designed for trained or training wilderness first responders.")
                    }
                    
                    PolicySection(title: "Changes to This Policy") {
                        Text("We may update this Privacy Policy from time to time. Any changes will be reflected in the app with an updated 'Last Updated' date. We will notify users of any material changes through an app update notice.")
                    }
                    
                    PolicySection(title: "Your Rights") {
                        Text("Since we don't collect any personal data, there's no personal information to access, modify, or delete. All app data is stored locally on your device and can be deleted by uninstalling the app.")
                    }
                    
                    PolicySection(title: "Contact Us") {
                        Text("If you have any questions about this Privacy Policy, please contact us through the Support section in the app.")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Policy Section Helper
private struct PolicySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            content()
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
