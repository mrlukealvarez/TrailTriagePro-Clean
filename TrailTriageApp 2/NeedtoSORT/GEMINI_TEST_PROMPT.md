# Google Gemini / AI Tool Test Prompt

## DIRECT PROMPT FOR AI TOOL

Copy the section below (starting with "You are an expert...") and paste it into Google Gemini, Claude, ChatGPT, or any AI coding assistant to test if it can recreate the entire WFR TrailTriage app.

---

**BEGIN PROMPT:**

You are an expert iOS app developer specializing in SwiftUI, SwiftData, and professional medical applications. I need you to build a complete iOS app called **TrailTriage: WFR Toolkit** - a comprehensive wilderness medicine documentation and reference application.

## COMPLETE APP SPECIFICATION

### App Purpose
Build an iOS app that combines SOAP note documentation, vital signs tracking, and 80+ hours of WFR curriculum reference materials - all working 100% offline for backcountry use by certified Wilderness First Responders.

### Core Requirements
1. **Platform:** iOS 17.0+, Swift 6.0, SwiftUI, SwiftData
2. **Architecture:** MVVM with Observable State Management
3. **Offline-First:** All features must work without internet connectivity
4. **Privacy:** Local storage with optional CloudKit sync (user-controlled)
5. **Medical Standards:** Professional documentation format, HIPAA-aware design

### Main Features to Build

#### 1. SOAP Note Documentation System
- Create, edit, delete SOAP notes with full S-O-A-P sections
- Multiple vital sign readings per note (HR, RR, BP, SpO2, Temp, GCS, AVPU, CSM, SCTM)
- GPS location capture
- Scene information (MOI, environment, weather, terrain)
- Patient demographics (age, sex, chief complaint, allergies, medications)
- Responder information (name, certification, agency)
- Bookmarks, tags, search functionality
- Auto-save and manual save
- PDF export for EMS handoff

**Data Model (SwiftData @Model):**
```swift
@Model
final class SOAPNote {
    var id: UUID
    var patientName: String?
    var dateCreated: Date
    var dateModified: Date
    var subjective: String
    var objective: String
    var assessment: String
    var plan: String
    var vitalSigns: [VitalSigns]
    var location: LocationData?
    var sceneInfo: SceneInformation?
    var patientDemographics: PatientDemographics?
    var responderInfo: ResponderInformation?
    var isBookmarked: Bool
    var tags: [String]
}
```

Supporting embedded types for VitalSigns, LocationData, SceneInformation, PatientDemographics, ResponderInformation.

#### 2. Vital Signs Tracking
- Record multiple vital sign readings over time (each with timestamp)
- Track: Heart Rate, Respiratory Rate, Blood Pressure (Systolic/Diastolic), Oxygen Saturation, Temperature, Glasgow Coma Scale, AVPU Level, CSM Checks (Circulation, Sensation, Motion), SCTM Checks (Skin Color, Temperature, Moisture)
- Timeline view showing all readings chronologically
- Visual trend indicators (improving/worsening)
- Color-coded alerts for abnormal values
- Quick-add modal for rapid entry

#### 3. Reference Module System (Topic-Based)
- Modern topic-based modules replacing chapter-based structure
- Categories: Patient Assessment, Environmental, Medical, Trauma, Other
- Module → Section → ContentBlock hierarchy
- Content block types: heading, paragraph, procedure, warning, tip, bulletedList, numberedList, table
- Search across all modules
- Category filtering
- Bookmarks
- Randomized park locations for scenarios (enhances content freshness)

