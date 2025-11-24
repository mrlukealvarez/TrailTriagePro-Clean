//
//  SOAPNote.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/7/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Core SOAP note data model for wilderness medicine documentation!
//

import Foundation
import SwiftData

/// Represents a SOAP note for wilderness medicine documentation
@Model
final class SOAPNote {
    var id: UUID
    var createdDate: Date
    var lastModified: Date
    var isCompleted: Bool
    var isArchived: Bool = false // For archiving closed notes
    
    // Patient Information
    var patientName: String?
    var patientAge: Int?
    var patientDateOfBirth: Date?
    var patientSex: PatientSex?
    var patientWeight: Double? // in pounds (lbs)
    var patientEmergencyContact: String? // Emergency contact info
    var initialNotes: String? // Early assessment notes while patient is alert
    
    // Scene Information
    var season: Season?
    var setting: String?
    var location: String? // Description or GPS coordinates
    var incidentTime: Date?
    
    // S - Subjective (SAMPLE)
    var signsSymptoms: String? // Chief complaint and symptoms
    var allergies: String?
    var medications: String?
    var pertinentHistory: String? // Past medical history
    var lastInOut: String? // Last food/water intake, last urination/bowel movement
    var events: String? // Events leading to incident
    
    // O - Objective
    var vitalSigns: [VitalSigns] = [] // Can have multiple readings over time
    var levelOfResponsiveness: LORLevel?
    var lorScore: Int? // LOR x4, x3, x2, etc. based on assessment
    var sctm: String? // Skin Color, Temperature, Moisture
    var csm: String? // Circulation, Sensation, Motion
    var csmScore: Int? // CSM x4, x3, x2, etc. based on assessment
    var csmDetails: String? // Details like "no hand cap refill"
    var perrl: Bool? // Pupils Equal, Round, Reactive to Light
    var physicalExamNotes: String?
    
    // OPQRST - Pain Assessment (if applicable)
    var hasPain: Bool = false
    var onset: String? // When did pain start?
    var provocation: String? // What makes it better/worse?
    var quality: String? // Sharp, dull, burning, etc.
    var region: String? // Where is the pain?
    var severity: Int? // 1-10 scale
    var time: String? // Constant or intermittent?
    
    // Burns/Frostbite Assessment (Rule of 9s)
    var hasBurns: Bool = false
    var burnRegions: [String] = [] // Body regions affected
    var burnPercentage: Double? // Total body surface area
    var burnDegree: BurnDegree?
    
    // A - Assessment
    var assessment: String? // Working diagnosis
    var anticipatedWorstCase: String?
    
    // P - Plan
    var treatmentProvided: String?
    var evacuationPlan: EvacuationUrgency?
    var evacuationNotes: String?
    var monitoringPlan: String?
    
    // Metadata
    var responders: [String] = [] // Names of WFRs on scene
    var responderName: String? // Primary responder name
    var responderAgency: String? // Agency (e.g., CSAR)
    var responderRescueNumber: String? // Rescue number
    var responderCertifications: String? // Certifications (e.g., WFR, EMT)
    var tags: [String] = [] // For categorization (trauma, medical, environmental, etc.)
    var isFavorite: Bool = false
    var photos: [Data] = [] // Photo attachments (stored as Data)
    var voiceNotes: [Data] = [] // Audio recordings
    
    init(
        id: UUID = UUID(),
        createdDate: Date = Date(),
        lastModified: Date = Date(),
        isCompleted: Bool = false
    ) {
        self.id = id
        self.createdDate = createdDate
        self.lastModified = lastModified
        self.isCompleted = isCompleted
    }
    
