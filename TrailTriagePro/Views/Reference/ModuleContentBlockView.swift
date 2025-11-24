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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch block.type {
            case .heading:
                Text(block.content)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .padding(.top, 8)
                
            case .subheading:
                Text(block.content)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                
            case .paragraph:
                Text(block.content)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
            case .bulletList:
                ForEach(block.content.components(separatedBy: "\n"), id: \.self) { item in
                    HStack(alignment: .top) {
                        Text("•")
                        Text(item.replacingOccurrences(of: "- ", with: ""))
                    }
                    .font(.body)
                }
                
            case .numberedList:
                ForEach(Array(block.content.components(separatedBy: "\n").enumerated()), id: \.offset) { index, item in
                    HStack(alignment: .top) {
                        Text("\(index + 1).")
                            .monospacedDigit()
                        Text(item)
                    }
                    .font(.body)
                }
                
            case .warning:
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                    
                    Text(block.content)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color.red.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .tip:
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                    
                    Text(block.content)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
                
            case .procedure:
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "list.number")
                        Text("PROCEDURE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                    }
                    .foregroundStyle(.secondary)
                    
                    ForEach(block.content.components(separatedBy: "\n"), id: \.self) { step in
                        HStack(alignment: .top) {
                            Text(step)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .table:
                // Simple key-value table rendering
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(block.content.components(separatedBy: "\n"), id: \.self) { row in
                        let parts = row.components(separatedBy: ":")
                        if parts.count >= 2 {
                            HStack(alignment: .top) {
                                Text(parts[0])
                                    .fontWeight(.bold)
                                    .frame(width: 40, alignment: .leading)
                                Text(parts[1])
                            }
                            Divider()
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .definition:
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(block.content.components(separatedBy: "\n"), id: \.self) { item in
                        Text(item)
                            .font(.callout)
                            .monospaced()
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
            case .scenario:
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("SCENARIO")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.orange)
                    
                    Text(block.content)
                        .font(.body)
                        .italic()
                    
                    if let location = block.location {
                        HStack {
                            Image(systemName: "location.fill")
                            Text(location)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
            default:
                Text(block.content)
            }
        }
        .padding(.vertical, 4)
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
