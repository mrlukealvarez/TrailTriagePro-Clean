//
//  VitalsTrackingPanel.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Vitals display component!
//

import SwiftUI
import SwiftData
import Foundation

struct VitalsTrackingPanel: View {
    let note: SOAPNote
    @State private var tracker = VitalSignsTracker.shared
    @State private var showingIntervalPicker = false
    @State private var showingAddVitals = false
    @State private var selectedInterval: VitalSignsTracker.TrackingInterval = .fifteenMinutes
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    
    var isTracking: Bool {
        tracker.isTracking(noteID: note.id)
    }
    
    var session: VitalSignsTracker.VitalTrackingSession? {
        tracker.session(for: note.id)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if isTracking {
                // Active tracking view
                activeTrackingView
            } else {
                // Start tracking view
                startTrackingView
            }
        }
        .padding()
        .background(isTracking ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
        .cornerRadius(12)
        .onAppear {
            loadPreferredInterval()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .sheet(isPresented: $showingAddVitals) {
            QuickAddVitalsSheet(note: note) {
                // Vitals added successfully
            }
        }
        .confirmationDialog("Select Check Interval", isPresented: $showingIntervalPicker) {
            ForEach(VitalSignsTracker.TrackingInterval.allCases) { interval in
                Button(interval.displayName) {
                    selectedInterval = interval
                    startTracking()
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
    }
    
    // MARK: - Active Tracking View
    
    @ViewBuilder
    private var activeTrackingView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "timer")
                    .font(.title2)
                    .foregroundStyle(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Vitals Tracking Active")
                        .font(.headline)
                    
                    if let session = session {
                        Text("Every \(session.intervalMinutes) minutes")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button(role: .destructive) {
                    stopTracking()
                } label: {
                    Image(systemName: "stop.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.red)
                }
            }
            
            Divider()
            
            // Timer display
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next Check")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if timeRemaining > 0 {
                        Text(formatTimeRemaining(timeRemaining))
                            .font(.title2.bold())
                            .foregroundStyle(.green)
                            .monospacedDigit()
                    } else {
                        Text("Ready Now")
                            .font(.title3.bold())
                            .foregroundStyle(.orange)
                    }
                }
                
                Spacer()
                
                if let session = session {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Checks")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("\(session.checksCompleted)")
                            .font(.title2.bold())
                    }
                }
            }
            
            // Quick add button
            Button {
                showingAddVitals = true
            } label: {
                Label("Add Vitals Now", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    // MARK: - Start Tracking View
    
    @ViewBuilder
    private var startTrackingView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "clock.badge.checkmark")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Track Vitals Automatically")
                        .font(.headline)
                    
                    Text("Get reminded to check vitals at regular intervals")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(spacing: 12) {
                // Interval picker button
                Menu {
                    ForEach(VitalSignsTracker.TrackingInterval.allCases) { interval in
                        Button {
                            selectedInterval = interval
                        } label: {
                            HStack {
                                Text(interval.displayName)
                                if selectedInterval == interval {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: selectedInterval.icon)
                        Text(selectedInterval.shortName)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .font(.subheadline.bold())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .foregroundStyle(.blue)
                    .cornerRadius(10)
                }
                
                // Start button
                Button {
                    startTracking()
                } label: {
                    Label("Start Tracking", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func startTracking() {
        Task {
            await tracker.startTracking(
                noteID: note.id,
                patientName: note.patientName,
                intervalMinutes: selectedInterval.rawValue
            )
            
            // Save preferred interval
            UserDefaults.standard.set(selectedInterval.rawValue, forKey: "preferredVitalsInterval")
        }
    }
    
    private func stopTracking() {
        tracker.stopTracking(noteID: note.id)
    }
    
    private func loadPreferredInterval() {
        let saved = UserDefaults.standard.integer(forKey: "preferredVitalsInterval")
        if saved > 0, let interval = VitalSignsTracker.TrackingInterval(rawValue: saved) {
            selectedInterval = interval
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        // Update time remaining every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let remaining = tracker.timeRemaining(for: note.id) {
                timeRemaining = remaining
            } else {
                timeRemaining = 0
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTimeRemaining(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    @Previewable @State var note: SOAPNote = {
        let n = SOAPNote(id: UUID())
        n.patientName = "John Doe"
        return n
    }()
    
    VStack {
        VitalsTrackingPanel(note: note)
            .padding()
        
        Spacer()
    }
    .modelContainer(for: SOAPNote.self, inMemory: true)
}
