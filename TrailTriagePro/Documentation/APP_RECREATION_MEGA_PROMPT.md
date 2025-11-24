# 🏔️ WFR TrailTriage - Complete App Recreation Mega Prompt

## App Purpose & Vision

**WFR TrailTriage** is a professional wilderness medicine iOS app designed to provide certified Wilderness First Responders (WFRs) with comprehensive documentation tools and reference materials that work 100% offline in backcountry environments.

### Core Mission
Enable wilderness medical responders to create professional patient documentation, track vital signs over time, and access 80+ hours of WFR curriculum protocols - all without requiring internet connectivity. The app serves as a digital "field guide" that combines practical documentation tools with evidence-based medical reference content.

### Target Users
- Certified Wilderness First Responders (WFR)
- Search and Rescue team members
- Outdoor adventure guides and trip leaders
- Emergency Medical Technicians working in remote areas
- Backcountry medical providers

### Key Value Propositions
1. **100% Offline Functionality** - Every feature works without internet (critical for backcountry use)
2. **Professional Documentation** - Industry-standard SOAP notes with PDF export for EMS handoff
3. **Comprehensive Reference** - 80+ hours of WFR curriculum content at your fingertips
4. **Privacy-First** - All data stored locally with optional iCloud encryption
5. **Built by Practitioners** - Created by a volunteer SAR member for real-world field use

---

# COMPLETE APP RECREATION SPECIFICATION

You are an expert iOS app developer specializing in SwiftUI, SwiftData, and professional medical applications. I need you to build a complete iOS app for wilderness medicine documentation and reference.

## USE CASE DESCRIPTION

Build **TrailTriage: WFR Toolkit** - a comprehensive iOS application that combines:

1. **SOAP Note Documentation System** - Create, edit, and manage patient documentation using the standard Subjective, Objective, Assessment, Plan format
2. **Vital Signs Tracking** - Monitor and record patient vital signs over time with timestamp tracking
3. **WFR Reference Modules** - Topic-based reference system with 80+ hours of wilderness medicine curriculum
4. **Quick Reference Protocols** - Categorized medical protocols for rapid access
5. **Medical Glossary** - Comprehensive terminology database for WFR field use
6. **Export & Backup** - Generate PDFs, export data, and sync across devices

**Critical Requirements:**
- Must work 100% offline (no external API dependencies for core functionality)
- Professional medical documentation standards
- HIPAA-aware design (educational tool disclaimer)
- Support for iOS 17.0+
- Optional CloudKit sync for data backup

---

## 1. WORKFLOW STRUCTURE

### App Architecture
**Pattern:** MVVM with Observable State Management  
**Frameworks:** SwiftUI, SwiftData, StoreKit 2, CloudKit, UserNotifications  
**Language:** Swift 6.0  
**Minimum iOS:** 17.0+

### Main Navigation Flow
```
App Launch
    ├── Onboarding Flow (if first launch)
    │   ├── Welcome Screen
    │   ├── Feature Overview
    │   ├── Sign In with Apple (optional)
    │   └── Subscription Check
    │
    └── MainTabView (after onboarding)
        ├── Notes Tab
        │   ├── NotesListView (list all SOAP notes)
        │   ├── NewNoteView (create new SOAP note)
        │   ├── NoteDetailView (view/edit existing note)
        │   ├── ExpertModeNoteView (advanced note editing)
        │   └── PatientTransferDocumentView (PDF export)
        │
        ├── Reference Tab
        │   ├── ModuleListView (browse reference modules)
        │   ├── ModuleDetailView (view module content)
        │   ├── GlossaryView (medical terms)
        │   └── ReferenceBookTitlePageView (cover page)
        │
        ├── Protocols Tab
        │   ├── ProtocolListView (browse protocols)
        │   └── ProtocolDetailView (view protocol steps)
        │
        └── Settings Tab
            ├── SettingsView (main settings)
            ├── PreferencesView (app preferences)
            ├── ExportBackupView (data export)
            ├── AdvancedSettingsView (cache, offline content)
            ├── SubscriptionStatusView (subscription info)
            └── AboutView (app info, support)
```

