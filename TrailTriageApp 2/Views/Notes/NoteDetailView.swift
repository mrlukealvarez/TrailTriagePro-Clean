//
//  NoteDetailView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/9/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: View/edit individual note!
//


import SwiftUI
import SwiftData

/// Comprehensive view for viewing and managing a SOAP note
struct NoteDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var note: SOAPNote
    
    @State private var selectedTab: DetailTab = .overview
    @State private var showingEditSheet = false
    @State private var showingTransferDocument = false
    @State private var showingDeleteConfirmation = false
    @State private var showingQuickAddVitals = false
    
    enum DetailTab: String, CaseIterable {
        case overview = "Overview"
        case vitals = "Vitals"
        case timeline = "Timeline"
        
        var icon: String {
            switch self {
            case .overview: return "doc.text"
            case .vitals: return "heart.text.square"
            case .timeline: return "chart.xyaxis.line"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab selector
            Picker("View", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Label(tab.rawValue, systemImage: tab.icon)
                        .tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content
            ScrollView {
                switch selectedTab {
                case .overview:
                    overviewContent
                case .vitals:
                    vitalsContent
                case .timeline:
                    timelineContent
                }
            }
        }
        .navigationTitle(note.patientName ?? "SOAP Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit Note", systemImage: "pencil")
                    }
                    
                    Button {
                        showingTransferDocument = true
                    } label: {
                        Label("Patient Report", systemImage: "doc.text.fill")
                    }
                    
                    Button {
                        exportAsPDF()
                    } label: {
                        Label("Share as PDF", systemImage: "square.and.arrow.up")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Label("Delete Note", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                ExpertModeNoteView(note: note)
            }
        }
        .sheet(isPresented: $showingTransferDocument) {
            NavigationStack {
                PatientTransferDocumentView(note: note)
            }
        }
        .sheet(isPresented: $showingQuickAddVitals) {
            QuickAddVitalsSheet(note: note) {
                // Refresh handled by SwiftData
            }
        }
        .confirmationDialog("Delete Note", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteNote()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
    
    // MARK: - Overview Content
    
    @ViewBuilder
    private var overviewContent: some View {
        VStack(spacing: 16) {
            // Quick stats
            quickStatsSection
            
            // Vitals tracking panel
            VitalsTrackingPanel(note: note)
                .padding(.horizontal)
            
            // Patient info
            if hasPatientInfo {
                patientInfoSection
            }
            
            // Chief complaint
            if let complaint = note.signsSymptoms {
                infoCard(title: "Chief Complaint", content: complaint, icon: "exclamationmark.circle", color: .red)
            }
            
            // Assessment
            if let assessment = note.assessment {
                infoCard(title: "Assessment", content: assessment, icon: "stethoscope", color: .blue)
            }
            
            // Treatment
            if let treatment = note.treatmentProvided {
                infoCard(title: "Treatment Provided", content: treatment, icon: "cross.case", color: .green)
            }
            
            // Evacuation
            if let evac = note.evacuationPlan {
                evacuationCard(evac)
            }
            
            // Provider info
            providerInfoSection
        }
        .padding()
    }
    
    // MARK: - Vitals Content
    
    @ViewBuilder
    private var vitalsContent: some View {
        VStack(spacing: 16) {
            // Quick add button
            Button {
                showingQuickAddVitals = true
            } label: {
                Label("Add Vitals Reading", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            // Latest vitals
            if let latest = note.vitalSigns.sorted(by: { $0.timestamp > $1.timestamp }).first {
                latestVitalsCard(latest)
            }
            
            // All vitals list
            if !note.vitalSigns.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("All Readings")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(note.vitalSigns.sorted(by: { $0.timestamp > $1.timestamp }), id: \.id) { vital in
                        VitalCheckRow(vital: vital)
                            .padding(.horizontal)
                    }
                }
            } else {
                emptyStateView(
                    icon: "heart.text.square",
                    title: "No Vitals Recorded",
                    message: "Tap the button above to add your first vitals reading"
                )
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - Timeline Content
    
    @ViewBuilder
    private var timelineContent: some View {
        VitalsTimelineView(note: note)
    }
    
    // MARK: - Supporting Views
    
    @ViewBuilder
    private var quickStatsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                value: note.vitalSigns.count,
                label: "Vitals Checks",
                icon: "heart.text.square",
                color: .red
            )
            
            StatCard(
                value: durationString,
                label: "Duration",
                icon: "clock",
                color: .blue
            )
            
            StatCard(
                value: note.evacuationPlan?.abbreviation ?? "None",
                label: "Evacuation",
                icon: "cross.case",
                color: evacuationColor
            )
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var patientInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Patient Information")
                .font(.headline)
            
            VStack(spacing: 8) {
                if let name = note.patientName {
                    PatientInfoRow(label: "Name", value: name)
                }
                
                if let age = note.patientAge {
                    PatientInfoRow(label: "Age", value: "\(age)")
                }
                
                if let sex = note.patientSex {
                    PatientInfoRow(label: "Sex", value: sex.rawValue)
                }
                
                if let weight = note.patientWeight {
                    let weightKg = weight * 0.453592
                    PatientInfoRow(
                        label: "Weight",
                        value: "\(String(format: "%.1f", weight)) lbs (\(String(format: "%.1f", weightKg)) kg)"
                    )
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var providerInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Provider Information")
                .font(.headline)
            
            VStack(spacing: 8) {
                if let name = note.responderName {
                    PatientInfoRow(label: "Responder", value: name)
                }
                
                if let agency = note.responderAgency {
                    PatientInfoRow(label: "Agency", value: agency)
                }
                
                if let certs = note.responderCertifications {
                    PatientInfoRow(label: "Certifications", value: certs)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func infoCard(title: String, content: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            Text(content)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func evacuationCard(_ urgency: EvacuationUrgency) -> some View {
        HStack {
            Image(systemName: urgency.icon)
                .font(.title2)
                .foregroundStyle(Color(urgency.color))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Evacuation Plan")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(urgency.rawValue)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(urgency.color).opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func latestVitalsCard(_ vital: VitalSigns) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Latest Reading")
                    .font(.headline)
                Spacer()
                Text(vital.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                if let hr = vital.heartRate {
                    VitalTile(label: "HR", value: "\(hr)", unit: "bpm", color: .red)
                }
                
                if let rr = vital.respiratoryRate {
                    VitalTile(label: "RR", value: "\(rr)", unit: "/min", color: .cyan)
                }
                
                if let bp = vital.bloodPressureString {
                    VitalTile(label: "BP", value: bp, unit: "mmHg", color: .purple)
                }
                
                if let temp = vital.temperature {
                    let tempF = (temp * 9/5) + 32
                    VitalTile(label: "Temp", value: String(format: "%.1f", tempF), unit: "°F", color: .orange)
                }
                
                if let spo2 = vital.oxygenSaturation {
                    VitalTile(label: "SpO₂", value: "\(spo2)", unit: "%", color: .blue)
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func emptyStateView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    // MARK: - Computed Properties
    
    private var hasPatientInfo: Bool {
        note.patientName != nil || note.patientAge != nil || 
        note.patientSex != nil || note.patientWeight != nil
    }
    
    private var durationString: String {
        if let incidentTime = note.incidentTime {
            let duration = Date().timeIntervalSince(incidentTime)
            let hours = Int(duration / 3600)
            let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
            
            if hours > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(minutes)m"
            }
        }
        
        let duration = Date().timeIntervalSince(note.createdDate)
        let hours = Int(duration / 3600)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private var evacuationColor: Color {
        guard let evac = note.evacuationPlan else { return .secondary }
        return Color(evac.color)
    }
    
    // MARK: - Actions
    
    private func exportAsPDF() {
        guard let data = PCRFormatter.generateStandardFormPDF(for: note) else {
            print("Failed to generate PDF")
            return
        }
        
        let fileName = "PCR_\(note.patientName ?? "Unknown")_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempURL)
            shareFile(url: tempURL)
        } catch {
            print("Error saving PDF: \(error)")
        }
    }
    
    private func deleteNote() {
        modelContext.delete(note)
        dismiss()
    }
    
    private func shareFile(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Use keyWindow for iOS 26.0+ compatibility
            if let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first,
               let rootViewController = keyWindow.rootViewController {
                rootViewController.present(activityVC, animated: true)
            }
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let value: Any
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text("\(String(describing: value))")
                .font(.title3.bold())
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PatientInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
        }
    }
}

struct VitalTile: View {
    let label: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2.bold())
                    .foregroundStyle(color)
                
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

extension EvacuationUrgency {
    var abbreviation: String {
        switch self {
        case .immediate: return "IMMED"
        case .urgent: return "URG"
        case .nonUrgent: return "Non-Urg"
        case .selfEvac: return "Self"
        case .noEvac: return "None"
        }
    }
}

#Preview {
    @Previewable @State var note: SOAPNote = {
        let n = SOAPNote(id: UUID())
        n.patientName = "John Doe"
        n.patientAge = 32
        n.patientSex = .male
        n.signsSymptoms = "Twisted ankle while hiking"
        n.assessment = "Grade 2 ankle sprain"
        n.treatmentProvided = "RICE protocol applied"
        n.evacuationPlan = .nonUrgent
        
        let vital = VitalSigns(id: UUID(), heartRate: 72, respiratoryRate: 16, bloodPressureSystolic: 120, bloodPressureDiastolic: 80)
        n.vitalSigns = [vital]
        
        return n
    }()
    
    NavigationStack {
        NoteDetailView(note: note)
    }
    .modelContainer(for: SOAPNote.self, inMemory: true)
}
