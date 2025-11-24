//
//  ReferenceBookTitlePageView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Title page component!
//

import SwiftUI

struct ReferenceBookTitlePageView: View {
    @Binding var showTitlePage: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Title page header
                VStack(spacing: 16) {
                    Text("Wilderness First Responder")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .multilineTextAlignment(.center)
                    
                    Text("Field Reference Guide")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Author/Publisher
                VStack(spacing: 12) {
                    Text("Black Elk Mountain Medicine")
                        .font(.headline)
                    
                    Text("Evidence-Based Wilderness Medicine Education")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer(minLength: 40)
                
                // Copyright and disclaimer
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Copyright Notice")
                            .font(.headline)
                        
                        Text("© 2025 Black Elk Mountain Medicine. All rights reserved.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Medical Disclaimer")
                            .font(.headline)
                        
                        Text("This reference guide is intended for educational purposes for trained Wilderness First Responders. It does not constitute medical advice and should not replace proper training, certification, or professional medical consultation.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scope of Practice")
                            .font(.headline)
                        
                        Text("Always operate within your scope of training and certification. When in doubt, contact professional medical services. This guide assumes wilderness contexts where evacuation to definitive care may be delayed.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Continue button
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showTitlePage = false
                    }
                } label: {
                    HStack(spacing: 12) {
                        Text("Begin Reading")
                            .font(.headline)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(radius: 5)
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

#Preview {
    ReferenceBookTitlePageView(showTitlePage: .constant(true))
}

// MARK: - Patient Assessment Module Views
// These views are for the new modern reference library

// Note: The full implementations are in separate files but included here for compilation
// SceneSizeUpView, PrimaryAssessmentView, SecondaryAssessmentView, 
// SOAPNotesReferenceView, and ReassessmentView

