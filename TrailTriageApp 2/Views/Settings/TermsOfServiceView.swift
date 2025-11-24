//
//  TermsOfServiceView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Terms of service!
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Service")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                
                Group {
                    Text("Last Updated: November 10, 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                    
                    PolicySection(title: "Acceptance of Terms") {
                        Text("By downloading, accessing, or using TrailTriage, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.")
                    }
                    
                    PolicySection(title: "Educational Purpose") {
                        Text("TrailTriage is an educational reference tool designed for trained or training Wilderness First Responders (WFR). The content provided is for educational purposes only and should not replace professional medical advice, diagnosis, or treatment.")
                    }
                    
                    PolicySection(title: "Medical Disclaimer") {
                        Text("TrailTriage provides wilderness medicine protocols and reference materials. Always seek the advice of qualified medical professionals for any medical condition. In emergency situations, contact emergency services immediately. The information in this app should not be used as a substitute for professional medical judgment.")
                    }
                    
                    PolicySection(title: "Scope of Practice") {
                        Text("Users are responsible for understanding and operating within their scope of practice as defined by their training, certifications, and local regulations. TrailTriage does not certify or qualify users for any medical practice or intervention.")
                    }
                    
                    PolicySection(title: "License and Access") {
                        Text("Black Elk Mountain Medicine grants you a personal, non-transferable license to use TrailTriage. Access may be provided through a one-time purchase or subscription, as indicated at the time of purchase.")
                    }
                    
                    PolicySection(title: "Subscription Terms") {
                        Text("If you choose a subscription plan:\n\n• Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period\n• You will be charged through your Apple ID account\n• You can manage or cancel subscriptions in your App Store account settings\n• Free trials, if offered, convert to paid subscriptions unless canceled before the trial period ends")
                    }
                    
                    PolicySection(title: "Lifetime Purchase") {
                        Text("If you choose a lifetime purchase, you will receive ongoing access to TrailTriage on the devices associated with your Apple ID, subject to these terms and Apple's policies.")
                    }
                    
                    PolicySection(title: "Refunds") {
                        Text("Refund requests are handled by Apple according to their refund policies. Black Elk Mountain Medicine does not directly process refunds.")
                    }
                    
                    PolicySection(title: "Content Updates") {
                        Text("We regularly update the content in TrailTriage to reflect current wilderness medicine standards and practices. We do not guarantee that all content will be up-to-date at all times, and users are responsible for verifying information through official sources.")
                    }
                    
                    PolicySection(title: "Limitation of Liability") {
                        Text("To the maximum extent permitted by law, Black Elk Mountain Medicine shall not be liable for any direct, indirect, incidental, consequential, or special damages arising from your use or inability to use TrailTriage, even if we have been advised of the possibility of such damages.")
                    }
                    
                    PolicySection(title: "Intellectual Property") {
                        Text("All content, design, graphics, and materials in TrailTriage are owned by Black Elk Mountain Medicine or its content suppliers and are protected by copyright and other intellectual property laws. You may not reproduce, distribute, or create derivative works from any content without explicit permission.")
                    }
                    
                    PolicySection(title: "Termination") {
                        Text("We reserve the right to terminate or suspend access to TrailTriage at any time, with or without notice, for conduct that we believe violates these Terms of Service or is harmful to other users, us, or third parties.")
                    }
                    
                    PolicySection(title: "Changes to Terms") {
                        Text("We may update these Terms of Service from time to time. Continued use of TrailTriage after changes constitutes acceptance of the new terms.")
                    }
                    
                    PolicySection(title: "Governing Law") {
                        Text("These Terms of Service are governed by the laws of the jurisdiction in which Black Elk Mountain Medicine operates, without regard to conflict of law principles.")
                    }
                    
                    PolicySection(title: "Contact Information") {
                        Text("For questions about these Terms of Service, please contact us through the Support section in the app.")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
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
        TermsOfServiceView()
    }
}
