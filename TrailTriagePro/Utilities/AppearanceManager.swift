//
//  AppearanceManager.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Theme & appearance management!
//

import SwiftUI

/// Manages app-wide appearance settings
@MainActor
final class AppearanceManager {
    static let shared = AppearanceManager()
    
    @AppStorage("appearance") private var storedAppearance: AppearanceMode = .system
    
    private init() {}
    
    var appearance: AppearanceMode {
        get { storedAppearance }
        set { storedAppearance = newValue }
    }
    
    var colorScheme: ColorScheme? {
        appearance.colorScheme
    }
}

// MARK: - View Extension
extension View {
    /// Applies the user's preferred color scheme to the view
    func applyUserPreferredAppearance() -> some View {
        let manager = AppearanceManager.shared
        return self.preferredColorScheme(manager.colorScheme)
    }
}
