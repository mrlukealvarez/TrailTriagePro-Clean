//
//  ExpertModeNoteView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Full SOAP note editor (comprehensive)!
//


import SwiftUI
import SwiftData
import CoreLocation
import MapKit
import Combine
import PDFKit
import UIKit

// MARK: - Location Manager Delegate
class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?
    var onLocationUpdate: ((CLLocation) -> Void)?
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            if let location = locations.last {
                lastLocation = location
                onLocationUpdate?(location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization changed to: \(manager.authorizationStatus.rawValue)")
    }
}

// MARK: - Body Region Enum
enum BodyRegion: String, CaseIterable, Hashable {
    case head = "Head"
    case neck = "Neck"
    case chestAnterior = "Chest (anterior)"
    case backPosterior = "Back (posterior)"
    case abdomen = "Abdomen"
    case upperArmLeft = "Upper arm L"
    case upperArmRight = "Upper arm R"
    case forearmLeft = "Forearm/Hand L"
    case forearmRight = "Forearm/Hand R"
    case thighLeft = "Thigh L"
    case thighRight = "Thigh R"
    case lowerLegLeft = "Lower leg L"
    case lowerLegRight = "Lower leg R"
    case footLeft = "Foot L"
    case footRight = "Foot R"
    case genitals = "Genitals"
    
    var percentage: Double {
        switch self {
        case .head, .chestAnterior, .backPosterior, .abdomen:
            return 9.0
        case .upperArmLeft, .upperArmRight, .forearmLeft, .forearmRight,
             .thighLeft, .thighRight, .lowerLegLeft, .lowerLegRight:
            return 4.5
        case .genitals:
            return 1.0
        case .neck, .footLeft, .footRight:
            return 0.0
        }
    }
}

struct IntakeOutputSelection: Equatable {
    var ate = false
    var drank = false
    var urinated = false
    var defecated = false
    
    var summary: String? {
        let selections = [
            ate ? "Ate" : nil,
            drank ? "Drank" : nil,
            urinated ? "Urinated" : nil,
            defecated ? "Bowel movement" : nil
        ].compactMap { $0 }
        
        guard !selections.isEmpty else { return nil }
        return selections.joined(separator: " • ")
    }
    
    static func parse(from text: String?) -> IntakeOutputSelection? {
        guard let text = text?.lowercased(), !text.isEmpty else { return nil }
        var selection = IntakeOutputSelection()
        if text.contains("ate") { selection.ate = true }
        if text.contains("drank") { selection.drank = true }
        if text.contains("urinated") || text.contains("pee") { selection.urinated = true }
        if text.contains("bowel") || text.contains("defecated") || text.contains("poop") {
            selection.defecated = true
        }
        return (selection.ate || selection.drank || selection.urinated || selection.defecated) ? selection : nil
    }
}

