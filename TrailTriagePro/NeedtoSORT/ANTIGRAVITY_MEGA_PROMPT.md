# 🏔️ WFR TrailTriage - Google Antigravity Mega Prompt
## Complete App Recreation with Nano Banana Pro + Gemini 3

**Platform:** Google Antigravity IDE  
**AI Agents:** Gemini 3 (powered by Gemini Advanced/Pro/Ultra) + Nano Banana Pro  
**Project:** TrailTriage: WFR Toolkit  
**Developer:** BlackElkMountainMedicine.com  
**Mascot:** 🦝 Jimmothy the Raccoon WFR  
**Date:** November 22, 2025

---

## ⚙️ ANTIGRAVITY PROJECT SETUP

### Google Cloud Project Configuration

**Project Details:**
- **Project Name:** TrailTriage-Pro
- **Project Number:** 128146934504
- **Project ID:** gen-lang-client-0212454764

**Setup Steps:**

1. **Link Project in Antigravity IDE**
   - Open Antigravity IDE (antigravity.google)
   - Go to Settings → Project Settings
   - Link your Google Cloud Project:
     - Project ID: `gen-lang-client-0212454764`
     - Project Number: `128146934504`
   - This enables Nano Banana Pro access and proper billing

2. **Enable Required APIs** (in Google Cloud Console)
   - Navigate to: https://console.cloud.google.com/apis/library
   - Enable these APIs:
     - **Generative Language API** (for Gemini 3)
     - **AI Platform API** (for Nano Banana Pro)
     - **Vertex AI API** (for advanced features)
   - Ensure billing is enabled for the project

3. **Verify Nano Banana Pro Access**
   - In Antigravity, go to Tools → AI Agents
   - Check that Nano Banana Pro shows as available
   - Free tier: Limited quota
   - Paid tier (Google AI Pro/Ultra): Higher limits, watermark-free, 4K mode

4. **Set Default Project** (in Antigravity)
   - Agent settings should use: `gen-lang-client-0212454764`
   - This ensures all AI calls (Gemini + Nano Banana Pro) use your project

### Antigravity IDE Configuration

**Recommended Settings:**
- **Default LLM:** Gemini 3 (Advanced/Pro/Ultra recommended)
- **Nano Banana Pro:** Enabled
- **Auto-call Nano Banana:** Yes (for image generation)
- **Project:** gen-lang-client-0212454764

---

## 🎯 USE CASE: Build Complete iOS App Using Antigravity's Seamless AI Integration

You are working inside **Google Antigravity IDE** (antigravity.google), where Gemini 3 coding agents can call Nano Banana Pro on-the-fly for image generation while building complete applications. This is a seamless, integrated workflow - you don't need to switch tools or apps.

**Your Mission:** Build the complete **TrailTriage: WFR Toolkit** iOS app - a professional wilderness medicine documentation and reference application for certified Wilderness First Responders (WFRs).

**Special Requirement:** Use Nano Banana Pro extensively to generate UI assets, mockups, icons, mascot imagery, and visual elements while building the code with Gemini 3.

---

## 📋 COMPLETE APP SPECIFICATION

### App Purpose & Vision

**TrailTriage: WFR Toolkit** is a professional iOS application that enables certified Wilderness First Responders to:
1. Create professional SOAP note documentation (Subjective, Objective, Assessment, Plan)
2. Track vital signs over time with detailed timestamping
3. Access 80+ hours of WFR curriculum reference materials
4. Export professional PDFs for EMS handoff
5. Work 100% offline in backcountry environments

**Critical Requirements:**
- ✅ **100% Offline Functionality** - All features work without internet (essential for backcountry use)
- ✅ **Professional Medical Standards** - Industry-standard SOAP format, HIPAA-aware design
- ✅ **Privacy-First** - Local storage with optional CloudKit sync (user-controlled)
- ✅ **Built by Practitioners** - Created by a volunteer SAR member for real-world field use

### Branding & Identity

