//
//  ModuleSeedData.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/22/25.
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Complete seed data for WFR modules extracted from reference book!
//

import Foundation
import SwiftData

/// Utility for seeding initial module content
/// This contains all modules extracted from the reference book with rebranding applied
struct ModuleSeedData {
    
    /// Seed all modules into SwiftData context
    /// This function creates WFRModule instances from extracted and organized content
    static func seedModules(context: ModelContext) {
        let modules = createAllModules()
        
        for module in modules {
            context.insert(module)
        }
        
        do {
            try context.save()
            print("✅ Successfully seeded \(modules.count) modules into SwiftData")
        } catch {
            print("❌ Error saving modules: \(error)")
        }
    }
    
    /// Create all modules from extracted content
    /// Content has been rebranded: Desert Mountain Medicine → Black Elk Mountain Medicine
    /// Terminology updated: SOAA'P → SOAPNote
    private static func createAllModules() -> [WFRModule] {
        var modules: [WFRModule] = []
        
        // Module 0: About Black Elk Mountain Medicine
        modules.append(createAboutModule())
        
        // Module 1: Introduction to Wilderness Medicine
        modules.append(createIntroductionModule())
        
        // Module 2: Patient Assessment
        modules.append(createPatientAssessmentModule())
        
        // Module 3: Basic Life Support
        modules.append(createBLSModule())
        
        // Module 4: Shock
        modules.append(createShockModule())
        
        // Module 5: Cardiac Emergencies
        modules.append(createCardiacEmergenciesModule())
        
        // Module 6: Stroke (CVA)
        modules.append(createStrokeModule())
        
        // Module 7: Hypothermia
        modules.append(createHypothermiaModule())
        
        // Module 8: Skin Related Problems
        modules.append(createSkinRelatedProblemsModule())
        
        // Module 9: Micromedics
        modules.append(createMicromedicsModule())
        
        return modules
    }
    
    // MARK: - Module Creation Functions
    
