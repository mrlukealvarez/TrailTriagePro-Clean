//
//  GlossaryView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/16/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Medical terminology glossary!
//

import SwiftUI

struct GlossaryView: View {
    static let glossaryTerms: [(category: String, term: String, definition: String)] = [
        // Patient Assessment & Acronyms
        ("Assessment", "A+O x4", "Alert and Oriented times 4. Patient can correctly identify: Person (their name), Place (location), Time (day/month), Event (what happened)"),
        ("Assessment", "AVPU", "Alert, Verbal, Pain, Unresponsive - A simple scale to quickly assess a patient's level of responsiveness"),
        ("Assessment", "ABCDE", "Airway, Breathing, Circulation, Disability, Environment/Expose - Critical steps of Initial Assessment to identify and treat life threats"),
        ("Assessment", "BSI", "Body Substance Isolation - Steps taken to prevent spread of infectious diseases, including gloves, eye protection, and PPE"),
        ("Assessment", "MOI", "Mechanism of Injury - The force or event that caused injury (e.g., fall, car accident) to help predict potential injuries"),
        ("Assessment", "SAMPLE", "Signs/Symptoms, Allergies, Medications, Pertinent history, Last intake/output, Events - Mnemonic for gathering medical history"),
        ("Assessment", "SOAP Note", "Subjective, Objective, Assessment, Plan - Standardized format for documenting patient care"),
        
        // Vital Signs
        ("Vitals", "HR", "Heart Rate - Number of times a person's heart beats per minute"),
        ("Vitals", "RR", "Respiratory Rate - Number of breaths a person takes per minute"),
        ("Vitals", "BP", "Blood Pressure - Pressure of circulating blood on vessel walls"),
        ("Vitals", "LOR", "Level of Responsiveness - Measure of how alert and reactive patient is (use AVPU scale)"),
        ("Vitals", "CSM", "Circulation, Sensation, Movement - Check used to assess injured limb, especially after splinting"),
        ("Vitals", "PERRL", "Pupils Equal, Round, Reactive to Light - Pupil assessment providing neurological status clues"),
        ("Vitals", "SCTM", "Skin Color, Temperature, Moisture - Key skin assessment for cardiovascular and respiratory status"),
        
        // Pain Assessment
        ("Pain", "OPQRST", "Onset, Provocation, Quality, Region/Radiate, Severity, Time/Treatments - Mnemonic for evaluating patient pain"),
        ("Pain", "Onset", "When did the pain start?"),
        ("Pain", "Provocation", "What makes the pain better or worse?"),
        ("Pain", "Quality", "What does the pain feel like? (sharp, dull, aching, burning, etc.)"),
        ("Pain", "Radiate", "Does the pain move or stay in one place?"),
        ("Pain", "Severity", "How bad is the pain on a scale of 1-10?"),
        ("Pain", "Time/Treatments", "How long has pain lasted? What treatments have been attempted?"),
        
        // Medical Terms
        ("Terms", "Hyper", "Prefix meaning 'above,' 'excessive,' or 'high' (e.g., hyperthermia = excessively high body temperature)"),
        ("Terms", "Hypo", "Prefix meaning 'below,' 'deficient,' or 'low' (e.g., hypoglycemia = low blood sugar)"),
        ("Terms", "URQ", "Upper Right Quadrant - Abdomen location for identifying pain or injury"),
        ("Terms", "ULQ", "Upper Left Quadrant - Abdomen location for identifying pain or injury"),
        ("Terms", "LRQ", "Lower Right Quadrant - Abdomen location for identifying pain or injury"),
        ("Terms", "LLQ", "Lower Left Quadrant - Abdomen location for identifying pain or injury"),
        
        // Advanced Assessment
        ("Assessment", "1ST STEP", "Mnemonic when confused about LOR: Sugar, Temperature, Salt, Toxins, Electricity/Elevation, Pressure - Possible causes of altered mental status"),
        
        // Certifications
        ("Certification", "WFR", "Wilderness First Responder - Advanced wilderness medical certification"),
        ("Certification", "EMT", "Emergency Medical Technician - Pre-hospital emergency medical provider"),
        ("Certification", "WFA", "Wilderness First Aid - Basic wilderness medical certification"),
        ("Certification", "WEMT", "Wilderness Emergency Medical Technician - Advanced wilderness + EMT certification"),
        
        // Equipment
        ("Equipment", "AED", "Automated External Defibrillator - Device for cardiac arrest treatment"),
        ("Equipment", "CPR", "Cardiopulmonary Resuscitation - Emergency lifesaving procedure for cardiac arrest"),
        ("Equipment", "PPE", "Personal Protective Equipment - Gear to protect from infectious diseases (gloves, masks, etc.)"),
    ]
    
    @State private var selectedCategory: String? = nil
    
    // Optimization #2: Cache expensive computation - categories don't change
    private static let cachedCategories: [String] = {
        let allCategories = Set(glossaryTerms.map { $0.category })
        return Array(allCategories).sorted()
    }()
    
    // Optimization #6: Use cached result instead of recomputing every time
    var categories: [String] {
        Self.cachedCategories
    }
    
    // Optimization #7: Pre-compute and cache terms by category
    private static let cachedTermsByCategory: [String: [(category: String, term: String, definition: String)]] = {
        Dictionary(grouping: glossaryTerms, by: { $0.category })
            .mapValues { terms in
                terms.sorted { $0.term < $1.term }
            }
    }()
    
    // Optimization #8: Pre-compute category counts
    private static let cachedCategoryCounts: [String: Int] = {
        Dictionary(grouping: glossaryTerms, by: { $0.category })
            .mapValues { $0.count }
    }()
    
