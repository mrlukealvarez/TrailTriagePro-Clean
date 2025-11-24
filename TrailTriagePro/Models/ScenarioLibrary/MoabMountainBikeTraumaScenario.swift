//
//  MoabMountainBikeTraumaScenario.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/23/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: A gnarly scenario for testing advanced trauma skills!
//

import Foundation
import SwiftData

/// Represents a specific training scenario: Mountain Bike Crash in Moab
/// This model will eventually hold the specific data, graphics, and branching logic
/// for this interactive scenario.
@Model
final class MoabMountainBikeTraumaScenario {
    var id: UUID
    var title: String
    var difficultyLevel: String // "Beginner", "Intermediate", "Advanced"
    var location: String
    var descriptionText: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), 
         title: String = "Slickrock Endover", 
         difficultyLevel: String = "Intermediate",
         location: String = "Moab, UT - Slickrock Trail",
         descriptionText: String = "A mountain biker has gone over the handlebars on a steep sandstone section. Potential head, neck, and wrist injuries.",
         isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.difficultyLevel = difficultyLevel
        self.location = location
        self.descriptionText = descriptionText
        self.isCompleted = isCompleted
    }
}
