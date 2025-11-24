//
//  WFRChapter.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Reference book chapter model for medical protocols!
//

import Foundation
import SwiftData

/// Represents a chapter in the WFR reference book
@Model
final class WFRChapter {
    var id: UUID
    var chapterNumber: Int
    var title: String
    var subtitle: String?
    var sections: [WFRSection]
    var orderIndex: Int
    var isBookmarked: Bool
    
    init(
        id: UUID = UUID(),
        chapterNumber: Int,
        title: String,
        subtitle: String? = nil,
        sections: [WFRSection] = [],
        orderIndex: Int,
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.chapterNumber = chapterNumber
        self.title = title
        self.subtitle = subtitle
        self.sections = sections
        self.orderIndex = orderIndex
        self.isBookmarked = isBookmarked
    }
}

/// Represents a section within a chapter
@Model
final class WFRSection {
    var id: UUID
    var title: String
    var content: [WFRContentBlock]
    var orderIndex: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        content: [WFRContentBlock] = [],
        orderIndex: Int
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.orderIndex = orderIndex
    }
}

/// Represents different types of content blocks within a section
@Model
final class WFRContentBlock {
    var id: UUID
    var type: ContentBlockType
    var content: String
    var orderIndex: Int
    var metadata: String? // For things like table data, list items in JSON, etc.
    
    init(
        id: UUID = UUID(),
        type: ContentBlockType,
        content: String,
        orderIndex: Int,
        metadata: String? = nil
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.orderIndex = orderIndex
        self.metadata = metadata
    }
}

enum ContentBlockType: String, Codable {
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
}
