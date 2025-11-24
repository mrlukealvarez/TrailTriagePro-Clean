//
//  ModuleListView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Modern module list view with card-based design!
//

import SwiftUI
import SwiftData

struct ModuleListView: View {
    @Query(sort: \WFRModule.orderIndex) private var allModules: [WFRModule]
    @State private var searchText = ""
    @State private var selectedCategory: ModuleCategory?
    @Environment(\.modelContext) private var modelContext
    
    // Filter modules by search and category
    private var filteredModules: [WFRModule] {
        var modules = allModules
        
        // Filter by category
        if let category = selectedCategory {
            modules = modules.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            modules = modules.filter { module in
                module.moduleTitle.localizedCaseInsensitiveContains(searchText) ||
                (module.moduleSubtitle?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (module.moduleDescription?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return modules
    }
    
    // Group modules by category for organized display
    private var modulesByCategory: [ModuleCategory: [WFRModule]] {
        Dictionary(grouping: filteredModules, by: { $0.category })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Category filter chips
                    if selectedCategory == nil {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                // All modules chip
                                CategoryChip(
                                    title: "All",
                                    icon: "book.fill",
                                    isSelected: selectedCategory == nil,
                                    color: .blue
                                ) {
                                    selectedCategory = nil
                                }
                                
                                // Category chips
                                ForEach(ModuleCategory.allCases, id: \.self) { category in
                                    CategoryChip(
                                        title: category.rawValue,
                                        icon: category.icon,
                                        isSelected: selectedCategory == category,
                                        color: colorForCategory(category)
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                    } else {
                        // Show back button when category selected
                        HStack {
                            Button {
                                withAnimation {
                                    selectedCategory = nil
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text(selectedCategory?.rawValue ?? "All Modules")
                                }
                                .foregroundStyle(.blue)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    // Modules grid/list
                    if filteredModules.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundStyle(.secondary)
                            Text("No modules found")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            if !searchText.isEmpty {
                                Text("Try a different search term")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 60)
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredModules.sorted(by: { $0.orderIndex < $1.orderIndex }), id: \.id) { module in
                                NavigationLink(destination: ModuleDetailView(module: module)) {
                                    ModuleCard(module: module)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Reference Modules")
            .searchable(text: $searchText, prompt: "Search modules...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedCategory != nil {
                        Button("Clear Filter") {
                            withAnimation {
                                selectedCategory = nil
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Helper to get color for category
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

// MARK: - Module Card

struct ModuleCard: View {
    let module: WFRModule
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorForCategory(module.category).opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: module.iconName ?? module.category.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(colorForCategory(module.category))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(module.moduleTitle)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                
                if let subtitle = module.moduleSubtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                if let description = module.moduleDescription {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // Section count badge
                if !module.sections.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                            .font(.caption2)
                        Text("\(module.sections.count) \(module.sections.count == 1 ? "section" : "sections")")
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                }
            }
            
            Spacer()
            
            // Bookmark indicator
            if module.isBookmarked {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.yellow)
                    .font(.caption)
            }
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundStyle(isSelected ? .white : color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? color : color.opacity(0.15))
            .cornerRadius(20)
        }
    }
}

// MARK: - ModuleCategory Extension

extension ModuleCategory: CaseIterable {
    static var allCases: [ModuleCategory] {
        return [.assessment, .environmental, .medical, .trauma, .minor, .evacuation, .communication, .general]
    }
}

#Preview {
    ModuleListView()
        .modelContainer(for: WFRModule.self, inMemory: true)
}

