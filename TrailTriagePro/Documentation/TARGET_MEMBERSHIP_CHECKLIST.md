# WFR TrailTriage - Target Membership Verification Checklist

**Created:** November 10, 2025  
**Purpose:** Ensure all Swift files are properly added to the app target

## ✅ CRITICAL FILES - MUST BE IN TARGET

### App Entry Point
- [x] `WFR_TrailTriageApp.swift` - Main app structure

### SwiftData Models (Referenced in Schema)
- [ ] **WFRProtocol.swift** - Protocol model
- [ ] **SOAPNote.swift** - SOAP note & VitalSigns models  
- [ ] **WFRChapter.swift** - Chapter, Section, ContentBlock models ⚠️ **RECENTLY RECREATED**

### Core Managers & Settings
- [ ] **AppSettings.swift** - User preferences (@Observable)
- [ ] **SubscriptionManager.swift** - StoreKit subscription handling
- [ ] **VitalSignsTracker.swift** - Vitals tracking & notifications

### Main Views
- [ ] **MainTabView.swift** - Main tab navigation
- [ ] **OnboardingView.swift** - Onboarding flow
- [ ] **ReferenceBookView.swift** - Reference book UI

### Additional Views (Search for More)
- [ ] Any other view files that are imported/used

---

## 🔍 HOW TO VERIFY IN XCODE

### For Each File:
1. Select the file in Project Navigator
2. Open File Inspector (⌥⌘1 or View → Inspectors → File)
3. Scroll to "Target Membership" section
4. **Ensure checkbox next to "WFR TrailTriage" (or your app target) is CHECKED**

### Batch Verification:
1. Select multiple files in Project Navigator (Cmd+Click)
2. Open File Inspector
3. Check Target Membership for all selected files

---

## ⚠️ COMMON ISSUES

### Why Files Get Left Out:
- Created file outside Xcode (drag/drop from Finder)
- Unchecked target during "New File" dialog
- File was in a different target (like tests)
- Copied from another project without re-adding

### Signs of Missing Target Membership:
- ✗ "Cannot find 'ClassName' in scope" errors
- ✗ Types are defined but compiler can't see them
- ✗ Import statements don't help
- ✗ Build succeeds but symbols are missing

---

## 🎯 PRIORITY ACTION ITEMS

1. **FIRST:** Check `WFRChapter.swift` target membership
   - This file was just recreated and is causing build errors
   - Must be added to app target immediately

2. **SECOND:** Verify all SwiftData models
   - WFRProtocol.swift
   - SOAPNote.swift
   - WFRChapter.swift (includes WFRSection, WFRContentBlock)

3. **THIRD:** Verify core infrastructure
   - AppSettings.swift
   - SubscriptionManager.swift
   - VitalSignsTracker.swift

4. **FOURTH:** Verify all views
   - Search project for all `.swift` files
   - Check each one's target membership

---

## 📝 NOTES

### Recently Recreated Files:
- `WFRChapter.swift` (Nov 10, 2025) - **CHECK THIS FIRST!**

### Files That Were Working:
- Other models were presumably working before
- Focus on newly created/added files

### Testing Verification:
After checking target membership:
1. Clean Build Folder (Shift+Cmd+K)
2. Rebuild (Cmd+B)
3. All errors should be resolved

---

## 🚀 NEXT STEPS AFTER FIX

Once all files are in target:
1. Uncomment the three model types in `WFR_TrailTriageApp.swift` (already done)
2. Clean and rebuild
3. Test app launch
4. Verify iCloud sync is working for all models
5. Test reference book feature

---

## 📋 CHECKLIST SUMMARY

**Before Running App:**
- [ ] All SwiftData models added to target
- [ ] All managers/settings added to target  
- [ ] All view files added to target
- [ ] Clean build succeeds with no errors
- [ ] App launches without crashes

**After App Runs:**
- [ ] SwiftData container initializes successfully
- [ ] All tabs in MainTabView load correctly
- [ ] Reference book view displays
- [ ] Onboarding works (if first launch)
- [ ] iCloud sync indicator appears (if enabled)