---

## 2. DATA MODELS (SwiftData @Model)

### Core Models

#### 1. SOAPNote
**Purpose:** Primary patient documentation model

**Properties:**
- `id: UUID` - Unique identifier
- `patientName: String?` - Patient name (optional for privacy)
- `dateCreated: Date` - Creation timestamp
- `dateModified: Date` - Last modification timestamp
- `subjective: String` - S (Subjective) section text
- `objective: String` - O (Objective) section text
- `assessment: String` - A (Assessment) section text
- `plan: String` - P (Plan) section text
- `vitalSigns: [VitalSigns]` - Array of vital sign readings
- `location: LocationData?` - GPS coordinates and location info
- `sceneInfo: SceneInformation?` - Scene details (MOI, environment)
- `patientDemographics: PatientDemographics?` - Age, sex, chief complaint
- `responderInfo: ResponderInformation?` - Responder credentials, agency
- `isBookmarked: Bool` - Favorite/bookmark flag
- `tags: [String]` - Searchable tags

**Supporting Types:**
- `VitalSigns` (embedded struct)
  - `timestamp: Date`
  - `heartRate: Int?`
  - `respiratoryRate: Int?`
  - `bloodPressureSystolic: Int?`
  - `bloodPressureDiastolic: Int?`
  - `oxygenSaturation: Int?`
  - `temperature: Double?`
  - `gcsScore: Int?` (Glasgow Coma Scale)
  - `avpuLevel: AVPULevel` (Alert, Voice, Pain, Unresponsive)
  - `csmChecks: CSMChecks?` (Circulation, Sensation, Motion)
  - `sctmChecks: SCTMChecks?` (Skin Color, Temperature, Moisture)
  
- `LocationData`
  - `latitude: Double`
  - `longitude: Double`
  - `altitude: Double?`
  - `address: String?`
  - `locationName: String?`
  
- `SceneInformation`
  - `mechanismOfInjury: String?`
  - `environmentalConditions: String?`
  - `weather: String?`
  - `terrain: String?`
  
- `PatientDemographics`
  - `age: Int?`
  - `sex: String?`
  - `chiefComplaint: String?`
  - `emergencyContact: String?`
  - `allergies: String?`
  - `medications: String?`
  
- `ResponderInformation`
  - `responderName: String`
  - `certification: String?`
  - `agency: String?`
  - `contactInfo: String?`

#### 2. WFRModule
**Purpose:** Modern topic-based reference modules (replacing chapter-based structure)

**Properties:**
- `id: UUID`
- `moduleTitle: String` - Module name
- `moduleSubtitle: String?` - Subtitle/description
- `category: ModuleCategory` - Enum: `.patientAssessment`, `.environmental`, `.medical`, `.trauma`, `.other`
- `iconName: String?` - SF Symbol name
- `description: String?` - Module overview
- `sections: [WFRModuleSection]` - Child sections
- `orderIndex: Int` - Display order
- `isBookmarked: Bool` - Favorite flag
- `location: String?` - Randomized park location for scenarios

**Relationships:**
- `sections: [WFRModuleSection]` - One-to-many relationship

#### 3. WFRModuleSection
**Purpose:** Sections within a module

**Properties:**
- `id: UUID`
- `sectionTitle: String`
- `content: [WFRModuleContentBlock]` - Content blocks within section
- `orderIndex: Int`

#### 4. WFRModuleContentBlock
**Purpose:** Individual content blocks (paragraphs, headings, procedures, etc.)

**Properties:**
- `id: UUID`
- `type: ContentBlockType` - Enum: `.heading`, `.paragraph`, `.procedure`, `.warning`, `.tip`, `.bulletedList`, `.numberedList`, `.table`, `.image`
- `content: String` - Main text content
- `orderIndex: Int`
- `metadata: String?` - JSON string for additional data (tables, lists)

