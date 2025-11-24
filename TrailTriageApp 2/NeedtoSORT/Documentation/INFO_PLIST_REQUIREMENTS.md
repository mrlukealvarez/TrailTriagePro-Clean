# Required Info.plist Configuration

## Location Services

Add this to your `Info.plist` file:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>WFR TrailTriage uses your location to document incident coordinates for emergency responders and evacuation planning.</string>
```

### How to Add:
1. Open your project in Xcode
2. Select your target
3. Go to the "Info" tab
4. Click the "+" button to add a new key
5. Select "Privacy - Location When In Use Usage Description"
6. Add the description above

---

## Optional: Photo Library Access (for future photo attachments)

If you plan to add photo attachment features in a future update:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>WFR TrailTriage can attach photos to document injuries and scene information.</string>

<key>NSCameraUsageDescription</key>
<string>WFR TrailTriage can take photos to document injuries and scene information.</string>
```

---

## Optional: Microphone Access (for future voice notes)

If you plan to add voice note recording in a future update:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>WFR TrailTriage can record voice notes for quick field documentation.</string>
```

---

## App Category & Permissions

Recommended settings for your target:

- **Category:** Medical
- **Requires full screen:** No
- **Supports multiple windows:** No (for V1, can add later)
- **Device orientation:** Portrait (primary), Landscape (optional)

---

## Build Settings Checklist

### General Tab:
- [ ] Bundle Identifier set (e.g., com.yourcompany.wfrtrailtriage)
- [ ] Version: 1.0
- [ ] Build: 1
- [ ] Minimum iOS: 17.0
- [ ] Supported Devices: iPhone, iPad

### Signing & Capabilities:
- [ ] Team selected
- [ ] Signing certificate active
- [ ] Bundle ID registered

### Required Capabilities:
- [ ] Location Services (When In Use)

### Optional Capabilities (for future):
- [ ] iCloud (if you want cloud sync)
- [ ] Push Notifications (for medication reminders, etc.)

---

## App Icons & Assets

Don't forget to add:
- [ ] App Icon (all required sizes in Assets.xcassets)
- [ ] App Store screenshot (iPhone and iPad)
- [ ] Launch screen (if custom)

---

## TestFlight Preparation

Before submitting to TestFlight:

1. **Test on real device** (not just simulator)
2. **Test location permissions** in real environment
3. **Test offline functionality** (airplane mode)
4. **Create test notes** and export them
5. **Verify responder info** appears in exports
6. **Test all tabs** and navigation flows
7. **Test on both iPhone and iPad** (if supporting both)

---

## App Store Listing Suggestions

### Short Description:
"Professional SOAP note documentation for wilderness first responders. Works completely offline."

### Keywords:
wilderness, first aid, WFR, SOAP notes, medical, emergency, outdoor, hiking, EMT, rescue, documentation

### Primary Category:
Medical

### Secondary Category:
Education

---

## Privacy Policy Requirements

Since you're collecting location data, Apple requires a privacy policy. Create a simple one covering:

1. What data you collect (location, notes)
2. Where it's stored (locally on device only)
3. Who has access (only the user)
4. How to delete data (delete app)

Example:
```
Privacy Policy for WFR TrailTriage

Data Collection:
- Location data (only when user requests coordinates)
- SOAP notes (stored locally on device)
- User settings

Data Storage:
All data is stored locally on your device. We do not transmit or store any data on external servers.

Data Sharing:
We do not share your data with any third parties.

Data Deletion:
To delete all data, simply delete the app from your device.

Contact:
support@blackelkmountainmedicine.com
```

Host this on your website and link it in App Store Connect.

---

You're almost ready to ship! 🚀