**App Name:** TrailTriage: WFR Toolkit  
**Developer:** BlackElkMountainMedicine.com  
**Bundle ID:** `com.blackelkmountainmedicine.trailtriage`  
**Mascot:** 🦝 Jimmothy the Raccoon WFR

**Jimmothy's Character:**
- **Name:** Jimmothy the Raccoon WFR (Wilderness First Responder)
- **Personality:** Helpful, enthusiastic, slightly mischievous, always prepared
- **Role:** Brand mascot appearing in onboarding, empty states, success messages
- **Voice:** Enthusiastic but professional, encouraging, occasionally makes gentle wilderness medicine puns
- **Mission:** Advocate for proper documentation, SOAP notes, and always having protocols handy

**Example Jimmothy Messages:**
- "🦝 Jimmothy approves this documentation! Your PDF is ready to share."
- "Jimmothy says: Don't forget to document those vitals!"
- "Jimmothy reminds you: A good SOAP note saves lives"
- "🦝 Certified by Jimmothy: Your documentation game is strong"

---

## 🎨 NANO BANANA PRO INTEGRATION STRATEGY

### When to Use Nano Banana Pro (On-the-Fly Generation)

**1. UI Assets & Icons**
- Generate app icon concepts (mountain/medical theme)
- Create SF Symbols alternatives when needed
- Design custom icons for categories (Patient Assessment, Environmental, Medical, Trauma)
- Generate mascot assets: Jimmothy in various poses (waving, dabbing, celebrating)

**2. Mockups & Wireframes**
- Create high-fidelity UI mockups before coding
- Generate screenshots of completed screens for documentation
- Design onboarding flow mockups
- Create reference book cover page designs

**3. Visual Elements**
- Generate illustrations for empty states
- Create background patterns/textures
- Design card backgrounds with subtle imagery
- Generate scene/environment illustrations for scenarios

**4. Branding Assets**
- Create Jimmothy mascot variations (different poses, expressions)
- Generate promotional images for App Store
- Design logo concepts and brand elements
- Create tutorial/demo imagery

### Nano Banana Pro Prompt Examples for This Project

**Mascot Generation:**
```
"Generate a photorealistic image of a friendly raccoon wearing a wilderness first responder uniform, holding a clipboard with a SOAP note. The raccoon should be waving at the camera with enthusiasm. Style: professional medical illustration with outdoor mountain backdrop. Include the text 'TrailTriage' subtly in the background. 4K resolution, perfect lighting, realistic shadows."
```

**UI Mockup Generation:**
```
"Create a high-fidelity iOS app mockup showing a SOAP note documentation screen. The design should be modern SwiftUI style with rounded cards, SF Symbols icons, and professional medical color scheme (blues and greens). Include placeholder text showing S-O-A-P sections. Style: clean, professional, accessible. Perfect text rendering, realistic device frame, 4K resolution."
```

**Empty State Illustration:**
```
"Design an empty state illustration for a wilderness medicine app. Show a friendly raccoon character (Jimmothy) sitting next to an empty notebook with the message 'No SOAP Notes Yet - Let's Create Your First!' Style: encouraging, professional medical illustration. Include mountain/forest elements subtly in background. 4K resolution, perfect composition."
```

### Antigravity Workflow Pattern

1. **Plan Feature** (Gemini 3)
   - "I need to build the SOAP note creation screen. First, let me generate a mockup with Nano Banana Pro to visualize the design."

2. **Generate Assets** (Nano Banana Pro - called automatically by Gemini)
   - Agent automatically invokes Nano Banana Pro: "Generate high-fidelity iOS SOAP note screen mockup..."
   - Shows generated image inline for approval

3. **Build Code** (Gemini 3)
   - "Perfect! Now I'll implement this in SwiftUI, matching the mockup exactly."
   - Writes complete SwiftUI code

4. **Refine Iteratively** (Both tools working together)
   - "The save button needs a different icon. Generate an SF Symbol style checkmark icon with Nano Banana Pro."
   - "Now update the code to use the new icon."

