//
//  ModuleSeedData.swift
//  TrailTriagePro
//
//  Full Reference Library Seed – November 2025
//

import Foundation
import SwiftData

@MainActor
struct ModuleSeedData {
    private static let seedVersionKey = "moduleSeedVersion"
    private static let currentSeedVersion = 3
    
    static func seed(context: ModelContext) {
        do {
            try removeDuplicateModules(in: context)
            
            let storedVersion = UserDefaults.standard.integer(forKey: seedVersionKey)
            guard storedVersion < currentSeedVersion else { return }
            
            try purgeExistingModules(in: context)
            
            let modules = try decodeModules()
            modules.forEach { context.insert($0) }
            try context.save()
            
            UserDefaults.standard.set(currentSeedVersion, forKey: seedVersionKey)
        } catch {
            #if DEBUG
            print("❌ Module seeding failed:", error.localizedDescription)
            #endif
        }
    }
}

// MARK: - Helpers

private extension ModuleSeedData {
    static func decodeModules() throws -> [WFRModule] {
        if let jsonModules = try? ModuleJSONLoader.loadModules() {
            return jsonModules
        }
        
        let payload = try JSONDecoder().decode(SeedPayload.self, from: ModuleSeedPayload.data)
        return payload.modules.sorted(by: { $0.orderIndex < $1.orderIndex }).map(makeModule)
    }
    
    static func purgeExistingModules(in context: ModelContext) throws {
        let descriptor = FetchDescriptor<WFRModule>()
        let existing = try context.fetch(descriptor)
        existing.forEach { context.delete($0) }
        if context.hasChanges {
            try context.save()
        }
    }
    
    static func removeDuplicateModules(in context: ModelContext) throws {
        let descriptor = FetchDescriptor<WFRModule>(sortBy: [SortDescriptor(\.moduleTitle)])
        let modules = try context.fetch(descriptor)
        
        var seenTitles: Set<String> = []
        modules.forEach { module in
            let key = module.moduleTitle.lowercased()
            if seenTitles.contains(key) {
                context.delete(module)
            } else {
                seenTitles.insert(key)
            }
        }
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    static func makeModule(from seed: SeedModule) -> WFRModule {
        WFRModule(
            moduleTitle: seed.moduleTitle,
            moduleSubtitle: seed.moduleSubtitle,
            category: mapCategory(seed.category),
            iconName: seed.iconName,
            moduleDescription: seed.descriptionText,
            sections: seed.sections
                .sorted(by: { $0.orderIndex < $1.orderIndex })
                .map(makeSection),
            orderIndex: seed.orderIndex,
            location: seed.location,
            pageImageNames: (0..<50).map { "module_\(seed.orderIndex)_page_\($0)" }
        )
    }
    
    static func makeSection(from seed: SeedSection) -> WFRModuleSection {
        WFRModuleSection(
            title: seed.sectionTitle,
            subtitle: seed.subtitle,
            content: seed.content
                .sorted(by: { $0.orderIndex < $1.orderIndex })
                .map(makeContentBlock),
            orderIndex: seed.orderIndex
        )
    }
    
    static func makeContentBlock(from seed: SeedContentBlock) -> WFRModuleContentBlock {
        WFRModuleContentBlock(
            type: mapContentType(seed.type),
            content: seed.content,
            orderIndex: seed.orderIndex,
            metadata: seed.metadata,
            location: seed.location,
            pageImageNames: (0..<50).map { "module_\(seed.orderIndex)_page_\($0)" }
        )
    }
    
}

extension ModuleSeedData {
    static func mapCategory(_ rawValue: String?) -> ModuleCategory {
        guard let rawValue = rawValue, !rawValue.isEmpty else {
            return .general
        }
        
        if let match = ModuleCategory(rawValue: rawValue) {
            return match
        }
        
        switch rawValue.lowercased() {
        case "assessment":
            return .assessment
        case "environmental":
            return .environmental
        case "medical":
            return .medical
        case "trauma":
            return .trauma
        case "minor", "micromedics":
            return .minor
        case "evacuation":
            return .evacuation
        case "communication":
            return .communication
        default:
            return .general
        }
    }
    
    static func mapContentType(_ rawValue: String) -> ModuleContentBlockType {
        if let match = ModuleContentBlockType(rawValue: rawValue) {
            return match
        }
        
        switch rawValue.lowercased() {
        case "bulletlist", "bullets":
            return .bulletList
        case "numberedlist":
            return .numberedList
        case "warning":
            return .warning
        case "tip":
            return .tip
        case "note":
            return .note
        case "procedure":
            return .procedure
        case "heading":
            return .heading
        default:
            return .paragraph
        }
    }
}

// MARK: - Seed DTOs

private struct SeedPayload: Decodable {
    let modules: [SeedModule]
}

private struct SeedModule: Decodable {
    let moduleTitle: String
    let moduleSubtitle: String?
    let category: String?
    let iconName: String?
    let descriptionText: String?
    let orderIndex: Int
    let location: String?
    let sections: [SeedSection]
    
    enum CodingKeys: String, CodingKey {
        case moduleTitle
        case moduleSubtitle
        case category
        case iconName
        case descriptionText = "description"
        case orderIndex
        case location
        case sections
    }
}

private struct SeedSection: Decodable {
    let sectionTitle: String
    let subtitle: String?
    let orderIndex: Int
    let content: [SeedContentBlock]
}

private struct SeedContentBlock: Decodable {
    let type: String
    let content: String
    let orderIndex: Int
    let metadata: String?
    let location: String?
}