struct ExpertModeNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var settings
    @Query private var allNotes: [SOAPNote]
    
    @State private var note: SOAPNote
    @State private var currentVitals = VitalSigns(id: UUID())
    @State private var showingReferenceSheet = false
    @State private var selectedReferenceChapter: String?
    @FocusState private var focusedField: Field?
    @State private var bpIsWNL = false
    @State private var showTempInput = false
    @State private var showSpO2Input = false
    @State private var useFahrenheit = true
    @State private var selectedBodyRegions: Set<BodyRegion> = []
    @State private var trackLastInOut = false
    @State private var lastInOutSelection = IntakeOutputSelection()
    @State private var manualLastInOutNotes = ""
    
    private let painRegionOptions = [
        "Head", "Neck", "Chest", "Back", "Abdomen",
        "Upper arm", "Forearm/Hand", "Thigh", "Lower leg", "Foot", "Genitals"
    ]
    @StateObject private var locationDelegate = LocationManagerDelegate()
    @State private var isRequestingLocation = false
    @State private var capRefillHands = "Normal"
    @State private var capRefillFeet = "Normal"
    @State private var sensation = "x4"
    @State private var motion = "x4"
    @State private var skinTemperature = "Warm"
    @State private var skinMoisture = "Dry"
    @State private var leftPupil = "Normal"
    @State private var rightPupil = "Normal"
    @State private var showLocationError = false
    @State private var locationErrorMessage = ""
    @State private var showWeightInput = false
    @State private var showDOBPicker = false
    @State private var assessLOR = false // Toggle for LOR assessment
    @State private var assessCSM = false // Toggle for CSM assessment
    
    // Track created note IDs (for paywall enforcement)
    private func getCreatedNoteIDs() -> Set<String> {
        if let data = UserDefaults.standard.data(forKey: "createdNoteIDs"),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            return decoded
        }
        return []
    }
    
    private func saveCreatedNoteIDs(_ ids: Set<String>) {
        if let encoded = try? JSONEncoder().encode(ids) {
            UserDefaults.standard.set(encoded, forKey: "createdNoteIDs")
        }
    }
    
    // LOR component tracking (A+O x4)
    @State private var lorPerson = true // Can identify self
    @State private var lorPlace = true // Knows where they are
    @State private var lorTime = true // Knows date/time
    @State private var lorEvent = true // Knows what happened
    
    // LOR - Verbal and Pain responses
    @State private var lorRespondsToVerbal = false // V - responds to verbal stimuli
    @State private var lorRespondsToPain = false // P - responds to pain
    
    // Smart diagnosis suggestions
    @State private var showDiagnosisSuggestion = false
    @State private var suggestedReferenceChapter = ""
    
    enum Field: Hashable {
        case patientName
        case age
        case location
        case vitalsHR, vitalsRR, vitalsBPSys, vitalsBPDia, vitalsTemp, vitalsSpO2
        case csm, sctm
        case other
    }
    
    init(note: SOAPNote? = nil) {
        let initialNote = note ?? SOAPNote(id: UUID())
        if initialNote.patientAge == nil, let dob = initialNote.patientDateOfBirth {
            initialNote.patientAge = ExpertModeNoteView.computeAge(from: dob)
        }
        _note = State(initialValue: initialNote)
        
        if let parsedSelection = IntakeOutputSelection.parse(from: initialNote.lastInOut) {
            _trackLastInOut = State(initialValue: true)
            _lastInOutSelection = State(initialValue: parsedSelection)
            _manualLastInOutNotes = State(initialValue: "")
        } else {
            _trackLastInOut = State(initialValue: false)
            _lastInOutSelection = State(initialValue: IntakeOutputSelection())
            _manualLastInOutNotes = State(initialValue: initialNote.lastInOut ?? "")
        }
    }
    

    
    var body: some View {
        NavigationStack {
            Form {
                // Patient Information
                Section("Patient Information") {
                    patientNameField
                    patientAgeSlider
                    patientDateOfBirthField
                    patientSexPicker
                    patientWeightField
                    patientNotesField
                }
                
                // Scene Information
                Section("Scene Information") {
                    Picker("Season", selection: Binding(
                        get: { note.season },
                        set: { note.season = $0 }
                    )) {
                        Text("Not specified").tag(nil as Season?)
                        ForEach(Season.allCases, id: \.self) { season in
                            Label(season.rawValue, systemImage: season.icon).tag(season as Season?)
                        }
                    }
                    
                    TextField("Setting (trail, camp, etc.)", text: Binding(
                        get: { note.setting ?? "" },
                        set: { note.setting = $0.isEmpty ? nil : $0 }
                    ))
                    
                    // Location display
                    if let location = note.location {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Coordinates")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(location)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button {
                                openInMaps()
                            } label: {
                                Image(systemName: "map.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    
                    // Location action button
                    HStack {
                        Button {
                            getCurrentLocation()
                        } label: {
                            if isRequestingLocation {
                                HStack {
                                    ProgressView()
                                        .controlSize(.small)
                                    Text("Getting location...")
                                }
                            } else {
                                Label(note.location == nil ? "Add Coordinates" : "Update Coordinates", 
                                      systemImage: "location.fill")
                            }
                        }
                        .disabled(isRequestingLocation)
                        
                        if note.location != nil {
                            Button(role: .destructive) {
                                note.location = nil
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                
                // S - Subjective (SAMPLE)
                Section {
                    TextField("Chief complaint, symptoms", text: Binding(
                        get: { note.signsSymptoms ?? "" },
                        set: { note.signsSymptoms = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(2...5)
                    
                    TextField("Allergies", text: Binding(
                        get: { note.allergies ?? "" },
                        set: { note.allergies = $0.isEmpty ? nil : $0 }
                    ))
                    
                    TextField("Medications", text: Binding(
                        get: { note.medications ?? "" },
                        set: { note.medications = $0.isEmpty ? nil : $0 }
                    ))
                    
                    TextField("Pertinent medical history", text: Binding(
                        get: { note.pertinentHistory ?? "" },
                        set: { note.pertinentHistory = $0.isEmpty ? nil : $0 }
                    ))
                    
                    Toggle("Quick intake/output log", isOn: $trackLastInOut)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    if trackLastInOut {
                        IntakeQuickLogView(selection: $lastInOutSelection)
                    } else {
                        TextField("Last food/water, last urination", text: $manualLastInOutNotes)
                            .onChange(of: manualLastInOutNotes) { _, newValue in
                                note.lastInOut = newValue.isEmpty ? nil : newValue
                            }
                    }
                    
                    TextField("Events leading to incident", text: Binding(
                        get: { note.events ?? "" },
                        set: { note.events = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(2...5)
                } header: {
                    HStack {
                        Text("S - Subjective (SAMPLE)")
                        Spacer()
                        Button {
                            selectedReferenceChapter = "Patient Assessment"
                            showingReferenceSheet = true
                        } label: {
                            Image(systemName: "book.circle")
                                .font(.caption)
                        }
                    }
                }
                
                // O - Objective (Vitals)
                Section {
                    // Current vitals entry
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Reading (\(Date.now.formatted(date: .omitted, time: .shortened)))")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("HR")
                                    .font(.caption)
                                TextField("60-100", value: $currentVitals.heartRate, format: .number)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .vitalsHR)
                                Text("bpm")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("RR")
                                    .font(.caption)
                                TextField("12-20", value: $currentVitals.respiratoryRate, format: .number)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($focusedField, equals: .vitalsRR)
                                Text("/min")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("BP")
                                .font(.caption)
                            
                            Toggle("WNL (Within Normal Limits)", isOn: $bpIsWNL)
                                .font(.caption)
                            
                            if !bpIsWNL {
                                HStack(spacing: 4) {
                                    TextField("120", value: $currentVitals.bloodPressureSystolic, format: .number)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 60)
                                        .focused($focusedField, equals: .vitalsBPSys)
                                    Text("/")
                                    TextField("80", value: $currentVitals.bloodPressureDiastolic, format: .number)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 60)
                                        .focused($focusedField, equals: .vitalsBPDia)
                                    Text("mmHg")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        
                        HStack {
                            // Temperature toggle
                            VStack(alignment: .leading) {
                                Toggle(isOn: $showTempInput) {
                                    Text("Temp")
                                        .font(.caption)
                                }
                                
                                if showTempInput {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            TextField("", value: Binding(
                                                get: {
                                                    if let temp = currentVitals.temperature {
                                                        return useFahrenheit ? celsiusToFahrenheit(temp) : temp
                                                    }
                                                    return nil
                                                },
                                                set: { newValue in
                                                    if let newValue = newValue {
                                                        currentVitals.temperature = useFahrenheit ? fahrenheitToCelsius(newValue) : newValue
                                                    } else {
                                                        currentVitals.temperature = nil
                                                    }
                                                }
                                            ), format: .number)
                                                .keyboardType(.decimalPad)
                                                .textFieldStyle(.roundedBorder)
                                                .frame(width: 60)
                                                .focused($focusedField, equals: .vitalsTemp)
                                            
                                            Text(useFahrenheit ? "°F" : "°C")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            
                                            // Ghostly conversion display
                                            if let temp = currentVitals.temperature {
                                                let convertedTemp = useFahrenheit ? temp : celsiusToFahrenheit(temp)
                                                let convertedUnit = useFahrenheit ? "°C" : "°F"
                                                Text("(\(String(format: "%.1f", convertedTemp))\(convertedUnit))")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary.opacity(0.5))
                                            }
                                        }
                                        
                                        if settings.showVitalsNormalRanges {
                                            Text(useFahrenheit ? "Normal: 98.6°F (37°C)" : "Normal: 37°C (98.6°F)")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            
                            // SpO2 toggle
                            VStack(alignment: .leading) {
                                Toggle(isOn: $showSpO2Input) {
                                    Text("SpO2")
                                        .font(.caption)
                                }
                                
                                if showSpO2Input {
                                    HStack {
                                        TextField("", value: $currentVitals.oxygenSaturation, format: .number)
                                            .keyboardType(.numberPad)
                                            .textFieldStyle(.roundedBorder)
                                            .frame(width: 60)
                                            .focused($focusedField, equals: .vitalsSpO2)
                                        Text("%")
                                            .font(.caption)
                                    }
                                    
                                    if settings.showVitalsNormalRanges {
                                        Text("95-100")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        
                        Button {
                            addVitalSigns()
                        } label: {
                            Label("Add Reading", systemImage: "plus.circle.fill")
                                .font(.subheadline.bold())
                        }
                    }
                    .padding(.vertical, 4)
                    
                    // Previous vitals
                    if !note.vitalSigns.isEmpty {
                        ForEach(note.vitalSigns.sorted(by: { $0.timestamp > $1.timestamp })) { vital in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(vital.timestamp.formatted(date: .omitted, time: .shortened))
                                    .font(.caption.bold())
                                
                                HStack {
                                    if let hr = vital.heartRate {
                                        Text("HR: \(hr)")
                                            .font(.caption)
                                    }
                                    if let rr = vital.respiratoryRate {
                                        Text("RR: \(rr)")
                                            .font(.caption)
                                    }
                                    if let bp = vital.bloodPressureString {
                                        Text("BP: \(bp)")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                } header: {
                    Text("O - Objective (Vitals)")
                }
                
                // Physical Exam
                Section("Physical Exam") {
                    // LOR Assessment with toggle (like PERRL and CSM)
                    Toggle("Assess Level of Responsiveness (AVPU)", isOn: $assessLOR)
                        .onChange(of: assessLOR) { _, newValue in
                            if newValue {
                                // When toggled on, default to perfect score (Alert & Oriented x4)
                                note.levelOfResponsiveness = .alert
                                lorPerson = true
                                lorPlace = true
                                lorTime = true
                                lorEvent = true
                                updateLOR()
                            }
                        }
                    
                    if assessLOR {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("LOR Score (AVPU)")
                                    .font(.caption.bold())
                                Spacer()
                                Text(lorAVPUDisplayText())
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(lorScoreBackgroundColor())
                                    .foregroundStyle(lorScoreForegroundColor())
                                    .cornerRadius(6)
                            }
                            
                            Divider()
                            
                            // Alert & Oriented (A) - Shows as separate section like V and P
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Alert & Oriented (A)")
                                        .font(.caption.bold())
                                    Spacer()
                                    if note.levelOfResponsiveness == .alert || lorPerson || lorPlace || lorTime || lorEvent {
                                        Text("A+O x\(calculateLORScore())")
                                            .font(.caption)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(alertOrientationBackgroundColor())
                                            .foregroundStyle(alertOrientationForegroundColor())
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            
                            // Alert & Oriented - Person
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Person - Can identify self")
                                    .font(.caption)
                                Picker("", selection: $lorPerson) {
                                    Text("Yes").tag(true)
                                    Text("No").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .disabled(note.levelOfResponsiveness == .unresponsive)
                                .onChange(of: lorPerson) { _, _ in updateLOR() }
                                
                                HStack {
                                    Circle()
                                        .fill(lorPerson ? .green : .orange)
                                        .frame(width: 12, height: 12)
                                    Text(lorPerson ? "Knows their name" : "Does not know their name")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            // Place
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Place - Knows location")
                                    .font(.caption)
                                Picker("", selection: $lorPlace) {
                                    Text("Yes").tag(true)
                                    Text("No").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .disabled(note.levelOfResponsiveness == .unresponsive)
                                .onChange(of: lorPlace) { _, _ in updateLOR() }
                                
                                HStack {
                                    Circle()
                                        .fill(lorPlace ? .green : .orange)
                                        .frame(width: 12, height: 12)
                                    Text(lorPlace ? "Knows where they are" : "Does not know location")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            // Time
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Time - Knows date/time")
                                    .font(.caption)
                                Picker("", selection: $lorTime) {
                                    Text("Yes").tag(true)
                                    Text("No").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .disabled(note.levelOfResponsiveness == .unresponsive)
                                .onChange(of: lorTime) { _, _ in updateLOR() }
                                
                                HStack {
                                    Circle()
                                        .fill(lorTime ? .green : .orange)
                                        .frame(width: 12, height: 12)
                                    Text(lorTime ? "Knows when it is (date/time)" : "Does not know date/time")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            // Event
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Event - Knows what happened")
                                    .font(.caption)
                                Picker("", selection: $lorEvent) {
                                    Text("Yes").tag(true)
                                    Text("No").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .disabled(note.levelOfResponsiveness == .unresponsive)
                                .onChange(of: lorEvent) { _, _ in updateLOR() }
                                
                                HStack {
                                    Circle()
                                        .fill(lorEvent ? .green : .orange)
                                        .frame(width: 12, height: 12)
                                    Text(lorEvent ? "Knows how they got here" : "Does not know what happened")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Divider()
                            
                            // Verbal Response
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Verbal Response (V)")
                                    .font(.caption.bold())
                                Picker("", selection: $lorRespondsToVerbal) {
                                    Text("Yes").tag(true)
                                    Text("No").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .disabled(note.levelOfResponsiveness == .unresponsive)
                                .onChange(of: lorRespondsToVerbal) { _, _ in updateLOR() }
                                
                                HStack {
                                    Circle()
                                        .fill(lorRespondsToVerbal ? .yellow : .gray)
                                        .frame(width: 12, height: 12)
                                    Text(lorRespondsToVerbal ? "Responds to voice" : "No verbal response")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            // Pain Response
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pain Response (P)")
                                    .font(.caption.bold())
                                Picker("", selection: $lorRespondsToPain) {
                                    Text("Yes").tag(true)
                                    Text("No").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .disabled(note.levelOfResponsiveness == .unresponsive)
                                .onChange(of: lorRespondsToPain) { _, _ in updateLOR() }
                                
                                HStack {
                                    Circle()
                                        .fill(lorRespondsToPain ? .orange : .gray)
                                        .frame(width: 12, height: 12)
                                    Text(lorRespondsToPain ? "Responds to pain" : "No pain response")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Divider()
                            
                            // Unresponsive (U) - At the bottom, auto-detected
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Unresponsive (U)")
                                    .font(.caption.bold())
                                Picker("", selection: Binding(
                                    get: { note.levelOfResponsiveness == .unresponsive },
                                    set: { newValue in
                                        if newValue {
                                            // Set to unresponsive and reset all others
                                            note.levelOfResponsiveness = .unresponsive
                                            lorPerson = false
                                            lorPlace = false
                                            lorTime = false
                                            lorEvent = false
                                            lorRespondsToVerbal = false
                                            lorRespondsToPain = false
                                        } else {
                                            note.levelOfResponsiveness = nil
                                        }
                                        updateLOR()
                                    }
                                )) {
                                    Text("Responsive").tag(false)
                                    Text("Unresponsive").tag(true)
                                }
                                .pickerStyle(.segmented)
                                
                                if note.levelOfResponsiveness == .unresponsive {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundStyle(.red)
                                        Text("CRITICAL - No response to any stimuli")
                                            .font(.caption2.bold())
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                        }
                    }
                    
                    // PERRL Assessment
                    Toggle("PERRL (Pupils Equal, Round, Reactive to Light)", isOn: Binding(
                        get: { note.perrl ?? false },
                        set: { note.perrl = $0 }
                    ))
                    
                    if note.perrl == true {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pupil Details")
                                .font(.caption.bold())
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Left Pupil")
                                        .font(.caption)
                                    Picker("", selection: $leftPupil) {
                                        Text("Normal").tag("Normal")
                                        Text("Dilated").tag("Dilated")
                                        Text("Constricted").tag("Constricted")
                                        Text("Non-reactive").tag("Non-reactive")
                                        Text("Sluggish").tag("Sluggish")
                                    }
                                    .pickerStyle(.menu)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Right Pupil")
                                        .font(.caption)
                                    Picker("", selection: $rightPupil) {
                                        Text("Normal").tag("Normal")
                                        Text("Dilated").tag("Dilated")
                                        Text("Constricted").tag("Constricted")
                                        Text("Non-reactive").tag("Non-reactive")
                                        Text("Sluggish").tag("Sluggish")
                                    }
                                    .pickerStyle(.menu)
                                }
                            }
                        }
                    }
                    
                    // CSM Assessment with toggle (like PERRL and LOR)
                    Toggle("Assess CSM (Circulation, Sensation, Motion)", isOn: $assessCSM)
                    
                    if assessCSM {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("CSM Score")
                                    .font(.caption.bold())
                                Spacer()
                                Text("x\(calculateCSMScore())")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundStyle(.blue)
                                    .cornerRadius(6)
                            }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cap Refill (Hands)")
                                .font(.caption)
                            Picker("", selection: $capRefillHands) {
                                Text("Normal (<2s)").tag("Normal")
                                Text("Delayed (>2s)").tag("Delayed")
                                Text("Not assessed").tag("N/A")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: capRefillHands) { _, _ in updateCSM() }
                            
                            // Visual indicator
                            HStack {
                                Circle()
                                    .fill(capRefillColor(capRefillHands))
                                    .frame(width: 12, height: 12)
                                Text(capRefillHands == "Normal" ? "Normal" : capRefillHands == "Delayed" ? "Delayed" : "Not assessed")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cap Refill (Feet)")
                                .font(.caption)
                            Picker("", selection: $capRefillFeet) {
                                Text("Normal (<2s)").tag("Normal")
                                Text("Delayed (>2s)").tag("Delayed")
                                Text("Not assessed").tag("N/A")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: capRefillFeet) { _, _ in updateCSM() }
                            
                            // Visual indicator
                            HStack {
                                Circle()
                                    .fill(capRefillColor(capRefillFeet))
                                    .frame(width: 12, height: 12)
                                Text(capRefillFeet == "Normal" ? "Normal" : capRefillFeet == "Delayed" ? "Delayed" : "Not assessed")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sensation (Can feel touch?)")
                                .font(.caption)
                            Picker("", selection: $sensation) {
                                Text("All extremities").tag("x4")
                                Text("Impaired").tag("Impaired")
                                Text("Not assessed").tag("N/A")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: sensation) { _, _ in updateCSM() }
                            
                            // Visual indicator
                            HStack {
                                Circle()
                                    .fill(csmStatusColor(sensation))
                                    .frame(width: 12, height: 12)
                                Text(sensation == "x4" ? "All extremities" : sensation == "Impaired" ? "Impaired" : "Not assessed")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Motion (Can wiggle fingers/toes?)")
                                .font(.caption)
                            Picker("", selection: $motion) {
                                Text("All extremities").tag("x4")
                                Text("Impaired").tag("Impaired")
                                Text("Not assessed").tag("N/A")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: motion) { _, _ in updateCSM() }
                            
                            // Visual indicator
                            HStack {
                                Circle()
                                    .fill(csmStatusColor(motion))
                                    .frame(width: 12, height: 12)
                                Text(motion == "x4" ? "All extremities" : motion == "Impaired" ? "Impaired" : "Not assessed")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                    
                    // SCTM with color picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SCTM (Skin Color, Temperature, Moisture)")
                            .font(.subheadline.bold())
                        
                        Picker("Skin Color", selection: Binding(
                            get: { note.sctm },
                            set: { note.sctm = $0 }
                        )) {
                            Text("Normal (pink)").tag("Normal (pink, warm, dry)" as String?)
                            Text("Pale").tag("Pale, cool" as String?)
                            Text("Flushed/Red").tag("Red, hot, raised" as String?)
                            Text("Blue/Cyanotic").tag("Blue, cyanotic" as String?)
                            Text("Ashen/Gray").tag("Ashen, gray" as String?)
                            Text("Yellow/Jaundiced").tag("Yellow, jaundiced" as String?)
                        }
                        
                        // Visual indicator for skin color
                        if let sctm = note.sctm {
                            HStack {
                                Circle()
                                    .fill(skinColorIndicator(sctm))
                                    .frame(width: 16, height: 16)
                                Text(sctm)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Temperature")
                                .font(.caption)
                            Picker("", selection: $skinTemperature) {
                                Text("Warm").tag("Warm")
                                Text("Cool").tag("Cool")
                                Text("Cold").tag("Cold")
                                Text("Hot").tag("Hot")
                            }
                            .pickerStyle(.segmented)
                            
                            // Visual indicator
                            HStack {
                                Circle()
                                    .fill(skinTempColor(skinTemperature))
                                    .frame(width: 12, height: 12)
                                Text(skinTemperature)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Moisture")
                                .font(.caption)
                            Picker("", selection: $skinMoisture) {
                                Text("Dry").tag("Dry")
                                Text("Moist").tag("Moist")
                                Text("Clammy").tag("Clammy")
                                Text("Diaphoretic").tag("Diaphoretic")
                            }
                            .pickerStyle(.segmented)
                            
                            // Visual indicator
                            HStack {
                                Circle()
                                    .fill(skinMoistureColor(skinMoisture))
                                    .frame(width: 12, height: 12)
                                Text(skinMoisture)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    TextField("Additional exam notes", text: Binding(
                        get: { note.physicalExamNotes ?? "" },
                        set: { note.physicalExamNotes = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(2...5)
                    .focused($focusedField, equals: .other)
                }
                
                // OPQRST - Pain Assessment
                Section {
                    Toggle("Patient has pain", isOn: $note.hasPain)
                    
                    if note.hasPain {
                        DatePicker("Onset (when did it start?)", 
                                 selection: Binding(
                                    get: { note.incidentTime ?? Date() },
                                    set: { note.incidentTime = $0 }
                                 ), displayedComponents: [.date, .hourAndMinute])
                        
                        TextField("Provocation (what makes it better/worse?)", text: Binding(
                            get: { note.provocation ?? "" },
                            set: { note.provocation = $0.isEmpty ? nil : $0 }
                        ))
                        .focused($focusedField, equals: .other)
                        
                        Picker("Quality", selection: Binding(
                            get: { note.quality },
                            set: { note.quality = $0 }
                        )) {
                            Text("Not specified").tag(nil as String?)
                            Text("Sharp").tag("Sharp" as String?)
                            Text("Dull").tag("Dull" as String?)
                            Text("Burning").tag("Burning" as String?)
                            Text("Aching").tag("Aching" as String?)
                            Text("Stabbing").tag("Stabbing" as String?)
                            Text("Throbbing").tag("Throbbing" as String?)
                            Text("Cramping").tag("Cramping" as String?)
                        }
                        
                        Picker("Region (location of pain)", selection: Binding(
                            get: { note.region },
                            set: { note.region = $0 }
                        )) {
                            Text("Not specified").tag(nil as String?)
                            ForEach(painRegionOptions, id: \.self) { region in
                                Text(region).tag(region as String?)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Severity: \(note.severity ?? 5) / 10")
                                Spacer()
                            }
                            Slider(value: Binding(
                                get: { Double(note.severity ?? 5) },
                                set: { note.severity = Int($0) }
                            ), in: 1...10, step: 1)
                        }
                        
                        Picker("Time (frequency)", selection: Binding(
                            get: { note.time },
                            set: { note.time = $0 }
                        )) {
                            Text("Not specified").tag(nil as String?)
                            Text("Constant").tag("Constant" as String?)
                            Text("Intermittent").tag("Intermittent" as String?)
                            Text("Comes and goes").tag("Comes and goes" as String?)
                            Text("Getting worse").tag("Getting worse" as String?)
                            Text("Getting better").tag("Getting better" as String?)
                        }
                    }
                } header: {
                    HStack {
                        Text("OPQRST - Pain Assessment")
                        Spacer()
                        Button {
                            selectedReferenceChapter = "Patient Assessment"
                            showingReferenceSheet = true
                        } label: {
                            Image(systemName: "book.circle")
                                .font(.caption)
                        }
                    }
                }
                
                // Burns/Frostbite Assessment (Rule of 9s)
                Section {
                    Toggle("Patient has burns/frostbite", isOn: $note.hasBurns)
                    
                    if note.hasBurns {
                        // Body region selection for burns
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Affected Body Regions (Rule of 9s)")
                                    .font(.caption.bold())
                                Spacer()
                                if !selectedBodyRegions.isEmpty {
                                    let totalPercentage = selectedBodyRegions.reduce(0.0) { $0 + $1.percentage }
                                    Text(String(format: "%.1f%% BSA", totalPercentage))
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.orange.opacity(0.2))
                                        .foregroundStyle(.orange)
                                        .cornerRadius(6)
                                        .bold()
                                }
                            }
                            
                            ForEach(BodyRegion.allCases, id: \.self) { region in
                                Toggle(region.rawValue, isOn: Binding(
                                    get: { selectedBodyRegions.contains(region) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedBodyRegions.insert(region)
                                        } else {
                                            selectedBodyRegions.remove(region)
                                        }
                                        updateBurnData()
                                    }
                                ))
                                .font(.caption)
                            }
                        }
                        
                        Picker("Burn/Frostbite Degree", selection: Binding(
                            get: { note.burnDegree },
                            set: { note.burnDegree = $0 }
                        )) {
                            Text("Not specified").tag(nil as BurnDegree?)
                            ForEach(BurnDegree.allCases, id: \.self) { degree in
                                Text(degree.rawValue).tag(degree as BurnDegree?)
                            }
                        }
                        
                        // Show description of selected burn degree
                        if let degree = note.burnDegree {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.orange)
                                Text(degree.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(8)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                } header: {
                    HStack {
                        Text("Burns/Frostbite Assessment")
                        Spacer()
                        Button {
                            selectedReferenceChapter = "Burns"
                            showingReferenceSheet = true
                        } label: {
                            Image(systemName: "book.circle")
                                .font(.caption)
                        }
                    }
                }
                
                // A - Assessment
                Section {
                    TextField("Working diagnosis", text: Binding(
                        get: { note.assessment ?? "" },
                        set: { note.assessment = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(2...5)
                    .focused($focusedField, equals: .other)
                    
                    Picker("Anticipated worst case scenario", selection: Binding(
                        get: { note.anticipatedWorstCase },
                        set: { note.anticipatedWorstCase = $0 }
                    )) {
                        Text("Not specified").tag(nil as String?)
                        Text("Provide care and monitor").tag("Provide care and monitor" as String?)
                        Text("Evacuate non-urgent").tag("Evacuate non-urgent" as String?)
                        Text("Evacuate urgent").tag("Evacuate urgent" as String?)
                        Text("Evacuate immediate").tag("Evacuate immediate" as String?)
                        Text("Life-threatening emergency").tag("Life-threatening emergency" as String?)
                    }
                    
                    // Visual indicator for worst case scenario
                    if let worstCase = note.anticipatedWorstCase, !worstCase.isEmpty {
                        HStack {
                            Image(systemName: worstCaseIcon(for: worstCase))
                            Text(worstCase)
                            Spacer()
                        }
                        .padding()
                        .background(worstCaseColor(for: worstCase))
                        .cornerRadius(8)
                    }
                } header: {
                    Text("A - Assessment")
                }
                
                // P - Plan
                Section {
                    TextField("Treatment provided (who/what/when)", text: Binding(
                        get: { note.treatmentProvided ?? "" },
                        set: { note.treatmentProvided = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(3...8)
                    .focused($focusedField, equals: .other)
                    
                    Picker("Evacuation Urgency", selection: Binding(
                        get: { note.evacuationPlan },
                        set: { note.evacuationPlan = $0 }
                    )) {
                        Text("Not determined").tag(nil as EvacuationUrgency?)
                        // Aligned with worst case scenario options
                        Label("No Evacuation Needed (Provide care and monitor)", systemImage: EvacuationUrgency.noEvac.icon)
                            .tag(EvacuationUrgency.noEvac as EvacuationUrgency?)
                        Label("Self-Evacuation", systemImage: EvacuationUrgency.selfEvac.icon)
                            .tag(EvacuationUrgency.selfEvac as EvacuationUrgency?)
                        Label("Non-Urgent (Evacuate non-urgent)", systemImage: EvacuationUrgency.nonUrgent.icon)
                            .tag(EvacuationUrgency.nonUrgent as EvacuationUrgency?)
                        Label("Urgent (Evacuate urgent)", systemImage: EvacuationUrgency.urgent.icon)
                            .tag(EvacuationUrgency.urgent as EvacuationUrgency?)
                        Label("Immediate (Life-threatening emergency)", systemImage: EvacuationUrgency.immediate.icon)
                            .tag(EvacuationUrgency.immediate as EvacuationUrgency?)
                    }
                    
                    // Visual indicator for evacuation urgency
                    if let evac = note.evacuationPlan {
                        HStack {
                            Image(systemName: evac.icon)
                            Text(evac.rawValue)
                            Spacer()
                        }
                        .padding()
                        .background(evacuationColor(for: evac))
                        .cornerRadius(8)
                    }
                    
                    TextField("Evacuation notes", text: Binding(
                        get: { note.evacuationNotes ?? "" },
                        set: { note.evacuationNotes = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(2...5)
                    .focused($focusedField, equals: .other)
                    
                    TextField("Monitoring plan", text: Binding(
                        get: { note.monitoringPlan ?? "" },
                        set: { note.monitoringPlan = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(2...5)
                    .focused($focusedField, equals: .other)
                } header: {
                    Text("P - Plan")
                }
                
                // Metadata
                Section("Additional Information") {
                    TextField("Other responders on scene", text: Binding(
                        get: { note.responders.joined(separator: ", ") },
                        set: { note.responders = $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                    ))
                    
                    Toggle("Mark as favorite", isOn: $note.isFavorite)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("SOAP Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                }
            }
            .onAppear {
                // Auto-focus on patient name when creating new note
                if note.patientName == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusedField = .patientName
                    }
                }
            }
            .sheet(isPresented: $showingReferenceSheet) {
                NavigationStack {
                    ReferenceQuickView(chapter: selectedReferenceChapter ?? "")
                        .navigationTitle("Reference")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    showingReferenceSheet = false
                                }
                            }
                        }
                }
            }
            .alert("Reference Suggestion", isPresented: $showDiagnosisSuggestion) {
                Button("View Reference") {
                    selectedReferenceChapter = suggestedReferenceChapter
                    showingReferenceSheet = true
                    dismiss()
                }
                Button("Close") {
                    dismiss()
                }
            } message: {
                Text("Would you like to view reference material for '\(suggestedReferenceChapter)'?")
            }
            .alert("Location Error", isPresented: $showLocationError) {
                Button("OK") {
                    showLocationError = false
                }
            } message: {
                Text(locationErrorMessage)
            }
            .onChange(of: lastInOutSelection) { _, _ in
                if trackLastInOut {
                    updateLastInOutStringFromSelection()
                }
            }
            .onChange(of: trackLastInOut) { _, isOn in
                if isOn {
                    updateLastInOutStringFromSelection()
                } else {
                    manualLastInOutNotes = note.lastInOut ?? manualLastInOutNotes
                    note.lastInOut = manualLastInOutNotes.isEmpty ? nil : manualLastInOutNotes
                }
            }
        }
    }
    
    // MARK: - Extracted View Components
    
    private var patientNameField: some View {
        TextField("Name", text: Binding(
            get: { note.patientName ?? "" },
            set: { note.patientName = $0.isEmpty ? nil : $0 }
        ))
        .focused($focusedField, equals: .patientName)
    }
    
    private var patientAgeSlider: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Age")
                    .font(.subheadline)
                Spacer()
                TextField("Age", value: Binding(
                    get: { note.patientAge },
                    set: { note.patientAge = $0 }
                ), format: .number)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 80)
                .multilineTextAlignment(.trailing)
            }
            if note.patientDateOfBirth != nil {
                Text("Auto-calculated from DOB")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var patientDateOfBirthField: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Date of Birth")
                    .font(.caption)
                Spacer()
                if note.patientDateOfBirth != nil {
                    Button("Clear") {
                        note.patientDateOfBirth = nil
                        showDOBPicker = false
                    }
                    .font(.caption)
                    .foregroundStyle(.red)
                }
            }
            
            if showDOBPicker || note.patientDateOfBirth != nil {
                DatePicker(
                    "Date of Birth",
                    selection: Binding(
                        get: { note.patientDateOfBirth ?? Date() },
                        set: {
                            note.patientDateOfBirth = $0
                            note.patientAge = ExpertModeNoteView.computeAge(from: $0)
                        }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
            } else {
                Button {
                    showDOBPicker = true
                } label: {
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("Add Date of Birth")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                }
            }
        }
    }
    
    private var patientSexPicker: some View {
        VStack(alignment: .leading) {
            Text("Sex")
                .font(.caption)
            Picker("Sex", selection: Binding(
                get: { note.patientSex ?? .unknown },
                set: { note.patientSex = $0 }
            )) {
                Text("Male").tag(PatientSex.male)
                Text("Unknown").tag(PatientSex.unknown)
                Text("Female").tag(PatientSex.female)
            }
            .pickerStyle(.segmented)
            
            // Visual indicator with color (matching SCTM style)
            HStack {
                Circle()
                    .fill(sexColorIndicator(note.patientSex))
                    .frame(width: 16, height: 16)
                Text(note.patientSex?.rawValue ?? "Unknown")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }
    
    private var patientWeightField: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Weight")
                    .font(.caption)
                Spacer()
                Toggle("", isOn: $showWeightInput)
                    .labelsHidden()
            }
            
            if showWeightInput {
                HStack {
                    TextField("Weight", value: Binding(
                        get: { note.patientWeight ?? 0 },
                        set: { note.patientWeight = $0 > 0 ? $0 : nil }
                    ), format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    
                    Text("lbs")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // Ghostly conversion display
                    if let weight = note.patientWeight, weight > 0 {
                        Text("(\(String(format: "%.1f", weight * 0.453592)) kg)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                }
            } else {
                Text("Toggle to add weight (needed for some medications)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
    
    private var patientNotesField: some View {
        TextField("Patient Notes (emergency contact, allergies, etc.)", 
                 text: Binding(
                    get: { note.initialNotes ?? "" },
                    set: { note.initialNotes = $0.isEmpty ? nil : $0 }
                 ),
                 axis: .vertical)
        .lineLimit(2...5)
        .font(.subheadline)
    }
    
    // MARK: - Helper Functions
    
    private func addVitalSigns() {
        // Handle WNL for BP
        if bpIsWNL {
            currentVitals.bloodPressureSystolic = 120
            currentVitals.bloodPressureDiastolic = 80
        }
        
        // Add the current vitals to the note
        note.vitalSigns.append(currentVitals)
        // Reset for next reading
        currentVitals = VitalSigns(id: UUID())
        bpIsWNL = false
        
        // Dismiss keyboard
        focusedField = nil
    }
    
    private func saveNote(completed: Bool = true) {
        note.lastModified = Date()
        note.isCompleted = completed
        
        // Track this note ID to prevent delete-bypass
        var ids = getCreatedNoteIDs()
        ids.insert(note.id.uuidString)
        saveCreatedNoteIDs(ids)
        
        // Add responder metadata from settings
        if !settings.responderName.isEmpty {
            note.responderName = settings.responderName
            if !note.responders.contains(settings.responderName) {
                note.responders.append(settings.responderName)
            }
        }
        if !settings.responderAgency.isEmpty {
            note.responderAgency = settings.responderAgency
        }
        if !settings.responderRescueNumber.isEmpty {
            note.responderRescueNumber = settings.responderRescueNumber
        }
        if !settings.combinedCertifications.isEmpty {
            note.responderCertifications = settings.combinedCertifications
        }
        
        modelContext.insert(note)
        
        do {
            try modelContext.save()
            
            // Show smart diagnosis suggestion if applicable
            if let diagnosis = note.assessment?.lowercased(), !diagnosis.isEmpty {
                if let suggestion = suggestReferenceForDiagnosis(diagnosis) {
                    suggestedReferenceChapter = suggestion
                    showDiagnosisSuggestion = true
                } else {
                    dismiss()
                }
            } else {
                dismiss()
            }
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    // Suggest reference material based on diagnosis
    private func suggestReferenceForDiagnosis(_ diagnosis: String) -> String? {
        let keywords: [String: String] = [
            "burn": "Burns",
            "frostbite": "Cold Injuries",
            "hypothermia": "Cold Injuries",
            "heat": "Heat Illness",
            "dehydration": "Hydration",
            "fracture": "Musculoskeletal Injuries",
            "dislocation": "Musculoskeletal Injuries",
            "sprain": "Musculoskeletal Injuries",
            "strain": "Musculoskeletal Injuries",
            "bleed": "Bleeding Control",
            "wound": "Wound Care",
            "head": "Head Injuries",
            "concussion": "Head Injuries",
            "spine": "Spinal Injuries",
            "shock": "Shock",
            "anaphylaxis": "Allergic Reactions",
            "asthma": "Respiratory Emergencies",
            "chest": "Chest Injuries",
            "altitude": "Altitude Illness",
            "lightning": "Lightning Injuries",
            "snake": "Bites and Stings",
            "bite": "Bites and Stings",
            "poison": "Toxins and Poisons"
        ]
        
        for (keyword, chapter) in keywords {
            if diagnosis.contains(keyword) {
                return chapter
            }
        }
        
        return nil
    }
    
    private func exportNote() {
        // Generate PDF using PCRFormatter
        guard let pdfData = PCRFormatter.generateStandardFormPDF(for: note) else {
            print("Failed to generate PDF")
            return
        }
        
        // Save to temporary file
        let fileName = "SOAP_Note_\(note.patientName ?? "Unknown")_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: tempURL)
            
            // Share via activity controller
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                // Use keyWindow for iOS 26.0+ compatibility
                if let window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first,
                   let rootVC = window.rootViewController {
                    // For iPad - present from a specific location
                    if let popover = activityVC.popoverPresentationController {
                        popover.sourceView = window
                        popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
                        popover.permittedArrowDirections = []
                    }
                    rootVC.present(activityVC, animated: true)
                }
            }
        } catch {
            print("Error saving PDF: \(error)")
        }
    }
    
    private func getCurrentLocation() {
        // Request authorization if needed
        let status = locationDelegate.authorizationStatus
        
        if status == .notDetermined {
            locationDelegate.requestAuthorization()
            return
        }
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            print("Location services not authorized")
            return
        }
        
        // Set up callback for location update
        locationDelegate.onLocationUpdate = { location in
            Task { @MainActor in
                note.location = String(format: "%.6f, %.6f", location.coordinate.latitude, location.coordinate.longitude)
                isRequestingLocation = false
            }
        }
        
        // Request location
        isRequestingLocation = true
        locationDelegate.requestLocation()
    }
    
    private func openInMaps() {
        guard let locationString = note.location else { return }
        
        // Try to parse as coordinates
        let components = locationString.components(separatedBy: ",")
        if components.count == 2,
           let lat = Double(components[0].trimmingCharacters(in: .whitespaces)),
           let lon = Double(components[1].trimmingCharacters(in: .whitespaces)) {
            
            // Open Maps using coordinate search to avoid deprecated APIs
            Task {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = "\(lat), \(lon)"
                let search = MKLocalSearch(request: request)
                
                do {
                    let response = try await search.start()
                    if let foundItem = response.mapItems.first {
                        foundItem.name = "Incident Location"
                        _ = await MainActor.run {
                            foundItem.openInMaps(launchOptions: [:])
                        }
                    } else {
                        // Fallback: just open Maps app with coordinate URL scheme
                        let url = URL(string: "http://maps.apple.com/?ll=\(lat),\(lon)&q=Incident+Location")!
                        _ = await MainActor.run {
                            UIApplication.shared.open(url)
                        }
                    }
                } catch {
                    // Fallback: just open Maps app with coordinate URL scheme
                    let url = URL(string: "http://maps.apple.com/?ll=\(lat),\(lon)&q=Incident+Location")!
                    Task { @MainActor in
                        UIApplication.shared.open(url)
                    }
                }
            }
        } else {
            // Try to geocode as address using MapKit
            Task {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = locationString
                let search = MKLocalSearch(request: request)
                
                do {
                    let response = try await search.start()
                    if let mapItem = response.mapItems.first {
                        mapItem.name = "Incident Location"
                        _ = await MainActor.run {
                            mapItem.openInMaps(launchOptions: [:])
                        }
                    }
                } catch {
                    print("Error geocoding address: \(error)")
                }
            }
        }
    }
    
    // MARK: - Color Helper Functions
    
    private func capRefillColor(_ status: String) -> Color {
        switch status {
        case "Normal":
            return .green
        case "Delayed":
            return .orange
        default:
            return .gray
        }
    }
    
    private func csmStatusColor(_ status: String) -> Color {
        switch status {
        case "x4":
            return .green
        case "Impaired":
            return .red
        default:
            return .gray
        }
    }
    
    private func skinColorIndicator(_ sctm: String) -> Color {
        if sctm.contains("Normal") || sctm.contains("pink") {
            return .pink
        } else if sctm.contains("Pale") {
            return .gray.opacity(0.5)
        } else if sctm.contains("Red") || sctm.contains("Flushed") {
            return .red
        } else if sctm.contains("Blue") || sctm.contains("Cyanotic") {
            return .blue
        } else if sctm.contains("Ashen") || sctm.contains("Gray") {
            return .gray
        } else if sctm.contains("Yellow") || sctm.contains("Jaundiced") {
            return .yellow
        }
        return .gray
    }
    
    private func sexColorIndicator(_ sex: PatientSex?) -> Color {
        switch sex {
        case .male:
            return .blue
        case .female:
            return .pink
        case .other:
            return .purple
        case .unknown, .none:
            return .gray
        }
    }
    
    private func skinTempColor(_ temp: String) -> Color {
        switch temp {
        case "Warm":
            return .green
        case "Cool":
            return .blue.opacity(0.7)
        case "Cold":
            return .blue
        case "Hot":
            return .red
        default:
            return .gray
        }
    }
    
    private func skinMoistureColor(_ moisture: String) -> Color {
        switch moisture {
        case "Dry":
            return .green
        case "Moist":
            return .yellow
        case "Clammy":
            return .orange
        case "Diaphoretic":
            return .red
        default:
            return .gray
        }
    }
    
    private func evacuationColor(for urgency: EvacuationUrgency) -> Color {
        switch urgency {
        case .noEvac:
            return .green.opacity(0.2)
        case .selfEvac:
            return .blue.opacity(0.2)
        case .nonUrgent:
            return .yellow.opacity(0.3)
        case .urgent:
            return .orange.opacity(0.3)
        case .immediate:
            return .red.opacity(0.3)
        }
    }
    
    private func worstCaseColor(for scenario: String) -> Color {
        if scenario.contains("monitor") {
            return .green.opacity(0.2)
        } else if scenario.contains("non-urgent") {
            return .yellow.opacity(0.3)
        } else if scenario.contains("urgent") && !scenario.contains("non") {
            return .orange.opacity(0.3)
        } else if scenario.contains("immediate") || scenario.contains("Life-threatening") {
            return .red.opacity(0.3)
        }
        return .gray.opacity(0.2)
    }
    
    private func worstCaseIcon(for scenario: String) -> String {
        if scenario.contains("monitor") {
            return "checkmark.circle.fill"
        } else if scenario.contains("non-urgent") {
            return "clock.fill"
        } else if scenario.contains("urgent") && !scenario.contains("non") {
            return "exclamationmark.circle.fill"
        } else if scenario.contains("immediate") || scenario.contains("Life-threatening") {
            return "exclamationmark.triangle.fill"
        }
        return "info.circle.fill"
    }
    
    // Temperature conversion helpers
    private func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 9/5) + 32
    }
    
    private func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) * 5/9
    }
    
    // CSM Score calculation (out of 4)
    private func calculateCSMScore() -> Int {
        var score = 0
        if capRefillHands == "Normal" { score += 1 }
        if capRefillFeet == "Normal" { score += 1 }
        if sensation == "x4" { score += 1 }
        if motion == "x4" { score += 1 }
        return score
    }
    
    // CSM Details (what's impaired)
    private func calculateCSMDetails() -> String {
        var issues: [String] = []
        if capRefillHands == "Delayed" { issues.append("delayed hand cap refill") }
        if capRefillHands == "N/A" { issues.append("hand cap refill not assessed") }
        if capRefillFeet == "Delayed" { issues.append("delayed foot cap refill") }
        if capRefillFeet == "N/A" { issues.append("foot cap refill not assessed") }
        if sensation == "Impaired" { issues.append("impaired sensation") }
        if sensation == "N/A" { issues.append("sensation not assessed") }
        if motion == "Impaired" { issues.append("impaired motion") }
        if motion == "N/A" { issues.append("motion not assessed") }
        
        return issues.isEmpty ? "All normal" : issues.joined(separator: ", ")
    }
    
    // Update note CSM when values change
    private func updateCSM() {
        let score = calculateCSMScore()
        let details = calculateCSMDetails()
        note.csmScore = score
        note.csmDetails = details
        note.csm = "CSM x\(score): \(details)"
    }
    
    // Update burn data when regions change
    private func updateBurnData() {
        let totalPercentage = selectedBodyRegions.reduce(0.0) { $0 + $1.percentage }
        note.burnPercentage = totalPercentage
        note.burnRegions = selectedBodyRegions.map { $0.rawValue }
    }
    
    private static func computeAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date, to: Date())
        return max(0, components.year ?? 0)
    }
    
    private func updateLastInOutStringFromSelection() {
        note.lastInOut = lastInOutSelection.summary
    }
    
    // LOR Score calculation (A+O x4)
    private func calculateLORScore() -> Int {
        guard note.levelOfResponsiveness == .alert else {
            // For V, P, U - just return 0 since we're not tracking components
            return 0
        }
        
        var score = 0
        if lorPerson { score += 1 }
        if lorPlace { score += 1 }
        if lorTime { score += 1 }
        if lorEvent { score += 1 }
        return score
    }
    
    // Update note LOR when values change
    private func updateLOR() {
        // If unresponsive, clear everything
        if note.levelOfResponsiveness == .unresponsive {
            note.lorScore = nil
            return
        }
        
        // Auto-detect: If all 4 A+O are "No" AND no verbal/pain response → Unresponsive
        let allOrientationNo = !lorPerson && !lorPlace && !lorTime && !lorEvent
        let noVerbalOrPain = !lorRespondsToVerbal && !lorRespondsToPain
        
        if allOrientationNo && noVerbalOrPain {
            // Automatically set to unresponsive
            note.levelOfResponsiveness = .unresponsive
            note.lorScore = nil
            return
        }
        
        // Determine level based on responses
        let isFullyOriented = lorPerson && lorPlace && lorTime && lorEvent
        
        if isFullyOriented {
            note.levelOfResponsiveness = .alert
            note.lorScore = 4
        } else if lorRespondsToVerbal {
            note.levelOfResponsiveness = .verbal
            note.lorScore = nil // V doesn't have a numeric score
        } else if lorRespondsToPain {
            note.levelOfResponsiveness = .painful
            note.lorScore = nil // P doesn't have a numeric score
        } else if lorPerson || lorPlace || lorTime || lorEvent {
            // Partially oriented but not all 4
            note.levelOfResponsiveness = .alert
            note.lorScore = calculateLORScore()
        } else {
            note.levelOfResponsiveness = nil
            note.lorScore = nil
        }
    }
    
    // LOR AVPU display text (just shows A, V, P, or U)
    private func lorAVPUDisplayText() -> String {
        guard let level = note.levelOfResponsiveness else {
            return "Not assessed"
        }
        
        switch level {
        case .alert:
            return "A" // Just "A" - the A+O score is shown separately
        case .verbal:
            return "V"
        case .painful:
            return "P"
        case .unresponsive:
            return "U"
        }
    }
    
    // Alert & Oriented background color helper
    private func alertOrientationBackgroundColor() -> Color {
        let score = calculateLORScore()
        switch score {
        case 4:
            return Color.green.opacity(0.1)
        case 3:
            return Color.yellow.opacity(0.1)
        case 2:
            return Color.orange.opacity(0.1)
        case 0...1:
            return Color.red.opacity(0.1)
        default:
            return Color.gray.opacity(0.1)
        }
    }
    
    // Alert & Oriented foreground color helper
    private func alertOrientationForegroundColor() -> Color {
        let score = calculateLORScore()
        switch score {
        case 4:
            return .green
        case 3:
            return .yellow
        case 2:
            return .orange
        case 0...1:
            return .red
        default:
            return .gray
        }
    }
    
    // LOR Score interpretation
    private func lorScoreInterpretation() -> String {
        guard let level = note.levelOfResponsiveness else {
            return "Not assessed"
        }
        
        switch level {
        case .alert:
            let score = calculateLORScore()
            switch score {
            case 4:
                return "Fully oriented"
            case 3:
                return "Mild confusion"
            case 2:
                return "Moderate confusion"
            case 1:
                return "Significant confusion"
            case 0:
                return "Disoriented"
            default:
                return "Unknown"
            }
        case .verbal:
            return lorRespondsToVerbal ? "Responds to voice" : "No verbal response"
        case .painful:
            return lorRespondsToPain ? "Responds to pain" : "No pain response"
        case .unresponsive:
            return "Unresponsive - Critical"
        }
    }
    
    private func lorScoreBackgroundColor() -> Color {
        guard let level = note.levelOfResponsiveness else {
            return Color.gray.opacity(0.2)
        }
        
        switch level {
        case .alert:
            let score = calculateLORScore()
            switch score {
            case 4:
                return Color.green.opacity(0.2)
            case 3:
                return Color.yellow.opacity(0.2)
            case 2:
                return Color.orange.opacity(0.2)
            case 0...1:
                return Color.red.opacity(0.2)
            default:
                return Color.gray.opacity(0.2)
            }
        case .verbal:
            return lorRespondsToVerbal ? Color.yellow.opacity(0.2) : Color.orange.opacity(0.2)
        case .painful:
            return lorRespondsToPain ? Color.orange.opacity(0.2) : Color.red.opacity(0.2)
        case .unresponsive:
            return Color.red.opacity(0.3)
        }
    }
    
    private func lorScoreForegroundColor() -> Color {
        guard let level = note.levelOfResponsiveness else {
            return .gray
        }
        
        switch level {
        case .alert:
            let score = calculateLORScore()
            switch score {
            case 4:
                return .green
            case 3:
                return .yellow
            case 2:
                return .orange
            case 0...1:
                return .red
            default:
                return .gray
            }
        case .verbal:
            return lorRespondsToVerbal ? .yellow : .orange
        case .painful:
            return lorRespondsToPain ? .orange : .red
        case .unresponsive:
            return .red
        }
    }
}

private struct IntakeQuickLogView: View {
    @Binding var selection: IntakeOutputSelection
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Last In/Out")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            LazyVGrid(columns: columns, spacing: 8) {
                IntakeQuickOptionChip(label: "Ate", systemImage: "fork.knife", isSelected: Binding(
                    get: { selection.ate },
                    set: { selection.ate = $0 }
                ))
                
                IntakeQuickOptionChip(label: "Drank", systemImage: "drop.fill", isSelected: Binding(
                    get: { selection.drank },
                    set: { selection.drank = $0 }
                ))
                
                IntakeQuickOptionChip(label: "Urinated", systemImage: "figure.walk.circle", isSelected: Binding(
                    get: { selection.urinated },
                    set: { selection.urinated = $0 }
                ))
                
                IntakeQuickOptionChip(label: "Bowel movement", systemImage: "leaf.arrow.circlepath", isSelected: Binding(
                    get: { selection.defecated },
                    set: { selection.defecated = $0 }
                ))
            }

            if let summary = selection.summary {
                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

private struct IntakeQuickOptionChip: View {
    let label: String
    let systemImage: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.caption)
                Text(label)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .foregroundStyle(isSelected ? .blue : .primary)
            .background(isSelected ? Color.blue.opacity(0.15) : Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Reference Quick View

struct ReferenceQuickView: View {
    let chapter: String
    @Query private var allChapters: [WFRChapter]
    @State private var selectedChapter: WFRChapter?
    
    private var matchingChapter: WFRChapter? {
        // Try to find chapter by title (case-insensitive partial match)
        allChapters.first { chapterTitle in
            chapterTitle.title.localizedCaseInsensitiveContains(chapter) ||
            chapter.localizedCaseInsensitiveContains(chapterTitle.title)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(chapter)
                    .font(.title2.bold())
                
                if let chapterContent = matchingChapter {
                    if let subtitle = chapterContent.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 8)
                    }
                    
                    // Display chapter sections
                    ForEach(chapterContent.sections.sorted(by: { $0.orderIndex < $1.orderIndex }), id: \.id) { section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.headline)
                                .padding(.top, 12)
                            
                            // Display content blocks
                            ForEach(section.content.sorted(by: { $0.orderIndex < $1.orderIndex }), id: \.id) { block in
                                VStack(alignment: .leading, spacing: 4) {
                                    if !block.content.isEmpty {
                                        Text(block.content)
                                            .font(block.type == .heading || block.type == .subheading ? .subheadline.bold() : .body)
                                            .foregroundStyle(block.type == .warning ? .red : .primary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                } else {
                Text("Quick reference content for \(chapter) will appear here.")
                    .foregroundStyle(.secondary)
                
                Text("This will show relevant protocols and checklists you can reference while documenting.")
                    .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
        .task {
            selectedChapter = matchingChapter
        }
    }
}

#Preview {
    NavigationStack {
        ExpertModeNoteView()
            .environment(AppSettings())
            .modelContainer(for: [SOAPNote.self, VitalSigns.self], inMemory: true)
    }
}