---

## 🏗️ COMPLETE ARCHITECTURE & IMPLEMENTATION

### Platform & Technology Stack

**Platform:** iOS 17.0+  
**Language:** Swift 6.0  
**Frameworks:** SwiftUI, SwiftData, StoreKit 2, UserNotifications, CloudKit  
**Architecture:** MVVM with Observable State Management  
**IDE:** Xcode 15.0+  

### File Structure (REQUIRED)

```
WFR TrailTriage/
├── App/
│   ├── WFR_TrailTriageApp.swift          # Main app entry point
│   └── MainTabView.swift                  # Root navigation
│
├── Models/
│   ├── SOAPNote.swift                     # Core SOAP note model
│   ├── WFRModule.swift                    # Reference modules
│   ├── WFRProtocol.swift                  # Medical protocols
│   ├── WFRChapter.swift                   # Legacy chapters (migration)
│   └── AppSettings.swift                  # User preferences
│
├── Views/
│   ├── Notes/
│   │   ├── NotesListView.swift            # List all SOAP notes
│   │   ├── NewNoteView.swift              # Create new note
│   │   ├── NoteDetailView.swift           # View/edit note
│   │   ├── ExpertModeNoteView.swift       # Advanced editing
│   │   ├── SOAPNoteCardView.swift         # Note card component
│   │   └── PatientTransferDocumentView.swift  # PDF export
│   │
│   ├── Reference/
│   │   ├── ModuleListView.swift           # Browse modules
│   │   ├── ModuleDetailView.swift         # View module content
│   │   ├── GlossaryView.swift             # Medical terms
│   │   └── ReferenceBookTitlePageView.swift  # Cover page
│   │
│   ├── Vitals/
│   │   ├── VitalSignsTracker.swift        # Main tracker
│   │   ├── VitalsTimelineView.swift       # Historical view
│   │   ├── VitalsTrackingPanel.swift      # Embedded panel
│   │   └── QuickAddVitalsSheet.swift      # Quick entry modal
│   │
│   ├── Settings/
│   │   ├── SettingsView.swift             # Main settings
│   │   ├── PreferencesView.swift          # App preferences
│   │   ├── ExportBackupView.swift         # Data export
│   │   ├── AdvancedSettingsView.swift     # Cache, offline content
│   │   └── AboutView.swift                # App info, support
│   │
│   ├── Onboarding/
│   │   └── OnboardingView.swift           # First-time user flow
│   │
│   └── Subscription/
│       ├── PaywallView.swift              # Subscription offer
│       └── SubscriptionStatusView.swift   # Subscription status
│
├── Services/
│   ├── StoreManager.swift                 # StoreKit 2 management
│   ├── SubscriptionManager.swift          # Subscription state
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
│   └── Date+Formatting.swift              # Date utilities
│
└── Resources/
    ├── Assets.xcassets/                   # Images, icons (include Nano Banana generated assets)
    ├── Info.plist                         # App configuration
    └── WFR TrailTriage.entitlements       # Capabilities (CloudKit, Sign in with Apple)
```

### Mandatory File Header (Every Swift File)

```swift
//  FileName.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on [Date]
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: [One-line description of file's purpose]
//
```

**Examples:**
- View: `🦝 Jimmothy Approved: Professional SOAP note creation and editing!`
- Model: `🦝 Jimmothy Approved: Core SOAP note data model for wilderness medicine documentation!`
- Service: `🦝 Jimmothy Approved: StoreKit 2 purchase management for subscriptions and lifetime access!`

---

## 📱 DATA MODELS (SwiftData @Model)

### Core Models

