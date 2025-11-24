//
//  AboutView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: About page!
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // App Icon & Name
                VStack(spacing: 16) {
                    Image("BlackElkMountainMedicineLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 8)
                    
                    VStack(spacing: 8) {
                        Text("TrailTriage")
                            .font(.title.bold())
                        
                        Text("Wilderness Medicine Reference")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 4) {
                            Text("Version")
                            Text(Bundle.main.appVersion ?? "1.0")
                            Text("(\(Bundle.main.buildNumber ?? "1"))")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
                .padding(.top, 32)
                
                // Mission Statement
                VStack(spacing: 16) {
                    Label("Our Mission", systemImage: "target")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    Text("""
                    TrailTriage was created to make professional wilderness medicine knowledge accessible to first responders in the field. We believe that having quick, offline access to accurate medical protocols can save lives in remote environments.
                    """)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Features
                VStack(spacing: 16) {
                    Label("What's Included", systemImage: "list.star")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        AboutFeatureRow(
                            icon: "book.fill",
                            title: "80+ Hours of Content",
                            description: "Comprehensive WFR protocols and procedures"
                        )
                        
                        AboutFeatureRow(
                            icon: "wifi.slash",
                            title: "100% Offline Access",
                            description: "All content available without internet"
                        )
                        
                        AboutFeatureRow(
                            icon: "doc.text.fill",
                            title: "SOAP Note Documentation",
                            description: "Professional medical documentation tools"
                        )
                        
                        AboutFeatureRow(
                            icon: "heart.text.square.fill",
                            title: "Vital Signs Tracking",
                            description: "Track patient vitals over time"
                        )
                        
                        AboutFeatureRow(
                            icon: "arrow.triangle.2.circlepath",
                            title: "Regular Updates",
                            description: "Content updated with latest standards"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // About the Developer
                VStack(spacing: 16) {
                    Label("About the Developer", systemImage: "person.fill")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    VStack(spacing: 12) {
                        Image(systemName: "figure.hiking")
                            .font(.system(size: 48))
                            .foregroundStyle(.blue)
                        
                        Text("""
                        Hi! I'm Luke Alvarez, a Wilderness First Responder and software developer based in the Black Hills of South Dakota. As someone passionate about outdoor safety and emergency preparedness, I created TrailTriage to help fellow WFRs have the information they need, when they need it most.
                        
                        This app is a labor of love, combining my technical skills with my commitment to wilderness medicine and search and rescue work.
                        """)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Acknowledgments
                VStack(spacing: 16) {
                    Label("Acknowledgments", systemImage: "heart.fill")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    
                    Text("""
                    Special thanks to:
                    
                    • Friends of Custer Search and Rescue for their dedication to saving lives in the Black Hills
                    
                    • All the WFR instructors who contributed to the knowledge base
                    
                    • The wilderness medicine community for their ongoing support
                    
                    • Beta testers who helped make this app better
                    """)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 32)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Contact & Legal
                VStack(spacing: 12) {
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(spacing: 8) {
                        Link("Visit Website", destination: URL(string: "https://mrlukealvarez.github.io/blackelkmountainmedicine.com/")!)
                            .font(.subheadline)
                        
                        Link("Contact Support", destination: URL(string: "mailto:support@blackelkmountainmedicine.com")!)
                            .font(.subheadline)
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(spacing: 4) {
                        Text("© 2025 Black Elk Mountain Medicine")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("Made with ❤️ in the Black Hills")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Feature Row (About Page)
fileprivate struct AboutFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 32)
            
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

#Preview {
    NavigationStack {
        AboutView()
    }
}