#### 5. WFRProtocol
**Purpose:** Quick reference medical protocols

**Properties:**
- `id: UUID`
- `title: String` - Protocol name
- `category: ProtocolCategory` - Enum: `.assessment`, `.trauma`, `.medical`, `.environmental`, `.other`
- `severity: ProtocolSeverity` - Enum: `.critical`, `.urgent`, `.nonUrgent`, `.info`
- `steps: [ProtocolStep]` - Step-by-step instructions
- `warnings: [String]` - Important warnings
- `tips: [String]` - Helpful tips
- `isFavorite: Bool` - Favorite flag
- `orderIndex: Int`

**Supporting Types:**
- `ProtocolStep`
  - `stepNumber: Int`
  - `instruction: String`
  - `isImportant: Bool`

#### 6. WFRChapter (Legacy - for migration)
**Purpose:** Legacy chapter-based structure (being migrated to WFRModule)

**Properties:**
- `id: UUID`
- `title: String`
- `sections: [WFRSection]`
- `orderIndex: Int`

#### 7. AppSettings
**Purpose:** User preferences and app configuration

**Properties:**
- `hasCompletedOnboarding: Bool`
- `enableCloudSync: Bool`
- `autoSave: Bool`
- `defaultResponderInfo: ResponderInformation?`
- `themePreference: ThemePreference` - `.system`, `.light`, `.dark`

---

## 3. UI/UX REQUIREMENTS

### Design System

**Branding:**
- **App Name:** TrailTriage: WFR Toolkit
- **Developer:** Black Elk Mountain Medicine
- **Bundle ID:** `com.blackelkmountainmedicine.trailtriage`
- **Mascot:** Jimmothy the Raccoon WFR (appears in onboarding)

**Color Scheme:**
- Primary: Mountain/outdoor themed (blues, greens, earth tones)
- Dark mode support throughout
- High contrast for readability in various lighting conditions
- Accessibility: WCAG AA compliant

**Typography:**
- Primary font: San Francisco (SF Pro) - system default
- Monospace font for code/protocols
- Hierarchical sizing: Title, Headline, Body, Caption

**UI Patterns:**
- Card-based design for lists
- Consistent spacing (8pt grid system)
- Smooth animations and transitions
- Haptic feedback for important actions
- Large tap targets (minimum 44x44pt)

### Key Views Implementation

#### NotesListView
**Purpose:** Display all SOAP notes in a scrollable list

**Features:**
- List of SOAPNote cards showing:
  - Patient name (or "Patient #X")
  - Date created/modified
  - Chief complaint preview
  - Vital signs summary (latest readings)
- Search bar at top
- Filter options (date range, bookmarked, tags)
- Swipe actions: Delete, Bookmark, Share
- Pull-to-refresh
- Empty state message when no notes

**Code Structure:**
```swift
struct NotesListView: View {
    @Query(sort: \SOAPNote.dateModified, order: .reverse) private var notes: [SOAPNote]
    @State private var searchText = ""
    @State private var showNewNote = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNotes) { note in
                    SOAPNoteCardView(note: note)
                        .swipeActions {
                            // Delete, Bookmark, Share actions
                        }
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showNewNote = true } 
                    label: { Image(systemName: "plus") }
                }
            }
        }
    }
}
```

#### NewNoteView / NoteDetailView
**Purpose:** Create and edit SOAP notes

**Features:**
- Form-based layout with sections:
  - Patient Information (name, demographics)
  - S (Subjective) - large text area
  - O (Objective) - large text area
  - A (Assessment) - large text area
  - P (Plan) - large text area
  - Vital Signs Tracking Panel
  - Scene Information
  - Responder Information
- Auto-save functionality
- GPS location capture button
- SAMPLE history template
- OPQRST pain assessment tool
- Burn/frostbite documentation (Rule of 9s)
- Save/Cancel buttons
- PDF export option