#### 1. SOAPNote
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
    
    // Supporting embedded types:
    // - VitalSigns (HR, RR, BP, SpO2, Temp, GCS, AVPU, CSM, SCTM)
    // - LocationData (GPS coordinates, altitude, address)
    // - SceneInformation (MOI, environment, weather, terrain)
    // - PatientDemographics (age, sex, chief complaint, allergies, medications)
    // - ResponderInformation (name, certification, agency)
}
```

#### 2. WFRModule (Modern Topic-Based Reference)
```swift
@Model
final class WFRModule {
    var id: UUID
    var moduleTitle: String
    var moduleSubtitle: String?
    var category: ModuleCategory  // .patientAssessment, .environmental, .medical, .trauma, .other
    var iconName: String?  // SF Symbol or custom icon
    var description: String?
    var sections: [WFRModuleSection]  // One-to-many relationship
    var orderIndex: Int
    var isBookmarked: Bool
    var location: String?  // Randomized park location for scenarios
}
```

#### 3. WFRModuleSection
```swift
@Model
final class WFRModuleSection {
    var id: UUID
    var sectionTitle: String
    var content: [WFRModuleContentBlock]  // One-to-many relationship
    var orderIndex: Int
}
```

#### 4. WFRModuleContentBlock
```swift
@Model
final class WFRModuleContentBlock {
    var id: UUID
    var type: ContentBlockType  // .heading, .paragraph, .procedure, .warning, .tip, .bulletedList, .numberedList, .table, .image
    var content: String
    var orderIndex: Int
    var metadata: String?  // JSON string for tables, lists
}
```

#### 5. WFRProtocol (Quick Reference)
```swift
@Model
final class WFRProtocol {
    var id: UUID
    var title: String
    var category: ProtocolCategory  // .assessment, .trauma, .medical, .environmental, .other
    var severity: ProtocolSeverity  // .critical, .urgent, .nonUrgent, .info
    var steps: [ProtocolStep]
    var warnings: [String]
    var tips: [String]
    var isFavorite: Bool
    var orderIndex: Int
}
```

### SwiftData Configuration

```swift
let schema = Schema([
    WFRProtocol.self,
    SOAPNote.self,
    VitalSigns.self,
    WFRModule.self,
    WFRModuleSection.self,
    WFRModuleContentBlock.self,
    WFRChapter.self,  // Legacy support
    WFRSection.self,  // Legacy support
    WFRContentBlock.self,  // Legacy support
])

let modelConfiguration = ModelConfiguration(
    schema: schema,
    isStoredInMemoryOnly: false
)
```

---

## 🎨 UI/UX DESIGN SYSTEM

### Design Philosophy

**Jimmothy's Golden Rule:** "If it doesn't look like it belongs in iOS 18, we rebuild it until it does! 🦝"

### Modern SwiftUI Patterns

**Card-Based Layout (Foundation):**
```swift
VStack(alignment: .leading, spacing: 12) {
    // Header with icon
    HStack {
        Image(systemName: icon)
            .foregroundStyle(color)
        Text(title)
            .font(.headline)
        Spacer()
    }
    
    // Content
    VStack(alignment: .leading, spacing: 8) {
        // Your content here
    }
}
.padding()
.background(color.opacity(0.05))
.cornerRadius(12)
```

### Design Tokens

**Color Semantic Mapping:**
- `.blue` - Primary actions, information, navigation
- `.green` - Success, active states, treatment
- `.red` - Critical, danger, complaints, heart rate
- `.orange` - Warnings, urgent items, temperature
- `.purple` - Blood pressure, specialized vitals
- `.cyan` - Respiratory rate, secondary vitals

**Spacing Scale:**
- 4pt - Tight internal spacing
- 8pt - Within-card spacing
- 12pt - Between related elements
- 16pt - Standard section spacing (DEFAULT)
- 24pt - Major section breaks

**Corner Radius:**
- 8pt - Small elements (badges, pills)
- 10pt - Medium buttons, inputs
- 12pt - Standard cards (DEFAULT)
- 16pt - Large hero sections

**Typography Hierarchy:**
- `.title.bold()` - Page headers, hero text
- `.headline` - Section titles, card headers
- `.subheadline` - Supporting text, metadata
- `.body` - Main content text
- `.caption` - Labels, footnotes

### Nano Banana Pro Usage for UI Design

**Before Coding Each Screen:**
1. Generate high-fidelity mockup with Nano Banana Pro
2. Show mockup to user for approval
3. Code the SwiftUI implementation to match mockup exactly
4. Generate screenshot comparison to verify match

**Example Workflow:**
```
Gemini 3 Agent: "I need to build the ModuleListView. Let me first generate a mockup showing the card-based module list with category filters."