    // Formatted responder information for export
    var formattedResponderInfo: String {
        var info: [String] = []
        
        if let name = responderName, !name.isEmpty {
            info.append("Name: \(name)")
        }
        
        if let agency = responderAgency, !agency.isEmpty {
            info.append("Agency: \(agency)")
        }
        
        if let number = responderRescueNumber, !number.isEmpty {
            info.append("ID/Number: \(number)")
        }
        
        if let certs = responderCertifications, !certs.isEmpty {
            info.append("Certifications: \(certs)")
        }
        
        // Additional responders (excluding primary)
        let additionalResponders = responders.filter { $0 != responderName && !$0.isEmpty }
        if !additionalResponders.isEmpty {
            info.append("Additional Responders: \(additionalResponders.joined(separator: ", "))")
        }
        
        return info.isEmpty ? "No responder information" : info.joined(separator: "\n")
    }
}

// MARK: - Supporting Types

@Model
final class VitalSigns {
    var id: UUID
    var timestamp: Date
    var heartRate: Int? // BPM
    var respiratoryRate: Int? // Breaths per minute
    var bloodPressureSystolic: Int?
    var bloodPressureDiastolic: Int?
    var temperature: Double? // Celsius
    var oxygenSaturation: Int? // SpO2 percentage
    var notes: String?
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        heartRate: Int? = nil,
        respiratoryRate: Int? = nil,
        bloodPressureSystolic: Int? = nil,
        bloodPressureDiastolic: Int? = nil,
        temperature: Double? = nil,
        oxygenSaturation: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.heartRate = heartRate
        self.respiratoryRate = respiratoryRate
        self.bloodPressureSystolic = bloodPressureSystolic
        self.bloodPressureDiastolic = bloodPressureDiastolic
        self.temperature = temperature
        self.oxygenSaturation = oxygenSaturation
        self.notes = notes
    }
    
    var bloodPressureString: String? {
        guard let systolic = bloodPressureSystolic,
              let diastolic = bloodPressureDiastolic else {
            return nil
        }
        return "\(systolic)/\(diastolic)"
    }
}

enum PatientSex: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case unknown = "Unknown"
}

enum Season: String, Codable, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case fall = "Fall"
    case winter = "Winter"
    
    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .fall: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

enum LORLevel: String, Codable, CaseIterable {
    case alert = "Alert & Oriented (A+Ox4)"
    case verbal = "Responds to Verbal"
    case painful = "Responds to Painful Stimuli"
    case unresponsive = "Unresponsive"
    
    var abbreviation: String {
        switch self {
        case .alert: return "A"
        case .verbal: return "V"
        case .painful: return "P"
        case .unresponsive: return "U"
        }
    }
    
    var color: String {
        switch self {
        case .alert: return "green"
        case .verbal: return "yellow"
        case .painful: return "orange"
        case .unresponsive: return "red"
        }
    }
}

enum EvacuationUrgency: String, Codable, CaseIterable {
    case immediate = "Immediate (Life-threatening)"
    case urgent = "Urgent (within hours)"
    case nonUrgent = "Non-Urgent (can wait 24+ hours)"
    case selfEvac = "Self-Evacuation"
    case noEvac = "No Evacuation Needed"
    
    var color: String {
        switch self {
        case .immediate: return "red"
        case .urgent: return "orange"
        case .nonUrgent: return "yellow"
        case .selfEvac: return "blue"
        case .noEvac: return "green"
        }
    }
    
    var icon: String {
        switch self {
        case .immediate: return "exclamationmark.triangle.fill"
        case .urgent: return "exclamationmark.circle.fill"
        case .nonUrgent: return "clock.fill"
        case .selfEvac: return "figure.walk"
        case .noEvac: return "checkmark.circle.fill"
        }
    }
}

enum BurnDegree: String, Codable, CaseIterable {
    case firstDegree = "Superficial (1st Degree)"
    case secondDegree = "Partial Thickness (2nd Degree)"
    case thirdDegree = "Full Thickness (3rd Degree)"
    case fourthDegree = "Deep (4th Degree)"
    