**Vital Signs Panel:**
- Quick add button opens modal
- Timeline view showing all readings
- Visual trend indicators (if values improving/worsening)
- Color-coded alerts for abnormal values

#### ModuleListView
**Purpose:** Browse reference modules

**Features:**
- Card-based grid/list view
- Category filters (Patient Assessment, Environmental, Medical, Trauma)
- Search functionality
- Bookmark indicator
- Module preview with description
- Randomized location badges for scenarios
- Section count indicator

**Design:**
- Large, readable cards
- Category icons/colors
- Module icons (SF Symbols)
- Smooth navigation to ModuleDetailView

#### ModuleDetailView
**Purpose:** Display module content

**Features:**
- Module header with title, subtitle, category
- Location badge (if scenario-based)
- Scrollable content sections
- Content blocks rendered appropriately:
  - Headings (large, bold)
  - Paragraphs (readable line height)
  - Procedures (numbered steps)
  - Warnings (highlighted boxes)
  - Tips (info boxes)
  - Bulleted/Numbered lists
  - Tables (formatted)
- Bookmark button
- Share button
- Print option

#### OnboardingView
**Purpose:** First-time user experience

**Screens:**
1. **Welcome** - App icon, title, Jimmothy mascot
2. **Features Overview** - Key features with illustrations
3. **Sign In** - Sign in with Apple (optional, skip available)
4. **Subscription** - Paywall/subscription options
5. **Completion** - Celebration screen with Jimmothy

**Requirements:**
- Skip options for non-essential steps
- Clear progress indicator
- Smooth page transitions
- No DEBUG code in production build

---

## 4. DATA PERSISTENCE & SYNC

### SwiftData Configuration

**Model Container:**
- Schema includes all @Model classes
- Persistent storage location: App Documents directory
- CloudKit sync enabled (optional, user-controlled)

**ModelConfiguration:**
```swift
let schema = Schema([
    WFRProtocol.self,
    SOAPNote.self,
    VitalSigns.self,
    WFRModule.self,
    WFRModuleSection.self,
    WFRModuleContentBlock.self,
    WFRChapter.self, // Legacy
    WFRSection.self, // Legacy
    WFRContentBlock.self, // Legacy
])

let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false
)
```

### CloudKit Sync

**Implementation:**
- Use ModelContainer with CloudKit schema
- Automatic sync when enabled
- Conflict resolution: Last-write-wins
- User control via Settings > Advanced Settings

**Sync Scope:**
- SOAPNote: Sync enabled (with encryption)
- WFRModule: Sync reference content
- WFRProtocol: Sync reference protocols
- AppSettings: Local only

### Data Export

**ExportBackupView Features:**
- Export all notes as:
  - PDF (individual or combined)
  - CSV (structured data)
  - JSON (complete data structure)
- Share via Share Sheet
- Save to Files app
- Email export option

---

## 5. SUBSCRIPTION SYSTEM (StoreKit 2)

### Subscription Model

**Product Structure:**
- Product ID format: `com.blackelkmountainmedicine.trailtriage.subscription`
- Subscription group: Single group
- Free trial: 3 days (configurable)
- Pricing: Set in App Store Connect

### Implementation

**StoreManager:**
- Manages StoreKit 2 transactions
- Observes subscription status
- Handles purchase flow
- Validates receipts
- Provides subscription state to app

**PaywallView:**
- Displays subscription benefits
- Pricing information
- Purchase button
- Restore purchases option
- Terms of Service / Privacy Policy links

**Access Control:**
- Free tier: Limited notes (configurable limit)
- Premium: Unlimited notes, full reference access
- Grace period: Access continues during renewal failures

---

## 6. REFERENCE CONTENT SYSTEM

### Module Organization

