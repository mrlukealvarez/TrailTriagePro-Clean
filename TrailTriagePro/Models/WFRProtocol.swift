//
//  WFRProtocol.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Medical protocol reference model for wilderness medicine!
//

import Foundation
import SwiftData

/// Represents a wilderness first responder protocol/procedure
@Model
final class WFRProtocol {
    var id: UUID
    var title: String
    var category: ProtocolCategory
    var severity: Severity
    var steps: [String]
    var warning: String?
    var isFavorite: Bool
    var createdDate: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        category: ProtocolCategory,
        severity: Severity,
        steps: [String],
        warning: String? = nil,
        isFavorite: Bool = false,
        createdDate: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.severity = severity
        self.steps = steps
        self.warning = warning
        self.isFavorite = isFavorite
        self.createdDate = createdDate
    }
}

/// Categories for organizing protocols
enum ProtocolCategory: String, Codable, CaseIterable {
    case trauma = "Trauma"
    case medical = "Medical"
    case environmental = "Environmental"
    case assessment = "Assessment"
    
    var icon: String {
        switch self {
        case .trauma:
            return "bandage"
        case .medical:
            return "cross.case"
        case .environmental:
            return "thermometer.snowflake"
        case .assessment:
            return "stethoscope"
        }
    }
}

/// Severity levels for protocols
enum Severity: String, Codable, CaseIterable {
    case critical = "Critical"
    case urgent = "Urgent"
    case nonUrgent = "Non-Urgent"
    case information = "Information"
}