    // Legacy values for backward compatibility
    private static let legacyMappings: [String: BurnDegree] = [
        "1st Degree": .firstDegree,
        "2nd Degree": .secondDegree,
        "3rd Degree": .thirdDegree,
        "4th Degree": .fourthDegree,
        "1st Degree (Superficial)": .firstDegree,
        "2nd Degree (Partial Thickness)": .secondDegree,
        "3rd Degree (Full Thickness)": .thirdDegree,
        "4th Degree (Deep)": .fourthDegree,
        "Superficial (1st)": .firstDegree,
        "Partial Thickness (2nd)": .secondDegree,
        "Full Thickness (3rd)": .thirdDegree,
        "Deep (4th)": .fourthDegree
    ]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        // Try the current format first
        if let value = BurnDegree(rawValue: rawValue) {
            self = value
            return
        }
        
        // Try legacy mappings
        if let mapped = Self.legacyMappings[rawValue] {
            self = mapped
            return
        }
        
        // Try partial matching for legacy formats
        let lowercased = rawValue.lowercased()
        if lowercased.contains("1st") || lowercased.contains("first") || lowercased.contains("superficial") {
            self = .firstDegree
        } else if lowercased.contains("2nd") || lowercased.contains("second") || lowercased.contains("partial") {
            self = .secondDegree
        } else if lowercased.contains("3rd") || lowercased.contains("third") || lowercased.contains("full thickness") {
            self = .thirdDegree
        } else if lowercased.contains("4th") || lowercased.contains("fourth") || lowercased.contains("deep") {
            self = .fourthDegree
        } else {
            // Default fallback - try to parse as current format or default to first degree
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize BurnDegree from invalid String value \(rawValue)"
            )
        }
    }
    
    var description: String {
        switch self {
        case .firstDegree: return "Red, painful, no blisters"
        case .secondDegree: return "Blisters, very painful"
        case .thirdDegree: return "White/charred, painless"
        case .fourthDegree: return "Extends to bone/muscle"
        }
    }
}

// MARK: - SOAP Note Extensions

