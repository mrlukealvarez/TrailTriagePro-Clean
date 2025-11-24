//
//  WFR_TrailTriageApp.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/7/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Main app entry point with SwiftData model container setup!
//

import SwiftUI
import SwiftData

@main
struct WFR_TrailTriageApp: App {
    @State private var appSettings = AppSettings()
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WFRProtocol.self,
            SOAPNote.self,
            VitalSigns.self,
            WFRModule.self,
            WFRModuleSection.self,
            WFRModuleContentBlock.self,
            // Legacy chapter support (can be removed after migration)
            WFRChapter.self,
            WFRSection.self,
            WFRContentBlock.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Seed reference content
            ModuleSeedData.seedModules(context: container.mainContext)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
                    .environment(appSettings)
            } else {
                MainTabView()
                    .environment(appSettings)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