[Agent automatically calls Nano Banana Pro]

Nano Banana Pro: [Generates mockup showing modern SwiftUI module list with:
- Rounded cards for each module
- Category icons (SF Symbols style)
- Search bar at top
- Category filter chips
- Bookmark indicators
- Professional medical color scheme]

Gemini 3 Agent: "Perfect! Now I'll implement this in SwiftUI code, matching the mockup exactly."

[Agent writes complete SwiftUI code]
```

---

## 🔑 KEY FEATURES TO IMPLEMENT

### 1. SOAP Note Documentation System

**Requirements:**
- Create, edit, delete SOAP notes
- Full S-O-A-P sections (Subjective, Objective, Assessment, Plan)
- Multiple vital sign readings per note with timestamps
- GPS location capture
- Scene information (MOI, environment, weather, terrain)
- Patient demographics (age, sex, chief complaint, allergies, medications)
- Responder information (name, certification, agency)
- Bookmarks, tags, search functionality
- Auto-save and manual save
- PDF export for EMS handoff

**Nano Banana Pro Assets Needed:**
- SOAP note form mockup
- Patient information card design
- Vital signs panel mockup
- PDF template design

### 2. Vital Signs Tracking

**Requirements:**
- Record: Heart Rate, Respiratory Rate, Blood Pressure (Systolic/Diastolic), Oxygen Saturation, Temperature, Glasgow Coma Scale, AVPU Level, CSM Checks (Circulation, Sensation, Motion), SCTM Checks (Skin Color, Temperature, Moisture)
- Timeline view showing all readings chronologically
- Visual trend indicators (improving/worsening)
- Color-coded alerts for abnormal values
- Quick-add modal for rapid entry

**Nano Banana Pro Assets Needed:**
- Vital signs timeline visualization mockup
- Quick-add modal design
- Trend indicator graphics

### 3. Reference Module System

**Requirements:**
- Topic-based modules (replacing chapter-based structure)
- Categories: Patient Assessment, Environmental, Medical, Trauma, Other
- Module → Section → ContentBlock hierarchy
- Content block types: heading, paragraph, procedure, warning, tip, bulletedList, numberedList, table
- Search across all modules
- Category filtering
- Bookmarks
- Randomized park locations for scenarios

**Nano Banana Pro Assets Needed:**
- Module list card design
- Module detail page layout
- Content block rendering examples
- Category icons
- Book cover page design

### 4. Onboarding Flow

**Requirements:**
- Welcome screen with app icon and Jimmothy mascot
- Feature overview with illustrations
- Sign in with Apple (optional, can skip)
- Subscription check/paywall
- Completion celebration with Jimmothy

**Nano Banana Pro Assets Needed:**
- Jimmothy mascot in various poses (waving, dabbing, celebrating)
- Onboarding screen mockups
- Feature illustration graphics
- Completion celebration animation mockup

### 5. PDF Export System

**Requirements:**
- Professional PDF generation using PCRFormatter
- Export single note or multiple notes
- Includes: Patient demographics, complete SOAP note, vital signs timeline, scene information, responder info, GPS coordinates, timestamps
- Share via Share Sheet, save to Files app, email attachment

**Nano Banana Pro Assets Needed:**
- PDF template design
- Professional medical report layout

---

## 📋 STANDARD OPERATING PROCEDURES (SOP)

### Code Standards

**Naming Conventions:**
- App Name: "TrailTriage: WFR Toolkit" (full) or "TrailTriage" (short)
- Developer: "BlackElkMountainMedicine.com"
- Jimmothy: "Jimmothy the Raccoon WFR" (full) or "Jimmothy" (short)
- Types: PascalCase (`SOAPNote`, `VitalSignsTracker`)
- Properties: camelCase (`patientName`, `isCompleted`)
- Functions: camelCase with verb (`exportAsText()`, `checkiCloudStatus()`)

**SwiftUI Conventions:**
- `@State` - view-local state
- `@Binding` - passed state
- `@Environment` - shared environment objects
- `@Query` - SwiftData queries
- `@Observable` - settings and managers
- `@Model` - SwiftData models

**MARK Comments (Required):**
```swift
// MARK: - Initialization
// MARK: - Public Methods
// MARK: - Private Helpers
// MARK: - Jimmothy's Special Features
// MARK: - Protocol Conformance
// MARK: - Preview
```

### Documentation Requirements

**Function Documentation:**
```swift
/// Generates a professional SOAP note PDF for EMS handoff
///
/// Jimmothy's Note: This ensures your documentation meets professional
/// standards and includes all required information for proper patient care continuity.
///
/// - Parameters:
///   - soapNote: The SOAP note to convert to PDF format
///   - includeVitals: Whether to include vital signs trending graphs
/// - Returns: A shareable PDF document ready for export
/// - Throws: `PDFGenerationError` if rendering fails
func generateSOAPNotePDF(from soapNote: SOAPNote, includeVitals: Bool = true) throws -> PDFDocument
```

### Jimmothy Integration Rules

**✅ Include Jimmothy In:**
- Empty states
- Onboarding
- Success messages
- Tips & hints
- Error recovery
- Loading states

**❌ Don't Include Jimmothy In:**
- Critical error messages
- HIPAA/Legal content
- Patient data display
- Emergency instructions

### Performance Standards

**Jimmothy's Rule:** "If it takes longer than 'one Mississippi, two Mississippi, three Mississippi,' it's too slow for emergency use."

- App launch: < 2 seconds
- Note creation: < 1 second
- PDF generation: < 3 seconds
- Protocol search: < 0.5 seconds

### Offline Capability

**Jimmothy's Rule:** "If you can't use it at 10,000 feet with no cell service, it's not ready for the backcountry."

- All core features must work offline
- Protocols must be locally cached
- Notes must be created without connectivity
- Sync should happen automatically when online

---

## 🚀 STEP-BY-STEP IMPLEMENTATION IN ANTIGRAVITY

### Phase 1: Setup & Foundation

1. **Create Xcode Project**
   - Project name: "WFR TrailTriage"
   - Bundle ID: `com.blackelkmountainmedicine.trailtriage`
   - Minimum iOS: 17.0
   - Language: Swift 6.0
   - UI Framework: SwiftUI

2. **Generate App Icon with Nano Banana Pro**
   ```
   "Create a professional iOS app icon for 'TrailTriage: WFR Toolkit' - a wilderness medicine app. Design should combine mountain/outdoor elements with medical symbols. Color scheme: blues and greens. Style: modern, professional, medical. Must look good at all sizes (29pt to 1024pt). 4K resolution, perfect rendering."
   ```

3. **Set Up SwiftData Models**
   - Create all model files with proper headers
   - Implement SwiftData @Model classes
   - Set up ModelContainer in app entry point

4. **Create Basic Navigation**
   - Implement MainTabView with 4 tabs: Notes, Reference, Protocols, Settings
   - Set up navigation structure

### Phase 2: Core Features

5. **SOAP Note System** (Use Nano Banana Pro for mockups first)
   - Generate SOAP note form mockup
   - Implement NotesListView
   - Implement NewNoteView/NoteDetailView
   - Add vital signs tracking panel
   - Implement save/delete/search

6. **Reference Module System** (Generate mockups before coding)
   - Generate module list mockup
   - Implement ModuleListView
   - Implement ModuleDetailView
   - Add search and filtering

7. **Vital Signs Tracking** (Visualize before coding)
   - Generate timeline visualization mockup
   - Implement VitalSignsTracker
   - Implement VitalsTimelineView
   - Add quick-add modal

### Phase 3: Enhanced Features

8. **Onboarding Flow** (Generate all assets with Nano Banana Pro)
   - Generate Jimmothy mascot assets (waving, dabbing, celebrating)
   - Generate onboarding screen mockups
   - Implement OnboardingView
   - Add feature overview graphics

9. **PDF Export** (Design template first)
   - Generate PDF template design
   - Implement PDF generation
   - Add export/share functionality

10. **Subscription System**
    - Implement StoreManager (StoreKit 2)
    - Implement PaywallView
    - Add subscription status management

### Phase 4: Polish & Content

11. **Settings & Preferences**
    - Implement SettingsView
    - Implement ExportBackupView
    - Implement AdvancedSettingsView

12. **Content Seeding**
    - Set up module seed data
    - Implement location randomization
    - Add reference content

13. **Final Polish**
    - Dark mode support
    - Accessibility (VoiceOver, Dynamic Type)
    - Performance optimization
    - Error handling
    - Testing

---

## 🎯 ANTIGRAVITY-SPECIFIC INSTRUCTIONS

### Working with Gemini 3 + Nano Banana Pro

**Prerequisites:**
- Ensure Antigravity project is linked: `gen-lang-client-0212454764`
- Verify Nano Banana Pro access in Agent Settings
- Confirm billing is enabled for Nano Banana Pro quota

**Seamless Integration Pattern:**
1. **Agent Plans:** "I need to build [feature]. First, let me visualize the design."
2. **Auto-Calls Nano Banana Pro:** Agent automatically invokes Nano Banana Pro using your project (`gen-lang-client-0212454764`)
3. **Shows Results:** Generated images appear inline for approval
4. **Builds Code:** Agent writes complete Swift code matching mockups
5. **Iterates:** Agent can refine both images and code in same conversation

**Project Context for Agent:**
When starting a new session in Antigravity, inform the agent:
```
"This project uses Google Cloud Project ID: gen-lang-client-0212454764. 
Use Nano Banana Pro for all UI mockups and asset generation. 
Project name: TrailTriage-Pro"
```

**Example Agent Conversation Flow:**
```
You (User): "Build the SOAP note creation screen"