extension SOAPNote {
    /// Generates a formatted text export of the SOAP note
    func exportAsText() -> String {
        var text = "===== WFR SOAP NOTE =====\n\n"
        
        // Header
        text += "Created: \(createdDate.formatted(date: .abbreviated, time: .shortened))\n"
        if let name = patientName {
            text += "Patient: \(name)"
            if let age = patientAge {
                text += ", Age \(age)"
            }
            if let sex = patientSex {
                text += ", \(sex.rawValue)"
            }
            if let weight = patientWeight {
                let weightKg = weight * 0.453592
                text += ", Weight: \(String(format: "%.1f", weight)) lbs (\(String(format: "%.1f", weightKg)) kg)"
            }
            text += "\n"
        }
        if let dob = patientDateOfBirth {
            text += "Date of Birth: \(dob.formatted(date: .abbreviated, time: .omitted))\n"
        }
        if let emergencyContact = patientEmergencyContact {
            text += "Emergency Contact: \(emergencyContact)\n"
        }
        if let initialNotes = initialNotes {
            text += "Initial Notes: \(initialNotes)\n"
        }
        text += "\n"
        
        // Scene
        if season != nil || setting != nil || location != nil {
            text += "SCENE INFORMATION:\n"
            if let season = season { text += "Season: \(season.rawValue)\n" }
            if let setting = setting { text += "Setting: \(setting)\n" }
            if let location = location { text += "Location: \(location)\n" }
            if let time = incidentTime { text += "Time: \(time.formatted(date: .omitted, time: .shortened))\n" }
            text += "\n"
        }
        
        // S - Subjective
        text += "SUBJECTIVE (SAMPLE):\n"
        if let ss = signsSymptoms { text += "Signs/Symptoms: \(ss)\n" }
        if let a = allergies { text += "Allergies: \(a)\n" }
        if let m = medications { text += "Medications: \(m)\n" }
        if let p = pertinentHistory { text += "Pertinent History: \(p)\n" }
        if let l = lastInOut { text += "Last In/Out: \(l)\n" }
        if let e = events { text += "Events: \(e)\n" }
        text += "\n"
        
        // O - Objective
        text += "OBJECTIVE:\n"
        if !vitalSigns.isEmpty {
            text += "Vitals:\n"
            for vital in vitalSigns {
                text += "  [\(vital.timestamp.formatted(date: .omitted, time: .shortened))]"
                if let hr = vital.heartRate { text += " HR: \(hr)" }
                if let rr = vital.respiratoryRate { text += " RR: \(rr)" }
                if let bp = vital.bloodPressureString { text += " BP: \(bp)" }
                if let temp = vital.temperature {
                    let tempF = (temp * 9/5) + 32
                    text += " Temp: \(String(format: "%.1f", temp))°C (\(String(format: "%.1f", tempF))°F)"
                }
                if let spo2 = vital.oxygenSaturation { text += " SpO2: \(spo2)%" }
                text += "\n"
            }
        }
        if let lor = levelOfResponsiveness {
            text += "LOR: \(lor.rawValue)"
            if let score = lorScore {
                text += " (x\(score))"
            }
            text += "\n"
        }
        if let sctm = sctm { text += "SCTM: \(sctm)\n" }
        if let csm = csm {
            text += "CSM: \(csm)"
            if let score = csmScore {
                text += " (x\(score))"
            }
            if let details = csmDetails {
                text += " - \(details)"
            }
            text += "\n"
        }
        if let perrl = perrl { text += "PERRL: \(perrl ? "Yes" : "No")\n" }
        if let exam = physicalExamNotes { text += "Physical Exam: \(exam)\n" }
        text += "\n"
        
        // OPQRST
        if hasPain {
            text += "PAIN ASSESSMENT (OPQRST):\n"
            if let o = onset { text += "Onset: \(o)\n" }
            if let p = provocation { text += "Provocation: \(p)\n" }
            if let q = quality { text += "Quality: \(q)\n" }
            if let r = region { text += "Region: \(r)\n" }
            if let s = severity { text += "Severity: \(s)/10\n" }
            if let t = time { text += "Time: \(t)\n" }
            text += "\n"
        }
        
        // Burns/Frostbite
        if hasBurns {
            text += "BURN/FROSTBITE ASSESSMENT:\n"
            if let percentage = burnPercentage {
                text += "Body Surface Area: \(String(format: "%.1f", percentage))%\n"
            }
            if let degree = burnDegree {
                text += "Degree: \(degree.rawValue) - \(degree.description)\n"
            }
            if !burnRegions.isEmpty {
                text += "Regions: \(burnRegions.joined(separator: ", "))\n"
            }
            text += "\n"
        }
        
        // A - Assessment
        text += "ASSESSMENT:\n"
        if let assess = assessment { text += "\(assess)\n" }
        if let worst = anticipatedWorstCase { text += "Worst Case: \(worst)\n" }
        text += "\n"
        
        // P - Plan
        text += "PLAN:\n"
        if let tx = treatmentProvided { text += "Treatment: \(tx)\n" }
        if let evac = evacuationPlan { text += "Evacuation: \(evac.rawValue)\n" }
        if let evacNotes = evacuationNotes { text += "Evac Notes: \(evacNotes)\n" }
        if let monitor = monitoringPlan { text += "Monitoring: \(monitor)\n" }
        text += "\n"
        
        // Footer
        text += "RESPONDER INFORMATION:\n"
        if let name = responderName {
            text += "Name: \(name)\n"
        }
        if let agency = responderAgency, !agency.isEmpty {
            text += "Agency: \(agency)\n"
        }
        if let rescueNum = responderRescueNumber, !rescueNum.isEmpty {
            text += "Rescue #: \(rescueNum)\n"
        }
        if let certs = responderCertifications, !certs.isEmpty {
            text += "Certifications: \(certs)\n"
        }
        if !responders.isEmpty {
            text += "Additional Responders: \(responders.joined(separator: ", "))\n"
        }
        text += "\nEnd of Report\n"
        text += "========================\n"
        
        return text
    }
}
