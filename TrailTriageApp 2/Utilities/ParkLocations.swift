//
//  ParkLocations.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Comprehensive park location database for scenario randomization!
//

import Foundation

/// Represents a park or wilderness location suitable for WFR scenarios
struct ParkLocation {
    let name: String
    let state: String
    let parkType: ParkType
    let terrainType: TerrainType
    let elevation: ElevationRange
    let isRemote: Bool // True for backcountry/wilderness scenarios
    
    enum ParkType: String, Codable {
        case nationalPark = "National Park"
        case nationalForest = "National Forest"
        case statePark = "State Park"
        case wildernessArea = "Wilderness Area"
        case nationalMonument = "National Monument"
        case nationalRecreationArea = "National Recreation Area"
        case blmLand = "BLM Land"
    }
    
    enum TerrainType: String, Codable {
        case mountain = "Mountain"
        case desert = "Desert"
        case forest = "Forest"
        case alpine = "Alpine"
        case coastal = "Coastal"
        case canyon = "Canyon"
        case prairie = "Prairie"
        case tundra = "Tundra"
    }
    
    enum ElevationRange: String, Codable {
        case seaLevel = "Sea Level - 2,000 ft"
        case low = "2,000 - 5,000 ft"
        case moderate = "5,000 - 8,000 ft"
        case high = "8,000 - 11,000 ft"
        case veryHigh = "11,000+ ft"
    }
}

/// Comprehensive database of US National Parks, State Parks, and wilderness areas
struct ParkLocations {
    
