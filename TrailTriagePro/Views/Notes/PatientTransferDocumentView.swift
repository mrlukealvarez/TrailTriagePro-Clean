//
//  PatientTransferDocumentView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/18/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Modern, beautiful patient transfer document - Apple-style design!
//

import SwiftUI
import SwiftData

enum TransferLayoutStyle {
    case standard
    case condensed
}

/// Modern, beautiful patient transfer document
/// Designed for viewing and AirDrop to EMTs - Apple-style UI
struct PatientTransferDocumentView: View {
    let note: SOAPNote
    
    var body: some View {
        ScrollView {
            PatientTransferDocumentContent(note: note, layoutStyle: .standard)
                .padding()
        }
        .navigationTitle("Patient Report")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Core Content (shared between on-device view and PDF export)

struct PatientTransferDocumentContent: View {
    let note: SOAPNote
    var layoutStyle: TransferLayoutStyle = .standard
    
    // Get most recent vitals
    private var latestVitals: VitalSigns? {
        note.vitalSigns.sorted(by: { $0.timestamp > $1.timestamp }).first
    }
    
    // Get all vitals for timeline
    private var allVitals: [VitalSigns] {
        note.vitalSigns.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    private var sectionSpacing: CGFloat {
        layoutStyle == .standard ? 20 : 8
    }
    
    private var cardContentSpacing: CGFloat {
        layoutStyle == .standard ? 16 : 8
    }
    
    private var condensedColumns: [GridItem] {
        [
            GridItem(.flexible(minimum: 0), spacing: 6),
            GridItem(.flexible(minimum: 0), spacing: 6)
        ]
    }
    
    var body: some View {
        Group {
            if layoutStyle == .condensed {
                condensedLayout
            } else {
                standardLayout
            }
        }
    }
    
    private var standardLayout: some View {
        VStack(spacing: sectionSpacing) {
            headerSection
            patientInfoCard
            complaintCardView
            vitalsContent
            assessmentTreatmentCard
            evacuationCardView
            sampleHistoryCard
            physicalExamCard
            providerInfoCard
            incidentInfoCard
            footerSection
        }
    }
    
    private var condensedLayout: some View {
        VStack(spacing: sectionSpacing) {
            headerSection
            LazyVGrid(columns: condensedColumns, spacing: 6) {
                patientInfoCard
                    .gridCellColumns(2)
                
                complaintCardView
                    .gridCellColumns(2)
                
                vitalsContent
                    .gridCellColumns(2)
                
                assessmentTreatmentCard
                    .gridCellColumns(2)
                
                evacuationCardView
                    .gridCellColumns(2)
                
                sampleHistoryCard
                physicalExamCard
                providerInfoCard
                incidentInfoCard
            }
            
            footerSection
                .padding(.top, sectionSpacing)
        }
    }
    
    @ViewBuilder
    private var complaintCardView: some View {
        if let complaint = note.signsSymptoms, !complaint.isEmpty {
            complaintCard(complaint)
        }
    }
    
    @ViewBuilder
    private var vitalsContent: some View {
        if let vitals = latestVitals {
            currentVitalsCard(vitals)
        }
        if note.vitalSigns.count > 1 {
            vitalsTimelineCard
        }
    }
    
    @ViewBuilder
    private var evacuationCardView: some View {
        if let evac = note.evacuationPlan {
            evacuationPriorityCard(evac)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: layoutStyle == .standard ? 12 : 4) {
            if layoutStyle == .condensed {
                HStack(spacing: 8) {
                    headerIcon
                    VStack(alignment: .leading, spacing: 1) {
                        Text("TrailTriage")
                            .font(.system(size: 18, weight: .bold))
                        Text("Patient Transfer Report")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(note.createdDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 1)
            } else {
                headerIcon
                VStack(spacing: 4) {
                    Text("TrailTriage")
                        .font(.system(size: 28, weight: .bold))
                    
                    Text("Patient Transfer Report")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(note.createdDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.secondarySystemBackground))
                .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, layoutStyle == .standard ? 20 : 4)
    }
    
    private var headerIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.2), .cyan.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: layoutStyle == .standard ? 80 : 50,
                       height: layoutStyle == .standard ? 80 : 50)
            
            Image(systemName: "cross.case.fill")
                .font(.system(size: layoutStyle == .standard ? 40 : 25, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
    
    // MARK: - Patient Info Card
    
    private var patientInfoCard: some View {
        ModernInfoCard(title: "Patient Information", icon: "person.fill", color: Color.blue, layoutStyle: layoutStyle) {
            VStack(alignment: .leading, spacing: cardContentSpacing) {
                if let name = note.patientName {
                    TransferInfoRow(icon: "person.circle.fill", label: "Name", value: name, color: Color.blue, layoutStyle: layoutStyle)
                }
                
                HStack(spacing: 20) {
                    if let age = note.patientAge {
                        TransferInfoRow(icon: "calendar", label: "Age", value: "\(age) years", color: Color.blue, layoutStyle: layoutStyle)
                    }
                    
                    if let sex = note.patientSex {
                        TransferInfoRow(icon: "person.text.rectangle", label: "Sex", value: sex.rawValue, color: Color.blue, layoutStyle: layoutStyle)
                    }
                }
                
                if let weight = note.patientWeight {
                    let weightKg = weight * 0.453592
                    TransferInfoRow(icon: "scalemass.fill", label: "Weight", value: String(format: "%.0f lbs (%.1f kg)", weight, weightKg), color: Color.blue, layoutStyle: layoutStyle)
                }
                
                if let contact = note.patientEmergencyContact {
                    TransferInfoRow(icon: "phone.fill", label: "Emergency Contact", value: contact, color: Color.blue, layoutStyle: layoutStyle)
                }
            }
        }
    }
    
    // MARK: - Chief Complaint Card
    
    private func complaintCard(_ complaint: String) -> some View {
        ModernInfoCard(title: "Chief Complaint", icon: "exclamationmark.bubble.fill", color: Color.orange, layoutStyle: layoutStyle) {
            Text(complaint)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Current Vitals Card
    
    private func currentVitalsCard(_ vitals: VitalSigns) -> some View {
        ModernInfoCard(title: "Current Vital Signs", icon: "heart.text.square.fill", color: Color.red, layoutStyle: layoutStyle) {
            VStack(spacing: cardContentSpacing) {
                // Vital signs grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: layoutStyle == .standard ? 16 : 8) {
                    if let hr = vitals.heartRate {
                        TransferVitalBadge(icon: "heart.fill", label: "Heart Rate", value: "\(hr)", unit: "bpm", color: Color.red, layoutStyle: layoutStyle)
                    }
                    
                    if let rr = vitals.respiratoryRate {
                        TransferVitalBadge(icon: "lungs.fill", label: "Respiratory", value: "\(rr)", unit: "/min", color: Color.blue, layoutStyle: layoutStyle)
                    }
                    
                    if let bp = vitals.bloodPressureString {
                        TransferVitalBadge(icon: "waveform.path", label: "Blood Pressure", value: bp, unit: "", color: Color.purple, layoutStyle: layoutStyle)
                    }
                    
                    if let temp = vitals.temperature {
                        let tempF = (temp * 9/5) + 32
                        TransferVitalBadge(icon: "thermometer", label: "Temperature", value: String(format: "%.1f", tempF), unit: "°F", color: Color.orange, layoutStyle: layoutStyle)
                    }
                    
                    if let spo2 = vitals.oxygenSaturation {
                        TransferVitalBadge(icon: "waveform.path.ecg", label: "SpO₂", value: "\(spo2)", unit: "%", color: Color.green, layoutStyle: layoutStyle)
                    }
                }
                
                // Timestamp
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text("Taken: \(vitals.timestamp.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // MARK: - Vitals Timeline Card
    
    private var vitalsTimelineCard: some View {
        ModernInfoCard(title: "Vital Signs Timeline", icon: "chart.xyaxis.line", color: Color.purple, layoutStyle: layoutStyle) {
            VStack(spacing: 12) {
                ForEach(allVitals.prefix(5), id: \.id) { vital in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(vital.timestamp.formatted(date: .omitted, time: .shortened))
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        
                        HStack(spacing: 16) {
                            if let hr = vital.heartRate {
                                HStack(spacing: 4) {
                                    Image(systemName: "heart.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.red)
                                    Text("\(hr)")
                                        .font(.caption.bold())
                                }
                            }
                            
                            if let rr = vital.respiratoryRate {
                                HStack(spacing: 4) {
                                    Image(systemName: "lungs.fill")
                                        .font(.caption2)
                                        .foregroundStyle(.blue)
                                    Text("\(rr)")
                                        .font(.caption.bold())
                                }
                            }
                            
                            if let bp = vital.bloodPressureString {
                                HStack(spacing: 4) {
                                    Image(systemName: "waveform.path")
                                        .font(.caption2)
                                        .foregroundStyle(.purple)
                                    Text(bp)
                                        .font(.caption.bold())
                                }
                            }
                            
                            if let temp = vital.temperature {
                                let tempF = (temp * 9/5) + 32
                                HStack(spacing: 4) {
                                    Image(systemName: "thermometer")
                                        .font(.caption2)
                                        .foregroundStyle(.orange)
                                    Text(String(format: "%.1f°F", tempF))
                                        .font(.caption.bold())
                                }
                            }
                            
                            if let spo2 = vital.oxygenSaturation {
                                HStack(spacing: 4) {
                                    Image(systemName: "waveform.path.ecg")
                                        .font(.caption2)
                                        .foregroundStyle(.green)
                                    Text("\(spo2)%")
                                        .font(.caption.bold())
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    if vital.id != allVitals.prefix(5).last?.id {
                        Divider()
                    }
                }
                
                if note.vitalSigns.count > 5 {
                    Text("+ \(note.vitalSigns.count - 5) more readings")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Assessment & Treatment Card
    
    private var assessmentTreatmentCard: some View {
        ModernInfoCard(title: "Assessment & Treatment", icon: "stethoscope", color: Color.green, layoutStyle: layoutStyle) {
            VStack(alignment: .leading, spacing: cardContentSpacing) {
                if let assessment = note.assessment {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Assessment")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        Text(assessment)
                            .font(.body)
                    }
                }
                
                if let treatment = note.treatmentProvided {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "bandage.fill")
                            Text("Treatment Provided")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        Text(treatment)
                            .font(.body)
                    }
                }
                
                if let monitor = note.monitoringPlan {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("Monitoring Plan")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)
                        Text(monitor)
                            .font(.body)
                    }
                }
            }
        }
    }
    
    // MARK: - Evacuation Priority Card
    
    private func evacuationPriorityCard(_ evac: EvacuationUrgency) -> some View {
        let (color, icon) = evacuationStyle(evac)
        
        return ModernInfoCard(title: "Evacuation Priority", icon: icon, color: color, layoutStyle: layoutStyle) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 32))
                        .foregroundStyle(color)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(evac.rawValue)
                            .font(.title3.bold())
                            .foregroundStyle(color)
                        
                        if let notes = note.evacuationNotes {
                            Text(notes)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private func evacuationStyle(_ evac: EvacuationUrgency) -> (Color, String) {
        switch evac {
        case .immediate:
            return (.red, "exclamationmark.triangle.fill")
        case .urgent:
            return (.orange, "arrow.up.circle.fill")
        case .nonUrgent:
            return (.green, "checkmark.circle.fill")
        case .selfEvac:
            return (.blue, "figure.walk.circle.fill")
        case .noEvac:
            return (.gray, "checkmark.circle.fill")
        }
    }
    
    // MARK: - SAMPLE History Card
    
    private var hasSampleHistory: Bool {
        note.signsSymptoms != nil ||
        note.allergies != nil ||
        note.medications != nil ||
        note.pertinentHistory != nil ||
        note.lastInOut != nil ||
        note.events != nil
    }
    
    @ViewBuilder
    private var sampleHistoryCard: some View {
        if hasSampleHistory {
            ModernInfoCard(title: "SAMPLE History", icon: "list.clipboard.fill", color: Color.indigo, layoutStyle: layoutStyle) {
                VStack(alignment: .leading, spacing: cardContentSpacing) {
                    if let ss = note.signsSymptoms {
                        TransferInfoRow(icon: "exclamationmark.circle.fill", label: "Signs/Symptoms", value: ss, color: Color.indigo, layoutStyle: layoutStyle)
                    }
                    if let allergies = note.allergies {
                        TransferInfoRow(icon: "allergens", label: "Allergies", value: allergies, color: Color.indigo, layoutStyle: layoutStyle)
                    }
                    if let meds = note.medications {
                        TransferInfoRow(icon: "pills.fill", label: "Medications", value: meds, color: Color.indigo, layoutStyle: layoutStyle)
                    }
                    if let history = note.pertinentHistory {
                        TransferInfoRow(icon: "clock.arrow.circlepath", label: "Pertinent History", value: history, color: Color.indigo, layoutStyle: layoutStyle)
                    }
                    if let lastInOut = note.lastInOut {
                        TransferInfoRow(icon: "drop.fill", label: "Last In/Out", value: lastInOut, color: Color.indigo, layoutStyle: layoutStyle)
                    }
                    if let events = note.events {
                        TransferInfoRow(icon: "calendar.badge.clock", label: "Events", value: events, color: Color.indigo, layoutStyle: layoutStyle)
                    }
                }
            }
        }
    }
    
    // MARK: - Physical Exam Card
    
    private var hasPhysicalExam: Bool {
        note.levelOfResponsiveness != nil ||
        note.perrl != nil ||
        note.sctm != nil ||
        note.csm != nil ||
        note.physicalExamNotes != nil
    }
    
    @ViewBuilder
    private var physicalExamCard: some View {
        if hasPhysicalExam {
            ModernInfoCard(title: "Physical Examination", icon: "stethoscope.circle.fill", color: Color.teal, layoutStyle: layoutStyle) {
                VStack(alignment: .leading, spacing: cardContentSpacing) {
                    if let lor = note.levelOfResponsiveness {
                        let lorText = buildLORText(lor: lor, score: note.lorScore)
                        TransferInfoRow(icon: "brain.head.profile", label: "LOR", value: lorText, color: Color.teal, layoutStyle: layoutStyle)
                    }
                    if let perrl = note.perrl {
                        TransferInfoRow(icon: "eye.fill", label: "PERRL", value: perrl ? "Yes" : "No", color: Color.teal, layoutStyle: layoutStyle)
                    }
                    if let sctm = note.sctm {
                        TransferInfoRow(icon: "hand.raised.fill", label: "SCTM", value: sctm, color: Color.teal, layoutStyle: layoutStyle)
                    }
                    if let csm = note.csm {
                        let csmText = buildCSMText(csm: csm, score: note.csmScore, details: note.csmDetails)
                        TransferInfoRow(icon: "hand.point.up.left.fill", label: "CSM", value: csmText, color: Color.teal, layoutStyle: layoutStyle)
                    }
                    if let exam = note.physicalExamNotes {
                        TransferInfoRow(icon: "note.text", label: "Exam Notes", value: exam, color: Color.teal, layoutStyle: layoutStyle)
                    }
                }
            }
        }
    }
    
    // MARK: - Provider Info Card
    
    private var hasProviderInfo: Bool {
        note.responderName != nil ||
        note.responderAgency != nil ||
        note.responderRescueNumber != nil ||
        note.responderCertifications != nil ||
        !note.responders.isEmpty
    }
    
    @ViewBuilder
    private var providerInfoCard: some View {
        if hasProviderInfo {
            ModernInfoCard(title: "WFR Provider", icon: "person.badge.shield.checkmark.fill", color: Color.blue, layoutStyle: layoutStyle) {
                VStack(alignment: .leading, spacing: cardContentSpacing) {
                    if let name = note.responderName {
                        TransferInfoRow(icon: "person.fill", label: "Name", value: name, color: Color.blue, layoutStyle: layoutStyle)
                    }
                    if let agency = note.responderAgency {
                        TransferInfoRow(icon: "building.2.fill", label: "Agency", value: agency, color: Color.blue, layoutStyle: layoutStyle)
                    }
                    if let number = note.responderRescueNumber {
                        TransferInfoRow(icon: "number", label: "ID/Rescue #", value: number, color: Color.blue, layoutStyle: layoutStyle)
                    }
                    if let certs = note.responderCertifications {
                        TransferInfoRow(icon: "checkmark.seal.fill", label: "Certifications", value: certs, color: Color.blue, layoutStyle: layoutStyle)
                    }
                    if !note.responders.isEmpty {
                        TransferInfoRow(icon: "person.2.fill", label: "Additional Responders", value: note.responders.joined(separator: ", "), color: Color.blue, layoutStyle: layoutStyle)
                    }
                }
            }
        }
    }
    
    // MARK: - Incident Info Card
    
    private var hasIncidentInfo: Bool {
        note.incidentTime != nil ||
        note.location != nil ||
        note.season != nil ||
        note.setting != nil
    }
    
    @ViewBuilder
    private var incidentInfoCard: some View {
        if hasIncidentInfo {
            ModernInfoCard(title: "Incident Information", icon: "mappin.circle.fill", color: Color.mint, layoutStyle: layoutStyle) {
                VStack(alignment: .leading, spacing: cardContentSpacing) {
                    TransferInfoRow(icon: "calendar", label: "Report Date", value: note.createdDate.formatted(date: .long, time: .shortened), color: Color.mint, layoutStyle: layoutStyle)
                    if let incidentTime = note.incidentTime {
                        TransferInfoRow(icon: "clock.fill", label: "Incident Time", value: incidentTime.formatted(date: .omitted, time: .shortened), color: Color.mint, layoutStyle: layoutStyle)
                    }
                    if let location = note.location {
                        TransferInfoRow(icon: "location.fill", label: "Location", value: location, color: Color.mint, layoutStyle: layoutStyle)
                    }
                    if let season = note.season {
                        TransferInfoRow(icon: "leaf.fill", label: "Season", value: season.rawValue, color: Color.mint, layoutStyle: layoutStyle)
                    }
                    if let setting = note.setting {
                        TransferInfoRow(icon: "mountain.2.fill", label: "Setting", value: setting, color: Color.mint, layoutStyle: layoutStyle)
                    }
                }
            }
        }
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Divider()
                .padding(.vertical, 8)
            
            HStack {
                Text("🦝 Generated by TrailTriage")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("ID: \(note.id.uuidString.prefix(8))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text("BlackElkMountainMedicine.com")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Helper Functions
    
    private func buildLORText(lor: LORLevel, score: Int?) -> String {
        var text = lor.rawValue
        if let score = score {
            text += " (A+O x\(score))"
        }
        return text
    }
    
    private func buildCSMText(csm: String, score: Int?, details: String?) -> String {
        var text = csm
        if let score = score {
            text += " (x\(score))"
        }
        if let details = details {
            text += " - \(details)"
        }
        return text
    }
}

// MARK: - Modern Info Card Component

struct ModernInfoCard<Content: View>: View {
    let title: String
    let icon: String
    var color: Color = .blue
    var layoutStyle: TransferLayoutStyle = .standard
    @ViewBuilder let content: Content
    
    private var paddingAmount: CGFloat {
        layoutStyle == .standard ? 20 : 12
    }
    
    private var cornerRadius: CGFloat {
        layoutStyle == .standard ? 16 : 10
    }
    
    private var spacing: CGFloat {
        layoutStyle == .standard ? 16 : 8
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            // Header with icon
            HStack(spacing: layoutStyle == .standard ? 10 : 8) {
                Image(systemName: icon)
                    .font(.system(size: layoutStyle == .standard ? 18 : 16, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: layoutStyle == .standard ? 28 : 24, height: layoutStyle == .standard ? 28 : 24)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())
                
                Text(title)
                    .font(layoutStyle == .standard ? .headline : .subheadline.bold())
                    .foregroundStyle(.primary)
            }
            
            // Content
            content
        }
        .padding(paddingAmount)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
        )
    }
}

// MARK: - Transfer Info Row Component

struct TransferInfoRow: View {
    let icon: String
    let label: String
    let value: String
    var color: Color = Color.blue
    var layoutStyle: TransferLayoutStyle = .standard
    
    var body: some View {
        HStack(spacing: layoutStyle == .standard ? 12 : 8) {
            Image(systemName: icon)
                .font(.system(size: layoutStyle == .standard ? 14 : 12))
                .foregroundStyle(color)
                .frame(width: layoutStyle == .standard ? 20 : 18)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(layoutStyle == .standard ? .caption.bold() : .caption2.bold())
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(layoutStyle == .standard ? .body : .subheadline)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Transfer Vital Badge Component

struct TransferVitalBadge: View {
    let icon: String
    let label: String
    let value: String
    let unit: String
    let color: Color
    var layoutStyle: TransferLayoutStyle = .standard
    
    var body: some View {
        VStack(spacing: layoutStyle == .standard ? 8 : 6) {
            Image(systemName: icon)
                .font(.system(size: layoutStyle == .standard ? 24 : 20))
                .foregroundStyle(color)
            
            VStack(spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(layoutStyle == .standard ? .title3.bold() : .headline.bold())
                        .foregroundStyle(color)
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(layoutStyle == .standard ? .caption : .caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, layoutStyle == .standard ? 12 : 8)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: layoutStyle == .standard ? 12 : 8))
    }
}

