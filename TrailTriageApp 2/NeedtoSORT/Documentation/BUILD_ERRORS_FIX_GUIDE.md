# Build Errors - Quick Fix Guide

## ✅ Fixed Issues:

### 1. Missing SwiftData Imports
All new files now have the proper imports:

✅ **VitalsTimelineView.swift** - Added `import SwiftData`  
✅ **VitalsTrackingPanel.swift** - Added `import SwiftData`  
✅ **ShareMultipleNotesView.swift** - Added `import SwiftData`  

### 2. Files Already Have Correct Imports:
✅ **NoteDetailView.swift** - Already has `import SwiftData`  
✅ **QuickAddVitalsSheet.swift** - Already has `import SwiftData`  
✅ **VitalSignsTracker.swift** - Doesn't need it (only uses Foundation)  
✅ **PCRFormatter.swift** - Doesn't need it (only uses UIKit/PDFKit)  
✅ **SOAPNoteCardView.swift** - Doesn't need it (doesn't use @Query)  

---

## 🔧 If You Still See Errors:

### Error: "Cannot find 'ModelContainer' in scope"
**Solution:** Make sure you've added the new files to your Xcode target!

**Steps to fix:**
1. In Xcode, select the file in Project Navigator
2. Open File Inspector (right panel, first tab)
3. Under "Target Membership", check the box next to "WFR TrailTriage"
4. Rebuild

**Files that need to be added to target:**
- ✅ VitalSignsTracker.swift
- ✅ QuickAddVitalsSheet.swift
- ✅ VitalsTimelineView.swift
- ✅ VitalsTrackingPanel.swift
- ✅ NoteDetailView.swift
- ✅ ShareMultipleNotesView.swift
- ✅ PCRFormatter.swift
- ✅ SOAPNoteCardView.swift

---

## 🎯 Quick Test After Fixing:

1. **Clean Build Folder**: Cmd + Shift + K
2. **Rebuild**: Cmd + B
3. **All errors should be gone!**

If you still see issues after adding all files to target, let me know which specific error you're seeing and I'll help debug it!

---

## 📝 Structure Check:

Your project should now have this structure:

```
WFR TrailTriage/
├── Core/
│   ├── SOAPNote.swift ✅
│   ├── VitalSigns.swift ✅
│   └── AppSettings.swift ✅
│
├── Vitals Tracking/
│   ├── VitalSignsTracker.swift ✅ NEW
│   ├── QuickAddVitalsSheet.swift ✅ NEW
│   ├── VitalsTimelineView.swift ✅ NEW (just fixed)
│   └── VitalsTrackingPanel.swift ✅ NEW (just fixed)
│
├── PDF Export/
│   ├── PCRFormatter.swift ✅ NEW
│   └── SOAPNoteCardView.swift ✅ NEW
│
├── Views/
│   ├── NoteDetailView.swift ✅ NEW
│   ├── ShareMultipleNotesView.swift ✅ NEW (just fixed)
│   ├── NotesListView.swift ✅
│   ├── MainTabView.swift ✅
│   ├── ExpertModeNoteView.swift ✅
│   └── OnboardingView.swift ✅
│
└── App/
    └── WFR_TrailTriageApp.swift ✅
```

All files should have ✅ checked box next to "WFR TrailTriage" in Target Membership!
