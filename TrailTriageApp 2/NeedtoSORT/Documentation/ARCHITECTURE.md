# WFR TrailTriage - Architecture Documentation

## Project Overview
**WFR TrailTriage** is a professional wilderness medicine documentation and reference tool built for certified Wilderness First Responders (WFRs). The app enables offline SOAP note creation, vital signs tracking, and quick access to wilderness medicine protocols and reference materials.

**Platform:** iOS 17.0+  
**Language:** Swift 6.0  
**Frameworks:** SwiftUI, SwiftData, StoreKit 2, UserNotifications, CloudKit  
**Architecture Pattern:** MVVM with Observable State Management  

---

## Core Principles

### 1. **Offline-First Architecture**
- All features work without internet connectivity
- Data persists locally using SwiftData
- Optional iCloud sync when available
- No external API dependencies for core functionality

### 2. **Privacy & Security**
- Patient data stored locally on device
- Optional iCloud encryption via CloudKit
- No third-party analytics or tracking
- HIPAA-aware design (educational tool disclaimer)

### 3. **Professional-Grade Documentation**
- Industry-standard SOAP note format
- Comprehensive vital signs tracking
- Export capabilities (Text, PDF, Share Sheet)
- Metadata for EMS handoff

### 4. **Performance & Reliability**
- Lazy loading and pagination for large datasets
- Efficient memory management
- Background task optimization
- Robust error handling

---

## Project Structure

```
WFR TrailTriage/
│
├── App/
│   ├── WFR_TrailTriageApp.swift          # App entry point, ModelContainer setup
│   └── MainTabView.swift                  # Root tab navigation
│
├── Models/                                 # SwiftData Models (@Model)
│   ├── SOAPNote.swift                     # Core SOAP note model + supporting types
│   ├── VitalSigns.swift                   # (embedded in SOAPNote.swift)
│   ├── WFRProtocol.swift                  # Medical protocols model
│   ├── WFRChapter.swift                   # Reference book chapters
│   └── AppSettings.swift                  # User preferences (@Observable)
│
├── Views/                                  # SwiftUI Views
│   ├── Notes/
│   │   ├── NewNoteView.swift              # Note creation landing page
│   │   ├── NotesListView.swift            # Archive/list of all notes
│   │   └── ExpertModeNoteView.swift       # Full SOAP note editor
│   │
│   ├── Reference/
│   │   ├── ReferenceBookView.swift        # Reference book main view
│   │   ├── ReferenceBookCoverView.swift   # Cover page
│   │   └── ReferenceBookTitlePageView.swift # Title page
│   │
│   ├── Settings/
│   │   ├── MoreView.swift                 # Settings hub
│   │   ├── SettingsView.swift             # App preferences
│   │   ├── SubscriptionStatusView.swift   # Subscription management
│   │   ├── FAQView.swift                  # Frequently asked questions
│   │   ├── AboutView.swift                # About page
│   │   ├── GlossaryView.swift             # Medical terminology
│   │   ├── TermsOfServiceView.swift       # Legal terms
│   │   └── PrivacyPolicyView.swift        # Privacy policy
│   │
│   └── Onboarding/
│       └── OnboardingView.swift           # First-launch onboarding
│
├── Utilities/
│   ├── VitalSignsTracker.swift            # Vitals monitoring & notifications
│   └── SubscriptionManager.swift          # StoreKit 2 subscription handling
│
├── Resources/
│   └── Assets.xcassets/                   # Images, icons, colors
│
└── Tests/                                  # Unit & UI tests (future)
```

---

## Architecture Layers

### 1. **Data Layer** (`Models/`)

All models use SwiftData's `@Model` macro for automatic persistence and CloudKit sync.

#### Primary Models
- **`SOAPNote`**: Core medical documentation model
  - Patient info, scene data, SAMPLE history
  - Vitals, physical exam, pain assessment (OPQRST)
  - Assessment, treatment plan, evacuation status
  - Metadata: responder info, tags, attachments

- **`VitalSigns`**: Embedded in SOAPNote
  - Timestamped vital readings
  - HR, RR, BP, SpO2, temperature

- **`WFRProtocol`**: Medical procedure reference
  - Category, severity, steps
  - Favorites system

