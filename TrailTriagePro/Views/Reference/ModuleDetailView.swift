//
//  ModuleDetailView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Modern module detail view with beautiful content display!
//

import SwiftUI
import SwiftData

struct ModuleDetailView: View {
    let module: WFRModule
    @Environment(\.modelContext) private var modelContext
    @State private var isBookmarked: Bool
    
    init(module: WFRModule) {
        self.module = module
        _isBookmarked = State(initialValue: module.isBookmarked)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Module Header
                VStack(spacing: 12) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(colorForCategory(module.category).opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: module.iconName ?? module.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(colorForCategory(module.category))
                    }
                    
                    // Title
                    Text(module.moduleTitle)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    
                    // Subtitle
                    if let subtitle = module.moduleSubtitle {
                        Text(subtitle)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Description
                    if let description = module.moduleDescription {
                        Text(description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Location badge (if scenario-based)
                    if let location = module.location {
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text(location)
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Sections
                if module.sections.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        Text("No content available")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text("Content will be available soon")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 60)
                } else {
                    LazyVStack(spacing: 24) {
                        ForEach(module.sections.sorted(by: { $0.orderIndex < $1.orderIndex }), id: \.id) { section in
                            ModuleSectionView(section: section, category: module.category)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isBookmarked.toggle()
                    module.isBookmarked = isBookmarked
                    try? modelContext.save()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(isBookmarked ? .yellow : .primary)
                }
            }
        }
    }
    
    private func colorForCategory(_ category: ModuleCategory) -> Color {
        switch category {
        case .assessment: return .blue
        case .environmental: return .orange
        case .medical: return .red
        case .trauma: return .purple
        case .minor: return .green
        case .evacuation: return .yellow
        case .communication: return .cyan
        case .general: return .gray
        }
    }
}

// MARK: - Module Section View

struct ModuleSectionView: View {
    let section: WFRModuleSection
    let category: ModuleCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            VStack(alignment: .leading, spacing: 8) {
                Text(section.title)
                    .font(.title2.bold())
                
                if let subtitle = section.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            // Content Blocks
            if section.content.isEmpty {
                Text("No content available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(section.content.sorted(by: { $0.orderIndex < $1.orderIndex }), id: \.id) { block in
                        ModuleContentBlockView(block: block)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}



#Preview {
    NavigationStack {
        ModuleDetailView(module: WFRModule(
            moduleTitle: "Environmental Emergencies",
            moduleSubtitle: "Heat, Cold, and Altitude",
            category: .environmental,
            orderIndex: 1
        ))
    }
}

