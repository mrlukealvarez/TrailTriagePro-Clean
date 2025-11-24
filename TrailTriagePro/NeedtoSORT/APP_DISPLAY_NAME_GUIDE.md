# App Display Name Configuration
## TrailTriage: WFR Toolkit

**Important:** The app name you see on the home screen is controlled by your `Info.plist` file and Xcode project settings, **not** by the code in Swift files.

---

## How to Update the App Display Name

### Method 1: In Xcode Project Settings (Recommended)

1. **Open your project in Xcode**
2. **Select the project** in the Navigator (blue icon at the top)
3. **Select your target** (TrailTriage or WFR TrailTriage)
4. **Go to the "General" tab**
5. **Find "Display Name"** field
6. **Enter:** `TrailTriage: WFR Toolkit`
7. **Build and run** to see the change on your device

### Method 2: Edit Info.plist Directly

1. **Locate `Info.plist`** in your project
2. **Find or add the key:** `CFBundleDisplayName`
3. **Set the value to:** `TrailTriage: WFR Toolkit`
4. **Save the file**
5. **Clean build folder** (Cmd+Shift+K)
6. **Build and run**

---

## Current Configuration Should Be

### Info.plist Keys

```xml
<key>CFBundleDisplayName</key>
<string>TrailTriage: WFR Toolkit</string>

<key>CFBundleName</key>
<string>$(PRODUCT_NAME)</string>

<key>CFBundleIdentifier</key>
<string>com.blackelkmountainmedicine.trailtriage</string>
```

### Xcode Target Settings

- **Display Name:** `TrailTriage: WFR Toolkit`
- **Bundle Identifier:** `com.blackelkmountainmedicine.trailtriage`
- **Product Name:** `TrailTriage`
- **Organization Name:** `BlackElkMountainMedicine.com`

---

## Character Limit for Display Names

**iOS Home Screen Display Name Limits:**
- **iPhone:** Maximum ~13-14 characters (depends on font/device)
- **iPad:** Maximum ~15-16 characters
- **App Store:** Maximum 30 characters

**Our App Name:** "TrailTriage: WFR Toolkit" = 26 characters

This fits within the App Store limit, but may be truncated on the home screen depending on device.

### Display Name Truncation Examples

**iPhone Home Screen:**
```
TrailTriage:...   (truncated)
```

**App Store & Settings:**
```
TrailTriage: WFR Toolkit   (full name)
```

### Alternative Short Names (if needed)

If you need a shorter version for the home screen while keeping the full name in the App Store:

1. **Display Name (Home Screen):** `TrailTriage`
2. **App Store Name:** `TrailTriage: WFR Toolkit`

To do this:
- Set `CFBundleDisplayName` to `TrailTriage` in Info.plist
- Use full name `TrailTriage: WFR Toolkit` in App Store Connect

---

## App Store Connect Configuration

### App Information
1. **Log in to App Store Connect**
2. **Select your app**
3. **Go to "App Information"**
4. **Set "Name":** `TrailTriage: WFR Toolkit`
5. **Set "Subtitle":** `Wilderness First Responder SOAP Notes` (or similar, max 30 chars)
6. **Set "Category":** Medical
7. **Set "Secondary Category":** Education

### Marketing Information
- **Developer Name:** BlackElkMountainMedicine.com
- **Marketing URL:** https://blackelkmountainmedicine.com
- **Support URL:** https://blackelkmountainmedicine.com/support
- **Privacy Policy URL:** https://blackelkmountainmedicine.com/privacy

---

## Verification Steps

After making changes, verify:

### 1. Home Screen Name
- Build and run on a physical device
- Check the app icon text on home screen
- Should show "TrailTriage: WFR Toolkit" or "TrailTriage:..." if truncated

### 2. Settings App Name
- Go to iPhone Settings
- Scroll to your app
- Should show full name: "TrailTriage: WFR Toolkit"

### 3. App Switcher Name
- Double-tap home button (or swipe up)
- Check app name in multitasking view
- Should show full or truncated name

### 4. Spotlight Search
- Swipe down on home screen
- Search for your app
- Should show "TrailTriage: WFR Toolkit"

### 5. App Store Listing
- View your app in App Store
- Name should be "TrailTriage: WFR Toolkit"

---

## Common Issues & Solutions

### Issue: Name Not Updating
**Solution:**
1. Clean build folder (Cmd+Shift+K)
2. Delete app from device
3. Rebuild and reinstall
4. If still not working, restart Xcode

### Issue: Name Truncated on Home Screen
**Solution:**
- This is normal iOS behavior
- Consider shorter display name
- Full name still shows in App Store and Settings

### Issue: Different Name in Different Places
**Solution:**
- Check `CFBundleDisplayName` in Info.plist
- Check Display Name in Xcode target settings
- Ensure consistency

---

## Where App Name Appears

