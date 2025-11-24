# TrailTriage: WFR Toolkit - Code Standards & SOP
## 🦝 Jimmothy-Approved Development Guidelines

**App:** TrailTriage: WFR Toolkit  
**Developer:** BlackElkMountainMedicine.com  
**Mascot:** Jimmothy the Raccoon WFR  
**Last Updated:** November 13, 2025

---

## Table of Contents
1. [File Headers](#file-headers)
2. [Naming Conventions](#naming-conventions)
3. [Code Documentation](#code-documentation)
4. [UI/UX Design Standards](#uiux-design-standards)
5. [Jimmothy Integration](#jimmothy-integration)
6. [Git Commit Standards](#git-commit-standards)
7. [Testing Requirements](#testing-requirements)
8. [Release Process](#release-process)

---

## File Headers

### Standard Swift File Header
Every `.swift` file should begin with:

```swift
//  FileName.swift
//  TrailTriage: WFR Toolkit
//
//  Created by [Developer Name] on [Date]
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: [One-line description of file's purpose]
//
```

### Examples

**View File:**
```swift
//  SOAPNoteView.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 11/1/25
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Professional SOAP note creation and editing!
//
```

**Model File:**
```swift
//  Patient.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 10/15/25
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: Patient data model with HIPAA-compliant storage!
//
```

**Manager/Service File:**
```swift
//  LocationManager.swift
//  TrailTriage: WFR Toolkit
//
//  Created by Luke Alvarez on 10/20/25
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: GPS coordination for backcountry incident tracking!
//
```

---

## Naming Conventions

### App Name
- **Full Name:** TrailTriage: WFR Toolkit
- **Short Name:** TrailTriage (when space is limited)
- **Never:** WFR TrailTriage, Trail Triage, TrailTriage WFR

### Developer Name
- **Primary:** BlackElkMountainMedicine.com
- **Spelled Out:** Black Elk Mountain Medicine
- **Abbreviation (internal only):** BEMM

### Jimmothy References
- **Full Name:** Jimmothy the Raccoon WFR
- **Short Name:** Jimmothy
- **Never:** Jimmy, James, Jim, Timothy

### Variables and Functions
```swift
// ✅ Good - Clear and descriptive
var soapNote: SOAPNote
func generatePDF(from note: SOAPNote) -> PDFDocument
var vitalSignsHistory: [VitalSign]

// ❌ Bad - Unclear or inconsistent
var note: SOAPNote  // Too vague
func makePDF(n: SOAPNote) -> PDFDocument  // Abbreviated parameter
var vitals: [VitalSign]  // Inconsistent naming
```

---

## Code Documentation

### Function Documentation
Use Swift's documentation markup for all public functions:

```swift
/// Generates a professional SOAP note PDF for EMS handoff
///
/// Jimmothy's Note: This ensures your documentation meets professional
/// standards and includes all required information for proper patient care continuity.
///
/// - Parameters:
///   - soapNote: The SOAP note to convert to PDF format
///   - includeVitals: Whether to include vital signs trending graphs
///   - includeLocation: Whether to include incident location map
/// - Returns: A shareable PDF document ready for export
/// - Throws: `PDFGenerationError` if rendering fails or data is incomplete
///
/// Example:
/// ```swift
/// let pdf = try generateSOAPNotePDF(
///     from: currentNote,
///     includeVitals: true,
///     includeLocation: true
/// )
/// ```
func generateSOAPNotePDF(
    from soapNote: SOAPNote,
    includeVitals: Bool = true,
    includeLocation: Bool = true
) throws -> PDFDocument {
    // Implementation
}
```

### Complex Logic Comments
```swift
// Jimmothy's Note: We use a 5-minute buffer for vital sign trends
// because changes can be gradual in wilderness scenarios
let trendingWindow: TimeInterval = 300

// Calculate the evacuation time based on terrain difficulty
// and patient's level of consciousness (Jimmothy tested this formula
// on 47 different rescue scenarios and it's accurate within 15 minutes)
let evacuationTime = calculateEvacuationTime(
    distance: distanceInMeters,
    terrain: currentTerrain,
    patientLOC: patient.levelOfConsciousness
)
```

### MARK Comments
Use MARK to organize code sections:

```swift
// MARK: - Initialization

// MARK: - Public Methods

// MARK: - Private Helpers

// MARK: - Jimmothy's Special Features

// MARK: - Protocol Conformance

// MARK: - Preview
```

---

## UI/UX Design Standards

### Modern SwiftUI Design Philosophy

**Jimmothy's Golden Rule:** "If it doesn't look like it belongs in iOS 18, we rebuild it until it does! 🦝"

#### Reference Implementation
- **Primary Reference:** `NoteDetailView.swift` - This is the gold standard
- **Supporting Views:** `VitalsTrackingPanel.swift`, updated `NewNoteView.swift`, updated `NotesListView.swift`
- **Design Document:** See `DESIGN_REFRESH_SUMMARY.md` for complete design token reference

### Photo-to-SwiftUI Conversion Process

When provided with photos, screenshots, or reference designs (books, websites, apps, etc.), follow this modernization process:

#### Step 1: Analyze the Source
```
✅ Identify:
- Layout structure (vertical stack, grid, list)
- Information hierarchy (what's most important)
- Color usage and meaning
- Icon opportunities
- Spacing patterns
- Typography styles
- Interactive elements
```

#### Step 2: Apply Modern SwiftUI Patterns
Transform traditional designs using these principles:

**Replace:** Plain backgrounds  
**With:** Rounded cards with subtle colored backgrounds
```swift
.padding()
.background(Color.blue.opacity(0.05))
.cornerRadius(12)
```

**Replace:** Text-only headers  
**With:** Icon + text combinations
```swift
HStack {
    Image(systemName: "stethoscope")
        .foregroundStyle(.blue)
    Text("Assessment")
        .font(.headline)
}
```

**Replace:** Flat lists  
**With:** Rich, scannable rows with status indicators
```swift
HStack(spacing: 12) {
    // Circular status badge
    ZStack {
        Circle()
            .fill(color.opacity(0.2))
            .frame(width: 44, height: 44)
        Image(systemName: icon)
            .foregroundStyle(color)
    }
    
    VStack(alignment: .leading, spacing: 6) {
        Text(title).font(.headline)
        Text(subtitle).font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
```

**Replace:** Dense tables  
**With:** Card-based layouts with breathing room
```swift
VStack(spacing: 16) {
    StatCard(value: "3", label: "Checks", icon: "heart", color: .red)
    StatCard(value: "2h", label: "Duration", icon: "clock", color: .blue)
}
```

#### Step 3: Maintain Information Density
```
✅ Keep all original information
✅ Improve scanability with icons and color
✅ Add visual hierarchy with size and weight
✅ Group related content in cards
✅ Use progressive disclosure for details
```

#### Step 4: Modernization Checklist
When converting any design to SwiftUI:

- [ ] Use rounded cards (12pt corners) for sections
- [ ] Apply semantic colors (`.blue`, `.red`, `.green`, etc.)
- [ ] Add relevant SF Symbols icons
- [ ] Implement proper spacing (16pt between major elements)
- [ ] Create visual hierarchy with typography
- [ ] Add subtle backgrounds (5-15% opacity)
- [ ] Use proper foregroundStyle (`.secondary` for supporting text)
- [ ] Include empty states with encouragement
- [ ] Test in both Light and Dark mode
- [ ] Ensure accessibility (VoiceOver, Dynamic Type)

### Design Tokens

#### Color Semantic Mapping
```swift
// Status & Actions
.blue      // Primary actions, information, navigation
.green     // Success, active states, treatment
.red       // Critical, danger, complaints, heart rate
.orange    // Warnings, urgent items, temperature
.yellow    // Caution, non-urgent
.purple    // Blood pressure, specialized vitals
.cyan      // Respiratory rate, secondary vitals
.gray      // Neutral, disabled states
```

#### Spacing Scale
```swift
4pt   // Tight internal spacing (label groups)
8pt   // Within-card spacing
12pt  // Between related elements
16pt  // Standard section spacing, padding
24pt  // Major section breaks
40pt  // Screen edge padding (when needed)
```

#### Corner Radius
```swift
8pt   // Small elements (badges, pills, tiles)
10pt  // Medium buttons, inputs
12pt  // Standard cards and sections (DEFAULT)
16pt  // Large hero sections
```

#### Typography Hierarchy
```swift
.title.bold()           // Page headers, hero text
.title2.bold()          // Major stats, key numbers
.title3.bold()          // Button labels, section numbers
.headline               // Section titles, card headers
.subheadline            // Supporting text, metadata
.body                   // Main content text
.caption                // Labels, footnotes, timestamps
.caption2               // Ultra-small metadata
```

### Card-Based Layout Pattern
The foundation of our modern design:

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

### Stat Card Pattern
For displaying key metrics:

```swift
struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            
            Text(value)
                .font(.title3.bold())
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
```

### Feature Card Pattern
For onboarding and informational screens:

```swift
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.05))
        .cornerRadius(12)
    }
}
```

### List Row Pattern
For rich, scannable list items:

```swift
HStack(spacing: 12) {
    // Status indicator
    ZStack {
        Circle()
            .fill(statusColor.opacity(0.2))
            .frame(width: 44, height: 44)
        
        Image(systemName: statusIcon)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(statusColor)
    }
    
    // Content
    VStack(alignment: .leading, spacing: 6) {
        Text(title)
            .font(.headline)
        
        HStack(spacing: 4) {
            Image(systemName: metadataIcon)
                .font(.caption2)
            Text(metadata)
                .font(.subheadline)
        }
        .foregroundStyle(.secondary)
        
        if let subtitle = subtitle {
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
    
    Spacer()
    
    // Badge (optional)
    VStack(spacing: 4) {
        Image(systemName: badgeIcon)
            .font(.caption)
            .foregroundStyle(badgeColor)
        
        Text(badgeValue)
            .font(.caption.bold())
            .foregroundStyle(.secondary)
    }
}
.padding(.vertical, 8)
```

### Empty State Pattern
```swift
VStack(spacing: 16) {
    ZStack {
        Circle()
            .fill(Color.blue.opacity(0.1))
            .frame(width: 120, height: 120)
        
        Image(systemName: icon)
            .font(.system(size: 60))
            .foregroundStyle(.blue)
    }
    
    Text(title)
        .font(.title2.bold())
    
    Text(message)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    
    Button(action: action) {
        Label(buttonTitle, systemImage: buttonIcon)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(12)
    }
    .padding(.horizontal)
}
.padding(.vertical, 40)
```

### Conversion Examples

#### Before (Traditional/Book Style):
```
┌─────────────────────────────┐
│ PATIENT INFORMATION         │
├─────────────────────────────┤
│ Name: John Doe              │
│ Age: 32                     │
│ Sex: Male                   │
│ Weight: 180 lbs             │
└─────────────────────────────┘
```

#### After (Modern SwiftUI):
```swift
VStack(alignment: .leading, spacing: 12) {
    HStack {
        Image(systemName: "person.fill")
            .foregroundStyle(.blue)
        Text("Patient Information")
            .font(.headline)
    }
    
    VStack(spacing: 8) {
        PatientInfoRow(label: "Name", value: "John Doe")
        PatientInfoRow(label: "Age", value: "32")
        PatientInfoRow(label: "Sex", value: "Male")
        PatientInfoRow(label: "Weight", value: "180 lbs")
    }
}
.padding()
.background(Color.blue.opacity(0.05))
.cornerRadius(12)
```

### Jimmothy's UI/UX Principles

1. **"If it doesn't pop, it flops!"** - Use color and icons meaningfully
2. **"Space is your friend!"** - Don't cram everything together
3. **"Icons speak louder than words!"** - Visual hierarchy matters
4. **"Cards are king!"** - Group related content visually
5. **"Dark mode or bust!"** - Always test in both themes
6. **"Thumbs-first design!"** - Optimize for one-handed use in the field

### Future Photo Conversion Protocol

When Luke provides photos/screenshots/book pages/etc.:

1. **Acknowledge receipt:** "Got it! I'll modernize this using our NoteDetailView standard."
2. **Analyze structure:** Identify information hierarchy and groupings
3. **Apply patterns:** Use established card/stat/feature patterns
4. **Maintain data:** Keep all original information, just make it beautiful
5. **Test both themes:** Ensure it works in Light and Dark mode
6. **Document:** Explain what was modernized and why

**Example Response Format:**
```
"Perfect! I can see this has:
- Patient demographic info (I'll use our PatientInfo card pattern)
- Vital signs table (I'll use our VitalTile grid pattern)
- Assessment notes (I'll use our info card with colored accent)

Converting to modern SwiftUI with:
✅ Rounded 12pt cards
✅ Blue semantic colors
✅ Proper spacing (16pt between sections)
✅ SF Symbols icons
✅ Dark mode compatible

Here's the implementation..."
```

---

## Jimmothy Integration

### When to Include Jimmothy

#### ✅ Include Jimmothy In:
1. **Empty States** - Encourage user action
2. **Onboarding** - Welcome and guide users
3. **Success Messages** - Celebrate achievements
4. **Tips & Hints** - Educational content
5. **Error Recovery** - Lighten the mood
6. **Loading States** - Keep users informed
7. **Achievement Unlocks** - Gamification

#### ❌ Don't Include Jimmothy In:
1. **Critical Error Messages** - Stay professional
2. **HIPAA/Legal Content** - Keep it formal
3. **Patient Data Display** - Maintain clinical tone
4. **Emergency Instructions** - No distractions

### Jimmothy Message Examples

**Empty States:**
```swift
VStack {
    Image("RaccoonMascotWaving")
        .resizable()
        .scaledToFit()
        .frame(width: 120, height: 120)
    
    Text("No SOAP Notes Yet")
        .font(.title2.bold())
    
    Text("Jimmothy is ready to help you create your first note!")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    
    Button("Create First Note") {
        createNewNote()
    }
}
```

**Success Messages:**
```swift
.alert("PDF Exported!", isPresented: $showSuccess) {
    Button("OK") { }
} message: {
    Text("🦝 Jimmothy approves this documentation! Your PDF is ready to share.")
}
```

**Loading States:**
```swift
VStack {
    ProgressView()
    Text("Jimmothy is gathering your protocols...")
        .font(.caption)
        .foregroundStyle(.secondary)
}
```

### Jimmothy Tips System
```swift
struct JimmothyTip: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "lightbulb.fill")
                .foregroundStyle(.yellow)
            
            VStack(alignment: .leading) {
                Text("🦝 Jimmothy's Tip")
                    .font(.caption.bold())
                
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// Usage
JimmothyTip(message: "Document vitals every 15 minutes during long evacuations")
```

---

## Git Commit Standards

### Commit Message Format
```
[Type] Brief description

Jimmothy's Note: [Why this change matters]

- Detailed change 1
- Detailed change 2
- Detailed change 3

Refs: #[issue-number] (if applicable)
```

### Commit Types
- `[Feature]` - New functionality
- `[Fix]` - Bug fixes
- `[Docs]` - Documentation updates
- `[Style]` - Code style changes
- `[Refactor]` - Code restructuring
- `[Test]` - Testing additions
- `[Jimmothy]` - Mascot-related updates

### Examples

```
[Feature] Add voice-to-text SOAP note entry

Jimmothy's Note: Cold weather operations need hands-free documentation!

- Implemented continuous voice recognition
- Added medical terminology dictionary
- Handles background noise filtering
- Tested in actual field conditions (-15°F)

Refs: #42
```

```
[Fix] Correct GPS accuracy in mountainous terrain

Jimmothy's Note: Raccoons are excellent navigators, now the app is too!

- Improved altitude calculation algorithm
- Better handling of GPS signal loss
- Added fallback to last known location
- Tested on Mt. Rainier at 10,000ft

Refs: #38
```

```
[Jimmothy] Update mascot animations for completion screen

Jimmothy's Note: More dabs = more celebration! 🦝

- Added dabbing raccoon asset
- Implemented smooth scale animations
- Added confetti celebration effect
- Jimmothy approves this level of swagger
```

---

## Testing Requirements

### Pre-Commit Checklist
Before committing code:
- [ ] Code compiles without warnings
- [ ] All tests pass
- [ ] No force unwrapping (`!`) without explicit safety check
- [ ] Proper error handling
- [ ] Documentation is updated
- [ ] Jimmothy would approve of the user experience
- [ ] Works in offline mode (if applicable)
- [ ] Tested on multiple device sizes
- [ ] Dark mode compatible
- [ ] Accessibility labels present

### Jimmothy's Field Test Requirements
All features must be tested for:
- ✅ Offline functionality
- ✅ Low battery performance
- ✅ Poor GPS conditions
- ✅ Gloved-hand usability
- ✅ Bright sunlight visibility
- ✅ Cold weather operation (-20°F minimum)
- ✅ High altitude functionality (10,000+ ft)

### Test Documentation
```swift
// MARK: - Tests

/// Tests PDF generation with complete SOAP note
///
/// Jimmothy's Note: We test this extensively because EMS needs
/// reliable documentation every single time.
func testCompletePDFGeneration() async throws {
    // Given
    let soapNote = createTestSOAPNote()
    
    // When
    let pdf = try await generatePDF(from: soapNote)
    
    // Then
    XCTAssertNotNil(pdf, "Jimmothy expects a valid PDF!")
    XCTAssertGreaterThan(pdf.pageCount, 0)
}
```

---

## Release Process

### Pre-Release Checklist
- [ ] All tests pass
- [ ] Version number updated
- [ ] Release notes written (with Jimmothy's perspective)
- [ ] App Store screenshots updated
- [ ] Jimmothy mascot assets current
- [ ] Privacy policy reviewed
- [ ] HIPAA compliance verified
- [ ] Offline functionality tested
- [ ] Battery impact measured
- [ ] Crash logs reviewed
- [ ] Beta testing complete (minimum 10 wilderness responders)

### Version Numbering
- **Major (X.0.0):** Significant new features or breaking changes
  - Example: "Jimmothy's Big Upgrade"
- **Minor (1.X.0):** New features, no breaking changes
  - Example: "Jimmothy Learns Voice Recognition"
- **Patch (1.0.X):** Bug fixes only
  - Example: "Jimmothy Fixes GPS Issues"

### Release Notes Requirements
Every release must include:
1. **Jimmothy's Welcome** - Fun intro
2. **New Features** - What's new
3. **Improvements** - What's better
4. **Bug Fixes** - What's fixed
5. **Jimmothy's Pro Tip** - Practical advice

See `RELEASE_NOTES_TEMPLATE.md` for detailed format.

### App Store Submission
1. Update version in Xcode
2. Create release notes with Jimmothy
3. Update screenshots (include Jimmothy where appropriate)
4. Review keywords (include: wilderness, first responder, SOAP, backcountry, Jimmothy)
5. Submit for review
6. Monitor for approval
7. Celebrate with Jimmothy! 🦝

---

## Code Review Guidelines

### What Reviewers Should Check
1. **Functionality** - Does it work as intended?
2. **User Experience** - Would Jimmothy approve?
3. **Code Quality** - Is it maintainable?
4. **Documentation** - Is it clear?
5. **Testing** - Is it covered?
6. **Branding** - Consistent naming?
7. **Performance** - Backcountry-ready?

### Review Comments Format
```swift
// ✅ Good Review Comment
// Jimmothy suggests: Consider caching this result to improve performance
// during long evacuations with poor connectivity

// ❌ Bad Review Comment  
// This is slow
```

---

## Performance Standards

### Load Times
- App launch: < 2 seconds
- Note creation: < 1 second
- PDF generation: < 3 seconds
- Protocol search: < 0.5 seconds

**Jimmothy's Rule:** If it takes longer than "one Mississippi, two Mississippi, three Mississippi," it's too slow for emergency use.

### Battery Impact
- Background sync: < 2% per hour
- Active use: < 10% per hour
- GPS tracking: < 15% per hour

**Jimmothy's Rule:** The app should last as long as the typical SAR operation (6-8 hours of active use minimum).

### Offline Capability
- All core features must work offline
- Protocols must be locally cached
- Notes must be created without connectivity
- Sync should happen automatically when online

**Jimmothy's Rule:** If you can't use it at 10,000 feet with no cell service, it's not ready for the backcountry.

---

## Accessibility Requirements

### All Interactive Elements Must Have:
- VoiceOver labels
- Minimum touch target 44x44 points
- Sufficient color contrast (WCAG AA minimum)
- Support for Dynamic Type
- Keyboard navigation support

### Jimmothy's Accessibility Commitment
"Every wilderness responder deserves access to great tools, regardless of their abilities. Build it right, build it accessible."

---

## Security & Privacy

### HIPAA Compliance Checklist
- [ ] All patient data encrypted at rest
- [ ] Secure data transmission
- [ ] No unnecessary data collection
- [ ] User consent properly obtained
- [ ] Data retention policy followed
- [ ] Audit logs maintained
- [ ] Secure deletion implemented

### Privacy Best Practices
```swift
// ✅ Good - Explicit consent
func requestLocationPermission() {
    // Jimmothy's Note: Always explain WHY we need permissions
    locationManager.requestWhenInUseAuthorization()
}

// ❌ Bad - No context or consent
locationManager.requestAlwaysAuthorization()
```

---

## Documentation Requirements

### Every Public API Needs:
1. Function description
2. Parameter descriptions
3. Return value description
4. Throws documentation (if applicable)
5. Example usage
6. Jimmothy's Note (when helpful)

### Every Complex Algorithm Needs:
1. Purpose explanation
2. Input/output description
3. Edge cases handled
4. Performance characteristics
5. Why this approach was chosen

---

## Continuous Improvement

### Monthly Review
- Review crash logs
- Analyze user feedback
- Update Jimmothy's tips
- Refine protocols
- Optimize performance
- Update documentation

### Quarterly Planning
- Plan major features
- Review roadmap
- Update Jimmothy's character
- Refresh marketing materials
- Review competitor landscape

### Annual Audit
- Comprehensive code review
- Security audit
- HIPAA compliance review
- Performance benchmarking
- User satisfaction survey
- Jimmothy's annual report 🦝

---

## Contact & Support

### For Development Questions
- Check this document first
- Review `JIMMOTHY_LORE_AND_BRANDING.md`
- Consult `RELEASE_NOTES_TEMPLATE.md`
- Ask: "What would Jimmothy do?"

### For Branding Questions
- Refer to `JIMMOTHY_LORE_AND_BRANDING.md`
- Use official app name: TrailTriage: WFR Toolkit
- Include developer attribution: BlackElkMountainMedicine.com
- Keep Jimmothy's character consistent

---

## Final Word from Jimmothy

*"Building tools for wilderness first responders is serious business. Lives depend on good documentation, reliable software, and thoughtful design. But that doesn't mean we can't have a little fun along the way! Write clean code, test thoroughly, document clearly, and always ask yourself: 'Would this help someone save a life in the backcountry?' If the answer is yes, ship it. If the answer is no, make it better. And remember—this raccoon is always watching! 🦝"*

—Jimmothy the Raccoon WFR

---

**Document Version:** 1.0  
**Last Updated:** November 13, 2025  
**Maintained By:** BlackElkMountainMedicine.com  
**Approved By:** 🦝 Jimmothy the Raccoon WFR

*This is a living document. As TrailTriage: WFR Toolkit grows, so should our standards. Commit to excellence, commit to safety, commit to helping wilderness first responders do their job better.*
