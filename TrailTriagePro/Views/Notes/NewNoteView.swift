//
//  NewNoteView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Note creation landing page!
//


import SwiftUI

struct NewNoteView: View {
    // After onboarding, users always have active subscription
    // They're auto-kicked if they cancel via StoreKit
    @State private var showingNewNote = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero section with icon
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "note.text.badge.plus")
                                .font(.system(size: 60))
                                .foregroundStyle(.blue)
                        }
                        .padding(.top, 40)
                        
                        VStack(spacing: 8) {
                            Text("Create SOAP Note")
                                .font(.title.bold())
                            
                            Text("Document patient assessments in the field")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // Feature cards
                    VStack(spacing: 16) {
                        FeatureCard(
                            icon: "stethoscope",
                            title: "Comprehensive Assessment",
                            description: "Full SOAP note with vitals tracking",
                            color: .blue
                        )
                        
                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Real-time Monitoring",
                            description: "Track vitals and patient changes over time",
                            color: .green
                        )
                        
                        FeatureCard(
                            icon: "doc.text.fill",
                            title: "Professional Reports",
                            description: "Generate PDF reports for handoff",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    // CTA button
                    Button(action: {
                        showingNewNote = true
                    }) {
                        Label("New Note", systemImage: "plus.circle.fill")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("New Note")
            .sheet(isPresented: $showingNewNote) {
                ExpertModeNoteView()
            }
        }
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    NewNoteView()
}
