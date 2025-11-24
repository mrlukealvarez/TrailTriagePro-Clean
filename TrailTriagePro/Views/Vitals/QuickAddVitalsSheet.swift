//
//  QuickAddVitalsSheet.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Quick vitals entry sheet!
//

import SwiftUI
import SwiftData
import Foundation

struct QuickAddVitalsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let note: SOAPNote
    let onComplete: () -> Void
    
    @State private var heartRate: String = ""
    @State private var respiratoryRate: String = ""
    @State private var bloodPressureSystolic: String = ""
    @State private var bloodPressureDiastolic: String = ""
    @State private var temperature: String = ""
    @State private var oxygenSaturation: String = ""
    @State private var notes: String = ""
    @State private var useImperial = true // Fahrenheit vs Celsius
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case heartRate, respiratoryRate, bpSystolic, bpDiastolic, temperature, spo2, notes
    }
    
    // Computed property for last vitals
    private var lastVitals: VitalSigns? {
        note.vitalSigns.sorted(by: { $0.timestamp > $1.timestamp }).first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with patient info
                    VStack(spacing: 8) {
                        if let patientName = note.patientName {
                            Text(patientName)
                                .font(.title2.bold())
                        } else {
                            Text("Patient Vitals")
                                .font(.title2.bold())
                        }
                        
                        Text("Check #\(note.vitalSigns.count + 1)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text(Date().formatted(date: .omitted, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Last vitals for reference
                    if let last = lastVitals {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Previous Reading")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            
                            HStack(spacing: 12) {
                                if let hr = last.heartRate {
                                    VitalPill(label: "HR", value: "\(hr)", unit: "bpm", trend: nil)
                                }
                                if let rr = last.respiratoryRate {
                                    VitalPill(label: "RR", value: "\(rr)", unit: "/min", trend: nil)
                                }
                                if let bp = last.bloodPressureString {
                                    VitalPill(label: "BP", value: bp, unit: "mmHg", trend: nil)
                                }
                            }
                            
                            Text(last.timestamp.formatted(date: .omitted, time: .shortened))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Quick entry fields
                    VStack(spacing: 20) {
                        // Heart Rate
                        VitalInputRow(
                            icon: "heart.fill",
                            color: .red,
                            label: "Heart Rate",
                            text: $heartRate,
                            unit: "bpm",
                            placeholder: "60-100",
                            keyboardType: .numberPad,
                            focusedField: $focusedField,
                            field: .heartRate
                        )
                        
                        // Respiratory Rate
                        VitalInputRow(
                            icon: "wind",
                            color: .cyan,
                            label: "Respiratory Rate",
                            text: $respiratoryRate,
                            unit: "/min",
                            placeholder: "12-20",
                            keyboardType: .numberPad,
                            focusedField: $focusedField,
                            field: .respiratoryRate
                        )
                        
                        // Blood Pressure
                        HStack(spacing: 12) {
                            Image(systemName: "heart.text.square.fill")
                                .font(.title2)
                                .foregroundStyle(.purple)
                                .frame(width: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Blood Pressure")
                                    .font(.subheadline.bold())
                                
                                HStack(spacing: 8) {
                                    TextField("120", text: $bloodPressureSystolic)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 70)
                                        .focused($focusedField, equals: .bpSystolic)
                                    
                                    Text("/")
                                        .font(.headline)
                                    
                                    TextField("80", text: $bloodPressureDiastolic)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 70)
                                        .focused($focusedField, equals: .bpDiastolic)
                                    
                                    Text("mmHg")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        
                        // Temperature
                        HStack(spacing: 12) {
                            Image(systemName: "thermometer")
                                .font(.title2)
                                .foregroundStyle(.orange)
                                .frame(width: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Temperature")
                                    .font(.subheadline.bold())
                                
                                HStack(spacing: 8) {
                                    TextField(useImperial ? "98.6" : "37.0", text: $temperature)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 90)
                                        .focused($focusedField, equals: .temperature)
                                    
                                    Picker("", selection: $useImperial) {
                                        Text("°F").tag(true)
                                        Text("°C").tag(false)
                                    }
                                    .pickerStyle(.segmented)
                                    .frame(width: 100)
                                }
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .cornerRadius(12)
                        
                        // Oxygen Saturation
                        VitalInputRow(
                            icon: "lungs.fill",
                            color: .blue,
                            label: "SpO₂",
                            text: $oxygenSaturation,
                            unit: "%",
                            placeholder: "95-100",
                            keyboardType: .numberPad,
                            focusedField: $focusedField,
                            field: .spo2
                        )
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.subheadline.bold())
                            
                            TextField("Any changes or observations...", text: $notes, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(3...6)
                                .focused($focusedField, equals: .notes)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Add Vitals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveVitals()
                    }
                    .disabled(!canSave)
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private var canSave: Bool {
        // At least one vital must be entered
        !heartRate.isEmpty || !respiratoryRate.isEmpty ||
        (!bloodPressureSystolic.isEmpty && !bloodPressureDiastolic.isEmpty) ||
        !temperature.isEmpty || !oxygenSaturation.isEmpty
    }
    
    private func saveVitals() {
        let vitals = VitalSigns()
        vitals.timestamp = Date()
        
        // Parse values
        if let hr = Int(heartRate) {
            vitals.heartRate = hr
        }
        
        if let rr = Int(respiratoryRate) {
            vitals.respiratoryRate = rr
        }
        
        if let systolic = Int(bloodPressureSystolic), let diastolic = Int(bloodPressureDiastolic) {
            vitals.bloodPressureSystolic = systolic
            vitals.bloodPressureDiastolic = diastolic
        }
        
        if let temp = Double(temperature) {
            // Convert to Celsius if imperial
            if useImperial {
                vitals.temperature = (temp - 32) * 5/9
            } else {
                vitals.temperature = temp
            }
        }
        
        if let spo2 = Int(oxygenSaturation) {
            vitals.oxygenSaturation = spo2
        }
        
        if !notes.isEmpty {
            vitals.notes = notes
        }
        
        // Add to note
        note.vitalSigns.append(vitals)
        note.lastModified = Date()
        
        // Save context
        do {
            try modelContext.save()
            
            // Notify tracker that vitals were recorded
            Task {
                await VitalSignsTracker.shared.recordVitalsCheck(noteID: note.id)
            }
            
            onComplete()
            dismiss()
        } catch {
            print("Error saving vitals: \(error)")
        }
    }
}

// MARK: - Supporting Views

struct VitalInputRow: View {
    let icon: String
    let color: Color
    let label: String
    @Binding var text: String
    let unit: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    
    var focusedField: FocusState<QuickAddVitalsSheet.Field?>.Binding
    let field: QuickAddVitalsSheet.Field
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline.bold())
                
                HStack(spacing: 8) {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 90)
                        .focused(focusedField, equals: field)
                    
                    Text(unit)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }
}

struct VitalPill: View {
    let label: String
    let value: String
    let unit: String
    let trend: String? // "up", "down", "stable", nil
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
            
            HStack(spacing: 2) {
                Text(value)
                    .font(.caption.bold())
                
                if let trend = trend {
                    Image(systemName: trendIcon(for: trend))
                        .font(.caption2)
                        .foregroundStyle(trendColor(for: trend))
                }
            }
            
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func trendIcon(for trend: String) -> String {
        switch trend {
        case "up": return "arrow.up"
        case "down": return "arrow.down"
        case "stable": return "minus"
        default: return "minus"
        }
    }
    
    private func trendColor(for trend: String) -> Color {
        switch trend {
        case "up": return .red
        case "down": return .blue
        case "stable": return .green
        default: return .secondary
        }
    }
}

#Preview {
    @Previewable @State var note: SOAPNote = {
        let n = SOAPNote(id: UUID())
        n.patientName = "John Doe"
        n.patientAge = 32
        return n
    }()
    
    QuickAddVitalsSheet(note: note, onComplete: {})
        .modelContainer(for: SOAPNote.self, inMemory: true)
}
