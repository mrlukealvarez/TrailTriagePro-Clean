//
//  VitalsTimelineView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Timeline visualization!
//

import SwiftUI
import SwiftData
import Foundation
import Charts

struct VitalsTimelineView: View {
    let note: SOAPNote
    @State private var selectedMetric: VitalMetric = .heartRate
    @State private var showingAddVitals = false
    
    enum VitalMetric: String, CaseIterable, Identifiable {
        case heartRate = "Heart Rate"
        case respiratoryRate = "Respiratory Rate"
        case bloodPressure = "Blood Pressure"
        case temperature = "Temperature"
        case oxygenSaturation = "SpO₂"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .heartRate: return "heart.fill"
            case .respiratoryRate: return "wind"
            case .bloodPressure: return "heart.text.square.fill"
            case .temperature: return "thermometer"
            case .oxygenSaturation: return "lungs.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .heartRate: return .red
            case .respiratoryRate: return .cyan
            case .bloodPressure: return .purple
            case .temperature: return .orange
            case .oxygenSaturation: return .blue
            }
        }
        
        var unit: String {
            switch self {
            case .heartRate: return "bpm"
            case .respiratoryRate: return "/min"
            case .bloodPressure: return "mmHg"
            case .temperature: return "°C"
            case .oxygenSaturation: return "%"
            }
        }
        
        var normalRange: ClosedRange<Double> {
            switch self {
            case .heartRate: return 60...100
            case .respiratoryRate: return 12...20
            case .bloodPressure: return 90...140 // Systolic
            case .temperature: return 36.1...37.2
            case .oxygenSaturation: return 95...100
            }
        }
    }
    
    var sortedVitals: [VitalSigns] {
        note.vitalSigns.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with metric selector
            VStack(spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(VitalMetric.allCases) { metric in
                            MetricButton(
                                metric: metric,
                                isSelected: selectedMetric == metric
                            ) {
                                selectedMetric = metric
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Quick stats
                if !sortedVitals.isEmpty {
                    HStack(spacing: 20) {
                        QuickStat(
                            label: "Latest",
                            value: latestValue(for: selectedMetric),
                            color: selectedMetric.color
                        )
                        
                        QuickStat(
                            label: "Trend",
                            value: trendIndicator(for: selectedMetric),
                            color: trendColor(for: selectedMetric)
                        )
                        
                        QuickStat(
                            label: "Checks",
                            value: "\(sortedVitals.count)",
                            color: .blue
                        )
                    }
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.05))
            
            Divider()
            
            // Chart or empty state
            if sortedVitals.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    
                    Text("No Vitals Recorded Yet")
                        .font(.headline)
                    
                    Text("Add vitals to start tracking trends")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Button {
                        showingAddVitals = true
                    } label: {
                        Label("Add First Reading", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        // Chart
                        VStack(alignment: .leading, spacing: 8) {
                            Text(selectedMetric.rawValue)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            chartView(for: selectedMetric)
                                .frame(height: 200)
                                .padding(.horizontal)
                        }
                        
                        // Timeline list
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Timeline")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(sortedVitals.reversed(), id: \.id) { vital in
                                VitalCheckRow(vital: vital)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .sheet(isPresented: $showingAddVitals) {
            QuickAddVitalsSheet(note: note) {
                // Refresh handled automatically by SwiftData
            }
        }
    }
    
    // MARK: - Chart Views
    
    @ViewBuilder
    private func chartView(for metric: VitalMetric) -> some View {
        Chart {
            // Normal range band
            RectangleMark(
                xStart: .value("Start", sortedVitals.first?.timestamp ?? Date()),
                xEnd: .value("End", sortedVitals.last?.timestamp ?? Date()),
                yStart: .value("Min", metric.normalRange.lowerBound),
                yEnd: .value("Max", metric.normalRange.upperBound)
            )
            .foregroundStyle(.green.opacity(0.1))
            .accessibilityLabel("Normal range")
            
            // Data line
            ForEach(chartData(for: metric), id: \.timestamp) { point in
                LineMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(metric.color)
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(metric.color)
                .symbolSize(60)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(date.formatted(date: .omitted, time: .shortened))
                    }
                }
            }
        }
    }
    
    private struct ChartDataPoint {
        let timestamp: Date
        let value: Double
    }
    
    private func chartData(for metric: VitalMetric) -> [ChartDataPoint] {
        sortedVitals.compactMap { vital in
            guard let value = getValue(from: vital, for: metric) else { return nil }
            return ChartDataPoint(timestamp: vital.timestamp, value: value)
        }
    }
    
    private func getValue(from vital: VitalSigns, for metric: VitalMetric) -> Double? {
        switch metric {
        case .heartRate:
            return vital.heartRate.map { Double($0) }
        case .respiratoryRate:
            return vital.respiratoryRate.map { Double($0) }
        case .bloodPressure:
            return vital.bloodPressureSystolic.map { Double($0) }
        case .temperature:
            return vital.temperature
        case .oxygenSaturation:
            return vital.oxygenSaturation.map { Double($0) }
        }
    }
    
    // MARK: - Helpers
    
    private func latestValue(for metric: VitalMetric) -> String {
        guard let latest = sortedVitals.last,
              let value = getValue(from: latest, for: metric) else {
            return "--"
        }
        
        if metric == .bloodPressure {
            if let diastolic = latest.bloodPressureDiastolic {
                return "\(Int(value))/\(diastolic)"
            }
        }
        
        return String(format: "%.1f", value)
    }
    
    private func trendIndicator(for metric: VitalMetric) -> String {
        guard sortedVitals.count >= 2,
              let first = getValue(from: sortedVitals[0], for: metric),
              let last = getValue(from: sortedVitals[sortedVitals.count - 1], for: metric) else {
            return "--"
        }
        
        let change = last - first
        let percentChange = (change / first) * 100
        
        if abs(percentChange) < 5 {
            return "→"
        } else if change > 0 {
            return "↑"
        } else {
            return "↓"
        }
    }
    
    private func trendColor(for metric: VitalMetric) -> Color {
        let indicator = trendIndicator(for: metric)
        switch indicator {
        case "→": return .green
        case "↑": return .orange
        case "↓": return .blue
        default: return .secondary
        }
    }
}

// MARK: - Supporting Views

struct MetricButton: View {
    let metric: VitalsTimelineView.VitalMetric
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: metric.icon)
                    .font(.callout)
                
                Text(metric.rawValue)
                    .font(.subheadline.bold())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? metric.color : Color.secondary.opacity(0.1))
            .foregroundStyle(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct QuickStat: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(color)
        }
    }
}

