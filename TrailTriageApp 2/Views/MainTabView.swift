//
//  MainTabView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Root tab navigation container for the entire app!
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Notes Tab
            NotesListView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(0)
            
            // New Note Tab
            NewNoteView()
                .tabItem {
                    Label("New Note", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            // Reference Book Tab - Modern Module-Based System
            ModuleListView()
                .tabItem {
                    Label("Reference", systemImage: "book.fill")
                }
                .tag(2)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
    }
}

// MARK: - Legacy Reference Tab View (Kept for backward compatibility)
// NOTE: This has been replaced by ModuleListView for the modern module-based system
// The old ReferenceTabView is kept here in case needed for reference, but is no longer used in MainTabView

// MARK: - Legacy Components (Preserved for reference)
// These components were part of the old chapter-based system and can be removed if not needed

// struct ReferenceTabView: View { ... } - Moved to ModuleListView.swift
// struct SectionButton: View { ... } - Replaced by CategoryChip in ModuleListView.swift

#Preview {
    MainTabView()
        .environment(AppSettings())
}