**Data Models:**
```swift
@Model
final class WFRModule {
    var id: UUID
    var moduleTitle: String
    var moduleSubtitle: String?
    var category: ModuleCategory // enum
    var iconName: String?
    var description: String?
    var sections: [WFRModuleSection]
    var orderIndex: Int
    var isBookmarked: Bool
    var location: String? // randomized park location
}

@Model
final class WFRModuleSection {
    var id: UUID
    var sectionTitle: String
    var content: [WFRModuleContentBlock]
    var orderIndex: Int
}

@Model
final class WFRModuleContentBlock {
    var id: UUID
    var type: ContentBlockType // enum: heading, paragraph, procedure, warning, tip, etc.
    var content: String
    var orderIndex: Int
    var metadata: String? // JSON for tables, lists
}
```

#### 4. Quick Reference Protocols
- Medical protocols organized by category
- Severity indicators (Critical, Urgent, Non-Urgent, Info)
- Step-by-step instructions
- Warnings and tips
- Favorites system
- Search functionality

#### 5. Medical Glossary
- Comprehensive WFR terminology
- Category-based browsing
- Search functionality
- Definitions and explanations

#### 6. PDF Export System
- Professional PDF generation using PCRFormatter
- Export single note or multiple notes
- Includes: Patient demographics, complete SOAP note, vital signs timeline, scene information, responder info, GPS coordinates, timestamps
- Share via Share Sheet, save to Files app, email attachment

#### 7. Subscription System (StoreKit 2)
- Free tier: Limited notes (configurable)
- Premium tier: Unlimited notes, full reference access
- 3-day free trial
- Sign in with Apple integration
- Paywall view with benefits
- Subscription status view
- Restore purchases option

