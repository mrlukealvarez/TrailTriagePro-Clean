# WFR TrailTriage - Cleanup & Target Membership Action Plan

## Current Status: Build Errors Due to Duplicate Files

### Problem Summary
You have duplicate definitions of `ReferenceBookView`, `ReferenceBookCoverView`, and `ReferenceBookTitlePageView` causing "Ambiguous use" compile errors.

**Root Cause**: The old files were not in the correct target, so a new consolidated file was created. Now both exist.

---

## 🚨 IMMEDIATE ACTION REQUIRED

### Step 1: Navigate to Project Directory
```bash
cd "/Users/luke/Documents/WFR TrailTriage"
```

### Step 2: Delete Old Duplicate Files
```bash
rm ReferenceBookView.swift
rm ReferenceBookCoverView.swift
rm ReferenceBookTitlePageView.swift
```

### Step 3: Verify Deletion
```bash
ls -la *.swift | grep -E "(ReferenceBook|MainTab)"
```

**Expected Output**: Should only show `ReferenceBookView_New.swift` and `MainTabView.swift`

### Step 4: Return to Xcode and Clean Build
1. In Xcode: **Product → Clean Build Folder** (Cmd+Shift+K)
2. **Product → Build** (Cmd+B)

✅ **Errors should be resolved!**

---

## 📋 COMPREHENSIVE PROJECT AUDIT

### Files Currently in Project
Based on search results, here are all Swift files identified:

#### ✅ Core App Files
- `WFR_TrailTriageApp.swift` - App entry point
- `MainTabView.swift` - Root navigation

#### ✅ Models
- `SOAPNote.swift` - Core SOAP note model (includes `VitalSigns`)
- `AppSettings.swift` - User preferences
- `WFRProtocol.swift` - Medical protocols
- `WFRChapter.swift` - Reference chapters (includes `WFRSection`, `WFRContentBlock`)

#### ✅ Views - Notes
- `NewNoteView.swift` - (embedded in MainTabView.swift)
- `NotesListView.swift` - Notes archive
- `ExpertModeNoteView.swift` - Full SOAP editor

#### ✅ Views - Reference
- `ReferenceBookView_New.swift` - **KEEP THIS** (consolidated file)
- ~~`ReferenceBookView.swift`~~ - **DELETE** (duplicate)
- ~~`ReferenceBookCoverView.swift`~~ - **DELETE** (duplicate)
- ~~`ReferenceBookTitlePageView.swift`~~ - **DELETE** (duplicate)

#### ✅ Views - Settings & More
- `MoreView.swift` - (embedded in MainTabView.swift)
- `SettingsView.swift` - (embedded in MainTabView.swift)
- `GlossaryView.swift` - (embedded in MainTabView.swift)
- `FAQView.swift` - (embedded in MainTabView.swift)
- `AboutView.swift` - (embedded in MainTabView.swift)
- `SubscriptionStatusView.swift` - Subscription management
- `TermsOfServiceView.swift` - Legal terms
- `PrivacyPolicyView.swift` - Privacy policy

#### ✅ Utilities
- `VitalSignsTracker.swift` - Vitals monitoring
- `SubscriptionManager.swift` - StoreKit integration

#### ⚠️ Missing Files (Referenced but not found)
- `OnboardingView.swift` - Referenced in `WFR_TrailTriageApp.swift`

---

## 🔍 TARGET MEMBERSHIP VERIFICATION

After deleting the old files, verify all remaining files are in the correct target:

### In Xcode:
1. Select **each Swift file** in Project Navigator
2. Open **File Inspector** (⌥⌘1)
3. Under **Target Membership**, ensure **"WFR TrailTriage"** is checked

### Files to Check:
```
✓ ReferenceBookView_New.swift
✓ MainTabView.swift
✓ NotesListView.swift
✓ ExpertModeNoteView.swift
✓ SubscriptionStatusView.swift
✓ TermsOfServiceView.swift
✓ PrivacyPolicyView.swift
✓ VitalSignsTracker.swift
✓ SubscriptionManager.swift
✓ SOAPNote.swift
✓ AppSettings.swift
✓ WFRProtocol.swift
✓ WFRChapter.swift
✓ WFR_TrailTriageApp.swift
```

---

## 🧹 CODE CLEANUP RECOMMENDATIONS

### 1. **Consolidate Embedded Views**
Currently, `MainTabView.swift` contains multiple views:
- `NewNoteView`
- `FAQView`
- `FAQItemView`
- `MoreView`
- `SettingsView`
- `GlossaryView`
- `AboutView`
- `FeaturePoint`

**Recommendation**: Extract into separate files for maintainability.

