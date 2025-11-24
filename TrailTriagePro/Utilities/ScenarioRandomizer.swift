//
//  ScenarioRandomizer.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Randomize scenario locations for fresh content!
//

import Foundation

/// Utility for randomly assigning park locations to WFR scenarios
/// Ensures variety and appropriate locations for different scenario types
struct ScenarioRandomizer {
    
    /// Randomize location for a scenario based on context
    /// - Parameters:
    ///   - scenarioType: Type of medical scenario (e.g., "hypothermia", "altitude illness")
    ///   - moduleCategory: Category of the module containing the scenario
    /// - Returns: A random appropriate park location as a display string
    static func randomizeLocation(
        for scenarioType: String? = nil,
        in moduleCategory: ModuleCategory? = nil
    ) -> String {
        var location: ParkLocation?
        
        // Choose location based on scenario type or module category
        if let category = moduleCategory {
            location = chooseLocationForCategory(category)
        } else if let type = scenarioType {
            location = chooseLocationForScenarioType(type)
        } else {
            // Random location from all remote locations
            location = ParkLocations.randomLocation(remoteOnly: true)
        }
        
        return ParkLocations.displayString(for: location ?? defaultLocation())
    }
    
    /// Choose appropriate location based on module category
    private static func chooseLocationForCategory(_ category: ModuleCategory) -> ParkLocation? {
        switch category {
        case .environmental:
            // Environmental emergencies - vary by type
            // Mix of high elevation (hypothermia) and desert (heat illness)
            let locations = [
                ParkLocations.randomLocation(byTerrain: .alpine, byElevation: .veryHigh, remoteOnly: true),
                ParkLocations.randomLocation(byTerrain: .desert, remoteOnly: true),
                ParkLocations.randomLocation(byTerrain: .mountain, remoteOnly: true)
            ].compactMap { $0 }
            return locations.randomElement() ?? ParkLocations.randomLocation(remoteOnly: true)
            
        case .medical:
            // Medical emergencies - any remote location
            return ParkLocations.randomLocation(remoteOnly: true)
            
        case .trauma:
            // Trauma scenarios - mix of terrain types
            let locations = [
                ParkLocations.randomLocation(byTerrain: .mountain, remoteOnly: true),
                ParkLocations.randomLocation(byTerrain: .forest, remoteOnly: true),
                ParkLocations.randomLocation(byTerrain: .canyon, remoteOnly: true)
            ].compactMap { $0 }
            return locations.randomElement() ?? ParkLocations.randomLocation(remoteOnly: true)
            
        case .assessment:
            // Assessment - any location suitable
            return ParkLocations.randomLocation(remoteOnly: true)
            
        case .minor:
            // Minor issues - any location
            return ParkLocations.randomLocation(remoteOnly: true)
            
        case .evacuation:
            // Evacuation scenarios - remote, challenging locations
            let locations = [
                ParkLocations.randomLocation(byTerrain: .alpine, remoteOnly: true),
                ParkLocations.randomLocation(byTerrain: .mountain, remoteOnly: true),
                ParkLocations.randomLocation(byType: .wildernessArea, remoteOnly: true)
            ].compactMap { $0 }
            return locations.randomElement() ?? ParkLocations.randomLocation(remoteOnly: true)
            
        case .communication:
            // Communication scenarios - very remote
            return ParkLocations.randomLocation(remoteOnly: true)
            
        case .general:
            return ParkLocations.randomLocation(remoteOnly: true)
        }
    }
    
    /// Choose appropriate location based on scenario type
    private static func chooseLocationForScenarioType(_ type: String) -> ParkLocation? {
        let lowercased = type.lowercased()
        
        // High elevation scenarios
        if lowercased.contains("altitude") || lowercased.contains("hypoxia") || 
           lowercased.contains("hypothermia") || lowercased.contains("cold") {
            return ParkLocations.randomLocation(
                byTerrain: .alpine,
                byElevation: .veryHigh,
                remoteOnly: true
            ) ?? ParkLocations.randomLocation(byElevation: .high, remoteOnly: true)
        }
        
        // Heat/desert scenarios
        if lowercased.contains("heat") || lowercased.contains("hyperthermia") || 
           lowercased.contains("dehydration") || lowercased.contains("desert") {
            return ParkLocations.randomLocation(byTerrain: .desert, remoteOnly: true)
        }
        
        // Lightning scenarios
        if lowercased.contains("lightning") {
            return ParkLocations.randomLocation(byTerrain: .mountain, remoteOnly: true)
        }
        
        // Drowning/water scenarios
        if lowercased.contains("drowning") || lowercased.contains("water") {
            let locations = [
                ParkLocations.randomLocation(byTerrain: .coastal, remoteOnly: true),
                ParkLocations.randomLocation(byTerrain: .forest, remoteOnly: true)
            ].compactMap { $0 }
            return locations.randomElement()
        }
        
        // Snakebite scenarios
        if lowercased.contains("snake") || lowercased.contains("bite") {
            return ParkLocations.randomLocation(byTerrain: .desert, remoteOnly: true) ??
                   ParkLocations.randomLocation(byTerrain: .forest, remoteOnly: true)
        }
        
        // Avalanche scenarios
        if lowercased.contains("avalanche") {
            return ParkLocations.randomLocation(
                byTerrain: .alpine,
                byElevation: .veryHigh,
                remoteOnly: true
            )
        }
        
        // Default - any remote location
        return ParkLocations.randomLocation(remoteOnly: true)
    }
    
    /// Get default location if randomization fails
    private static func defaultLocation() -> ParkLocation {
        // Return a common, appropriate default
        return ParkLocations.allLocations.first { $0.name == "Yellowstone National Park" } ??
               ParkLocations.allLocations.first!
    }
    
    /// Randomize multiple locations ensuring variety
    /// - Parameter count: Number of locations needed
    /// - Returns: Array of unique location strings
    static func randomizeMultipleLocations(count: Int, exclude: [String] = []) -> [String] {
        var locations: [String] = []
        var usedLocations = Set<String>()
        usedLocations.formUnion(exclude)
        
        let allLocations = ParkLocations.allLocations.filter { location in
            location.isRemote && !usedLocations.contains(ParkLocations.displayString(for: location))
        }
        
        let shuffled = allLocations.shuffled()
        
        for location in shuffled.prefix(count) {
            let locationString = ParkLocations.displayString(for: location)
            if !usedLocations.contains(locationString) {
                locations.append(locationString)
                usedLocations.insert(locationString)
            }
        }
        
        // Fill remaining slots if needed
        while locations.count < count {
            if let location = ParkLocations.randomLocation(remoteOnly: true) {
                let locationString = ParkLocations.displayString(for: location)
                if !usedLocations.contains(locationString) {
                    locations.append(locationString)
                    usedLocations.insert(locationString)
                }
            }
        }
        
        return Array(locations.prefix(count))
    }
    
    /// Check if a location is appropriate for a scenario type
    static func isLocationAppropriate(_ location: ParkLocation, for scenarioType: String) -> Bool {
        let lowercased = scenarioType.lowercased()
        
        // High elevation scenarios need high elevation locations
        if lowercased.contains("altitude") || lowercased.contains("hypoxia") {
            return location.elevation == .high || location.elevation == .veryHigh
        }
        
        // Desert scenarios need desert locations
        if lowercased.contains("heat") || lowercased.contains("hyperthermia") {
            return location.terrainType == .desert
        }
        
        return true
    }
}

