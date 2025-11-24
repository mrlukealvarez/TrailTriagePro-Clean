//
//  ModuleSeedData.swift
//  TrailTriagePro
//
//  Created by Black Elk Mountain Medicine LLC
//  Full Reference Library Seed – November 2025
//  Rebranded from Desert Mountain Medicine → Black Elk Mountain Medicine
//

import Foundation
import SwiftData

struct ModuleSeedData {
    static func seed(context: ModelContext) {
        let modules: [WFRModule] = [
            // MARK: - 1. About Black Elk Mountain Medicine
            WFRModule(
                id: "module-about-bemm",
                title: "About Black Elk Mountain Medicine",
                icon: "mountain.2.fill",
                accentColor: "orange",
                orderIndex: 0,
                sections: [
                    WFRSection(
                        id: "teaching-philosophy",
                        title: "Teaching Philosophy",
                        contentBlocks: [
                            ContentBlock(type: .heroImage, content: "bemm-mountain-illo"),
                            ContentBlock(type: .paragraph, content: "Black Elk Mountain Medicine was started with the premise that wilderness medicine instruction should not be limited to classroom lectures. Luke and the team are driven to develop a creative, experiential-based curriculum; one which effectively addresses the dynamic nature of a wilderness environment and the rapid advancement in emergency care, as well as supports and addresses multiple learning styles."),
                            ContentBlock(type: .paragraph, content: "Our teaching approach heavily favors hands-on, scenario-based practice taught in an outdoor setting while simulating real-world examples. The completion of scenarios plays a powerful role in self-reflection and allows for inquiry-based learning so each student can relate their experience to the real world. We believe students should be physically involved in the learning process so that intensive learning outcomes are experienced as challenging, fun, and applicable to all aspects of life."),
                            ContentBlock(type: .paragraph, content: "We know that our teaching philosophy is successful when students have mastered the material, attained personal growth, and expanded awareness of self, others, and environment.")
                        ]
                    )
                ]
            ),

            // MARK: - 2. Introduction to Wilderness Medicine
            WFRModule(
                id: "module-intro-wilderness-medicine",
                title: "Introduction to Wilderness Medicine",
                icon: "figure.hiking",
                accentColor: "orange",
                orderIndex: 1,
                sections: [
                    WFRSection(id: "overview", title: "What Makes Wilderness Medicine Different", contentBlocks: [
                        ContentBlock(type: .heroImage, content: "bemm-orange-mountains"),
                        ContentBlock(type: .paragraph, content: "Outdoor guides, instructors, enthusiasts, and those whose professions take them to remote backcountry locations require specialized medical training not adequately met by traditional first aid programs.")
                    ]),
                    WFRSection(id: "training-levels", title: "Wilderness Medicine Training Levels", contentBlocks: [
                        ContentBlock(type: .list, content: """
                        • Wilderness First Aid (WFA) – 16 hours
                        • Wilderness Advanced First Aid (WAFA) – 40 hours
                        • Wilderness First Responder (WFR) – 80 hours
                        • Wilderness EMT Upgrade – 54 hours
                        • Expedition Medicine – 45 hours
                        """)
                    ])
                ]
            ),

            // MARK: - 3. Anatomy & Physiology Fundamentals
            WFRModule(
                id: "module-anatomy-physiology",
                title: "Anatomy & Physiology Fundamentals",
                icon: "figure.arms.open",
                accentColor: "cyan",
                orderIndex: 2,
                sections: [
                    WFRSection(id: "cardiopulmonary", title: "Cardiopulmonary System", contentBlocks: [
                        ContentBlock(type: .heroImage, content: "cardiopulmonary-diagram"),
                        ContentBlock(type: .keyFacts, content: "Vena Cava: largest vein – returns unoxygenated blood to right atrium\nAorta: largest artery – carries oxygenated blood from left ventricle")
                    ]),
                    WFRSection(id: "skeletal", title: "Skeletal System", contentBlocks: [
                        ContentBlock(type: .interactiveDiagram, content: "skeletal-system-labeled")
                    ])
                ]
            ),

            // MARK: - 4. Patient Assessment & SOAP Note
            WFRModule(
                id: "module-patient-assessment",
                title: "Patient Assessment & SOAP Note",
                icon: "doc.text.fill",
                accentColor: "red",
                orderIndex: 3,
                sections: [
                    WFRSection(id: "scene-size-up", title: "1. Scene Size-Up & Standard Precautions", contentBlocks: [
                        ContentBlock(type: .keyCard, content: "Safety for YOU and your CREW")
                    ]),
                    WFRSection(id: "primary", title: "2. Primary Assessment – ABCDEG", contentBlocks: [
                        ContentBlock(type: .abcdegFlow, content: "A,B,C,D,E,G")
                    ]),
                    WFRSection(id: "secondary", title: "3. Secondary Assessment", contentBlocks: [
                        ContentBlock(type: .vitalsPanel, content: "HR,RR,BP,LOR,SCTM,CSM,PERRL")
                    ]),
                    WFRSection(id: "reassessment", title: "4. Reassessment & Documentation", contentBlocks: [
                        ContentBlock(type: .soapNoteForm, content: "black-elk-soap-v2")
                    ])
                ]
            ),

            // MARK: - 5. Basic Life Support
            WFRModule(
                id: "module-basic-life-support",
                title: "Basic Life Support",
                icon: "heart.fill",
                accentColor: "green",
                orderIndex: 4,
                sections: [
                    WFRSection(id: "cpr-overview", title: "CPR Fundamentals & Wilderness Guidelines", contentBlocks: [
                        ContentBlock(type: .cabFlowchart, content: "cpr-decision-tree-2025")
                    ]),
                    WFRSection(id: "aed", title: "Automated External Defibrillator (AED)", contentBlocks: [
                        ContentBlock(type: .numberedSteps, content: "7-Step AED Protocol")
                    ]),
                    WFRSection(id: "choking", title: "Airway Obstruction & Choking", contentBlocks: [
                        ContentBlock(type: .algorithm, content: "consciousAdultChild")
                    ])
                ]
            ),

            // MARK: - 6. Traumatic Injuries
            WFRModule(
                id: "module-traumatic-injuries",
                title: "Traumatic Injuries",
                icon: "cross.fill",
                accentColor: "red",
                orderIndex: 5,
                sections: [
                    WFRSection(id: "bleeding-shock", title: "Severe Bleeding & Shock"),
                    WFRSection(id: "spine-injuries", title: "Spine Assessment & Protection"),
                    WFRSection(id: "fractures-dislocations", title: "Fractures & Dislocations"),
                    WFRSection(id: "tbi", title: "Traumatic Brain Injury")
                ]
            ),

            // MARK: - 7. Backcountry Medical Problems
            WFRModule(
                id: "module-backcountry-medical",
                title: "Backcountry Medical Problems",
                icon: "cross.case.fill",
                accentColor: "blue",
                orderIndex: 6,
                sections: [
                    WFRSection(id: "diabetic-emergencies", title: "Diabetic Emergencies"),
                    WFRSection(id: "anaphylaxis", title: "Allergies & Anaphylaxis"),
                    WFRSection(id: "cardiac-emergencies", title: "Cardiac Emergencies"),
                    WFRSection(id: "mental-health", title: "Mental Health Conditions")
                ]
            ),

            // MARK: - 8. Environmental Medicine
            WFRModule(
                id: "module-environmental-medicine",
                title: "Environmental Medicine",
                icon: "cloud.sun.rain.fill",
                accentColor: "orange",
                orderIndex: 7,
                sections: [
                    WFRSection(id: "hypothermia", title: "Hypothermia (Mild → Severe)"),
                    WFRSection(id: "heat-illness", title: "Heat Exhaustion → Heat Stroke"),
                    WFRSection(id: "high-altitude", title: "High Altitude Illnesses (AMS/HACE/HAPE)"),
                    WFRSection(id: "snakebites", title: "Snakebites & Envenomation"),
                    WFRSection(id: "lightning", title: "Lightning Injuries")
                ]
            ),

            // MARK: - 9. Micromedics & Medication Reference
            WFRModule(
                id: "module-micromedics",
                title: "Micromedics & Medication Reference",
                icon: "pills.fill",
                accentColor: "purple",
                orderIndex: 8,
                sections: [
                    WFRSection(id: "dental", title: "Dental Emergencies"),
                    WFRSection(id: "sun-eye", title: "Sun & Eye Problems"),
                    WFRSection(id: "skin", title: "Skin-Related Problems"),
                    WFRSection(id: "motion-sickness", title: "Motion Sickness"),
                    WFRSection(id: "med-chart", title: "Wilderness Medication Chart")
                ]
            )
        ]

        for module in modules {
            context.insert(module)
        }

        try? context.save()
    }
}
