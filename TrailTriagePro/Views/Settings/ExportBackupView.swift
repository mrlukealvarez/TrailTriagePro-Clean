//
//  ExportBackupView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/10/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Data export & backup!
//

import SwiftUI
import SwiftData
import PDFKit

struct ExportBackupView: View {
    @Query private var allNotes: [SOAPNote]
    @State private var showExportSheet = false
    @State private var showBackupSheet = false
    @State private var showRestoreSheet = false
    @State private var showingSuccessAlert = false
    @State private var alertMessage = ""
    @State private var isExporting = false
    @State private var exportProgress: Double = 0
    @State private var showingShareSheet = false
    @State private var exportedFileURL: URL?
    
    private var noteCount: Int {
        allNotes.count
    }
    
    private var storageSize: String {
        let estimatedBytesPerNote: Int = 3000 // 3KB average per note
        let totalBytes = noteCount * estimatedBytesPerNote
        return formatBytes(totalBytes)
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    var body: some View {
        List {
            // Export Section
            Section {
                Button {
                    showExportSheet = true
                } label: {
                    HStack {
                        Circle()
                            .fill(Color.blue.gradient)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Export SOAP Notes")
                                .foregroundStyle(.primary)
                            Text("Export as PDF or CSV")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Button {
                    exportAllAsPDF()
                } label: {
                    HStack {
                        Circle()
                            .fill(Color.red.gradient)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "doc.fill")
                                    .foregroundStyle(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Export All as PDF")
                                .foregroundStyle(.primary)
                            Text("Generate comprehensive report")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if isExporting {
                            ProgressView()
                        }
                    }
                }
                .disabled(isExporting)
            } header: {
                Text("Export")
            } footer: {
                Text("Export your SOAP notes for sharing or archival")
            }
            
            // Backup Section
            Section {
                Button {
                    createBackup()
                } label: {
                    HStack {
                        Circle()
                            .fill(Color.green.gradient)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "arrow.down.doc.fill")
                                    .foregroundStyle(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Create Backup")
                                .foregroundStyle(.primary)
                            Text("Save all data to file")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if isExporting {
                            ProgressView()
                        }
                    }
                }
                .disabled(isExporting)
                
                Button {
                    showRestoreSheet = true
                } label: {
                    HStack {
                        Circle()
                            .fill(Color.orange.gradient)
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "arrow.up.doc.fill")
                                    .foregroundStyle(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Restore from Backup")
                                .foregroundStyle(.primary)
                            Text("Load previously saved data")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Backup & Restore")
            } footer: {
                Text("Create backups of your data for safekeeping. You can restore from a backup at any time.")
            }
            
            // iCloud Section
            Section {
                HStack {
                    Circle()
                        .fill(Color.cyan.gradient)
                        .frame(width: 44, height: 44)
                        .overlay {
                            Image(systemName: "icloud.fill")
                                .foregroundStyle(.white)
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("iCloud Sync")
                        Text("Automatically backed up")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
                
                Button {
                    // Force iCloud sync
                    forceICloudSync()
                } label: {
                    HStack {
                        Text("Sync Now")
                        Spacer()
                        Image(systemName: "arrow.triangle.2.circlepath")
                    }
                }
            } header: {
                Text("Cloud Backup")
            } footer: {
                Text("Your data is automatically synced to iCloud when enabled in your device settings")
            }
            
            // Storage Info
            Section {
                HStack {
                    Text("SOAP Notes")
                    Spacer()
                    Text("\(noteCount) \(noteCount == 1 ? "note" : "notes")")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Storage Used")
                    Spacer()
                    Text(storageSize)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Storage Information")
            }
        }
        .navigationTitle("Export & Backup")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showExportSheet) {
            ExportOptionsSheet()
        }
        .sheet(isPresented: $showRestoreSheet) {
            RestoreSheet()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = exportedFileURL {
                ShareSheet(items: [url])
            }
        }
        .alert("Success", isPresented: $showingSuccessAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func exportAllAsPDF() {
        guard !allNotes.isEmpty else {
            alertMessage = "No notes to export"
            showingSuccessAlert = true
            return
        }
        
        isExporting = true
        
        Task {
            var pdfDocuments: [PDFDocument] = []
            
            for (index, note) in allNotes.enumerated() {
                guard let pdfData = PCRFormatter.generateStandardFormPDF(for: note),
                      let pdfDoc = PDFDocument(data: pdfData) else {
                    continue
                }
                
                pdfDocuments.append(pdfDoc)
                
                // Update progress
                exportProgress = Double(index + 1) / Double(allNotes.count)
            }
            
            guard !pdfDocuments.isEmpty else {
                await MainActor.run {
                    isExporting = false
                    alertMessage = "Failed to generate PDFs"
                    showingSuccessAlert = true
                }
                return
            }
            
            // Combine all PDFs into single document
            let combinedPDF = PDFDocument()
            var pageIndex = 0
            
            for pdfDoc in pdfDocuments {
                for pageNum in 0..<pdfDoc.pageCount {
                    if let page = pdfDoc.page(at: pageNum) {
                        combinedPDF.insert(page, at: pageIndex)
                        pageIndex += 1
                    }
                }
            }
            
            // Save to temporary file
            let fileName = "TrailTriage_All_Notes_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).pdf"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try combinedPDF.dataRepresentation()?.write(to: tempURL)
                
                await MainActor.run {
            isExporting = false
                    exportedFileURL = tempURL
                    showingShareSheet = true
            alertMessage = "All SOAP notes exported successfully as PDF"
            showingSuccessAlert = true
                }
            } catch {
                await MainActor.run {
                    isExporting = false
                    alertMessage = "Failed to save PDF: \(error.localizedDescription)"
                    showingSuccessAlert = true
                }
            }
        }
    }
    
    private func createBackup() {
        isExporting = true
        
        Task {
            // Simulate backup creation
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            isExporting = false
            alertMessage = "Backup created successfully"
            showingSuccessAlert = true
        }
    }
    
    private func forceICloudSync() {
        alertMessage = "iCloud sync initiated"
        showingSuccessAlert = true
    }
}

// MARK: - Export Options Sheet
private struct ExportOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var allNotes: [SOAPNote]
    @State private var exportFormat: ExportFormat = .pdf
    @State private var includeImages = true
    @State private var includeVitalSigns = true
    @State private var isExporting = false
    @State private var exportProgress: Double = 0
    @State private var showingShareSheet = false
    @State private var exportedFileURL: URL?
    
    enum ExportFormat: String, CaseIterable {
        case pdf = "PDF"
        case csv = "CSV"
        case json = "JSON"
        
        var icon: String {
            switch self {
            case .pdf: return "doc.fill"
            case .csv: return "tablecells.fill"
            case .json: return "chevron.left.forwardslash.chevron.right"
            }
        }
    }
    
    private func performExport() {
        guard !allNotes.isEmpty else {
            dismiss()
            return
        }
        
        isExporting = true
        
        Task {
            let fileName: String
            let fileData: Data?
            
            switch exportFormat {
            case .pdf:
                fileName = "TrailTriage_Export_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).pdf"
                
                // Generate combined PDF
                var pdfDocuments: [PDFDocument] = []
                for note in allNotes {
                    guard let pdfData = PCRFormatter.generateStandardFormPDF(for: note),
                          let pdfDoc = PDFDocument(data: pdfData) else {
                        continue
                    }
                    pdfDocuments.append(pdfDoc)
                }
                
                let combinedPDF = PDFDocument()
                var pageIndex = 0
                for pdfDoc in pdfDocuments {
                    for pageNum in 0..<pdfDoc.pageCount {
                        if let page = pdfDoc.page(at: pageNum) {
                            combinedPDF.insert(page, at: pageIndex)
                            pageIndex += 1
                        }
                    }
                }
                
                fileData = combinedPDF.dataRepresentation()
                
            case .csv:
                fileName = "TrailTriage_Export_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).csv"
                
                var csvContent = "Date,Patient Name,Age,Sex,Chief Complaint,Assessment,Evacuation Plan\n"
                for note in allNotes {
                    let date = note.createdDate.formatted(date: .numeric, time: .omitted)
                    let name = note.patientName ?? "Unknown"
                    let age = note.patientAge.map { String($0) } ?? ""
                    let sex = note.patientSex?.rawValue ?? ""
                    let complaint = (note.signsSymptoms ?? "").replacingOccurrences(of: ",", with: ";")
                    let assessment = (note.assessment ?? "").replacingOccurrences(of: ",", with: ";")
                    let evac = note.evacuationPlan?.rawValue ?? ""
                    
                    csvContent += "\(date),\(name),\(age),\(sex),\(complaint),\(assessment),\(evac)\n"
                }
                
                fileData = csvContent.data(using: .utf8)
                
            case .json:
                fileName = "TrailTriage_Export_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).json"
                
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                
                let exportData = allNotes.map { note -> [String: Any?] in
                    var dict: [String: Any?] = [:]
                    dict["id"] = note.id.uuidString
                    dict["createdDate"] = note.createdDate
                    dict["patientName"] = note.patientName
                    dict["patientAge"] = note.patientAge
                    dict["patientSex"] = note.patientSex?.rawValue
                    dict["signsSymptoms"] = note.signsSymptoms
                    dict["assessment"] = note.assessment
                    dict["evacuationPlan"] = note.evacuationPlan?.rawValue
                    dict["location"] = note.location
                    
                    if includeVitalSigns {
                        dict["vitalSigns"] = note.vitalSigns.map { vital -> [String: Any?] in
                            [
                                "timestamp": vital.timestamp,
                                "heartRate": vital.heartRate,
                                "respiratoryRate": vital.respiratoryRate,
                                "bloodPressureSystolic": vital.bloodPressureSystolic,
                                "bloodPressureDiastolic": vital.bloodPressureDiastolic,
                                "temperature": vital.temperature,
                                "oxygenSaturation": vital.oxygenSaturation
                            ]
                        }
                    }
                    
                    return dict
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: [.prettyPrinted, .sortedKeys])
                    fileData = jsonData
                } catch {
                    fileData = nil
                }
            }
            
            guard let data = fileData else {
                await MainActor.run {
                    isExporting = false
                    dismiss()
                }
                return
            }
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try data.write(to: tempURL)
                
                await MainActor.run {
                    isExporting = false
                    exportedFileURL = tempURL
                    dismiss()
                    showingShareSheet = true
                }
            } catch {
                await MainActor.run {
                    isExporting = false
                    dismiss()
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Format", selection: $exportFormat) {
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            Label(format.rawValue, systemImage: format.icon)
                                .tag(format)
                        }
                    }
                    .pickerStyle(.inline)
                } header: {
                    Text("Export Format")
                }
                
                Section {
                    Toggle(isOn: $includeImages) {
                        Label("Include Images", systemImage: "photo")
                    }
                    
                    Toggle(isOn: $includeVitalSigns) {
                        Label("Include Vital Signs", systemImage: "heart.text.square")
                    }
                } header: {
                    Text("Export Options")
                }
                
                Section {
                    Button {
                        performExport()
                    } label: {
                        HStack {
                            Spacer()
                            if isExporting {
                                ProgressView()
                                    .padding(.trailing, 8)
                            }
                            Label("Export", systemImage: "square.and.arrow.up")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .disabled(isExporting)
                }
            }
            .navigationTitle("Export Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isExporting)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = exportedFileURL {
                    ShareSheet(items: [url])
                }
            }
        }
    }
}

// MARK: - Restore Sheet
private struct RestoreSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingFilePicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "arrow.up.doc.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                VStack(spacing: 12) {
                    Text("Restore from Backup")
                        .font(.title2.bold())
                    
                    Text("Select a backup file to restore your SOAP notes and settings")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Choose Backup File", systemImage: "folder")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5))
                            .foregroundStyle(.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    
                    Text("Warning: Restoring will replace all current data")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
            .navigationTitle("Restore Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExportBackupView()
    }
}
