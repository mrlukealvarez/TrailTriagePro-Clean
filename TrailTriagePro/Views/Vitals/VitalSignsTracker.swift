//
//  VitalSignsTracker.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Vitals monitoring & notifications!
//

import Foundation
import SwiftData
import UserNotifications

/// Manages timed vital signs tracking with notifications
@Observable
class VitalSignsTracker {
    static let shared = VitalSignsTracker()
    
    // Active tracking sessions (note ID -> timer info)
    private(set) var activeSessions: [UUID: VitalTrackingSession] = [:]
    
    // MARK: - Types
    
    struct VitalTrackingSession: Codable {
        let noteID: UUID
        let patientName: String?
        let startTime: Date
        let intervalMinutes: Int
        var nextCheckTime: Date
        var checksCompleted: Int = 0
        
        var isActive: Bool {
            Date() < nextCheckTime
        }
    }
    
    enum TrackingInterval: Int, CaseIterable, Identifiable {
        case fiveMinutes = 5
        case tenMinutes = 10
        case fifteenMinutes = 15
        case thirtyMinutes = 30
        case sixtyMinutes = 60
        
        var id: Int { rawValue }
        
        var displayName: String {
            switch self {
            case .fiveMinutes: return "5 minutes"
            case .tenMinutes: return "10 minutes"
            case .fifteenMinutes: return "15 minutes"
            case .thirtyMinutes: return "30 minutes"
            case .sixtyMinutes: return "1 hour"
            }
        }
        
        var shortName: String {
            switch self {
            case .fiveMinutes: return "5 min"
            case .tenMinutes: return "10 min"
            case .fifteenMinutes: return "15 min"
            case .thirtyMinutes: return "30 min"
            case .sixtyMinutes: return "1 hr"
            }
        }
        
        var icon: String {
            switch self {
            case .fiveMinutes: return "timer"
            case .tenMinutes: return "clock"
            case .fifteenMinutes: return "clock.fill"
            case .thirtyMinutes: return "clock.badge"
            case .sixtyMinutes: return "clock.badge.checkmark"
            }
        }
    }
    
    // MARK: - Init
    
    private init() {
        loadActiveSessions()
    }
    
    // MARK: - Session Management
    
    /// Start tracking vitals for a note
    func startTracking(
        noteID: UUID,
        patientName: String?,
        intervalMinutes: Int
    ) async {
        // Request notification permission if needed
        await requestNotificationPermission()
        
        // Create session
        let nextCheck = Date().addingTimeInterval(TimeInterval(intervalMinutes * 60))
        let session = VitalTrackingSession(
            noteID: noteID,
            patientName: patientName,
            startTime: Date(),
            intervalMinutes: intervalMinutes,
            nextCheckTime: nextCheck,
            checksCompleted: 0
        )
        
        activeSessions[noteID] = session
        saveActiveSessions()
        
        // Schedule notification
        await scheduleNotification(for: session)
        
        print("✅ Started vital signs tracking for note \(noteID) every \(intervalMinutes) min")
    }
    
    /// Stop tracking vitals for a note
    func stopTracking(noteID: UUID) {
        activeSessions.removeValue(forKey: noteID)
        saveActiveSessions()
        
        // Cancel notifications
        cancelNotifications(for: noteID)
        
        print("⏹️ Stopped vital signs tracking for note \(noteID)")
    }
    
    /// Record that vitals were checked - resets timer
    func recordVitalsCheck(noteID: UUID) async {
        guard var session = activeSessions[noteID] else { return }
        
        // Update session
        session.checksCompleted += 1
        session.nextCheckTime = Date().addingTimeInterval(TimeInterval(session.intervalMinutes * 60))
        activeSessions[noteID] = session
        saveActiveSessions()
        
        // Schedule next notification
        await scheduleNotification(for: session)
        
        print("✅ Recorded vitals check #\(session.checksCompleted) for note \(noteID)")
    }
    
