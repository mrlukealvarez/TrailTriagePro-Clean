//
//  SOAPNoteCardView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Note card component for display!
//


import SwiftUI
import SwiftData

/// Displays a SOAP note in a professional, printable card format
struct SOAPNoteCardView: View {
    let note: SOAPNote
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                headerSection
                
                Divider()
                
                // Incident Information
                incidentSection
                
                // Patient Demographics
                patientSection
                
                // Chief Complaint
                if note.signsSymptoms != nil {
                    chiefComplaintSection
                }
                
                // Vital Signs
                if !note.vitalSigns.isEmpty {
                    vitalSignsSection
                }
                
                // SAMPLE History
                sampleSection
                
                // Physical Exam
                physicalExamSection
                
                // Assessment & Plan
                assessmentPlanSection
                
                // Provider Info
                providerSection
                
                // Footer
                footerSection
            }
            .padding()
            .background(Color.white)
        }
        .navigationTitle("Patient Care Report")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("PATIENT CARE REPORT")
                .font(.title.bold())
            
            Text("Wilderness First Responder Documentation")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(note.createdDate.formatted(date: .long, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.05))
    }
    
    private var incidentSection: some View {
        CardSection(title: "INCIDENT INFORMATION") {
            VStack(alignment: .leading, spacing: 8) {
                if let incidentTime = note.incidentTime {
                    InfoRow(label: "Incident Time", value: incidentTime.formatted(date: .omitted, time: .shortened))
                }
                
                if let location = note.location {
                    InfoRow(label: "Location", value: location)
                }
                
                if let season = note.season {
                    InfoRow(label: "Season", value: season.rawValue)
                }
                
                if let setting = note.setting {
                    InfoRow(label: "Setting", value: setting)
                }
            }
        }
    }
    
    private var patientSection: some View {
        CardSection(title: "PATIENT DEMOGRAPHICS") {
            VStack(alignment: .leading, spacing: 8) {
                if let name = note.patientName {
                    InfoRow(label: "Name", value: name)
                }
                
                if let age = note.patientAge {
                    InfoRow(label: "Age", value: "\(age)")
                } else if let dob = note.patientDateOfBirth {
                    InfoRow(label: "Date of Birth", value: dob.formatted(date: .abbreviated, time: .omitted))
                }
                
                if let sex = note.patientSex {
                    InfoRow(label: "Sex", value: sex.rawValue)
                }
                
                if let weight = note.patientWeight {
                    let weightKg = weight * 0.453592
                    InfoRow(label: "Weight", value: "\(String(format: "%.1f", weight)) lbs (\(String(format: "%.1f", weightKg)) kg)")
                }
                
                if let contact = note.patientEmergencyContact {
                    InfoRow(label: "Emergency Contact", value: contact)
                }
            }
        }
    }
    
    private var chiefComplaintSection: some View {
        CardSection(title: "CHIEF COMPLAINT") {
            if let complaint = note.signsSymptoms {
                Text(complaint)
                    .font(.body)
            }
        }
    }
    
    private var vitalSignsSection: some View {
        CardSection(title: "VITAL SIGNS") {
            VStack(alignment: .leading, spacing: 12) {
                // Table header
                HStack {
                    Text("Time").frame(width: 60, alignment: .leading).font(.caption.bold())
                    Text("HR").frame(width: 40, alignment: .leading).font(.caption.bold())
                    Text("RR").frame(width: 40, alignment: .leading).font(.caption.bold())
                    Text("BP").frame(width: 70, alignment: .leading).font(.caption.bold())
                    Text("Temp").frame(width: 50, alignment: .leading).font(.caption.bold())
                    Text("SpO₂").frame(width: 40, alignment: .leading).font(.caption.bold())
                }
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
                
                // Vital signs rows
                ForEach(note.vitalSigns.sorted(by: { $0.timestamp < $1.timestamp }), id: \.id) { vital in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(vital.timestamp.formatted(date: .omitted, time: .shortened))
                                .frame(width: 60, alignment: .leading)
                                .font(.caption)
                            
                            Text(vital.heartRate.map { "\($0)" } ?? "--")
                                .frame(width: 40, alignment: .leading)
                                .font(.caption)
                            
                            Text(vital.respiratoryRate.map { "\($0)" } ?? "--")
                                .frame(width: 40, alignment: .leading)
                                .font(.caption)
                            
                            Text(vital.bloodPressureString ?? "--")
                                .frame(width: 70, alignment: .leading)
                                .font(.caption)
                            
                            if let temp = vital.temperature {
                                let tempF = (temp * 9/5) + 32
                                Text(String(format: "%.1f", tempF))
                                    .frame(width: 50, alignment: .leading)
                                    .font(.caption)
                            } else {
                                Text("--")
                                    .frame(width: 50, alignment: .leading)
                                    .font(.caption)
                            }
                            
                            Text(vital.oxygenSaturation.map { "\($0)" } ?? "--")
                                .frame(width: 40, alignment: .leading)
                                .font(.caption)
                        }
                        
                        if let notes = vital.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 8)
                        }
                    }
                    .padding(.vertical, 4)
                    
                    if vital.id != note.vitalSigns.last?.id {
                        Divider()
                    }
                }
            }
        }
    }
    
    private var sampleSection: some View {
        CardSection(title: "SAMPLE HISTORY") {
            VStack(alignment: .leading, spacing: 8) {
                if let ss = note.signsSymptoms {
                    InfoRow(label: "Signs/Symptoms", value: ss)
                }
                
                if let allergies = note.allergies {
                    InfoRow(label: "Allergies", value: allergies)
                }
                
                if let meds = note.medications {
                    InfoRow(label: "Medications", value: meds)
                }
                
                if let history = note.pertinentHistory {
                    InfoRow(label: "Pertinent History", value: history)
                }
                
                if let lastInOut = note.lastInOut {
                    InfoRow(label: "Last In/Out", value: lastInOut)
                }
                
                if let events = note.events {
                    InfoRow(label: "Events", value: events)
                }
            }
        }
    }
    
    private var physicalExamSection: some View {
        CardSection(title: "PHYSICAL EXAMINATION") {
            VStack(alignment: .leading, spacing: 8) {
                if let lor = note.levelOfResponsiveness {
                    let lorText = buildLORText(lor: lor, score: note.lorScore)
                    InfoRow(label: "LOR", value: lorText)
                }
                
                if let perrl = note.perrl {
                    InfoRow(label: "PERRL", value: perrl ? "Yes" : "No")
                }
                
                if let sctm = note.sctm {
                    InfoRow(label: "SCTM", value: sctm)
                }
                
                if let csm = note.csm {
                    let csmText = buildCSMText(csm: csm, score: note.csmScore, details: note.csmDetails)
                    InfoRow(label: "CSM", value: csmText)
                }
                
                if let exam = note.physicalExamNotes {
                    InfoRow(label: "Exam Notes", value: exam)
                }
            }
        }
    }
    
    private var assessmentPlanSection: some View {
        CardSection(title: "ASSESSMENT & PLAN") {
            VStack(alignment: .leading, spacing: 8) {
                if let assessment = note.assessment {
                    InfoRow(label: "Assessment", value: assessment)
                }
                
                if let treatment = note.treatmentProvided {
                    InfoRow(label: "Treatment", value: treatment)
                }
                
                if let evac = note.evacuationPlan {
                    InfoRow(label: "Evacuation", value: evac.rawValue)
                }
                
                if let evacNotes = note.evacuationNotes {
                    InfoRow(label: "Evac Notes", value: evacNotes)
                }
                
                if let monitor = note.monitoringPlan {
                    InfoRow(label: "Monitoring", value: monitor)
                }
            }
        }
    }
    
    private var providerSection: some View {
        CardSection(title: "PROVIDER INFORMATION") {
            VStack(alignment: .leading, spacing: 8) {
                if let name = note.responderName {
                    InfoRow(label: "Name", value: name)
                }
                
                if let agency = note.responderAgency {
                    InfoRow(label: "Agency", value: agency)
                }
                
                if let number = note.responderRescueNumber {
                    InfoRow(label: "ID/Rescue #", value: number)
                }
                
                if let certs = note.responderCertifications {
                    InfoRow(label: "Certifications", value: certs)
                }
                
                if !note.responders.isEmpty {
                    InfoRow(label: "Additional Responders", value: note.responders.joined(separator: ", "))
                }
            }
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 4) {
            Text("Generated by WFR TrailTriage")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text("Report ID: \(note.id.uuidString.prefix(8))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.05))
    }
    
    // MARK: - Actions
    
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

// MARK: - Supporting Views

struct CardSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.blue)
            
            content
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
        .padding(.vertical, 4)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.body)
        }
    }
}

// MARK: - ShareSheet is defined in ShareSheet.swift

#Preview {
    @Previewable @State var note: SOAPNote = {
        let n = SOAPNote(id: UUID())
        n.patientName = "John Doe"
        n.patientAge = 32
        n.patientSex = .male
        n.signsSymptoms = "Twisted ankle while hiking"
        n.assessment = "Grade 2 ankle sprain"
        n.treatmentProvided = "RICE protocol applied"
        
        let vital = VitalSigns(id: UUID(), heartRate: 72, respiratoryRate: 16, bloodPressureSystolic: 120, bloodPressureDiastolic: 80)
        n.vitalSigns = [vital]
        
        return n
    }()
    
    NavigationStack {
        SOAPNoteCardView(note: note)
    }
    .modelContainer(for: SOAPNote.self, inMemory: true)
}
