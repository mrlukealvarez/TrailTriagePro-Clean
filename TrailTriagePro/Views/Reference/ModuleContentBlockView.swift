//
//  ModuleContentBlockView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//

import SwiftUI

/// Renders a single content block based on its type
struct ModuleContentBlockView: View {
    let block: WFRModuleContentBlock
    private static let chipColumns: [GridItem] = [
        GridItem(.adaptive(minimum: 70), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch block.type {
            case .heading:
                Theme.headline(block.content)
                    .padding(.top, 8)
                
            case .subheading:
                Theme.subheadline(block.content)
                    .padding(.top, 4)
                
            case .paragraph:
                Theme.body(block.content)
                    .fixedSize(horizontal: false, vertical: true)
                
            case .bulletList:
                ForEach(lineItems(from: block.content), id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(Theme.primary.opacity(0.4))
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        Theme.body(item.replacingOccurrences(of: "- ", with: ""))
                    }
                }
                
            case .numberedList:
                ForEach(Array(lineItems(from: block.content).enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1).")
                            .monospacedDigit()
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(Theme.textSecondary)
                        Theme.body(item)
                    }
                }
                
            case .warning:
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                    
                    Theme.body(block.content)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Theme.alert)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
            case .tip:
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.title3)
                        .foregroundStyle(Theme.accent)
                    
                    Theme.body(block.content)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Theme.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
                )
                
            case .procedure:
                VStack(alignment: .leading, spacing: 12) {
                    Label("Procedure", systemImage: "list.number")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.textSecondary)
                    
                    ForEach(block.content.components(separatedBy: "\n"), id: \.self) { step in
                        Theme.body(step)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(Theme.surfaceMuted)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
            case .table:
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(block.content.components(separatedBy: "\n"), id: \.self) { row in
                        let parts = row.components(separatedBy: ":")
                        if parts.count >= 2 {
                            VStack(alignment: .leading, spacing: 4) {
                                Theme.caption(parts[0], weight: .semibold)
                                Theme.body(parts[1])
                            }
                            .padding(.vertical, 4)
                            Divider().foregroundStyle(Theme.divider)
                        }
                    }
                }
                .padding()
                .background(Theme.surfaceMuted)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
            case .definition:
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(block.content.components(separatedBy: "\n"), id: \.self) { item in
                        Theme.body(item)
                            .monospaced()
                    }
                }
                .padding()
                .background(Theme.primary.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
            case .scenario:
                VStack(alignment: .leading, spacing: 8) {
                    Label("Scenario", systemImage: "map.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Theme.accent)
                    
                    Theme.body(block.content)
                        .italic()
                    
                    if let location = block.location {
                        Label(location, systemImage: "location.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Theme.accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                
            case .heroImage, .interactiveDiagram, .soapNoteForm, .cabFlowchart, .algorithm:
                mediaBlock(assetName: block.content)
                
            case .keyFacts:
                keyFactsBlock(block.content)
                
            case .keyCard:
                keyCardBlock(block.content)
                
            case .abcdegFlow:
                chipBlock(
                    title: "Primary Assessment – ABCDEG",
                    icon: "stethoscope",
                    items: commaSeparatedItems(from: block.content),
                    tint: .red
                )
                
            case .vitalsPanel:
                chipBlock(
                    title: "Vitals Panel",
                    icon: "waveform.path.ecg",
                    items: commaSeparatedItems(from: block.content),
                    tint: .blue
                )
                
            case .numberedSteps:
                numberedStepsBlock(block.content)
                
            case .incidentCard:
                incidentCardBlock(block)
                
            default:
                Theme.body(block.content)
            }
        }
        .padding(.vertical, 4)
    }
}

private extension ModuleContentBlockView {
    func lineItems(from content: String) -> [String] {
        content
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    func commaSeparatedItems(from content: String) -> [String] {
        content
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    @ViewBuilder
    func mediaBlock(assetName: String) -> some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primary.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
    
    @ViewBuilder
    func keyFactsBlock(_ content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Key Facts", systemImage: "lightbulb.max.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.accent)
            
            ForEach(lineItems(from: content), id: \.self) { fact in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)
                    Theme.body(fact)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Theme.accent.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    @ViewBuilder
    func keyCardBlock(_ content: String) -> some View {
        Theme.headline(content)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.accent.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    @ViewBuilder
    func chipBlock(title: String, icon: String, items: [String], tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(tint)
            
            LazyVGrid(columns: Self.chipColumns, alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.caption.weight(.semibold))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(tint.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    @ViewBuilder
    func numberedStepsBlock(_ content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Step-by-step protocol", systemImage: "list.number")
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.textSecondary)
            
            ForEach(Array(lineItems(from: content).enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(index + 1).")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)
                    Theme.body(item)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Theme.surfaceMuted)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @ViewBuilder
    func incidentCardBlock(_ block: WFRModuleContentBlock) -> some View {
        if let metadata = decodeIncidentMetadata(from: block) {
            IncidentCardView(header: block.content, metadata: metadata)
        } else {
            Theme.body(block.content)
        }
    }
    
    func decodeIncidentMetadata(from block: WFRModuleContentBlock) -> IncidentCardMetadata? {
        guard let meta = block.metadata,
              let data = meta.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(IncidentCardMetadata.self, from: data)
    }
}

// MARK: - Incident Card Support

struct IncidentCardMetadata: Codable {
    struct History: Codable {
        var acronym: String
        var fields: [String]
    }
    
    struct Vitals: Codable {
        struct Row: Codable, Identifiable {
            var id: String { label }
            var label: String
            var normal: String
            var trend: String?
        }
        var grid: [Row]
    }
    
    struct EvacPlan: Codable {
        var priorities: [String]
    }
    
    var title: String?
    var history: History
    var vitals: Vitals
    var evac: EvacPlan
    var notes: String?
}

struct IncidentCardView: View {
    let header: String
    let metadata: IncidentCardMetadata
    
    private let vitalsColumns = [GridItem(.flexible()), GridItem(.flexible())]
    private let historyColumns = [GridItem(.adaptive(minimum: 140), spacing: 8)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                if let title = metadata.title {
                    Theme.caption(title, weight: .semibold)
                        .foregroundStyle(.white.opacity(0.85))
                }
                
                Text(header)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                
                Text("You're the trail lifeline—act calm, evac smart.")
                    .font(.system(.subheadline))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding()
            .background(Theme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            VStack(alignment: .leading, spacing: 10) {
                Label("\(metadata.history.acronym) History", systemImage: "list.bullet.rectangle")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textSecondary)
                
                LazyVGrid(columns: historyColumns, alignment: .leading, spacing: 8) {
                    ForEach(metadata.history.fields, id: \.self) { item in
                        Text(item)
                            .font(.caption.weight(.semibold))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(Theme.primary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Label("Vitals & Trends", systemImage: "waveform.path.ecg")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textSecondary)
                
                LazyVGrid(columns: vitalsColumns, spacing: 12) {
                    ForEach(metadata.vitals.grid) { row in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(row.label)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Theme.textSecondary)
                            Theme.body(row.normal)
                            if let trend = row.trend {
                                Text(trend)
                                    .font(.caption)
                                    .foregroundStyle(Theme.alert)
                            }
                        }
                        .padding()
                        .background(Theme.surfaceMuted)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Evac Priorities", systemImage: "figure.walk.motion")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Theme.textSecondary)
                
                ForEach(metadata.evac.priorities, id: \.self) { priority in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "triangle.fill")
                            .font(.caption)
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 4)
                        Theme.body(priority)
                    }
                }
            }
            
            if let note = metadata.notes {
                Text(note)
                    .brandFont(.subheadline)
                    .italic()
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding()
        .trailCard()
    }
}


#Preview {
    VStack {
        ModuleContentBlockView(block: WFRModuleContentBlock(type: .heading, content: "Primary Assessment", orderIndex: 0))
        ModuleContentBlockView(block: WFRModuleContentBlock(type: .warning, content: "If not breathing, start CPR immediately.", orderIndex: 1))
        ModuleContentBlockView(block: WFRModuleContentBlock(type: .tip, content: "Check for medical alert tags.", orderIndex: 2))
    }
    .padding()
}