**Categories:**
1. **Patient Assessment** - ABCDE, SAMPLE, OPQRST
2. **Environmental** - Hypothermia, heat illness, altitude
3. **Medical** - Cardiac, respiratory, diabetic emergencies
4. **Trauma** - Fractures, wounds, head injuries
5. **Other** - Evacuation, communication, special situations

### Content Structure

**Module → Section → ContentBlock hierarchy:**
- Each module contains multiple sections
- Each section contains multiple content blocks
- Content blocks can be: headings, paragraphs, procedures, warnings, tips, lists, tables

### Content Migration

**Legacy to Modern:**
- Old system: Chapter-based structure (WFRChapter)
- New system: Topic-based modules (WFRModule)
- Migration utility: `ModuleMigrationUtility.swift`
- Seed data: `ModuleSeedData.swift`

### Location Randomization

**Scenario Enhancement:**
- Utilities: `ParkLocations.swift` (US National/State Parks database)
- Utilities: `ScenarioRandomizer.swift` (randomly assign locations to scenarios)
- Purpose: Make content feel fresh for repeat users
- Implementation: Assign random park location to scenario-based modules

### OCR Content Extraction

**Scripts:**
- `extract_single_chapter.py` - PaddleOCR extraction script
- Processes chapter photos from `OldRefBook/` folder
- Outputs structured JSON and text files
- Image optimization: Resize to max 2000px width for speed

**Content Processing Pipeline:**
1. Extract text from book photos using PaddleOCR
2. Clean OCR text (fix common errors)
3. Update branding (Desert Mountain Medicine → Black Elk Mountain Medicine)
4. Convert SOAA'P to SOAPNote format
5. Randomize scenario locations
6. Organize into module structure
7. Seed into SwiftData

---

## 7. VITAL SIGNS TRACKING

### Features

**Tracking Capabilities:**
- Heart Rate (BPM)
- Respiratory Rate (breaths/min)
- Blood Pressure (Systolic/Diastolic)
- Oxygen Saturation (SpO2 %)
- Temperature (°F or °C)
- Glasgow Coma Scale (GCS)
- AVPU Level (Alert, Voice, Pain, Unresponsive)
- CSM Checks (Circulation, Sensation, Motion)
- SCTM Checks (Skin Color, Temperature, Moisture)

**UI Components:**
- `VitalSignsTracker` - Main tracking interface
- `QuickAddVitalsSheet` - Modal for quick entry
- `VitalsTimelineView` - Historical view of all readings
- `VitalsTrackingPanel` - Embedded panel in note view

**Features:**
- Timestamp for each reading
- Multiple readings per note (trending)
- Color-coded alerts for abnormal values
- Visual timeline with trend indicators
- Unit conversion (F/C, metric/imperial)

---

## 8. PDF EXPORT

### Implementation

**Formatter:**
- Uses `PCRFormatter` (PDF Creation & Rendering library)
- Custom formatting for medical documentation
- Professional layout for EMS handoff

**PDF Contents:**
- Patient demographics
- Complete SOAP note (S, O, A, P sections)
- Vital signs timeline
- Scene information
- Responder information
- GPS coordinates
- Date/time stamps
- Page numbers
- App branding (subtle)

**Export Options:**
- Individual note PDF
- Multiple notes combined PDF
- Share via Share Sheet
- Save to Files app
- Email attachment

---

## 9. SETTINGS & PREFERENCES

### SettingsView

**Sections:**
1. **Account**
   - Subscription status
   - Sign In with Apple
   - Cloud Sync toggle
   
2. **Preferences**
   - Auto-save toggle
   - Default responder info
   - Theme preference
   - Units (metric/imperial)
   
3. **Data Management**
   - Export/Backup
   - Advanced Settings
   - Cache management
   - Offline content
   
4. **About**
   - App version
   - Support/FAQ
   - Privacy Policy
   - Terms of Service
   - Credits

### AdvancedSettingsView

**Features:**
- Cache size display
- Clear cache button
- Offline content management
- Cloud sync status
- Debug info (if enabled)

