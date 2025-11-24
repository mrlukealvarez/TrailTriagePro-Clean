//
//  Bundle+Extensions.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Bundle helper extensions for app version!
//

import Foundation

extension Bundle {
    /// The version string from Info.plist (e.g., "1.0.0")
    var appVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// The build number from Info.plist (e.g., "1")
    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// Combined version and build string (e.g., "1.0.0 (1)")
    var fullVersion: String {
        let version = appVersion ?? "Unknown"
        let build = buildNumber ?? "Unknown"
        return "\(version) (\(build))"
    }
}