#### 8. Onboarding Flow
- Welcome screen with app icon and mascot (Jimmothy the Raccoon WFR)
- Feature overview
- Sign in with Apple (optional, can skip)
- Subscription check/paywall
- Completion celebration
- First-launch detection (don't show if already completed)

#### 9. Settings & Preferences
- Account section (subscription status, Sign in with Apple, Cloud sync toggle)
- Preferences (auto-save, default responder info, theme, units)
- Data Management (export/backup, advanced settings, cache management)
- About section (version, support/FAQ, Privacy Policy, Terms of Service)

#### 10. Export & Backup
- Export all notes as PDF (individual or combined)
- Export as CSV
- Export as JSON
- Share via Share Sheet
- Save to Files app
- Cache management (view size, clear cache)
- Offline content management

### UI/UX Requirements

**Design System:**
- Brand: Black Elk Mountain Medicine
- Bundle ID: `com.blackelkmountainmedicine.trailtriage`
- Color scheme: Mountain/outdoor themed (blues, greens, earth tones)
- Full dark mode support
- High contrast for readability
- WCAG AA accessibility compliance
- San Francisco font (system default)

**UI Patterns:**
- Card-based design for lists
- 8pt grid spacing system
- Smooth animations and transitions
- Haptic feedback for important actions
- Large tap targets (minimum 44x44pt)

**Main Navigation:**
```
MainTabView (Root)
├── Notes Tab
│   ├── NotesListView (list all SOAP notes)
│   ├── NewNoteView (create new note)
│   ├── NoteDetailView (view/edit note)
│   └── PatientTransferDocumentView (PDF export)
├── Reference Tab
│   ├── ModuleListView (browse modules)
│   ├── ModuleDetailView (view module content)
│   └── GlossaryView
├── Protocols Tab
│   ├── ProtocolListView
│   └── ProtocolDetailView
└── Settings Tab
    ├── SettingsView
    ├── PreferencesView
    ├── ExportBackupView
    └── AdvancedSettingsView
```

### Technical Implementation Details

**SwiftData Configuration:**
```swift
let schema = Schema([
    WFRProtocol.self,
    SOAPNote.self,
    VitalSigns.self,
    WFRModule.self,
    WFRModuleSection.self,
    WFRModuleContentBlock.self,
])

let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false
)
```

**CloudKit Sync:**
- Optional (user-controlled in settings)
- Automatic sync when enabled
- Conflict resolution: Last-write-wins
- Encryption for sensitive data (SOAP notes)

**Offline Functionality:**
- All features work without internet
- Data persists locally
- No external API dependencies for core functionality
- Clear indicators when offline

**Error Handling:**
- Try-catch blocks around all data operations
- User-friendly error messages
- Graceful degradation (offline mode, sync failures)
- Empty states with helpful messages

### File Structure
```
WFR TrailTriage/
├── App/
│   ├── WFR_TrailTriageApp.swift          # App entry point
│   └── MainTabView.swift                 # Root navigation
├── Models/
│   ├── SOAPNote.swift
│   ├── WFRModule.swift
│   ├── WFRProtocol.swift
│   └── AppSettings.swift
├── Views/
│   ├── Notes/
│   ├── Reference/
│   ├── Vitals/
│   ├── Settings/
│   ├── Onboarding/
│   └── Subscription/
├── Services/
│   ├── StoreManager.swift
│   └── SubscriptionManager.swift
└── Utilities/
    ├── ParkLocations.swift
    ├── ScenarioRandomizer.swift
    └── Theme.swift
```

### Key Views to Implement

1. **NotesListView:** List all SOAP notes with search, filters, swipe actions (delete, bookmark, share)
2. **NewNoteView/NoteDetailView:** Form-based SOAP note editor with all sections, vital signs panel, GPS capture
3. **ModuleListView:** Card-based grid/list of reference modules with category filters and search
4. **ModuleDetailView:** Scrollable module content with proper rendering of all content block types
5. **VitalSignsTracker:** Timeline view of vital sign readings with quick-add modal
6. **OnboardingView:** Multi-step onboarding flow
7. **PaywallView:** Subscription benefits and purchase flow
8. **ExportBackupView:** Export options (PDF, CSV, JSON) with Share Sheet integration

### Success Criteria

✅ All core features work offline
✅ SOAP notes save and persist correctly
✅ Vital signs tracking functional
✅ Reference content displays properly
✅ PDF export generates professional documents
✅ CloudKit sync works (when enabled)
✅ Subscription system functions
✅ Onboarding guides new users
✅ No crashes in normal use
✅ Smooth animations and transitions
✅ Accessible (VoiceOver, Dynamic Type)
✅ Professional appearance

### Testing Requirements

- Create at least 10 sample SOAP notes with various scenarios
- Test vital signs tracking with multiple readings per note
- Verify PDF export for single and multiple notes
- Test search functionality across all content
- Verify CloudKit sync (enable/disable)
- Test subscription purchase and restore
- Verify offline functionality (airplane mode)
- Test accessibility features

### Additional Notes

- No DEBUG code in production build
- Privacy Policy URL: https://blackelkmountainmedicine.com/privacy.html
- Terms of Service URL: https://blackelkmountainmedicine.com/terms.html
- Mascot: Jimmothy the Raccoon WFR (appears in onboarding)
- Educational tool disclaimer required (not a replacement for training)
- Evidence-based protocols only

---

## YOUR TASK

Build the complete WFR TrailTriage iOS app following this specification. Provide:

1. **Complete Swift code** for all models, views, services, and utilities
2. **File structure** with all files organized
3. **Implementation notes** explaining key decisions
4. **Setup instructions** for Xcode project configuration
5. **Testing checklist** to verify functionality

Start with the core models and app structure, then build out the views and features. Ensure everything follows iOS best practices, SwiftUI patterns, and the requirements specified above.

**END PROMPT**

---

## HOW TO USE THIS

1. Copy everything between "BEGIN PROMPT" and "END PROMPT"
2. Paste into Google Gemini, Claude, ChatGPT, or similar AI tool
3. Request the AI to build the complete app
4. Compare the output to our existing implementation
5. Document differences and improvements

This prompt contains everything needed to recreate the app. The test will show if an AI tool can:
- Understand the complete specification
- Generate working Swift code
- Follow iOS best practices
- Implement all features correctly
- Match our current architecture

---

*Generated: November 22, 2025*  
*For testing AI code generation capabilities*