---

## 10. ERROR HANDLING & EDGE CASES

### Error Handling Strategy

**Data Persistence:**
- Try-catch blocks around SwiftData operations
- Fallback to in-memory storage if disk fails
- User-friendly error messages

**CloudKit Sync:**
- Handle network errors gracefully
- Show sync status in UI
- Allow manual retry
- Continue offline if sync fails

**PDF Export:**
- Handle large documents (>100 pages)
- Progress indicators for long operations
- Error messages if export fails

**Subscription:**
- Handle purchase failures
- Validate receipts
- Show appropriate error messages
- Allow restore purchases

### Edge Cases

**Empty States:**
- No notes: Show helpful message with "Create Note" CTA
- No modules: Show loading state or error
- No search results: Show "No results found" message

**Offline Mode:**
- All features work offline
- Graceful degradation (no sync, but full functionality)
- Clear indicators when offline

**Large Datasets:**
- Pagination for notes list
- Lazy loading for modules
- Efficient queries with predicates

---

## 11. TESTING REQUIREMENTS

### Test Cases

**SOAP Note Creation:**
1. Create new note with all fields
2. Add multiple vital sign readings
3. Save and verify persistence
4. Edit existing note
5. Delete note
6. Search for note
7. Bookmark note

**Reference System:**
1. Browse modules by category
2. Search modules
3. View module detail
4. Bookmark module
5. Navigate sections and content blocks

**Export:**
1. Export single note as PDF
2. Export multiple notes as PDF
3. Export as CSV
4. Export as JSON
5. Share via Share Sheet
6. Save to Files app

**Subscription:**
1. Purchase subscription
2. Restore purchases
3. Handle purchase failure
4. Verify access control

### Sample Data

**Test Notes:**
- At least 10 sample SOAP notes
- Various scenarios (trauma, medical, environmental)
- Different vital sign patterns
- Various completion states

**Test Modules:**
- Sample modules for each category
- Various content block types
- Test search functionality

---

## 12. OPTIMIZATION STRATEGIES

### Performance

**SwiftData Queries:**
- Use predicates for filtering
- Limit fetch results with pagination
- Index frequently searched fields

**UI Optimization:**
- Lazy loading for lists
- Image caching
- Debounced search

**Memory Management:**
- Efficient image handling (resize before storage)
- Clear temporary files
- Monitor memory usage

### Cost Optimization

**CloudKit:**
- Minimize sync operations
- Batch updates
- User-controlled sync (opt-in)

**Subscription:**
- Clear value proposition
- Reasonable pricing
- Free trial to reduce friction

### Scalability

**Content Growth:**
- Modular content structure
- Efficient search indexing
- Pagination for large lists

**User Base:**
- CloudKit handles scaling automatically
- Local-first architecture reduces server load

---

## 13. DEPLOYMENT CHECKLIST

### Pre-Launch

- [ ] All features implemented and tested
- [ ] Reference content migrated and seeded
- [ ] Subscription products configured in App Store Connect
- [ ] Privacy Policy and Terms of Service published
- [ ] App Store assets prepared (screenshots, descriptions)
- [ ] No DEBUG code in production build
- [ ] Error handling comprehensive
- [ ] Offline functionality verified
- [ ] CloudKit sync tested
- [ ] PDF export verified
- [ ] Accessibility tested

### App Store Connect

- [ ] App metadata completed
- [ ] Screenshots uploaded (all required sizes)
- [ ] App preview video (optional)
- [ ] Privacy Policy URL set
- [ ] Terms of Service URL set
- [ ] Age rating configured
- [ ] App categories selected
- [ ] Keywords optimized
- [ ] Support URL configured

### Code Signing

- [ ] Provisioning profiles set up
- [ ] Certificates valid
- [ ] Bundle identifier configured
- [ ] Capabilities enabled (CloudKit, Sign in with Apple)
- [ ] Entitlements configured

---