    /// All available park locations
    static let allLocations: [ParkLocation] = [
        // National Parks - Mountain/Alpine
        ParkLocation(name: "Yellowstone National Park", state: "Wyoming/Montana/Idaho", parkType: .nationalPark, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Yosemite National Park", state: "California", parkType: .nationalPark, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Rocky Mountain National Park", state: "Colorado", parkType: .nationalPark, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Grand Teton National Park", state: "Wyoming", parkType: .nationalPark, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Glacier National Park", state: "Montana", parkType: .nationalPark, terrainType: .alpine, elevation: .high, isRemote: true),
        ParkLocation(name: "Mount Rainier National Park", state: "Washington", parkType: .nationalPark, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "North Cascades National Park", state: "Washington", parkType: .nationalPark, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Olympic National Park", state: "Washington", parkType: .nationalPark, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Sequoia National Park", state: "California", parkType: .nationalPark, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Kings Canyon National Park", state: "California", parkType: .nationalPark, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Great Smoky Mountains National Park", state: "North Carolina/Tennessee", parkType: .nationalPark, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Shenandoah National Park", state: "Virginia", parkType: .nationalPark, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Acadia National Park", state: "Maine", parkType: .nationalPark, terrainType: .coastal, elevation: .low, isRemote: true),
        ParkLocation(name: "Black Hills National Forest", state: "South Dakota", parkType: .nationalForest, terrainType: .mountain, elevation: .moderate, isRemote: true),
        
        // National Parks - Desert/Canyon
        ParkLocation(name: "Grand Canyon National Park", state: "Arizona", parkType: .nationalPark, terrainType: .canyon, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Zion National Park", state: "Utah", parkType: .nationalPark, terrainType: .canyon, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Arches National Park", state: "Utah", parkType: .nationalPark, terrainType: .desert, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Canyonlands National Park", state: "Utah", parkType: .nationalPark, terrainType: .canyon, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Bryce Canyon National Park", state: "Utah", parkType: .nationalPark, terrainType: .canyon, elevation: .high, isRemote: true),
        ParkLocation(name: "Joshua Tree National Park", state: "California", parkType: .nationalPark, terrainType: .desert, elevation: .low, isRemote: true),
        ParkLocation(name: "Death Valley National Park", state: "California", parkType: .nationalPark, terrainType: .desert, elevation: .low, isRemote: true),
        ParkLocation(name: "Mojave National Preserve", state: "California", parkType: .nationalPark, terrainType: .desert, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Capitol Reef National Park", state: "Utah", parkType: .nationalPark, terrainType: .canyon, elevation: .moderate, isRemote: true),
        
        // National Parks - Forest/Coastal
        ParkLocation(name: "Redwood National Park", state: "California", parkType: .nationalPark, terrainType: .forest, elevation: .low, isRemote: true),
        ParkLocation(name: "Great Basin National Park", state: "Nevada", parkType: .nationalPark, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Crater Lake National Park", state: "Oregon", parkType: .nationalPark, terrainType: .alpine, elevation: .high, isRemote: true),
        ParkLocation(name: "Mount Hood National Forest", state: "Oregon", parkType: .nationalForest, terrainType: .mountain, elevation: .high, isRemote: true),
        
        // State Parks - Mountain
        ParkLocation(name: "Baxter State Park", state: "Maine", parkType: .statePark, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Adirondack Park", state: "New York", parkType: .statePark, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "White Mountain National Forest", state: "New Hampshire", parkType: .nationalForest, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "San Juan National Forest", state: "Colorado", parkType: .nationalForest, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Sawtooth National Forest", state: "Idaho", parkType: .nationalForest, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Uinta-Wasatch-Cache National Forest", state: "Utah", parkType: .nationalForest, terrainType: .mountain, elevation: .high, isRemote: true),
        
        // State Parks - Desert/Southwest
        ParkLocation(name: "Big Bend National Park", state: "Texas", parkType: .nationalPark, terrainType: .desert, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Guadalupe Mountains National Park", state: "Texas", parkType: .nationalPark, terrainType: .desert, elevation: .high, isRemote: true),
        ParkLocation(name: "Chiricahua National Monument", state: "Arizona", parkType: .nationalMonument, terrainType: .desert, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Organ Pipe Cactus National Monument", state: "Arizona", parkType: .nationalMonument, terrainType: .desert, elevation: .low, isRemote: true),
        
        // State Parks - Forest/East Coast
        ParkLocation(name: "Alleghany State Park", state: "Pennsylvania", parkType: .statePark, terrainType: .forest, elevation: .low, isRemote: true),
        ParkLocation(name: "Hocking Hills State Park", state: "Ohio", parkType: .statePark, terrainType: .forest, elevation: .low, isRemote: false),
        ParkLocation(name: "Letchworth State Park", state: "New York", parkType: .statePark, terrainType: .forest, elevation: .low, isRemote: false),
        
        // Wilderness Areas
        ParkLocation(name: "Frank Church River of No Return Wilderness", state: "Idaho", parkType: .wildernessArea, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Selway-Bitterroot Wilderness", state: "Idaho/Montana", parkType: .wildernessArea, terrainType: .mountain, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Bob Marshall Wilderness", state: "Montana", parkType: .wildernessArea, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Absaroka-Beartooth Wilderness", state: "Montana/Wyoming", parkType: .wildernessArea, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Weminuche Wilderness", state: "Colorado", parkType: .wildernessArea, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Maroon Bells-Snowmass Wilderness", state: "Colorado", parkType: .wildernessArea, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "John Muir Wilderness", state: "California", parkType: .wildernessArea, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Ansel Adams Wilderness", state: "California", parkType: .wildernessArea, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Sawtooth Wilderness", state: "Idaho", parkType: .wildernessArea, terrainType: .mountain, elevation: .high, isRemote: true),
        
        // Additional remote locations
        ParkLocation(name: "Denali National Park", state: "Alaska", parkType: .nationalPark, terrainType: .tundra, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Gates of the Arctic National Park", state: "Alaska", parkType: .nationalPark, terrainType: .tundra, elevation: .moderate, isRemote: true),
        ParkLocation(name: "Wrangell-St. Elias National Park", state: "Alaska", parkType: .nationalPark, terrainType: .alpine, elevation: .veryHigh, isRemote: true),
        ParkLocation(name: "Kenai Fjords National Park", state: "Alaska", parkType: .nationalPark, terrainType: .coastal, elevation: .low, isRemote: true),
        ParkLocation(name: "Haleakalā National Park", state: "Hawaii", parkType: .nationalPark, terrainType: .mountain, elevation: .high, isRemote: true),
        ParkLocation(name: "Hawaiʻi Volcanoes National Park", state: "Hawaii", parkType: .nationalPark, terrainType: .mountain, elevation: .moderate, isRemote: true),
    ]
    
    /// Get locations filtered by criteria
    static func locations(
        byType: ParkLocation.ParkType? = nil,
        byTerrain: ParkLocation.TerrainType? = nil,
        byElevation: ParkLocation.ElevationRange? = nil,
        remoteOnly: Bool = false
    ) -> [ParkLocation] {
        var filtered = allLocations
        
        if let type = byType {
            filtered = filtered.filter { $0.parkType == type }
        }
        
        if let terrain = byTerrain {
            filtered = filtered.filter { $0.terrainType == terrain }
        }
        
        if let elevation = byElevation {
            filtered = filtered.filter { $0.elevation == elevation }
        }
        
        if remoteOnly {
            filtered = filtered.filter { $0.isRemote }
        }
        
        return filtered
    }
    
    /// Get a random location
    static func randomLocation(
        byType: ParkLocation.ParkType? = nil,
        byTerrain: ParkLocation.TerrainType? = nil,
        byElevation: ParkLocation.ElevationRange? = nil,
        remoteOnly: Bool = true
    ) -> ParkLocation? {
        let filtered = locations(byType: byType, byTerrain: byTerrain, byElevation: byElevation, remoteOnly: remoteOnly)
        return filtered.randomElement()
    }
    
    /// Format location as display string
    static func displayString(for location: ParkLocation) -> String {
        return "\(location.name), \(location.state)"
    }
    
    /// Format location with park type
    static func detailedDisplayString(for location: ParkLocation) -> String {
        return "\(location.name) (\(location.parkType.rawValue)), \(location.state)"
    }
}

