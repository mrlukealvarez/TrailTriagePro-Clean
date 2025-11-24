//
//  PreferencesView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: User preferences!
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage("appearance") private var appearance: AppearanceMode = .system
    @AppStorage("enableNotifications") private var enableNotifications = true
    @AppStorage("enableSoundEffects") private var enableSoundEffects = true
    @AppStorage("useMetricUnits") private var useMetricUnits = false
    @AppStorage("autoSaveInterval") private var autoSaveInterval: AutoSaveInterval = .immediate
    
    var body: some View {
        List {
            // Appearance Section
            Section {
                Picker("Theme", selection: $appearance) {
                    ForEach(AppearanceMode.allCases, id: \.self) { mode in
                        Label(mode.displayName, systemImage: mode.iconName)
                            .tag(mode)
                    }
                }
                .pickerStyle(.inline)
            } header: {
                Label("Appearance", systemImage: "paintbrush.fill")
            } footer: {
                Text("Choose how TrailTriage looks on your device")
            }
            
            // Notifications Section
            Section {
                Toggle(isOn: $enableNotifications) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(.blue)
                            .frame(width: 24)
                        Text("Enable Notifications")
                    }
                }
                
                if enableNotifications {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundStyle(.blue)
                                .frame(width: 24)
                            Text("Notification Preferences")
                        }
                    }
                }
            } header: {
                Label("Notifications", systemImage: "bell.badge.fill")
            } footer: {
                Text("Receive reminders and updates")
            }
            
            // Sound & Haptics
            Section {
                Toggle(isOn: $enableSoundEffects) {
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(.orange)
                            .frame(width: 24)
                        Text("Sound Effects")
                    }
                }
            } header: {
                Label("Sound & Haptics", systemImage: "waveform")
            }
            
            // Units Section
            Section {
                Toggle(isOn: $useMetricUnits) {
                    HStack(spacing: 12) {
                        Image(systemName: "ruler.fill")
                            .foregroundStyle(.green)
                            .frame(width: 24)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Use Metric Units")
                            Text(useMetricUnits ? "Celsius, cm, kg" : "Fahrenheit, inches, lbs")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Label("Measurement Units", systemImage: "ruler")
            } footer: {
                Text("Choose your preferred measurement system for vital signs and patient data")
            }
            
            // Auto-Save Section
            Section {
                Picker("Auto-Save Interval", selection: $autoSaveInterval) {
                    ForEach(AutoSaveInterval.allCases, id: \.self) { interval in
                        Text(interval.displayName).tag(interval)
                    }
                }
                .pickerStyle(.menu)
            } header: {
                Label("Auto-Save", systemImage: "arrow.clockwise.circle.fill")
            } footer: {
                Text("How often your SOAP notes are automatically saved")
            }
            
            // Reset Section
            Section {
                Button(role: .destructive) {
                    resetToDefaults()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset to Defaults")
                    }
                }
            } header: {
                Label("Reset", systemImage: "arrow.counterclockwise.circle")
            } footer: {
                Text("Restore all preferences to their default values")
            }
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func resetToDefaults() {
        appearance = .system
        enableNotifications = true
        enableSoundEffects = true
        useMetricUnits = false
        autoSaveInterval = .immediate
    }
}

// MARK: - Appearance Mode
enum AppearanceMode: String, CaseIterable {
    case light
    case dark
    case system
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "Automatic"
        }
    }
    
    var iconName: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

// MARK: - Auto-Save Interval
enum AutoSaveInterval: String, CaseIterable {
    case immediate
    case every30Seconds
    case every1Minute
    case every5Minutes
    case manual
    
    var displayName: String {
        switch self {
        case .immediate: return "Immediate"
        case .every30Seconds: return "Every 30 seconds"
        case .every1Minute: return "Every minute"
        case .every5Minutes: return "Every 5 minutes"
        case .manual: return "Manual only"
        }
    }
    
    var timeInterval: TimeInterval? {
        switch self {
        case .immediate: return nil
        case .every30Seconds: return 30
        case .every1Minute: return 60
        case .every5Minutes: return 300
        case .manual: return nil
        }
    }
}

// MARK: - Notification Settings View
private struct NotificationSettingsView: View {
    @AppStorage("notifyOnNewProtocols") private var notifyOnNewProtocols = true
    @AppStorage("notifyOnSOAPReminder") private var notifyOnSOAPReminder = true
    @AppStorage("notifyOnUpdates") private var notifyOnUpdates = true
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $notifyOnNewProtocols) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("New Protocols")
                        Text("When new medical protocols are added")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Toggle(isOn: $notifyOnSOAPReminder) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SOAP Note Reminders")
                        Text("Remind me to complete unfinished notes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Toggle(isOn: $notifyOnUpdates) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("App Updates")
                        Text("When new features are available")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Notification Types")
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PreferencesView()
    }
}
