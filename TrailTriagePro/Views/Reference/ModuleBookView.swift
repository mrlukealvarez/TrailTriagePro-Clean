//
//  ModuleBookView.swift
//  TrailTriagePro
//
//  Created by Luke Alvarez on 11/24/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Hybrid Digital Book Reader!
//

import SwiftUI

struct ModuleBookView: View {
    let module: WFRModule
    @State private var currentPageIndex = 0
    @State private var showTextOverlay = true
    @State private var textOverlayHeight: PresentationDetent = .medium
    
    // Filter valid images (simple check if we can load them, or just rely on the list)
    var validPages: [String] {
        (module.pageImageNames ?? []).filter { name in
            UIImage(named: name) != nil
        }
    }
    
    var body: some View {
        ZStack {
            // Background: Scanned Pages
            if validPages.isEmpty {
                ContentUnavailableView("No Scanned Pages", systemImage: "book.closed", description: Text("This module does not have scanned pages available."))
            } else {
                TabView(selection: $currentPageIndex) {
                    ForEach(Array(validPages.enumerated()), id: \.offset) { index, pageName in
                        GeometryReader { proxy in
                            Image(pageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .clipped()
                        }
                        .tag(index)
                        .ignoresSafeArea()
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showTextOverlay.toggle()
                    }
                }
            }
            
            // Foreground: Text Overlay
            if showTextOverlay {
                VStack {
                    Spacer()
                    
                    // Glassmorphic Card
                    VStack(alignment: .leading, spacing: 16) {
                        // Handle / Grabber
                        HStack {
                            Spacer()
                            Capsule()
                                .fill(Color.secondary.opacity(0.5))
                                .frame(width: 40, height: 5)
                            Spacer()
                        }
                        .padding(.top, 10)
                        
                        // Header
                        HStack {
                            Text(module.moduleTitle)
                                .font(.headline)
                            Spacer()
                            Button {
                                withAnimation {
                                    showTextOverlay = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Scrollable Content
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(module.sections.sorted(by: { $0.orderIndex < $1.orderIndex })) { section in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(section.title)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        ForEach(section.content.sorted(by: { $0.orderIndex < $1.orderIndex })) { block in
                                            ModuleContentBlockView(block: block)
                                        }
                                    }
                                    Divider()
                                }
                            }
                            .padding()
                        }
                        .frame(maxHeight: 400) // Limit height
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(radius: 10)
                    .padding()
                    .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle(module.moduleTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(currentPageIndex + 1)/\(validPages.count)")
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(.black.opacity(0.5))
                    .clipShape(Capsule())
            }
        }
    }
}
