//
//  NotesListView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/7/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Archive/list of all notes!
//

import SwiftUI
import SwiftData
import PDFKit
import UIKit

struct NotesListView: View {
    @Query private var allNotes: [SOAPNote]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedNotes = Set<SOAPNote.ID>()
    @State private var isSelecting = false
    @State private var showingShareSheet = false
    @State private var searchText = ""
    @State private var showArchived = false
    @State private var sortOrder: SortOrder = .dateDescending
    
    enum SortOrder: String, CaseIterable {
        case dateDescending = "Newest First"
        case dateAscending = "Oldest First"
        case patientName = "Patient Name"
        case evacPriority = "Evacuation Priority"
    }
    
    // Filtered and sorted notes
    private var filteredNotes: [SOAPNote] {
        var notes = allNotes.filter { $0.isArchived == showArchived }
        
        // Apply search filter
        if !searchText.isEmpty {
            notes = notes.filter { note in
                (note.patientName?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (note.assessment?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (note.location?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        // Apply sorting
        switch sortOrder {
        case .dateDescending:
            return notes.sorted { $0.createdDate > $1.createdDate }
        case .dateAscending:
            return notes.sorted { $0.createdDate < $1.createdDate }
        case .patientName:
            return notes.sorted { ($0.patientName ?? "") < ($1.patientName ?? "") }
        case .evacPriority:
            return notes.sorted { evacPriorityValue($0) > evacPriorityValue($1) }
        }
    }
    
    // Helper to get numeric evacuation priority for sorting
    private func evacPriorityValue(_ note: SOAPNote) -> Int {
        guard let evac = note.evacuationPlan else { return 0 }
        switch evac {
        case .immediate: return 5
        case .urgent: return 4
        case .nonUrgent: return 3
        case .selfEvac: return 2
        case .noEvac: return 1
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredNotes.isEmpty {
                    if searchText.isEmpty {
                        ContentUnavailableView(
                            showArchived ? "No Archived Notes" : "No Active Notes",
                            systemImage: "note.text",
                            description: Text(showArchived ? "Archived notes will appear here." : "Create your first SOAP note using the New Note tab.")
                        )
                    } else {
                        ContentUnavailableView.search(text: searchText)
                    }
                } else {
                    List(selection: $selectedNotes) {
                        ForEach(filteredNotes) { note in
                            NavigationLink {
                                NoteDetailView(note: note)
                            } label: {
                                NoteRowView(note: note)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteNote(note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    toggleArchive(note)
                                } label: {
                                    Label(note.isArchived ? "Unarchive" : "Archive", 
                                          systemImage: note.isArchived ? "tray.and.arrow.up" : "archivebox")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    .environment(\.editMode, .constant(isSelecting ? .active : .inactive))
                }
            }
            .navigationTitle(showArchived ? "Archived Notes" : "Active Notes")
            .searchable(text: $searchText, prompt: "Search by name, diagnosis, location")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("View", selection: $showArchived) {
                            Label("Active Notes", systemImage: "folder").tag(false)
                            Label("Archived Notes", systemImage: "archivebox").tag(true)
                        }
                        
                        Divider()
                        
                        Picker("Sort By", selection: $sortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                    } label: {
                        Label("Filter & Sort", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    if !filteredNotes.isEmpty {
                        Button(isSelecting ? "Done" : "Select") {
                            isSelecting.toggle()
                            if !isSelecting {
                                selectedNotes.removeAll()
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    if isSelecting && !selectedNotes.isEmpty {
                        HStack {
                            Button(role: .destructive) {
                                deleteSelectedNotes()
                            } label: {
                                Label("Delete \(selectedNotes.count)", systemImage: "trash")
                            }
                            
                            Spacer()
                            
                            Button {
                                archiveSelectedNotes()
                            } label: {
                                Label("Archive \(selectedNotes.count)", systemImage: "archivebox")
                            }
                            
                            Spacer()
                            
                            Button {
                                showingShareSheet = true
                            } label: {
                                Label("Share \(selectedNotes.count)", systemImage: "square.and.arrow.up")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareMultipleNotesView(noteIDs: Array(selectedNotes), allNotes: filteredNotes)
            }
        }
    }
    
    private func deleteNote(_ note: SOAPNote) {
        modelContext.delete(note)
    }
    
    private func toggleArchive(_ note: SOAPNote) {
        note.isArchived.toggle()
    }
    
    private func deleteSelectedNotes() {
        for noteID in selectedNotes {
            if let note = filteredNotes.first(where: { $0.id == noteID }) {
                modelContext.delete(note)
            }
        }
        selectedNotes.removeAll()
        isSelecting = false
    }
    
    private func archiveSelectedNotes() {
        for noteID in selectedNotes {
            if let note = filteredNotes.first(where: { $0.id == noteID }) {
                note.isArchived = !showArchived // Toggle based on current view
            }
        }
        selectedNotes.removeAll()
        isSelecting = false
    }
}

// MARK: - Note Row View
struct NoteRowView: View {
    let note: SOAPNote
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator with icon
            ZStack {
                Circle()
                    .fill(evacuationColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: evacuationIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(evacuationColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(note.patientName ?? "Unnamed Patient")
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(note.createdDate, style: .date)
                        .font(.subheadline)
                }
                .foregroundStyle(.secondary)
                
                if let chiefComplaint = note.signsSymptoms, !chiefComplaint.isEmpty {
                    Text(chiefComplaint)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            // Stats badge
            VStack(spacing: 4) {
                Image(systemName: "heart.text.square.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                
                Text("\(note.vitalSigns.count)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var evacuationColor: Color {
        guard let evac = note.evacuationPlan else { return .gray }
        return Color(evac.color)
    }
    
    private var evacuationIcon: String {
        guard let evac = note.evacuationPlan else { return "doc.text" }
        return evac.icon
    }
}

// MARK: - Helper Views
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value.isEmpty ? "—" : value)
                .font(.body)
        }
    }
}

#Preview {
    @Previewable @Query var allNotes: [SOAPNote]
    
    NotesListView()
        .modelContainer(for: [SOAPNote.self, VitalSigns.self], inMemory: true)
}
