//
//  ShareMultipleNotesView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Batch export functionality!
//


import SwiftUI
import PDFKit
import SwiftData

/// View for batch exporting multiple SOAP notes
struct ShareMultipleNotesView: View {
    @Environment(\.dismiss) private var dismiss
    
    let noteIDs: [UUID]
    let allNotes: [SOAPNote]
    
    @State private var isProcessing = false
    @State private var exportFormat: ExportFormat = .separatePDFs
    @State private var showingShareSheet = false
    @State private var exportedURLs: [URL] = []
    
    enum ExportFormat: String, CaseIterable, Identifiable {
        case separatePDFs = "Separate PDFs"
        case combinedPDF = "Combined PDF"
        case textFile = "Combined Text File"
        
        var id: String { rawValue }
        
        var icon: String {
            switch self {
            case .separatePDFs: return "doc.on.doc"
            case .combinedPDF: return "doc.fill"
            case .textFile: return "doc.text"
            }
        }
        
        var description: String {
            switch self {
            case .separatePDFs:
                return "Generate individual PDF files for each note"
            case .combinedPDF:
                return "Combine all notes into a single PDF document"
            case .textFile:
                return "Export all notes as a single text file"
            }
        }
    }
    
    private var selectedNotes: [SOAPNote] {
        allNotes.filter { noteIDs.contains($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    
                    Text("Export \(selectedNotes.count) Notes")
                        .font(.title2.bold())
                    
                    Text("Choose export format and share")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.05))
                
                // Format selector
                VStack(alignment: .leading, spacing: 16) {
                    Text("Export Format")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(ExportFormat.allCases) { format in
                        FormatOptionCard(
                            format: format,
                            isSelected: exportFormat == format
                        ) {
                            exportFormat = format
                        }
                    }
                }
                .padding(.vertical)
                
                Spacer()
                
                // Notes preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Selected Notes")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(selectedNotes, id: \.id) { note in
                                NotePreviewRow(note: note)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 200)
                }
                
                Spacer()
                
                // Export button
                Button {
                    exportNotes()
                } label: {
                    if isProcessing {
                        HStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                            Text("Processing...")
                        }
                    } else {
                        Label("Export & Share", systemImage: "square.and.arrow.up")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isProcessing ? Color.gray : Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
                .padding()
                .disabled(isProcessing)
            }
            .navigationTitle("Batch Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if !exportedURLs.isEmpty {
                ShareSheet(items: exportedURLs)
            }
        }
    }
    
    // MARK: - Export Functions
    
    private func exportNotes() {
        isProcessing = true
        exportedURLs = []
        
        Task {
            defer {
                Task { @MainActor in
                    isProcessing = false
                }
            }
            
            switch exportFormat {
            case .separatePDFs:
                await exportSeparatePDFs()
            case .combinedPDF:
                await exportCombinedPDF()
            case .textFile:
                await exportTextFile()
            }
            
            await MainActor.run {
                if !exportedURLs.isEmpty {
                    showingShareSheet = true
                }
            }
        }
    }
    
    private func exportSeparatePDFs() async {
        for note in selectedNotes {
            guard let pdfData = PCRFormatter.generatePDF(for: note) else {
                continue
            }
            
            let fileName = "PCR_\(note.patientName ?? "Unknown")_\(note.createdDate.formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).pdf"
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try pdfData.write(to: tempURL)
                await MainActor.run {
                    exportedURLs.append(tempURL)
                }
            } catch {
                print("Error saving PDF: \(error)")
            }
        }
    }
    
    private func exportCombinedPDF() async {
        let pdfDocument = PDFDocument()
        
        for (index, note) in selectedNotes.enumerated() {
            guard let pdfData = PCRFormatter.generatePDF(for: note),
                  let notePDF = PDFDocument(data: pdfData) else {
                continue
            }
            
            // Add all pages from this note's PDF to combined document
            for pageIndex in 0..<notePDF.pageCount {
                if let page = notePDF.page(at: pageIndex) {
                    pdfDocument.insert(page, at: pdfDocument.pageCount)
                }
            }
            
            // Add separator page if not last note
            if index < selectedNotes.count - 1 {
                // You could add a separator page here if desired
            }
        }
        
        let fileName = "Combined_PCR_Reports_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        if pdfDocument.write(to: tempURL) {
            await MainActor.run {
                exportedURLs.append(tempURL)
            }
        }
    }
    
    private func exportTextFile() async {
        var combinedText = "WFR TRAILTRIAGE - PATIENT CARE REPORTS\n"
        combinedText += "Generated: \(Date().formatted(date: .long, time: .shortened))\n"
        combinedText += "Number of Reports: \(selectedNotes.count)\n"
        combinedText += String(repeating: "=", count: 80) + "\n\n"
        
        for (index, note) in selectedNotes.enumerated() {
            combinedText += "REPORT \(index + 1) OF \(selectedNotes.count)\n"
            combinedText += note.exportAsText()
            combinedText += "\n" + String(repeating: "=", count: 80) + "\n\n"
        }
        
        let fileName = "Combined_Reports_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).txt"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try combinedText.write(to: tempURL, atomically: true, encoding: .utf8)
            await MainActor.run {
                exportedURLs.append(tempURL)
            }
        } catch {
            print("Error saving text file: \(error)")
        }
    }
}

// MARK: - Supporting Views

struct FormatOptionCard: View {
    let format: ShareMultipleNotesView.ExportFormat
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: format.icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? .blue : .secondary)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(format.rawValue)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(format.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.secondary.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .padding(.horizontal)
    }
}

struct NotePreviewRow: View {
    let note: SOAPNote
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.patientName ?? "Unnamed Patient")
                    .font(.subheadline.bold())
                
                Text(note.createdDate.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if let evac = note.evacuationPlan {
                Text(evac.abbreviation)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(evac.color).opacity(0.2))
                    .foregroundStyle(Color(evac.color))
                    .cornerRadius(6)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    @Previewable @State var notes: [SOAPNote] = {
        let note1 = SOAPNote()
        note1.patientName = "John Doe"
        note1.evacuationPlan = .urgent
        
        let note2 = SOAPNote()
        note2.patientName = "Jane Smith"
        note2.evacuationPlan = .nonUrgent
        
        return [note1, note2]
    }()
    
    ShareMultipleNotesView(
        noteIDs: notes.map { $0.id },
        allNotes: notes
    )
    .modelContainer(for: SOAPNote.self, inMemory: true)
}