- **`WFRChapter`**: Reference book content
  - Hierarchical: Chapter → Section → ContentBlock
  - Supports rich formatting (warnings, tips, tables)

- **`AppSettings`**: User preferences (@Observable)
  - Auto-save, GPS capture, vitals display
  - Responder metadata (name, agency, certs)

#### Supporting Enums
- `PatientSex`, `Season`, `LORLevel`, `EvacuationUrgency`, `BurnDegree`
- `ProtocolCategory`, `Severity`, `ContentBlockType`

### 2. **View Layer** (`Views/`)

SwiftUI views following MVVM pattern with `@Environment`, `@State`, `@Query`.

#### Navigation Structure
```
TabView (MainTabView)
├── Tab 1: New Note (NewNoteView)
│   └── Sheet: ExpertModeNoteView
├── Tab 2: My Notes (NotesListView)
│   └── NavigationLink: Note Detail
├── Tab 3: Reference (ReferenceBookView)
│   └── NavigationLink: Chapter Detail
├── Tab 4: Glossary (GlossaryView)
└── Tab 5: More (MoreView)
    ├── Settings
    ├── Subscription
    ├── FAQ
    └── About
```

#### View Responsibilities
- **NewNoteView**: Landing page with CTA to create SOAP note
- **ExpertModeNoteView**: Full-featured SOAP note editor with sections, vitals tracking
- **NotesListView**: Searchable, filterable list of past notes
- **ReferenceBookView**: Displays chapters with search, bookmarks
- **GlossaryView**: Medical terminology dictionary with categories
- **SettingsView**: App configuration, iCloud status, responder info

### 3. **Utility Layer** (`Utilities/`)

#### `VitalSignsTracker`
- Manages recurring vital sign check notifications
- UserNotifications framework integration
- Configurable intervals (5, 10, 15, 30, 60 min)

#### `SubscriptionManager`
- StoreKit 2 integration
- Subscription status monitoring
- Handles purchase flow, restoration

### 4. **App Entry Point** (`WFR_TrailTriageApp.swift`)

- Configures SwiftData `ModelContainer` with CloudKit sync
- Initializes `@State` for `AppSettings` and `SubscriptionManager`
- Conditional onboarding display
- Registers notification categories

---

## Data Flow

### Read Operations
```
View → @Query → SwiftData → Local Storage
                            ↓
                      iCloud Sync (if enabled)
```

### Write Operations
```
User Input → View (@Bindable) → SwiftData Model
                                  ↓
                            Auto-save to local DB
                                  ↓
                            CloudKit sync (async)
```

### Settings Management
```
User Input → SettingsView → AppSettings (@Observable)
                             ↓
                        UserDefaults persistence
                             ↓
                        Observed by dependent views
```

---

## Key Features & Implementation

### 1. SOAP Note Documentation
- **Format**: Subjective, Objective, Assessment, Plan
- **Features**:
  - Patient demographics
  - Scene information (location, time, season)
  - SAMPLE history (Signs/Symptoms, Allergies, Medications, etc.)
  - Vital signs tracking over time
  - Pain assessment (OPQRST)
  - Physical exam notes
  - Treatment plan & evacuation urgency
  - Responder metadata for EMS handoff
- **Export**: Plain text format via Share Sheet

### 2. Vital Signs Monitoring
- Timed reminders using UserNotifications
- Customizable intervals
- Historical tracking within each note
- Visual indicators for normal ranges (optional)

### 3. Reference Material
- Chapter-based organization
- Rich content types: paragraphs, lists, warnings, tips, tables
- Searchable and bookmarkable
- Cover page and title page for professional presentation

### 4. Subscription System
- Freemium model (onboarding access, then subscription)
- StoreKit 2 integration
- Subscription status view in settings

### 5. iCloud Sync
- Automatic sync when signed in
- Visual indicator in settings
- Fallback to local-only mode

---

## Naming Conventions

### Files
- **Models**: `ModelName.swift` (e.g., `SOAPNote.swift`)
- **Views**: `FeatureName + ViewType.swift` (e.g., `NotesListView.swift`)
- **Utilities**: `ServiceName.swift` (e.g., `SubscriptionManager.swift`)