Agent (Gemini 3): "I'll build the SOAP note creation screen. Let me first generate a high-fidelity mockup using Nano Banana Pro to visualize the design."

[Agent automatically calls Nano Banana Pro]

Nano Banana Pro: [Generates mockup showing:
- Modern SwiftUI form layout
- S-O-A-P sections with clear labels
- Vital signs panel on the side
- Professional medical color scheme
- Jimmothy mascot in corner encouraging user]

Agent: "Perfect! I've generated the mockup. Now I'll implement this in SwiftUI code, matching the design exactly."

[Agent writes complete SwiftUI code for NewNoteView]
```

### Nano Banana Pro Asset Generation Checklist

For each major UI component, generate:
- [ ] High-fidelity mockup (4K resolution)
- [ ] Icon concepts (if needed)
- [ ] Empty state illustrations (if applicable)
- [ ] Loading state graphics (if applicable)
- [ ] Error state graphics (if applicable)

### Code Generation Standards

**Every file must:**
- ✅ Include proper file header with Jimmothy approval
- ✅ Follow naming conventions
- ✅ Include MARK comments
- ✅ Have function documentation
- ✅ Support dark mode
- ✅ Be accessible (VoiceOver, Dynamic Type)
- ✅ Work offline

---

## ✅ SUCCESS CRITERIA

### Functional Requirements
- ✅ All core features work offline
- ✅ SOAP notes save and persist correctly
- ✅ Vital signs tracking functional
- ✅ Reference content displays properly
- ✅ PDF export generates professional documents
- ✅ CloudKit sync works (when enabled)
- ✅ Subscription system functions
- ✅ Onboarding guides new users

### Quality Requirements
- ✅ No crashes in normal use
- ✅ Smooth animations and transitions
- ✅ Responsive UI (<100ms feedback)
- ✅ Accessible (VoiceOver, Dynamic Type)
- ✅ Professional appearance
- ✅ Fast load times (<2s initial load)

### Jimmothy Requirements
- ✅ Jimmothy appears in onboarding
- ✅ Jimmothy celebrates success
- ✅ Jimmothy helps in empty states
- ✅ Jimmothy voice is consistent and appropriate
- ✅ All Jimmothy assets are professional quality

### Nano Banana Pro Requirements
- ✅ All UI mockups generated before coding
- ✅ Mascot assets are photorealistic and professional
- ✅ Generated assets match final implementation
- ✅ Assets are optimized for iOS (proper sizes, formats)

---

## 📝 FINAL CHECKLIST FOR ANTIGRAVITY IMPLEMENTATION

### Antigravity Setup
- [ ] Google Cloud Project linked in Antigravity: `gen-lang-client-0212454764`
- [ ] Required APIs enabled (Generative Language API, AI Platform API, Vertex AI API)
- [ ] Billing enabled for Nano Banana Pro access
- [ ] Nano Banana Pro verified as available in Antigravity
- [ ] Default project set to: `gen-lang-client-0212454764`

### Xcode Project Setup
- [ ] Xcode project created with correct settings
- [ ] Bundle ID configured: `com.blackelkmountainmedicine.trailtriage`
- [ ] App icon generated with Nano Banana Pro
- [ ] SwiftData models implemented with proper headers

### Core Features
- [ ] SOAP note system complete (with Nano Banana mockups)
- [ ] Vital signs tracking functional
- [ ] Reference module system complete
- [ ] PDF export working
- [ ] CloudKit sync optional and user-controlled

### UI/UX
- [ ] All screens match Nano Banana generated mockups
- [ ] Dark mode support throughout
- [ ] Accessibility implemented
- [ ] Jimmothy assets integrated (from Nano Banana Pro)
- [ ] Onboarding flow complete with mascot

### Quality Assurance
- [ ] All files have proper headers
- [ ] Code follows SOP standards
- [ ] Documentation complete
- [ ] Error handling robust
- [ ] Performance optimized
- [ ] Offline functionality verified

### Nano Banana Pro Assets
- [ ] App icon generated
- [ ] Jimmothy mascot assets (multiple poses)
- [ ] UI mockups for all major screens
- [ ] Empty state illustrations
- [ ] Onboarding graphics
- [ ] PDF template design

---

## 🦝 FINAL WORD FROM JIMMOTHY

*"Hey there! Jimmothy the Raccoon WFR here! 🦝 If you're building TrailTriage: WFR Toolkit in Antigravity, remember: use Nano Banana Pro to make everything beautiful BEFORE you code it. I want to look good in those mascot assets, and I want the UI to be as clean as my perfectly organized medical pack! Generate mockups, visualize the design, then build it right. And always ask yourself: 'Would this help someone save a life in the backcountry?' If yes, ship it! If no, make it better. Let's build something amazing together! 🏔️"*

—Jimmothy the Raccoon WFR

---

## 📚 REFERENCE DOCUMENTS

This mega prompt references:
- `AGENT_SYSTEM_PROMPT.md` - Complete SOP for AI assistants
- `JIMMOTHY_LORE_AND_BRANDING.md` - Mascot character guide
- `CODE_STANDARDS_AND_SOP.md` - Coding standards and best practices
- `ARCHITECTURE.md` - Technical architecture documentation

---

**This mega prompt is designed for Google Antigravity IDE where Gemini 3 agents can seamlessly call Nano Banana Pro for image generation while building complete iOS applications. Use it to recreate TrailTriage: WFR Toolkit from scratch with professional UI assets generated on-the-fly.**

---

*Generated: November 22, 2025*  
*For Google Antigravity IDE (antigravity.google)*  
*Black Elk Mountain Medicine*  
*Approved by: 🦝 Jimmothy the Raccoon WFR*

