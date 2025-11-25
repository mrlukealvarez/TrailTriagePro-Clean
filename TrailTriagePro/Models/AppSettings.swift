//
//  AppSettings.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/7/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: User preferences and app settings model!
//

import Foundation
import SwiftUI

/// User preferences and app settings
@Observable
class AppSettings {
    // Note-taking preferences
    var expertModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(expertModeEnabled, forKey: "expertModeEnabled")
        }
    }
    
    var autoSaveEnabled: Bool {
        didSet {
            UserDefaults.standard.set(autoSaveEnabled, forKey: "autoSaveEnabled")
        }
    }
    
    var captureGPSLocation: Bool {
        didSet {
            UserDefaults.standard.set(captureGPSLocation, forKey: "captureGPSLocation")
        }
    }
    
    var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    // Display preferences
    var showVitalsNormalRanges: Bool {
        didSet {
            UserDefaults.standard.set(showVitalsNormalRanges, forKey: "showVitalsNormalRanges")
        }
    }
    
    // User info (for responder metadata in notes)
    var responderName: String {
        didSet {
            UserDefaults.standard.set(responderName, forKey: "responderName")
        }
    }
    
    var responderAgency: String {
        didSet {
            UserDefaults.standard.set(responderAgency, forKey: "responderAgency")
        }
    }
    
    var responderRescueNumber: String {
        didSet {
            UserDefaults.standard.set(responderRescueNumber, forKey: "responderRescueNumber")
        }
    }
    
    var responderCertification: String {
        didSet {
            UserDefaults.standard.set(responderCertification, forKey: "responderCertification")
        }
    }
    
    var responderCertification2: String {
        didSet {
            UserDefaults.standard.set(responderCertification2, forKey: "responderCertification2")
        }
    }
    
    // Computed property for combined certifications
    var combinedCertifications: String {
        let certs = [responderCertification, responderCertification2]
            .filter { !$0.isEmpty }
        return certs.joined(separator: ", ")
    }
    
    init() {
        self.expertModeEnabled = UserDefaults.standard.bool(forKey: "expertModeEnabled")
        self.autoSaveEnabled = UserDefaults.standard.bool(forKey: "autoSaveEnabled")
        self.captureGPSLocation = UserDefaults.standard.bool(forKey: "captureGPSLocation")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.showVitalsNormalRanges = UserDefaults.standard.bool(forKey: "showVitalsNormalRanges")
        self.responderName = UserDefaults.standard.string(forKey: "responderName") ?? ""
        self.responderAgency = UserDefaults.standard.string(forKey: "responderAgency") ?? ""
        self.responderRescueNumber = UserDefaults.standard.string(forKey: "responderRescueNumber") ?? ""
        self.responderCertification = UserDefaults.standard.string(forKey: "responderCertification") ?? ""
        self.responderCertification2 = UserDefaults.standard.string(forKey: "responderCertification2") ?? ""
    }
}