### Types
- **Classes/Structs**: PascalCase (e.g., `SOAPNote`, `VitalSignsTracker`)
- **Properties**: camelCase (e.g., `patientName`, `isCompleted`)
- **Enums**: PascalCase with descriptive raw values (e.g., `PatientSex`, `LORLevel`)
- **Functions**: camelCase with verb prefix (e.g., `exportAsText()`, `checkiCloudStatus()`)

### SwiftUI Conventions
- **State**: `@State`, `@Binding`, `@Environment`, `@Query`
- **Models**: `@Model` (SwiftData), `@Observable` (settings)
- **View Builders**: Use `@ViewBuilder` for conditional content

---

## Testing Strategy

### Unit Tests (Future)
- Model validation logic
- SOAP note export formatting
- Vital signs calculations
- Enum helpers and computed properties

### Integration Tests (Future)
- SwiftData persistence
- iCloud sync verification
- Notification scheduling

### UI Tests (Future)
- Onboarding flow
- Note creation workflow
- Settings persistence

---

## Security & Compliance

### Data Protection
- Local-first storage (no external servers)
- Optional iCloud encryption via CloudKit
- No third-party analytics or tracking
- User owns their data (export/delete)

### Legal Disclaimers
- Educational tool only (not medical advice)
- User certification required
- Clear terms of service and privacy policy
- No HIPAA compliance claims (not intended for PHI)

---

## Performance Optimization

### Applied Optimizations
1. **Static Constants**: Glossary terms and categories cached
2. **Lazy Loading**: Use `@Query` with predicates for filtered data
3. **Background Tasks**: iCloud checks on background threads
4. **Incremental Filtering**: Early exit for search queries
5. **Memory Efficiency**: Avoid unnecessary array allocations

### Future Optimizations
- Pagination for large note lists
- Image compression for attachments
- Lazy chapter loading in reference book
- SwiftData background contexts for imports

---

## Deployment

### Build Configuration
- **Target**: iOS 17.0+
- **Deployment**: App Store via Xcode Cloud or manual upload
- **Code Signing**: Developer account with CloudKit entitlements
- **In-App Purchases**: StoreKit 2 configuration in App Store Connect

### Release Checklist
1. Version bump in Xcode project settings
2. Update `CHANGELOG.md` (if exists)
3. Test subscription flow in sandbox
4. Verify iCloud sync on multiple devices
5. Export compliance review
6. App Store metadata update
7. Submit for review

---

## Future Roadmap

### Phase 1 (Current)
- ✅ Core SOAP note creation
- ✅ Vital signs tracking
- ✅ Reference book structure
- ✅ iCloud sync
- ✅ Subscription system

### Phase 2 (Planned)
- [ ] Photo attachments from camera
- [ ] Voice memo recording
- [ ] PDF export with formatting
- [ ] GPS location capture
- [ ] Offline maps integration

### Phase 3 (Backlog)
- [ ] Apple Watch companion app
- [ ] Widget for quick note creation
- [ ] Siri shortcuts integration
- [ ] Advanced analytics (vitals trends)
- [ ] Multi-patient incident management

---

## Contributing Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use SwiftLint for consistency (if configured)
- Comment complex logic, not obvious code
- Keep view files focused (max 300-400 lines)

### Git Workflow
- Feature branches: `feature/feature-name`
- Bug fixes: `fix/bug-description`
- Hotfixes: `hotfix/issue-description`
- Commit messages: Imperative mood (e.g., "Add vitals export feature")

### Documentation
- Update `ARCHITECTURE.md` for structural changes
- Add inline comments for business logic
- Document public APIs with triple-slash comments (`///`)

---

## Support & Maintenance

### Contact
- **Website**: blackelkmountainmedicine.com
- **Email**: support@blackelkmountainmedicine.com
- **Developer**: Luke Alvarez

### Version History
- **v1.0**: Initial release (November 2025)

---

## License & Copyright

© 2025 Black Elk Mountain Medicine LLC  
All Rights Reserved

This app and its content are proprietary. No reproduction, distribution, or use of AI training without explicit permission.

---

**Last Updated**: November 10, 2025  
**Maintained By**: Luke Alvarez
