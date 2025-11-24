//
//  WFRModule.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Modern topic-based reference module model!
//

import Foundation
import SwiftData

/// Represents a topic-based module in the WFR reference guide
/// Modern replacement for chapter-based structure
@Model
final class WFRModule {
    var id: UUID
    var moduleTitle: String
    var moduleSubtitle: String?
    var category: ModuleCategory
    var iconName: String?
    var moduleDescription: String?
    var sections: [WFRModuleSection]
    var orderIndex: Int
    var isBookmarked: Bool
    var location: String? // Randomized park location for scenarios
    
    init(
        id: UUID = UUID(),
        moduleTitle: String,
        moduleSubtitle: String? = nil,
        category: ModuleCategory,
        iconName: String? = nil,
        moduleDescription: String? = nil,
        sections: [WFRModuleSection] = [],
        orderIndex: Int,
        isBookmarked: Bool = false,
        location: String? = nil
    ) {
        self.id = id
        self.moduleTitle = moduleTitle
        self.moduleSubtitle = moduleSubtitle
        self.category = category
        self.iconName = iconName
        self.moduleDescription = moduleDescription
        self.sections = sections
        self.orderIndex = orderIndex
        self.isBookmarked = isBookmarked
        self.location = location
    }
}

/// Module categories for organizing content
enum ModuleCategory: String, Codable {
    case assessment = "Assessment"
    case environmental = "Environmental"
    case medical = "Medical"
    case trauma = "Trauma"
    case minor = "Minor Issues"
    case evacuation = "Evacuation"
    case communication = "Communication"
    case general = "General"
    
    var icon: String {
        switch self {
        case .assessment:
            return "stethoscope"
        case .environmental:
            return "thermometer"
        case .medical:
            return "heart.circle"
        case .trauma:
            return "cross.case"
        case .minor:
            return "bandage"
        case .evacuation:
            return "figure.walk"
        case .communication:
            return "antenna.radiowaves.left.and.right"
        case .general:
            return "book"
        }
    }
    
    var color: String {
        switch self {
        case .assessment:
            return "blue"
        case .environmental:
            return "orange"
        case .medical:
            return "red"
        case .trauma:
            return "purple"
        case .minor:
            return "green"
        case .evacuation:
            return "yellow"
        case .communication:
            return "cyan"
        case .general:
            return "gray"
        }
    }
}

/// Represents a section within a module
@Model
final class WFRModuleSection {
    var id: UUID
    var title: String
    var subtitle: String?
    var content: [WFRModuleContentBlock]
    var orderIndex: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        content: [WFRModuleContentBlock] = [],
        orderIndex: Int
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = content
        self.orderIndex = orderIndex
    }
}

/// Represents different types of content blocks within a module section
@Model
final class WFRModuleContentBlock {
    var id: UUID
    var type: ModuleContentBlockType
    var content: String
    var orderIndex: Int
    var metadata: String? // For table data, list items JSON, etc.
    var location: String? // Randomized park location for scenarios
    
    init(
        id: UUID = UUID(),
        type: ModuleContentBlockType,
        content: String,
        orderIndex: Int,
        metadata: String? = nil,
        location: String? = nil
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.orderIndex = orderIndex
        self.metadata = metadata
        self.location = location
    }
}

enum ModuleContentBlockType: String, Codable {
    case heading
    case subheading
    case paragraph
    case bulletList
    case numberedList
    case warning
    case tip
    case note
    case table
    case procedure
    case definition
    case example
    case scenario // WFR scenarios with randomized locations
}