## 14. PROMPTS & TEMPLATES

### SOAP Note Templates

**Standard Template:**
```
S (Subjective):
- Chief Complaint:
- History of Present Illness:
- SAMPLE History:
  - Signs/Symptoms:
  - Allergies:
  - Medications:
  - Past Medical History:
  - Last Oral Intake:
  - Events Leading Up:

O (Objective):
- Vital Signs: [see vital signs panel]
- Physical Examination:
- CSM Checks:
- SCTM Checks:
- AVPU/GCS:

A (Assessment):
- Primary Assessment:
- Secondary Assessment:
- Differential Diagnoses:

P (Plan):
- Immediate Interventions:
- Continued Monitoring:
- Evacuation Decision:
- Transport Priority:
```

### Module Content Templates

**Procedure Block:**
```json
{
  "type": "procedure",
  "title": "Primary Assessment - ABCDE",
  "steps": [
    {"number": 1, "text": "Assess Airway...", "important": true},
    {"number": 2, "text": "Check Breathing...", "important": true}
  ]
}
```

**Warning Block:**
```json
{
  "type": "warning",
  "title": "Critical Warning",
  "content": "Do not move patient if spinal injury suspected"
}
```

---

## 15. FILE STRUCTURE

```
WFR TrailTriage/
│
├── App/
│   ├── WFR_TrailTriageApp.swift          # Main app entry point
│   └── MainTabView.swift                  # Root navigation
│
├── Models/
│   ├── SOAPNote.swift                     # Core note model
│   ├── WFRModule.swift                    # Reference modules
│   ├── WFRProtocol.swift                  # Medical protocols
│   ├── WFRChapter.swift                   # Legacy chapters
│   └── AppSettings.swift                  # User preferences
│
├── Views/
│   ├── Notes/
│   │   ├── NotesListView.swift
│   │   ├── NewNoteView.swift
│   │   ├── NoteDetailView.swift
│   │   ├── ExpertModeNoteView.swift
│   │   ├── SOAPNoteCardView.swift
│   │   └── PatientTransferDocumentView.swift
│   │
│   ├── Reference/
│   │   ├── ModuleListView.swift
│   │   ├── ModuleDetailView.swift
│   │   ├── GlossaryView.swift
│   │   └── ReferenceBookTitlePageView.swift
│   │
│   ├── Vitals/
│   │   ├── VitalSignsTracker.swift
│   │   ├── VitalsTimelineView.swift
│   │   ├── VitalsTrackingPanel.swift
│   │   └── QuickAddVitalsSheet.swift
│   │
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── PreferencesView.swift
│   │   ├── ExportBackupView.swift
│   │   ├── AdvancedSettingsView.swift
│   │   └── AboutView.swift
│   │
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   │
│   └── Subscription/
│       ├── PaywallView.swift
│       └── SubscriptionStatusView.swift
│
├── Services/
│   ├── StoreManager.swift                 # StoreKit 2 subscription management
│   ├── SubscriptionManager.swift          # Subscription state management
│   └── LocationManager.swift              # GPS location services
│
├── Utilities/
│   ├── ParkLocations.swift                # US National/State Parks database
│   ├── ScenarioRandomizer.swift           # Location randomization
│   ├── ModuleMigrationUtility.swift       # Legacy to modern migration
│   ├── ModuleSeedData.swift               # Seed reference content
│   └── Theme.swift                        # Color/design system
│
├── Extensions/
│   ├── Color+Design.swift                 # Color extensions
│   └── Date+Formatting.swift              # Date formatting utilities
│
└── Resources/
    ├── Assets.xcassets/                   # Images, icons
    ├── Info.plist                         # App configuration
    └── WFR TrailTriage.entitlements       # Capabilities
```

---

## 16. IMPLEMENTATION PRIORITY

### Phase 1: Core Functionality
1. SwiftData model setup
2. SOAP note creation/editing
3. Basic notes list view
4. Data persistence

