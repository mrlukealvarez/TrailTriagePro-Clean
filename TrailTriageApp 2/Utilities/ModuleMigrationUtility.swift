//
//  ModuleMigrationUtility.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Migration utility to convert chapters to modules!
//

import Foundation
import SwiftData

/// Utility for migrating from old WFRChapter structure to new WFRModule structure
struct ModuleMigrationUtility {
    
    /// Migrate a WFRChapter to a WFRModule
    /// Maps chapter-based content to topic-based modules
    static func migrateChapterToModule(_ chapter: WFRChapter) -> WFRModule? {
        // Map chapter titles to module categories and titles
        let (moduleTitle, category) = mapChapterToModule(chapter.title, chapterNumber: chapter.chapterNumber)
        
        // Create module
        let module = WFRModule(
            moduleTitle: moduleTitle,
            moduleSubtitle: chapter.subtitle,
            category: category,
            iconName: category.icon,
            moduleDescription: nil,
            sections: migrateSections(chapter.sections),
            orderIndex: chapter.orderIndex,
            isBookmarked: chapter.isBookmarked,
            location: nil
        )
        
        return module
    }
    
    /// Map chapter title/number to module title and category
    private static func mapChapterToModule(_ chapterTitle: String, chapterNumber: Int) -> (String, ModuleCategory) {
        let lowercased = chapterTitle.lowercased()
        
        // Check chapter title keywords
        if lowercased.contains("environmental") || lowercased.contains("heat") || 
           lowercased.contains("cold") || lowercased.contains("hypothermia") ||
           lowercased.contains("altitude") || lowercased.contains("lightning") {
            return ("Environmental Emergencies", .environmental)
        }
        
        if lowercased.contains("medical") || lowercased.contains("diabetic") ||
           lowercased.contains("cardiac") || lowercased.contains("respiratory") ||
           lowercased.contains("allergy") || lowercased.contains("anaphylaxis") {
            return ("Medical Emergencies", .medical)
        }
        
        if lowercased.contains("trauma") || lowercased.contains("fracture") ||
           lowercased.contains("spine") || lowercased.contains("head") ||
           lowercased.contains("burn") || lowercased.contains("bleeding") {
            return ("Trauma Management", .trauma)
        }
        
        if lowercased.contains("assessment") || lowercased.contains("primary") ||
           lowercased.contains("secondary") || lowercased.contains("sample") ||
           lowercased.contains("vitals") {
            return ("Patient Assessment", .assessment)
        }
        
        if lowercased.contains("evacuation") || lowercased.contains("rescue") ||
           lowercased.contains("extraction") {
            return ("Evacuation & Rescue", .evacuation)
        }
        
        if lowercased.contains("communication") || lowercased.contains("radio") ||
           lowercased.contains("signal") {
            return ("Communication", .communication)
        }
        
        if lowercased.contains("minor") || lowercased.contains("micro") ||
           lowercased.contains("blister") || lowercased.contains("dental") ||
           lowercased.contains("skin") {
            return ("Minor Medical Issues", .minor)
        }
        
        // Default based on chapter number
        switch chapterNumber {
        case 1...3:
            return ("Patient Assessment", .assessment)
        case 4...6:
            return ("Trauma Management", .trauma)
        case 7:
            return ("Medical Emergencies", .medical)
        case 8:
            return ("Environmental Emergencies", .environmental)
        case 9:
            return ("Minor Medical Issues", .minor)
        default:
            return (chapterTitle, .general)
        }
    }
    
    /// Migrate sections from WFRSection to WFRModuleSection
    private static func migrateSections(_ sections: [WFRSection]) -> [WFRModuleSection] {
        return sections.map { section in
            WFRModuleSection(
                title: section.title,
                subtitle: nil,
                content: migrateContentBlocks(section.content),
                orderIndex: section.orderIndex
            )
        }
    }
    
    /// Migrate content blocks from WFRContentBlock to WFRModuleContentBlock
    private static func migrateContentBlocks(_ blocks: [WFRContentBlock]) -> [WFRModuleContentBlock] {
        return blocks.map { block in
            // Convert content block type
            let moduleType = mapContentBlockType(block.type)
            
            // Process content - convert SOAA'P to SOAPNote
            let processedContent = processContent(block.content, type: moduleType)
            
            // Randomize location for scenarios
            let location = moduleType == .scenario ? 
                ScenarioRandomizer.randomizeLocation() : nil
            
            return WFRModuleContentBlock(
                type: moduleType,
                content: processedContent,
                orderIndex: block.orderIndex,
                metadata: block.metadata,
                location: location
            )
        }
    }
    
    /// Map old ContentBlockType to new ModuleContentBlockType
    private static func mapContentBlockType(_ oldType: ContentBlockType) -> ModuleContentBlockType {
        switch oldType {
        case .heading:
            return .heading
        case .subheading:
            return .subheading
        case .paragraph:
            return .paragraph
        case .bulletList:
            return .bulletList
        case .numberedList:
            return .numberedList
        case .warning:
            return .warning
        case .tip:
            return .tip
        case .note:
            return .note
        case .table:
            return .table
        case .procedure:
            return .procedure
        case .definition:
            return .definition
        case .example:
            return .example
        }
    }
    
    /// Process content to update branding and format
    /// - Convert SOAA'P to SOAPNote
    /// - Update old branding to Black Elk Mountain Medicine
    private static func processContent(_ content: String, type: ModuleContentBlockType) -> String {
        var processed = content
        
        // Convert SOAA'P to SOAPNote
        processed = processed.replacingOccurrences(of: "SOAA'P", with: "SOAPNote", options: [.caseInsensitive])
        processed = processed.replacingOccurrences(of: "SOAAP", with: "SOAPNote", options: [.caseInsensitive])
        processed = processed.replacingOccurrences(of: "SOAA P", with: "SOAPNote", options: [.caseInsensitive])
        
        // Update old branding references
        // (Add specific branding replacements here if needed)
        
        return processed
    }
    
    /// Batch migrate all chapters to modules
    static func migrateAllChapters(
        chapters: [WFRChapter],
        context: ModelContext
    ) -> [WFRModule] {
        var migratedModules: [WFRModule] = []
        var usedLocations: [String] = []
        
        for chapter in chapters.sorted(by: { $0.orderIndex < $1.orderIndex }) {
            if let module = migrateChapterToModule(chapter) {
                // Randomize module location for scenarios
                if module.category == .environmental || module.category == .evacuation {
                    // Ensure unique locations for variety
                    var location = ScenarioRandomizer.randomizeLocation(
                        in: module.category
                    )
                    
                    // Ensure unique location
                    while usedLocations.contains(location) && usedLocations.count < 50 {
                        location = ScenarioRandomizer.randomizeLocation(in: module.category)
                    }
                    
                    module.location = location
                    usedLocations.append(location)
                }
                
                // Randomize locations in content blocks
                for section in module.sections {
                    for block in section.content where block.type == .scenario {
                        var location = ScenarioRandomizer.randomizeLocation()
                        
                        // Ensure unique location for each scenario
                        while usedLocations.contains(location) && usedLocations.count < 100 {
                            location = ScenarioRandomizer.randomizeLocation()
                        }
                        
                        block.location = location
                        usedLocations.append(location)
                    }
                }
                
                migratedModules.append(module)
                context.insert(module)
            }
        }
        
        // Save context
        do {
            try context.save()
        } catch {
            print("Error saving migrated modules: \(error)")
        }
        
        return migratedModules
    }
}

// MARK: - ContentBlockType Extension (from WFRChapter.swift)

// Note: This assumes ContentBlockType is accessible
// If not, we may need to import or reference it differently