struct VitalCheckRow: View {
    let vital: VitalSigns
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(vital.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline.bold())
                
                Spacer()
                
                Text(relativeTime(from: vital.timestamp))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 12) {
                if let hr = vital.heartRate {
                    VitalBadge(icon: "heart.fill", value: "\(hr)", unit: "bpm", color: .red)
                }
                
                if let rr = vital.respiratoryRate {
                    VitalBadge(icon: "wind", value: "\(rr)", unit: "/min", color: .cyan)
                }
                
                if let bp = vital.bloodPressureString {
                    VitalBadge(icon: "heart.text.square.fill", value: bp, unit: "", color: .purple)
                }
            }
            
            HStack(spacing: 12) {
                if let temp = vital.temperature {
                    let tempF = (temp * 9/5) + 32
                    VitalBadge(
                        icon: "thermometer",
                        value: String(format: "%.1f", tempF),
                        unit: "°F",
                        color: .orange
                    )
                }
                
                if let spo2 = vital.oxygenSaturation {
                    VitalBadge(icon: "lungs.fill", value: "\(spo2)", unit: "%", color: .blue)
                }
            }
            
            if let notes = vital.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func relativeTime(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        
        if minutes < 1 {
            return "just now"
        } else if minutes < 60 {
            return "\(minutes)m ago"
        } else {
            let hours = minutes / 60
            return "\(hours)h ago"
        }
    }
}

struct VitalBadge: View {
    let icon: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            
            Text(value)
                .font(.caption.bold())
            
            if !unit.isEmpty {
                Text(unit)
                    .font(.caption2)
            }
        }
        .foregroundStyle(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.1))
        .cornerRadius(6)
    }
}

#Preview {
    @Previewable @State var note: SOAPNote = {
        let n = SOAPNote(id: UUID())
        n.patientName = "Jane Doe"
        
        // Add some sample vitals
        let vital1 = VitalSigns(id: UUID(), heartRate: 72, respiratoryRate: 16, bloodPressureSystolic: 120, bloodPressureDiastolic: 80)
        let vital2 = VitalSigns(id: UUID(), heartRate: 78, respiratoryRate: 18, bloodPressureSystolic: 125, bloodPressureDiastolic: 82)
        vital2.timestamp = Date().addingTimeInterval(-600)
        
        n.vitalSigns = [vital1, vital2]
        
        return n
    }()
    
    VitalsTimelineView(note: note)
        .modelContainer(for: SOAPNote.self, inMemory: true)
}