    /// Module 0: About Black Elk Mountain Medicine - Teaching Philosophy
    private static func createAboutModule() -> WFRModule {
        return WFRModule(
            moduleTitle: "About Black Elk Mountain Medicine",
            moduleSubtitle: "Teaching Philosophy",
            category: .general,
            iconName: "book",
            moduleDescription: "Our teaching philosophy emphasizes hands-on, scenario-based practice in outdoor settings, supporting multiple learning styles and developing expertise, teamwork, and leadership.",
            sections: [
                WFRModuleSection(
                    title: "Teaching Philosophy",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "Black Elk Mountain Medicine was started with the premise that wilderness medicine instruction should not be limited to classroom lectures. We are driven to develop a creative, experiential based curriculum; one which effectively addresses the dynamic nature of a wilderness environment and the rapid advancement in emergency care, as well as supports and addresses multiple learning styles.",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "Our teaching approach heavily favors hands-on, scenario-based practice taught in an outdoor setting while simulating real-world examples. The completion of scenarios plays a powerful role in self-reflection and allows for inquiry-based learning so each student can relate his or her experience to the real world.",
                            orderIndex: 1
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "We believe that practice and repetition of increasingly complex scenarios helps students develop an in-depth and personalized approach to patient assessment where the learning is ingrained and can be accessed and applied rapidly in an emergency situation.",
                            orderIndex: 2
                        )
                    ],
                    orderIndex: 0
                )
            ],
            orderIndex: 0,
            isBookmarked: false,
            location: nil
        )
    }
    
    /// Module 1: Introduction to Wilderness Medicine
    private static func createIntroductionModule() -> WFRModule {
        return WFRModule(
            moduleTitle: "Introduction to Wilderness Medicine",
            moduleSubtitle: "Course Types, EMS System, and Legal Considerations",
            category: .general,
            iconName: "book",
            moduleDescription: "Introduction to wilderness medicine, including different course levels, the Emergency Medical System, and legal considerations for wilderness medical providers.",
            sections: [
                WFRModuleSection(
                    title: "What is Wilderness Medicine?",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "Wilderness medicine is a specialized branch addressing medical and trauma emergencies in remote areas, often more complex than urban medicine. Outdoor guides, instructors, enthusiasts, and professionals working in remote backcountry locations require specialized medical training beyond traditional first aid.",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "Unlike urban EMS which has official governing bodies, wilderness medicine currently lacks such a body. Course curricula have historically evolved based on evidence and practical experience, leading to a de facto consensus among training organizations.",
                            orderIndex: 1
                        )
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Types of Wilderness Medicine Courses",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Wilderness First Aid (WFA) - 16 hours",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "This training is for outdoor leaders that are never far from the umbrella of the local EMS response. They are taught to recognize, treat, and stabilize basic injuries and medical issues and call for an evacuation.",
                            orderIndex: 1
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Wilderness Advanced First Aid (WAFA) - 40 hours",
                            orderIndex: 2
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "The WAFA is for outdoor leaders working in remote backcountry locations that have sound communication and rescue responses. These leaders may not need to rely on their personal decision-making and/or judgment skills in the event of life and death medical decisions.",
                            orderIndex: 3
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Wilderness First Responder (WFR) - 80 hours",
                            orderIndex: 4
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "The WFR is the standard in the outdoor recreation industry for multi-day trips in remote locations with unreliable communication and where rescue is delayed or unavailable. This course is designed to address injuries, medical illnesses, and behavioral issues common to extended backcountry trips. These leaders are trained to make life and death decisions about patient treatment and to organize and manage their own rescue.",
                            orderIndex: 5
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Wilderness EMT Upgrade - 54 hours",
                            orderIndex: 6
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "This course is designed to add a wilderness module to a current Emergency Medical Technician's urban training. It focuses on the same principles of a WFR with the addition of oxygen, advanced airway techniques, intravenous therapy, and drugs. This module upgrades an urban EMT to a WEMT.",
                            orderIndex: 7
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Expedition Medicine - 45 hours",
                            orderIndex: 8
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "This course is for licensed medical practitioners (e.g. MD, PA, RN, DNP or DO) who aspire to become primary medical personnel on wilderness expeditions. This entirely field-based course covers the latest advanced care life support (ACLS) protocols applied in the field, expedition medications, first aid kits, and innovative treatment and management of common backcountry trauma, illnesses, and rescues.",
                            orderIndex: 9
                        )
                    ],
                    orderIndex: 1
                )
            ],
            orderIndex: 1,
            isBookmarked: false,
            location: nil
        )
    }
    
    /// Module 2: Patient Assessment
    private static func createPatientAssessmentModule() -> WFRModule {
        // Randomize location for scenarios
        let location = ParkLocations.randomLocation(remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Patient Assessment",
            moduleSubtitle: "Scene Size-Up, Primary Assessment, Secondary Assessment, and Reassessment",
            category: .assessment,
            iconName: "stethoscope",
            moduleDescription: "Comprehensive patient assessment system including scene size-up, primary assessment (ABCDEG), secondary assessment, baseline vitals, and ongoing reassessment.",
            sections: [
                WFRModuleSection(
                    title: "Patient Assessment Overview",
                    subtitle: "Four-Step Assessment Process",
                    content: [
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "Patient assessment is an organized process for gathering information about a patient, consisting of four components: 1) Scene Size-Up, 2) Primary Assessment, 3) Secondary Assessment, and 4) Reassessment. This model is standard in pre-hospital care.",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Scene Size-Up",
                            orderIndex: 1
                        ),
                        WFRModuleContentBlock(
                            type: .bulletList,
                            content: "Scene Safety\nStandard Precautions\nMechanism of Injury (MOI) / Nature of Illness (NOI)\nNumber of Patients\nResources Needed",
                            orderIndex: 2
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Primary Assessment (ABCDEG)",
                            orderIndex: 3
                        ),
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "A - AIRWAY: Clear and Open Airway (Jaw Thrust or Head-Tilt, Chin-lift), Advanced Airway (OPA-NPA-King)\nB - BREATHING: Positive Pressure Ventilation (PPV), Occlusive Dressing, Stabilize Flail Chest\nC - CIRCULATION: Control Blood Loss, Check Pulses (Carotid & Radial), Perfusion (Treat for Shock)\nD - DISABILITY: Spine Precautions, AVPU\nE - EXPOSE & ENVIRONMENT: Remove/cut Clothing to Reveal Injuries, Cover Patient Up\nG - GLUCOSE: Give Sugar Orally (If unresponsive, give when patient is laying on their side)",
                            orderIndex: 4
                        ),
                        WFRModuleContentBlock(
                            type: .warning,
                            content: "Note: Any person in a remote backcountry setting that is found unresponsive for unknown reasons should be given sugar between their cheek and gum (while lying on their side to protect their airway).",
                            orderIndex: 5
                        )
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Standard Precautions",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "Standard precautions are part of Scene Size-up and are designed to protect rescuers and patients from blood-borne pathogens, viruses, and bacteria through contact and droplet transmission.",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Personal Protective Equipment (PPE)",
                            orderIndex: 1
                        ),
                        WFRModuleContentBlock(
                            type: .bulletList,
                            content: "Gloves: Required for contact with mucous membranes, non-intact skin, blood, or other body fluids. Use non-latex gloves due to latex sensitivity. Improvise with plastic zip-lock bags if gloves are unavailable.\nProtective Surgical Masks: Required for rescuers and patients when a pathogen is transmittable via droplets.\nCPR Mask (pocket mask): Required during CPR or rescue breathing to protect rescuers from body fluids.\nEye Protection: Glasses or sunglasses help protect against disease transmission from body fluids splashing into the rescuer's eyes via droplet transmission.\nClothing: Protective clothing (e.g., rain jacket, rain pants) for significant blood splashes or major bleeding to avoid rescuer contamination.",
                            orderIndex: 2
                        )
                    ],
                    orderIndex: 1
                ),
                WFRModuleSection(
                    title: "Secondary Assessment",
                    subtitle: "Baseline Vitals, History, and Physical Exam",
                    content: [
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "Baseline Vitals",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "Heart Rate (HR): HR = # of beats in 15 sec. x 4 (Normal: 60-100 beats/min). Assess pulse strength: strong, weak, thready, slow, or irregular.\nRespiration Rate (RR): RR = # of chest rises in 15 sec. x 4 (Normal: 12-20 breaths/min). Listen for abnormal breath sounds (wheezing, rales, stridor), coughing, or labored breathing.\nBlood Pressure (BP): Assess strength of radial pulse. Strong ≈ 100 mmHg, Weak ≈ 80 mmHg, None = < 80 mmHg.\nLevel of Responsiveness (LOR): Using AVPU scale - Alert and Oriented (A&O) to person, place, time, and event; Verbal stimuli; Pain Stimuli; Unresponsive.\nPupils Equal Round Reactive to Light (PERRL): Assess pupil size, equality, and reactivity.\nSkin Color • Temperature • Moisture (SCTM): Assess color (pink, red, pale, blue, yellow), temperature (warm, hot, cold), and moisture (sweating, dry, diaphoretic).\nCirculation • Sensory • Motor (CSM): Assess distal pulses and capillary refill, sensation, and motor function on all four extremities.",
                            orderIndex: 1
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "History Taking (SAMPLE)",
                            orderIndex: 2
                        ),
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "S - Signs & Symptoms (S/Sx)\nA - Allergies\nM - Medications\nP - Pre-Existing Conditions\nL - Last Ins & Outs\nE - Events Prior",
                            orderIndex: 3
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "OPQRST (For Pain Assessment)",
                            orderIndex: 4
                        ),
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "O - Onset\nP - Provoke\nQ - Quality\nR - Radiate\nS - Severity\nT - Time/Treatments",
                            orderIndex: 5
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "1ST STEP (For Altered LOR)",
                            orderIndex: 6
                        ),
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "S - Sugar\nT - Temperature\nS - Salt\nT - Toxins\nE - Electricity/Elevation\nP - Pressure",
                            orderIndex: 7
                        )
                    ],
                    orderIndex: 2
                ),
                WFRModuleSection(
                    title: "Reassessment",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "Reevaluate:\n• Chief Complaint\n• Primary Assessment\n• Vitals\n• Interventions\n\nDocument:\n• RECORD On Athletic Tape\n• WRITE OUT SOAPNote\n• TRANSFER TO Incident Report Form",
                            orderIndex: 0
                        )
                    ],
                    orderIndex: 3
                )
            ],
            orderIndex: 2,
            isBookmarked: false,
            location: locationString
        )
    }
    
    /// Module 3: Basic Life Support
    private static func createBLSModule() -> WFRModule {
        // Randomize location for scenarios
        let location = ParkLocations.randomLocation(remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Basic Life Support",
            moduleSubtitle: "CPR, Airway Management, and AED",
            category: .assessment,
            iconName: "heart.circle",
            moduleDescription: "Cardiopulmonary resuscitation, airway management, and automatic external defibrillator use in wilderness settings.",
            sections: [
                WFRModuleSection(
                    title: "Cardiopulmonary Resuscitation (CPR)",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "CPR consists of pushing on the chest (compressions) and providing positive pressure ventilations (breaths) to circulate oxygenated blood to all vital organs, including the brain.",
                            orderIndex: 0
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "When to Start CPR",
                            orderIndex: 1
                        ),
                        WFRModuleContentBlock(
                            type: .paragraph,
                            content: "When there are no signs of life. In addition to a palpable pulse, signs of life include chest rise, movement of any kind, and good skin color (pink skin or mucous membranes). If you witness a collapse and notice unresponsiveness, and you're in an urban setting, activate the EMS system (call 911) and use an AED, if available, before beginning compressions.",
                            orderIndex: 2
                        ),
                        WFRModuleContentBlock(
                            type: .warning,
                            content: "When there is a suspicion of asphyxia (e.g., avalanche burial, drowning, or CO & CO2 poisoning) give 5 breaths to oxygenate the patient before rescue breathing and/or CPR.",
                            orderIndex: 3
                        ),
                        WFRModuleContentBlock(
                            type: .heading,
                            content: "CPR Overview - C-A-B vs A-B-C",
                            orderIndex: 4
                        ),
                        WFRModuleContentBlock(
                            type: .procedure,
                            content: "NO PULSE: Use C-A-B sequence (Circulation, Airway, Breathing)\n• Circulation: Start compressions, fast and hard, allow for total chest recoil, rate of 100-120/minute\n• Airway: Open airway using Head-tilt-chin-lift or Jaw thrust\n• Breathing: Give two breaths, give effective breaths to make chest rise, avoid excessive ventilations, minimize interruptions to less than 10 seconds\n\nPULSE PRESENT: Use A-B-C sequence (Airway, Breathing, Circulation)\n• Airway: Open Airway using Head-tilt, chin-lift or Jaw thrust\n• Breathing: NO Breathing or INADEQUATE Breathing (<8/min or > 30/min and shallow) = RESCUE BREATHING. Give 1 breath every 6 seconds, give effective breaths to make chest rise, avoid excessive ventilations. Continue primary assessment.",
                            orderIndex: 5
                        )
                    ],
                    orderIndex: 0
                )
            ],
            orderIndex: 3,
            isBookmarked: false,
            location: locationString
        )
    }
    
    // MARK: - Additional Module Creation Functions
    
    /// Module 4: Shock
    private static func createShockModule() -> WFRModule {
        let location = ParkLocations.randomLocation(remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Shock",
            moduleSubtitle: "Types, Stages, Recognition, and Treatment",
            category: .trauma,
            iconName: "cross.case",
            moduleDescription: "Comprehensive guide to shock types, stages (compensatory, decompensatory, irreversible), recognition, and treatment protocols.",
            sections: [
                WFRModuleSection(
                    title: "Types of Shock",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "Normal", orderIndex: 0),
                        WFRModuleContentBlock(type: .paragraph, content: "Fluid level, pump & container are normal. HR: 60-100 bpm, RR: 12-24 bpm, BP: Normal (strong radial pulses), SCTM: Pink, warm & dry (PWD).", orderIndex: 1),
                        WFRModuleContentBlock(type: .heading, content: "Hypovolemic Shock", orderIndex: 2),
                        WFRModuleContentBlock(type: .paragraph, content: "Fluid problem, severe bleed or severe dehydration. Visual: Healthy red heart connected to red circular container, but blue liquid level significantly reduced (<4 liters). HR: Over 100 bpm, RR: Over 24 bpm, BP: Normal to low, SCTM: Pale, cool & clammy (PCC).", orderIndex: 3),
                        WFRModuleContentBlock(type: .heading, content: "Cardiogenic Shock", orderIndex: 4),
                        WFRModuleContentBlock(type: .paragraph, content: "Pump problem: MI, CHF or cardiac tamponade. Visual: Red heart with diagonal line through it (indicating problem), connected to red circular container completely filled with blue liquid (5 liters). HR: Over 100 bpm, RR: Over 24 bpm, BP: Normal to low, SCTM: Pale, cool & clammy (PCC). Diaphoresis (sweating profusely) is common.", orderIndex: 5),
                        WFRModuleContentBlock(type: .heading, content: "Anaphylactic Shock (Vasogenic)", orderIndex: 6),
                        WFRModuleContentBlock(type: .paragraph, content: "Container problem, severe allergy. HR: Over 100 bpm, RR: Over 24 bpm (wheezing), BP: Low, SCTM: Red, hot & sweaty (RHS). Swallowing and breathing difficulties are common. Abdominal pain, cramps, vomiting, diarrhea, hives, and angioedema (swelling similar to hives, but beneath the skin instead of on the surface) is also possible.", orderIndex: 7),
                        WFRModuleContentBlock(type: .heading, content: "Septic Shock (Vasogenic)", orderIndex: 8),
                        WFRModuleContentBlock(type: .paragraph, content: "Container problem, severe infection. HR: Over 100 bpm, RR: Over 24 bpm, BP: Low, SCTM: Red & hot. A fever is usually present.", orderIndex: 9),
                        WFRModuleContentBlock(type: .heading, content: "Neurogenic Shock (Vasogenic)", orderIndex: 10),
                        WFRModuleContentBlock(type: .paragraph, content: "Container problem, high cord injury (C1-T4). HR: Over 100 bpm (or below 60/min bradycardia in some cases depending on spinal cord injury), RR: Over 24 bpm or absent, BP: Low, SCTM: Red, hot & dry (RHD), CSM: Poor (especially sensory and motor). Neck and/or back pain is usually present if patient is conscious.", orderIndex: 11)
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Stages of Shock",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "Compensatory Shock", orderIndex: 0),
                        WFRModuleContentBlock(type: .procedure, content: "Signs/Symptoms:\n• Approximately 1 liter of blood loss\n• LOR: Anxious, restless, & confused\n• SCTM: Pale, cool, clammy, & diaphoretic\n• HR: Tachycardia (above 100 bpm)\n• RR: Tachypnea (above 24 bpm)\n• BP: Strong radial pulse\n• PERRL: Normal", orderIndex: 1),
                        WFRModuleContentBlock(type: .heading, content: "Decompensatory Shock", orderIndex: 2),
                        WFRModuleContentBlock(type: .procedure, content: "Signs/Symptoms:\n• Approximately 2 liters of blood loss\n• LOR: Drops to unresponsiveness\n• SCTM: Very pale, cool, & clammy\n• HR: Increased tachycardia (weak & thready)\n• RR: Increased tachypnea (rapid & shallow)\n• BP: No radial pulse bilaterally\n• PERRL: Pupils are slow to react", orderIndex: 3),
                        WFRModuleContentBlock(type: .heading, content: "Irreversible Shock", orderIndex: 4),
                        WFRModuleContentBlock(type: .procedure, content: "Signs/Symptoms:\n• Over 2 liters of blood loss\n• LOR: Unresponsive\n• SCTM: Cold & mottled\n• HR: Extreme tachycardia (weak & thready)\n• RR: Extreme tachypnea (rapid & shallow)\n• BP: Weak to no palpable carotid pulses\n• PERRL: Fixed & dilated", orderIndex: 5)
                    ],
                    orderIndex: 1
                ),
                WFRModuleSection(
                    title: "Treatment",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .procedure, content: "Tx (Treatment):\n• Assess ABCs\n• Stop blood loss\n• Anticipate shock\n• Keep patient calm & warm\n• IV therapy if available\n• High flow O₂ if available\n• Evacuate immediately", orderIndex: 0),
                        WFRModuleContentBlock(type: .warning, content: "NOTE: Individuals who take beta-blockers or calcium channel blockers for high BP or arrhythmias may decompensate more rapidly with shock since these drugs block the heart from beating above 100 bpm. Beta-blockers end in \"olol\" (e.g., metoprolol, atenolol & propranolol). Calcium channel blockers end in \"dipine\" (e.g., amlodipine, nicardipine & felodipine).", orderIndex: 1)
                    ],
                    orderIndex: 2
                )
            ],
            orderIndex: 4,
            isBookmarked: false,
            location: locationString
        )
    }
    
    /// Module 5: Cardiac Emergencies
    private static func createCardiacEmergenciesModule() -> WFRModule {
        let location = ParkLocations.randomLocation(byTerrain: .mountain, remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Cardiac Emergencies",
            moduleSubtitle: "Angina, MI, CHF, and Treatment Protocols",
            category: .medical,
            iconName: "heart.circle",
            moduleDescription: "Recognition and treatment of cardiac emergencies including angina pectoris, myocardial infarction (MI), and congestive heart failure (CHF) in wilderness settings.",
            sections: [
                WFRModuleSection(
                    title: "Angina Pectoris",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "Signs/Symptoms (S/Sx)", orderIndex: 0),
                        WFRModuleContentBlock(type: .bulletList, content: "Anxiety & denial\nChest pain/pressure\nPain that radiates to the left jaw and arm\nShortness of breath (SOB)\nWeakness\nPale skin\nDiaphoresis (sweating profusely)\nPossible elevated HR and RR\nS/Sx often resolves with rest and/or nitroglycerin", orderIndex: 1),
                        WFRModuleContentBlock(type: .note, content: "Some individuals may simply present with weakness, nausea and/or pain in the back and/or belly.", orderIndex: 2)
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Myocardial Infarction (MI)",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "Signs/Symptoms (S/Sx)", orderIndex: 0),
                        WFRModuleContentBlock(type: .bulletList, content: "Anxiety & denial\nNausea & vomiting\nChest pain/pressure\nPain that radiates to the left jaw and arm\nShortness of breath (SOB)\nWeakness\nPale cool & clammy\nDiaphoresis (sweating profusely)\nElevated HR & RR\nCardiogenic shock especially if on betablockers and CCBs", orderIndex: 1),
                        WFRModuleContentBlock(type: .note, content: "Some individuals may simply present with weakness, nausea and/or pain in the back and/or belly.", orderIndex: 2)
                    ],
                    orderIndex: 1
                ),
                WFRModuleSection(
                    title: "Congestive Heart Failure (CHF)",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "Signs/Symptoms (S/Sx)", orderIndex: 0),
                        WFRModuleContentBlock(type: .bulletList, content: "Weakness & fatigue\nNausea & vomiting\nSwollen ankles and legs or shortness of breath due to pulmonary edema (crackly lung sounds)\nMay have chest pain\nIncreased HR & RR", orderIndex: 1)
                    ],
                    orderIndex: 2
                ),
                WFRModuleSection(
                    title: "Treatment (Tx)",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .procedure, content: "General Treatment:\n• Rest\n• Position of comfort\n• 325 mg of Aspirin\n• Patient's Rx of nitroglycerin\n• CPR when indicated\n• Evacuate immediately!", orderIndex: 0)
                    ],
                    orderIndex: 3
                )
            ],
            orderIndex: 5,
            isBookmarked: false,
            location: locationString
        )
    }
    
    /// Module 6: Stroke (CVA)
    private static func createStrokeModule() -> WFRModule {
        let location = ParkLocations.randomLocation(byTerrain: .alpine, remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Stroke (CVA)",
            moduleSubtitle: "Recognition, FAST Assessment, and Treatment",
            category: .medical,
            iconName: "heart.circle",
            moduleDescription: "Recognition and treatment of cerebral vascular accident (CVA/stroke) using FAST assessment and wilderness treatment protocols.",
            sections: [
                WFRModuleSection(
                    title: "What is a Stroke (CVA)?",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .paragraph, content: "A CVA (stroke) occurs when either a blood clot lodges in a cerebral blood vessel (ischemic stroke) or a cerebral artery ruptures (hemorrhagic stroke), both leading to inadequate tissue perfusion of the brain.", orderIndex: 0),
                        WFRModuleContentBlock(type: .paragraph, content: "Neurological damage from an ischemic stroke might be reversible with thrombolytics, which dissolve clots to improve blood flow and prevent permanent brain damage. This therapy is for certain patients and must be administered within a 4.5-hour window after symptom onset.", orderIndex: 1),
                        WFRModuleContentBlock(type: .paragraph, content: "A stroke has sudden onset. It is critical to determine a \"Last Seen Normal\" time from the patient or bystanders. Proper wilderness treatment involves accurate assessment, patient comfort, and prompt evacuation.", orderIndex: 2),
                        WFRModuleContentBlock(type: .heading, content: "Aphasia", orderIndex: 3),
                        WFRModuleContentBlock(type: .paragraph, content: "Aphasia is an impairment of language, common in strokes and other brain injuries. It can present in three ways: 1) inability to form words and speak while understanding others, 2) inability to comprehend language resulting in incomprehensible speech, or 3) a combination of both. Individuals who can comprehend language might still communicate in written form.", orderIndex: 4)
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Signs and Symptoms",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .bulletList, content: "Headache\nSlurred speech\nHemiparesis (one-sided weakness)\nHemiplegia (paralysis on one side of the body)\nLoss of CSM on one side (Circulation, Sensation, Movement)\nAphasia\nDifficulty breathing\nDecreased LOR (Level of Responsiveness)", orderIndex: 0)
                    ],
                    orderIndex: 1
                ),
                WFRModuleSection(
                    title: "FAST Assessment",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "F - Facial Droop", orderIndex: 0),
                        WFRModuleContentBlock(type: .paragraph, content: "Partial paralysis of one side of the face results in drooping features. Instruction: Ask the person to smile.", orderIndex: 1),
                        WFRModuleContentBlock(type: .heading, content: "A - Arm Drift", orderIndex: 2),
                        WFRModuleContentBlock(type: .paragraph, content: "The person cannot raise or hold arms up equally. Instruction: Ask the person to hold both arms straight out in front of them with palms up.", orderIndex: 3),
                        WFRModuleContentBlock(type: .heading, content: "S - Speech", orderIndex: 4),
                        WFRModuleContentBlock(type: .paragraph, content: "The person slurs words, uses the wrong words or is unable to speak. There may also be difficulty swallowing exhibited by coughing or choking. Instruction: Ask the person to repeat a sentence after you.", orderIndex: 5),
                        WFRModuleContentBlock(type: .heading, content: "T - Time", orderIndex: 6),
                        WFRModuleContentBlock(type: .paragraph, content: "Time lost is brain lost. Think 'Brain Attack', like 'Heart Attack'. Instructions: Ask family/friends/bystanders when the person was last seen acting normally. Evacuate immediately!!", orderIndex: 7)
                    ],
                    orderIndex: 2
                ),
                WFRModuleSection(
                    title: "Treatment",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .procedure, content: "Tx (Treatment):\n• ABCs (Airway, Breathing, Circulation)\n• Assess & document \"FAST\" (Face drooping, Arm weakness, Speech difficulty, Time to call emergency services)\n• Reassurance\n• Evacuate immediately!", orderIndex: 0),
                        WFRModuleContentBlock(type: .warning, content: "NEVER give aspirin in the event of a CVA. It will increase bleeding in the brain in the case of a hemorrhagic stroke.", orderIndex: 1)
                    ],
                    orderIndex: 3
                )
            ],
            orderIndex: 6,
            isBookmarked: false,
            location: locationString
        )
    }
    
    /// Module 7: Hypothermia
    private static func createHypothermiaModule() -> WFRModule {
        let location = ParkLocations.randomLocation(byTerrain: .alpine, byElevation: .veryHigh, remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Hypothermia",
            moduleSubtitle: "Stages, Recognition, and Treatment",
            category: .environmental,
            iconName: "thermometer",
            moduleDescription: "Comprehensive guide to hypothermia stages (Cold Stressed, Mild, Moderate, Severe), recognition, and treatment protocols including hypowrap and ECLS considerations.",
            sections: [
                WFRModuleSection(
                    title: "Assessing Hypothermia",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .procedure, content: "Assessment Steps:\n1. Assess Consciousness (conscious or unresponsive)\n2. Assess Movement (normal, impaired, or no movement)\n3. Assess Shivering (mild, uncontrollable, or decreasing)\n4. Assess LOR (A&Ox4, decreasing, \"U\" on AVPU)", orderIndex: 0)
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Stages of Hypothermia",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "COLD STRESSED", orderIndex: 0),
                        WFRModuleContentBlock(type: .procedure, content: "Indicators:\n• CONSCIOUS\n• MOVEMENT NORMAL\n• SHIVERING\n• LOR = A&Ox4 (Level of Responsiveness = Alert & Oriented x4)\n\nTreatment:\n1. Reduce heat loss\n2. Provide high-calorie food or drink\n3. Move around/exercise to warm up", orderIndex: 1),
                        WFRModuleContentBlock(type: .heading, content: "MILD", orderIndex: 2),
                        WFRModuleContentBlock(type: .procedure, content: "Indicators:\n• CONSCIOUS\n• IMPAIRED MOVEMENT\n• SHIVERING\n• LOR = A&Ox4\n\nTreatment:\n1. Handle gently\n2. Have patient sit or lie down in hypowrap for at least 30 min.\n3. Heat sources - chest, back, armpits\n4. Give high-calorie food/drink\n5. Monitor for 'afterdrop' if patient recovers\n6. Evacuate if no improvement", orderIndex: 3),
                        WFRModuleContentBlock(type: .heading, content: "MODERATE", orderIndex: 4),
                        WFRModuleContentBlock(type: .procedure, content: "Indicators:\n• CONSCIOUS\n• UNCONTROLLABLE SHIVERING → NONE\n• ↓LOR (decreasing Level of Responsiveness)\n\nTreatment:\n1. No standing/walking\n2. Handle gently\n3. Keep horizontal in hypowrap\n4. Heat sources - chest, back, armpits\n5. No food or drink\n6. Evacuate carefully to hospital with ECLS capability", orderIndex: 5),
                        WFRModuleContentBlock(type: .heading, content: "SEVERE", orderIndex: 6),
                        WFRModuleContentBlock(type: .procedure, content: "If cold & unresponsive, assume SEVERE HYPOTHERMIA\n\nTreatment:\n1. Check carotid pulse for 60 sec.\n   • IF no pulse, start CPR\n   • IF pulse but no breathing, rescue breathe: (1 breath every 5-6 sec.)\n2. Treat like Moderate Hypothermia\n3. Evacuate carefully ASAP to hospital with ECLS capability", orderIndex: 7)
                    ],
                    orderIndex: 1
                )
            ],
            orderIndex: 7,
            isBookmarked: false,
            location: locationString
        )
    }
    
    /// Module 8: Skin Related Problems
    private static func createSkinRelatedProblemsModule() -> WFRModule {
        let location = ParkLocations.randomLocation(byTerrain: .forest, remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Skin Related Problems",
            moduleSubtitle: "Poison Ivy, Oak, Sumac, and Fungal Infections",
            category: .minor,
            iconName: "bandage",
            moduleDescription: "Recognition, prevention, and treatment of contact dermatitis from Toxicodendron plants and common fungal skin infections.",
            sections: [
                WFRModuleSection(
                    title: "Poison Ivy, Oak & Sumac",
                    subtitle: "Toxicodendron Genus",
                    content: [
                        WFRModuleContentBlock(type: .paragraph, content: "Contact dermatitis caused by plants in the Toxicodendron genus. Urushiol-induced contact dermatitis can be severe (potential for anaphylaxis). Approximately 15-30% of people are non-allergic. Risk of inhaling fumes from burning plants. Toxicodendron sp. is found across the US and southern Canada, excluding deserts and altitudes above ~5000 ft (1524 m).", orderIndex: 0),
                        WFRModuleContentBlock(type: .heading, content: "Prevention", orderIndex: 1),
                        WFRModuleContentBlock(type: .bulletList, content: "Recognize plants by \"leaves of three\"\nWear protective clothing\nWash exposed clothing with laundry detergent or special solvents like Tecnu® products", orderIndex: 2),
                        WFRModuleContentBlock(type: .heading, content: "Signs/Symptoms (S/Sx)", orderIndex: 3),
                        WFRModuleContentBlock(type: .bulletList, content: "Extremely itchy, red rash containing small to large fluid-filled blisters\nOutbreaks can last up to three weeks\nDifficulty breathing from inhalation of fumes from burning the plant", orderIndex: 4),
                        WFRModuleContentBlock(type: .heading, content: "Treatment (Tx)", orderIndex: 5),
                        WFRModuleContentBlock(type: .procedure, content: "1. Wash exposed area immediately with soap and cold water (avoiding hot water to prevent pore opening and faster absorption)\n2. Use Tecnu Extreme® for its oil-dissolving and anti-itch properties\n3. Consider anti-histamines or oral steroids for severe reactions", orderIndex: 6),
                        WFRModuleContentBlock(type: .warning, content: "Evacuate anyone who has inhaled fumes or has difficulty breathing.", orderIndex: 7)
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Fungal Infections",
                    subtitle: nil,
                    content: [
                        WFRModuleContentBlock(type: .paragraph, content: "Fungal infections typically grow in dark, warm, moist areas like feet and groin.", orderIndex: 0),
                        WFRModuleContentBlock(type: .heading, content: "Prevention", orderIndex: 1),
                        WFRModuleContentBlock(type: .bulletList, content: "Wear breathable, dry clothing\nFrequently change socks and underwear to reduce moisture in problem areas", orderIndex: 2),
                        WFRModuleContentBlock(type: .heading, content: "Signs/Symptoms (S/Sx)", orderIndex: 3),
                        WFRModuleContentBlock(type: .bulletList, content: "Red, swollen, itchy, skin that can be scaling and cracking", orderIndex: 4),
                        WFRModuleContentBlock(type: .heading, content: "Treatment (Tx)", orderIndex: 5),
                        WFRModuleContentBlock(type: .procedure, content: "1. Clean and air-dry the affected area\n2. Allow it to breathe\n3. Short exposure to UV radiation may help\n4. Apply diluted tea tree oil, 1% hydrocortisone cream, or other over-the-counter anti-fungal creams", orderIndex: 6)
                    ],
                    orderIndex: 1
                )
            ],
            orderIndex: 8,
            isBookmarked: false,
            location: locationString
        )
    }
    
    // MARK: - Placeholder Functions (for additional modules)
    
    /// Create placeholder modules for testing/development
    static func createPlaceholderModules(context: ModelContext) {
        let modules = createAllModules()
        
        for module in modules {
            context.insert(module)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving placeholder modules: \(error)")
        }
    }
    
    /// Module 9: Micromedics
    private static func createMicromedicsModule() -> WFRModule {
        let location = ParkLocations.randomLocation(remoteOnly: true)
        let locationString = location != nil ? ParkLocations.displayString(for: location!) : nil
        
        return WFRModule(
            moduleTitle: "Micromedics",
            moduleSubtitle: "Microscopic Threats and Water Treatment",
            category: .environmental,
            iconName: "drop.circle",
            moduleDescription: "Understanding and managing microscopic threats in the wilderness, including waterborne pathogens, disinfection techniques, and hygiene.",
            sections: [
                WFRModuleSection(
                    title: "Waterborne Pathogens",
                    subtitle: "Bacteria, Viruses, and Protozoa",
                    content: [
                        WFRModuleContentBlock(type: .paragraph, content: "Wilderness water sources can contain microscopic pathogens that cause illness. Understanding these threats is key to prevention.", orderIndex: 0),
                        WFRModuleContentBlock(type: .heading, content: "Types of Pathogens", orderIndex: 1),
                        WFRModuleContentBlock(type: .bulletList, content: "Protozoa (e.g., Giardia, Cryptosporidium) - Larger, resistant to some chemical treatments\nBacteria (e.g., E. coli, Salmonella) - Medium size, generally easy to kill\nViruses (e.g., Hepatitis A, Norovirus) - Very small, require specific treatments", orderIndex: 2)
                    ],
                    orderIndex: 0
                ),
                WFRModuleSection(
                    title: "Water Disinfection",
                    subtitle: "Methods and Best Practices",
                    content: [
                        WFRModuleContentBlock(type: .heading, content: "Boiling", orderIndex: 0),
                        WFRModuleContentBlock(type: .paragraph, content: "The most reliable method. Bring water to a rolling boil for 1 minute (3 minutes at altitudes above 6,500 ft / 2,000 m).", orderIndex: 1),
                        WFRModuleContentBlock(type: .heading, content: "Filtration", orderIndex: 2),
                        WFRModuleContentBlock(type: .paragraph, content: "Effective against protozoa and bacteria. Most filters do not remove viruses due to their small size.", orderIndex: 3),
                        WFRModuleContentBlock(type: .heading, content: "Chemical Treatment", orderIndex: 4),
                        WFRModuleContentBlock(type: .paragraph, content: "Iodine or Chlorine Dioxide. Effectiveness depends on concentration, contact time, and water temperature. Chlorine Dioxide is generally preferred over Iodine.", orderIndex: 5),
                        WFRModuleContentBlock(type: .heading, content: "UV Light", orderIndex: 6),
                        WFRModuleContentBlock(type: .paragraph, content: "Effective but requires clear water and batteries. Stirring is often required.", orderIndex: 7)
                    ],
                    orderIndex: 1
                ),
                WFRModuleSection(
                    title: "Hygiene",
                    subtitle: "Preventing Fecal-Oral Transmission",
                    content: [
                        WFRModuleContentBlock(type: .paragraph, content: "Good hygiene is the first line of defense against illness in the backcountry.", orderIndex: 0),
                        WFRModuleContentBlock(type: .bulletList, content: "Wash hands with soap and water (at least 200ft from water sources)\nUse hand sanitizer when washing isn't possible\nClean dishes thoroughly\nDesignate a 'kitchen' area separate from 'bathroom' areas", orderIndex: 1)
                    ],
                    orderIndex: 2
                )
            ],
            orderIndex: 9,
            isBookmarked: false,
            location: locationString
        )
    }
}