| Location | Uses | Can Customize? |
|----------|------|----------------|
| Home Screen | `CFBundleDisplayName` | Yes (set in Info.plist) |
| Settings App | `CFBundleDisplayName` | Yes (same as above) |
| App Switcher | `CFBundleDisplayName` | Yes (same as above) |
| App Store | App Store Connect Name | Yes (in ASC) |
| Spotlight | `CFBundleDisplayName` | Yes (same as home screen) |
| Notifications | `CFBundleDisplayName` | Yes (same as home screen) |
| Share Sheet | `CFBundleDisplayName` | Yes (same as home screen) |

---

## Best Practices

### For Home Screen Display
✅ **Recommended:**
- Keep under 14 characters for full display
- Use clear, recognizable name
- Avoid special characters that may render poorly

❌ **Avoid:**
- Overly long names that will truncate
- All caps (hard to read when small)
- Special Unicode characters

### For App Store
✅ **Recommended:**
- Use full, descriptive name
- Include key terms (WFR, Toolkit)
- Stay within 30 character limit

❌ **Avoid:**
- Keyword stuffing
- Misleading names
- Generic terms only

---

## Current Branding

### Official App Name
**TrailTriage: WFR Toolkit**

### Display Name Strategy
**Option 1 (Current):**
- Display Name: `TrailTriage: WFR Toolkit`
- App Store: `TrailTriage: WFR Toolkit`
- May truncate on home screen but shows full name in Settings

**Option 2 (Alternative):**
- Display Name: `TrailTriage`
- App Store: `TrailTriage: WFR Toolkit`
- Always shows fully on home screen

**Recommendation:** Use Option 1 (full name) for brand consistency.

---

## Updating Across All Platforms

### iOS App
1. Update Info.plist `CFBundleDisplayName`
2. Update Xcode Display Name setting
3. Rebuild and test

### App Store
1. Log into App Store Connect
2. Update app name
3. Submit for review (if changing existing app)

### Marketing Materials
1. Update website
2. Update social media profiles
3. Update press kit
4. Update support documentation

### Code Headers
1. Update all file headers to say "TrailTriage: WFR Toolkit"
2. Update copyright notices
3. Update About screen text

---

## Jimmothy's Approval Checklist

- [ ] `CFBundleDisplayName` set to "TrailTriage: WFR Toolkit"
- [ ] Xcode Display Name matches
- [ ] App Store name is "TrailTriage: WFR Toolkit"
- [ ] Bundle ID is correct
- [ ] All file headers updated
- [ ] About screen shows correct info
- [ ] Tested on physical device
- [ ] Verified in Settings app
- [ ] Checked App Store listing
- [ ] 🦝 Jimmothy gives the raccoon seal of approval!

---

## Code to Display App Name in UI

If you need to show the app name in your UI (like an About screen):

```swift
// Get display name from Info.plist
let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "TrailTriage"

// Or use hardcoded for consistency
let appName = "TrailTriage: WFR Toolkit"
let developer = "BlackElkMountainMedicine.com"

// Usage in SwiftUI
VStack {
    Text(appName)
        .font(.title.bold())
    
    Text("by \(developer)")
        .font(.caption)
        .foregroundStyle(.secondary)
    
    Text("🦝 Featuring Jimmothy the Raccoon WFR")
        .font(.caption2)
        .italic()
}
```

---

## Testing Your Changes

### Manual Test Plan
1. **Clean and rebuild** the project
2. **Delete app** from test device
3. **Install fresh** build
4. **Check home screen** - Verify app name
5. **Check Settings** - Should show full name
6. **Check App Switcher** - Verify display
7. **Search in Spotlight** - Verify searchable name

### Automated Verification
```swift
// Unit test to verify Info.plist values
func testAppDisplayName() {
    let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    XCTAssertEqual(displayName, "TrailTriage: WFR Toolkit", "Display name should match branding")
}

func testBundleIdentifier() {
    let bundleID = Bundle.main.bundleIdentifier
    XCTAssertEqual(bundleID, "com.blackelkmountainmedicine.trailtriage")
}
```

---

## Important Notes

⚠️ **Changing Display Name of Published App:**
If your app is already published, changing the display name in App Store Connect requires app review. Plan accordingly!

⚠️ **Character Encoding:**
Use standard ASCII characters in display names. Special characters may cause issues on some systems.

⚠️ **Consistency:**
Keep the app name consistent across:
- Info.plist
- App Store Connect  
- Website
- Marketing materials
- Support documentation
- Social media
- Press releases

---

## Additional Resources

- [Apple: Configuring Your App's Info.plist](https://developer.apple.com/documentation/bundleresources/information_property_list)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [iOS Human Interface Guidelines - App Icon](https://developer.apple.com/design/human-interface-guidelines/app-icons)

---

**Summary:**
The app name on your device comes from `CFBundleDisplayName` in Info.plist, **not from code**. Update it there, clean build, and you'll see "TrailTriage: WFR Toolkit" everywhere! 🦝

---

**Last Updated:** November 13, 2025  
**Maintained By:** BlackElkMountainMedicine.com  
**Approved By:** 🦝 Jimmothy the Raccoon WFR
