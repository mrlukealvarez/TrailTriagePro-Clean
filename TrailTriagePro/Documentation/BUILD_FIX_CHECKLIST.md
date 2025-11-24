# Build Fix Checklist
**Date:** November 16, 2025  
**Issue:** Multiple commands produce `.stringsdata` files  
**Root Cause:** Duplicate file references in Xcode project

---

## 🚨 Problem Summary

Xcode is trying to compile duplicate files, causing conflicts during the build process. The following files have duplicates that must be removed:

1. ✅ `WFRProtocol.swift` (older version from 11/7/25) → **DELETE THIS**
2. ✅ `WFRProtocol 2.swift` (newer version from 11/10/25) → **KEEP THIS** (already updated with merged properties)
3. ✅ `ReferenceBookView_New.swift` → **DELETE THIS** (marked as duplicate)
4. ✅ `ReferenceBookView.swift` → **KEEP THIS**

---

## 📋 Manual Steps Required in Xcode

### Step 1: Delete Duplicate Files ⚠️

In Xcode, locate and delete these files:

#### A. Delete Old `WFRProtocol.swift` (created 11/7/25)
1. In Xcode Project Navigator (⌘1), find `WFRProtocol.swift`
2. **Check the file header** to verify it shows `Created by Luke Alvarez on 11/7/25`
3. Right-click → **Delete**
4. Choose **"Move to Trash"** (not "Remove Reference")

#### B. Delete `ReferenceBookView_New.swift`
1. In Xcode Project Navigator, find `ReferenceBookView_New.swift`
2. Right-click → **Delete**
3. Choose **"Move to Trash"**

### Step 2: Rename `WFRProtocol 2.swift` to `WFRProtocol.swift`

1. In Xcode Project Navigator, find `WFRProtocol 2.swift`
2. Right-click → **Rename**
3. Change name to: `WFRProtocol.swift`
4. Press Enter

### Step 3: Verify File Target Membership ✅

Make sure these files are **ONLY** in the `WFR TrailTriage` target (not in multiple targets):

1. Select each file in Project Navigator
2. Open File Inspector (⌘⌥1)
3. Under "Target Membership", verify only `WFR TrailTriage` is checked

**Critical Files to Check:**
- [ ] `WFRProtocol.swift` (newly renamed)
- [ ] `NotesListView.swift`
- [ ] `ExpertModeNoteView.swift`
- [ ] `MainTabView.swift`
- [ ] `AppSettings.swift`
- [ ] `SOAPNote.swift`

### Step 4: Clean Build Folder 🧹

1. In Xcode: **Product → Clean Build Folder** (⇧⌘K)
2. Wait for completion

### Step 5: Delete DerivedData

Close Xcode, then in Terminal:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/WFR_TrailTriage-*
```

### Step 6: Rebuild 🏗️

1. Reopen Xcode
2. **Product → Build** (⌘B)
3. ✅ Build should succeed with 0 errors!

---

## 🔍 Troubleshooting

### If Build Still Fails:

#### Error: "No such module 'SwiftData'"
- **Fix**: Ensure deployment target is iOS 17.0+
- Project Settings → General → Minimum Deployments → iOS 17.0

#### Error: "Cannot find type 'WFRProtocol' in scope"
- **Fix**: The renamed file might not be in the target
- Select `WFRProtocol.swift` → File Inspector → Check "WFR TrailTriage" target

#### Error: Still seeing "Multiple commands produce"
- **Fix**: There may be additional duplicate files
- Search project for files with "2" or "copy" in the name:
  ```bash
  find . -name "* 2.swift" -o -name "*copy*.swift"
  ```

#### Error: "Build input file cannot be found"
- **Fix**: Clean references in project.pbxproj
- Close Xcode
- Use a text editor to manually remove stale references from `WFR TrailTriage.xcodeproj/project.pbxproj`
- Reopen Xcode

---

## ✅ Verification Checklist

After following all steps, verify:

- [ ] Build succeeds (⌘B) with 0 errors
- [ ] No duplicate files in Project Navigator
- [ ] `WFRProtocol.swift` exists (without "2" in name)
- [ ] `ReferenceBookView.swift` exists (without "_New" variant)
- [ ] App launches in Simulator
- [ ] All tabs navigate correctly
- [ ] Can create new SOAP note
- [ ] Can view reference protocols

---

## 📦 Git Cleanup (After Build Success)

Once Xcode builds successfully:

```bash
# Stage changes
git add .

# Commit
git commit -m "fix: remove duplicate files causing build conflicts

- Deleted old WFRProtocol.swift (11/7/25 version)
- Deleted ReferenceBookView_New.swift (duplicate)
- Renamed WFRProtocol 2.swift → WFRProtocol.swift
- Updated ARCHITECTURE.md with current structure
- Resolved 'Multiple commands produce' errors"

# Push
git push origin main
```

---

## 🎉 Success Criteria

When you see this, you're done:

```
** BUILD SUCCEEDED **

Build target WFR TrailTriage
Platform: iOS Simulator
Architecture: arm64
0 errors, 0 warnings
```

---

## 📞 Need Help?

If issues persist after following this checklist:

1. **Check Xcode Console** for specific error messages
2. **Run `xcodebuild clean`** from Terminal
3. **Restart Mac** (clears Xcode caches)
4. **Post error logs** with full context

---

**Next Steps After Build Fix:**
- [ ] Run app in Simulator to verify functionality
- [ ] Test note creation and export
- [ ] Verify reference book content loads
- [ ] Begin Test suite implementation (`Tests/`)

**Status:** 🔄 Ready to execute checklist