    /// Check if tracking is active for a note
    func isTracking(noteID: UUID) -> Bool {
        activeSessions[noteID] != nil
    }
    
    /// Get active session for a note
    func session(for noteID: UUID) -> VitalTrackingSession? {
        activeSessions[noteID]
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied")
            }
        } catch {
            print("❌ Error requesting notification permission: \(error)")
        }
    }
    
    private func scheduleNotification(for session: VitalTrackingSession) async {
        let center = UNUserNotificationCenter.current()
        
        // Cancel existing notifications for this note
        cancelNotifications(for: session.noteID)
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Time to Check Vitals"
        
        if let patientName = session.patientName {
            content.body = "It's time to record vitals for \(patientName)"
        } else {
            content.body = "It's time to record patient vitals"
        }
        
        content.categoryIdentifier = "VITALS_CHECK"
        content.sound = .defaultCritical // Critical sound to override silent mode
        content.interruptionLevel = .timeSensitive // Shows even in Focus mode
        
        // Add note ID to userInfo for deep linking
        content.userInfo = [
            "noteID": session.noteID.uuidString,
            "action": "addVitals"
        ]
        
        // Calculate time until next check
        let timeInterval = session.nextCheckTime.timeIntervalSinceNow
        
        guard timeInterval > 0 else {
            print("⚠️ Next check time is in the past, not scheduling notification")
            return
        }
        
        // Create trigger
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
        
        // Create request
        let identifier = "vitals-\(session.noteID.uuidString)"
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Schedule notification
        do {
            try await center.add(request)
            print("✅ Scheduled notification for \(session.nextCheckTime.formatted(date: .omitted, time: .shortened))")
        } catch {
            print("❌ Error scheduling notification: \(error)")
        }
    }
    
    private func cancelNotifications(for noteID: UUID) {
        let center = UNUserNotificationCenter.current()
        let identifier = "vitals-\(noteID.uuidString)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    // MARK: - Persistence
    
    private func saveActiveSessions() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(activeSessions) {
            UserDefaults.standard.set(encoded, forKey: "activeVitalsSessions")
        }
    }
    
    private func loadActiveSessions() {
        if let data = UserDefaults.standard.data(forKey: "activeVitalsSessions") {
            let decoder = JSONDecoder()
            if let sessions = try? decoder.decode([UUID: VitalTrackingSession].self, from: data) {
                activeSessions = sessions
                
                // Clean up expired sessions
                let now = Date()
                activeSessions = activeSessions.filter { _, session in
                    // Keep sessions that are still active or within 1 hour of next check
                    session.nextCheckTime.addingTimeInterval(3600) > now
                }
                saveActiveSessions()
            }
        }
    }
    
    // MARK: - Time Remaining
    
    /// Get time remaining until next vitals check
    func timeRemaining(for noteID: UUID) -> TimeInterval? {
        guard let session = activeSessions[noteID] else { return nil }
        return session.nextCheckTime.timeIntervalSinceNow
    }
    
    /// Get formatted time remaining string
    func formattedTimeRemaining(for noteID: UUID) -> String? {
        guard let remaining = timeRemaining(for: noteID), remaining > 0 else {
            return nil
        }
        
        let minutes = Int(remaining / 60)
        let seconds = Int(remaining.truncatingRemainder(dividingBy: 60))
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Notification Category Setup

extension VitalSignsTracker {
    /// Call this during app initialization to set up notification categories
    static func setupNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        
        // Define actions
        let addVitalsAction = UNNotificationAction(
            identifier: "ADD_VITALS",
            title: "Add Vitals Now",
            options: [.foreground]
        )
        
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_5MIN",
            title: "Remind in 5 min",
            options: []
        )
        
        // Create category
        let category = UNNotificationCategory(
            identifier: "VITALS_CHECK",
            actions: [addVitalsAction, snoozeAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Register category
        center.setNotificationCategories([category])
    }
}