### Phase 2: Reference System
1. Module data model
2. Module list and detail views
3. Content rendering (all block types)
4. Search and filtering

### Phase 3: Enhanced Features
1. Vital signs tracking
2. PDF export
3. CloudKit sync
4. Advanced note editing

### Phase 4: Polish
1. Onboarding flow
2. Subscription system
3. Settings and preferences
4. Export/backup

### Phase 5: Content Migration
1. OCR extraction scripts
2. Content processing pipeline
3. Module seeding
4. Location randomization

---

## 17. BRANDING & COPY

### Brand Voice
- Professional but approachable
- Field-tested and practical
- Respectful of medical seriousness
- Empowering for responders

### Key Messages
- "Professional documentation in the palm of your hand"
- "Built by practitioners, for practitioners"
- "100% offline - works anywhere"
- "Essential tool for wilderness medicine professionals"

### Mascot: Jimmothy the Raccoon WFR
- Friendly, helpful character
- Appears in onboarding
- Represents the app's personality
- Professional yet approachable

---

## 18. CONSTRAINTS & CONSIDERATIONS

### Technical Constraints
- iOS 17.0+ requirement
- Swift 6.0 language features
- SwiftUI (not UIKit)
- SwiftData (not Core Data)
- StoreKit 2 (not StoreKit 1)

### Medical/Legal Constraints
- Educational tool disclaimer
- Not a replacement for training
- HIPAA-aware design (local storage, optional encryption)
- Professional standards for documentation
- Evidence-based protocols only

### Design Constraints
- Must work in outdoor lighting conditions
- High contrast for readability
- Large tap targets for gloved use
- Battery-efficient for extended use

---

## 19. SUCCESS CRITERIA

### Functional Requirements
✅ All core features work offline
✅ SOAP notes save and persist correctly
✅ Reference content loads and displays
✅ PDF export generates correctly
✅ CloudKit sync works (when enabled)
✅ Subscription system functions
✅ Onboarding guides new users

### Quality Requirements
✅ No crashes in normal use
✅ Smooth animations and transitions
✅ Responsive UI (<100ms feedback)
✅ Accessible (VoiceOver, Dynamic Type)
✅ Professional appearance
✅ Fast load times (<2s initial load)

### Content Requirements
✅ 80+ hours of WFR curriculum available
✅ Protocols organized by category
✅ Search works across all content
✅ Content updates maintain structure

---

## 20. MAINTENANCE & UPDATES

### Content Updates
- Add new modules via seed data
- Update existing modules
- Add new protocols
- Expand glossary

### Feature Updates
- User feedback integration
- New documentation features
- Enhanced export options
- Additional reference content types

### Technical Updates
- iOS version compatibility
- Swift language updates
- Framework updates
- Security patches

---

# FINAL CHECKLIST FOR RECREATION

When building this app, ensure:

1. ✅ All models defined with proper SwiftData annotations
2. ✅ Navigation structure matches MainTabView specification
3. ✅ All views implement required features
4. ✅ Offline functionality verified
5. ✅ CloudKit sync optional and user-controlled
6. ✅ Subscription system integrated
7. ✅ PDF export professional quality
8. ✅ Vital signs tracking comprehensive
9. ✅ Reference content system modular
10. ✅ Onboarding flow complete
11. ✅ Settings comprehensive
12. ✅ Error handling robust
13. ✅ Accessibility implemented
14. ✅ Dark mode support
15. ✅ Performance optimized
16. ✅ No DEBUG code in production
17. ✅ App Store assets prepared
18. ✅ Privacy policy published
19. ✅ Terms of service published
20. ✅ Ready for App Store submission

---

**This mega prompt contains everything needed to recreate WFR TrailTriage from scratch. Use it as a complete specification document for AI-assisted development or team onboarding.**

---

*Generated: November 22, 2025*  
*App Version: 1.0 (Pre-Launch)*  
*Black Elk Mountain Medicine*