    // Show terms for selected category - now O(1) lookup instead of O(n) filter + sort
    var categoryTerms: [(category: String, term: String, definition: String)] {
        guard let category = selectedCategory else { return [] }
        return Self.cachedTermsByCategory[category] ?? []
    }
    
    var body: some View {
        List {
            if selectedCategory == nil {
                // Show category list
                Section {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            HStack {
                                Text(category)
                                    .foregroundStyle(.primary)
                                Spacer()
                                let count = Self.cachedCategoryCounts[category] ?? 0
                                Text("\(count)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Categories")
                } footer: {
                    Text("Use the Search tab to quickly find specific terms across all categories")
                        .font(.caption)
                }
            } else {
                // Show terms in selected category
                Section {
                    Button {
                        selectedCategory = nil
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.caption)
                            Text("Back to Categories")
                        }
                        .foregroundStyle(.blue)
                    }
                }
                
                Section {
                    ForEach(categoryTerms, id: \.term) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.term)
                                .font(.headline)
                            Text(item.definition)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
                
                if categoryTerms.isEmpty {
                    Section {
                        Text("No terms in this category")
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                }
            }
        }
        .navigationTitle(selectedCategory ?? "Glossary")
    }
}

#Preview {
    NavigationStack {
        GlossaryView()
    }
}

// MARK: - Patient Assessment Reference Module
// Full interactive views for modern reference library

struct SceneSizeUpView: View {
    @State private var expandedStep: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    Text("Scene Size-Up")
                        .font(.largeTitle.bold())
                    Text("The first step in patient assessment")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(16)
                .padding()
                
                VStack(spacing: 16) {
                    SceneSizeUpCard(title: "Scene Safety", icon: "shield.checkered", color: .red, isExpanded: expandedStep == "safety", details: ["Look for environmental hazards", "Assess weather conditions", "Check for unstable terrain", "Identify potential threats"]) {
                        withAnimation { expandedStep = expandedStep == "safety" ? nil : "safety" }
                    }
                    
                    SceneSizeUpCard(title: "Mechanism of Injury", icon: "figure.fall", color: .orange, isExpanded: expandedStep == "moi", details: ["Interview the patient", "Talk to bystanders", "Look for clues at scene", "Anticipate injuries"]) {
                        withAnimation { expandedStep = expandedStep == "moi" ? nil : "moi" }
                    }
                    
                    SceneSizeUpCard(title: "Number of Patients", icon: "person.3.fill", color: .blue, isExpanded: expandedStep == "patients", details: ["Count all patients", "Identify most critical", "Call for backup if needed"]) {
                        withAnimation { expandedStep = expandedStep == "patients" ? nil : "patients" }
                    }
                    
                    SceneSizeUpCard(title: "Additional Resources", icon: "antenna.radiowaves.left.and.right", color: .green, isExpanded: expandedStep == "resources", details: ["Assess severity", "Consider evacuation needs", "Call for backup early"]) {
                        withAnimation { expandedStep = expandedStep == "resources" ? nil : "resources" }
                    }
                    
                    SceneSizeUpCard(title: "Standard Precautions", icon: "hand.raised.fill", color: .purple, isExpanded: expandedStep == "precautions", details: ["Wear gloves before contact", "Use eye protection if needed", "Avoid body fluids", "Wash hands after care"]) {
                        withAnimation { expandedStep = expandedStep == "precautions" ? nil : "precautions" }
                    }
                }
                .padding(.horizontal)
                
                CalloutCard(icon: "exclamationmark.triangle.fill", title: "Remember", message: "Never enter an unsafe scene. Your safety comes first!", color: .orange)
                    .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct SceneSizeUpCard: View {
    let title: String
    let icon: String
    let color: Color
    let isExpanded: Bool
    let details: [String]
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                        .frame(width: 44, height: 44)
                        .background(color.opacity(0.1))
                        .cornerRadius(10)
                    
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
                
                if isExpanded {
                    Divider()
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(details, id: \.self) { detail in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(color)
                                Text(detail)
                                    .font(.body)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

struct PrimaryAssessmentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.red)
                    Text("Primary Assessment")
                        .font(.largeTitle.bold())
                    Text("Address life-threatening conditions immediately")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.05))
                .cornerRadius(16)
                .padding()
                
                Text("✨ ABCDE framework with interactive cards coming soon!")
                    .font(.headline)
                    .foregroundStyle(.red)
                    .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct SecondaryAssessmentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    Text("Secondary Assessment")
                        .font(.largeTitle.bold())
                    Text("Detailed evaluation after primary assessment")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.05))
                .cornerRadius(16)
                .padding()
                
                Text("✨ SAMPLE, OPQRST, and Head-to-Toe exam coming soon!")
                    .font(.headline)
                    .foregroundStyle(.green)
                    .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct SOAPNotesReferenceView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.blue)
                    Text("SOAP Notes")
                        .font(.largeTitle.bold())
                    Text("Black Elk Mountain Medicine Standard")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.05))
                .cornerRadius(16)
                .padding()
                
                Text("✨ Modern card-based SOAP format coming soon!")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct ReassessmentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 60))
                        .foregroundStyle(.purple)
                    Text("Reassessment")
                        .font(.largeTitle.bold())
                    Text("Continuous monitoring and calling for rescue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.05))
                .cornerRadius(16)
                .padding()
                
                Text("✨ Monitoring schedules and rescue protocols coming soon!")
                    .font(.headline)
                    .foregroundStyle(.purple)
                    .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Helper Views

struct CalloutCard: View {
    let icon: String
    let title: String
    let message: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