#### Example:
```bash
# Create Views/Notes/ directory structure
mkdir -p Views/Notes
mkdir -p Views/Settings
mkdir -p Views/Reference

# Move conceptual files (you'll create these in Xcode)
# Views/Notes/NewNoteView.swift
# Views/Settings/SettingsView.swift
# Views/Settings/FAQView.swift
# Views/Settings/GlossaryView.swift
# Views/Settings/AboutView.swift
```

### 2. **Rename Consolidated File**
After deletion of old files, optionally rename:
```bash
mv ReferenceBookView_New.swift ReferenceBookView.swift
```

### 3. **Create Missing OnboardingView**
The app references `OnboardingView` but it wasn't found. You need to either:
- Create the file
- Remove the reference if not needed

**Suggested Temporary Fix** (if onboarding isn't ready):
```swift
// In WFR_TrailTriageApp.swift, replace:
if showOnboarding {
    OnboardingView(isPresented: $showOnboarding)
        .environment(appSettings)
} else {
    MainTabView()
        .environment(appSettings)
        .environment(subscriptionManager)
}

// With:
MainTabView()
    .environment(appSettings)
    .environment(subscriptionManager)
```

---

## 📂 PROPOSED FILE STRUCTURE (After Cleanup)

```
WFR TrailTriage/
├── WFR_TrailTriageApp.swift
├── MainTabView.swift
│
├── Models/
│   ├── SOAPNote.swift
│   ├── AppSettings.swift
│   ├── WFRProtocol.swift
│   └── WFRChapter.swift
│
├── Views/
│   ├── Notes/
│   │   ├── NewNoteView.swift         [Extract from MainTabView]
│   │   ├── NotesListView.swift       ✓
│   │   └── ExpertModeNoteView.swift  ✓
│   │
│   ├── Reference/
│   │   └── ReferenceBookView.swift   [Rename from _New]
│   │
│   ├── Settings/
│   │   ├── MoreView.swift            [Extract from MainTabView]
│   │   ├── SettingsView.swift        [Extract from MainTabView]
│   │   ├── FAQView.swift             [Extract from MainTabView]
│   │   ├── GlossaryView.swift        [Extract from MainTabView]
│   │   ├── AboutView.swift           [Extract from MainTabView]
│   │   ├── SubscriptionStatusView.swift ✓
│   │   ├── TermsOfServiceView.swift  ✓
│   │   └── PrivacyPolicyView.swift   ✓
│   │
│   └── Onboarding/
│       └── OnboardingView.swift      [CREATE or REMOVE REFERENCE]
│
└── Utilities/
    ├── VitalSignsTracker.swift       ✓
    └── SubscriptionManager.swift     ✓
```

---

## 🎯 NEXT STEPS PRIORITY

### Priority 1: Fix Build Errors (NOW)
1. ✅ Run deletion commands in terminal
2. ✅ Clean build in Xcode
3. ✅ Verify build succeeds

### Priority 2: Verify Target Membership (After build succeeds)
1. Check all Swift files are in target
2. Verify Info.plist and entitlements are configured

### Priority 3: Code Organization (Optional, but recommended)
1. Extract embedded views from `MainTabView.swift`
2. Rename `ReferenceBookView_New.swift` → `ReferenceBookView.swift`
3. Create folder structure in Xcode (Groups)

### Priority 4: Handle Missing OnboardingView
1. Create `OnboardingView.swift` or
2. Remove onboarding logic from `WFR_TrailTriageApp.swift`

### Priority 5: Testing & QA
1. Test iCloud sync
2. Test subscription flow
3. Test SOAP note creation and export
4. Test reference book navigation

---

## 🛠️ TERMINAL COMMANDS SUMMARY

```bash
# Navigate to project
cd "/Users/luke/Documents/WFR TrailTriage"

# Delete duplicate files
rm ReferenceBookView.swift ReferenceBookCoverView.swift ReferenceBookTitlePageView.swift

# Verify only _New version remains
ls -la ReferenceBook*.swift

# Optional: Rename consolidated file
mv ReferenceBookView_New.swift ReferenceBookView.swift

# List all Swift files to verify cleanup
ls -la *.swift
```

---

## ✅ SUCCESS CRITERIA

After cleanup, you should have:
- ✅ No build errors
- ✅ All files in correct target
- ✅ No duplicate type definitions
- ✅ Clean project structure
- ✅ All features working (notes, reference, settings)

---

## 📞 SUPPORT

If you encounter issues after cleanup:
1. Check Xcode build logs for specific errors
2. Verify file target membership
3. Clean derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/WFR_TrailTriage-*`
4. Restart Xcode

---

**Created**: November 10, 2025  
**Status**: Ready for execution  
**Estimated Time**: 5-10 minutes
