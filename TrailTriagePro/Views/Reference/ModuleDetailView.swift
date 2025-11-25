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
            NavigationLink(destination: ModuleBookView(module: module)) {
                HStack(spacing: 12) {
                    Image(systemName: "book.closed.fill")
                        .font(.title3)
                        .padding(12)
                        .background(Theme.primary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .foregroundStyle(Theme.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Read Full Module")
                            .brandFont(.headline, weight: .semibold)
                        Text("Original scans + refreshed layouts for offline review.")
                            .brandFont(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding()
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    ZStack {
                        Theme.headerGradient
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        
                        VStack(spacing: 12) {
                            Image(systemName: module.iconName ?? module.category.icon)
                                .font(.system(size: 44, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(16)
                                .background(.white.opacity(0.15))
                                .clipShape(Circle())
                            
                            Text(module.moduleTitle)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            if let subtitle = module.moduleSubtitle {
                                Text(subtitle)
                                    .font(.system(.headline))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            if let description = module.moduleDescription {
                                Text(description)
                                    .font(.system(.body))
                                    .foregroundStyle(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            if let location = module.location {
                                Label(location, systemImage: "mappin.circle.fill")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.white.opacity(0.15))
                                    .clipShape(Capsule())
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.vertical, 28)
                        .padding(.horizontal)
                    }
                    
                    Text("Stabilize confidently, evacuate smart. You're the medic on scene.")
                        .brandFont(.body)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.horizontal)
                
                if module.sections.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 50))
                            .foregroundStyle(Theme.textSecondary)
                        Text("No content available")
                            .brandFont(.headline, weight: .semibold)
                            .foregroundStyle(Theme.textSecondary)
                        Text("Content will be available soon")
                            .brandFont(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
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
        .trailBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isBookmarked.toggle()
                    module.isBookmarked = isBookmarked
                    try? modelContext.save()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                        .foregroundStyle(isBookmarked ? Theme.accent : Theme.textPrimary)
                }
            }
        }
    }
    
    private func colorForCategory(_ category: ModuleCategory) -> Color {
        switch category {
        case .assessment: return .forestGreen
        case .environmental: return .warmEarth
        case .medical: return .deepCrimson
        case .trauma: return Color(hex: "7B4B94")
        case .minor: return Color(hex: "5AA469")
        case .evacuation: return Color(hex: "C98C3A")
        case .communication: return Color(hex: "3B88C3")
        case .general: return Theme.textSecondary
        }
    }
}

// MARK: - Module Section View

struct ModuleSectionView: View {
    let section: WFRModuleSection
    let category: ModuleCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(section.title)
                    .brandFont(.title3, weight: .bold)
                
                if let subtitle = section.subtitle {
                    Text(subtitle)
                        .brandFont(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            
            Divider()
                .foregroundStyle(Theme.divider)
            
            if section.content.isEmpty {
                Text("No content available")
                    .brandFont(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
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
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
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

