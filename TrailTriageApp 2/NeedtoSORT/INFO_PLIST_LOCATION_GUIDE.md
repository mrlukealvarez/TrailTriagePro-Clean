# Info.plist Location Permission - Exact Code to Add

## If Your Info.plist is in GUI Mode (Default View):

### Steps:
1. Open `Info.plist` in Xcode
2. You'll see a table with "Key" and "Value" columns
3. Right-click anywhere and select "Add Row"
4. In the new row, start typing in the Key field: `Privacy - Location`
5. From the dropdown, select: **Privacy - Location When In Use Usage Description**
6. In the Value field, type: `WFR TrailTriage uses your location to document incident coordinates for emergency responders and evacuation planning.`
7. Press Enter
8. Save the file (Cmd+S)

---

## If Your Info.plist is in Source Code Mode (XML):

### Steps:
1. Right-click `Info.plist` in Project Navigator
2. Select "Open As" → "Source Code"
3. Find the `<dict>` tag near the top (usually around line 4-5)
4. Add these lines anywhere between `<dict>` and `</dict>`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>WFR TrailTriage uses your location to document incident coordinates for emergency responders and evacuation planning.</string>
```

### Example - Before:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <!-- Your other keys here -->
</dict>
</plist>
```

### Example - After:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    
    <!-- ADD THIS LINE -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>WFR TrailTriage uses your location to document incident coordinates for emergency responders and evacuation planning.</string>
    
    <!-- Your other keys here -->
</dict>
</plist>
```

---

## ✅ Verify It Worked

### GUI Mode:
After adding, you should see in the Info.plist table:
- **Key:** Privacy - Location When In Use Usage Description
- **Type:** String
- **Value:** WFR TrailTriage uses your location to document incident coordinates for emergency responders and evacuation planning.

### Source Code Mode:
You should see these two lines in the XML:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>WFR TrailTriage uses your location to document incident coordinates for emergency responders and evacuation planning.</string>
```

---

## 🎯 What This Does

- ✅ Tells iOS your app needs location access
- ✅ Shows this message to users when they're asked for permission
- ✅ Required by Apple App Store Review
- ✅ Prevents app crash when requesting location

---

## 🚨 Common Mistakes to Avoid

❌ **Wrong Key Name**
- Don't use: `NSLocationAlwaysUsageDescription` (that's for background location)
- Don't use: `NSLocationDescription` (doesn't exist)
- ✅ Use: `NSLocationWhenInUseUsageDescription` (exact spelling)

❌ **No Description**
- Don't leave the value blank
- ✅ Must have a clear explanation

❌ **Wrong Format**
- Don't put XML tags in GUI mode (it handles that)
- ✅ Just type the description text in the Value field

---

## 🔍 Testing

After adding the permission:

1. Build and run your app (Cmd+R)
2. Go to "New Note" tab
3. Start creating a note
4. Scroll to "Scene Information"
5. Tap "Add Coordinates"
6. **You should see:** Permission dialog with your description
7. Tap "Allow" (in simulator or on device)
8. Coordinates should be captured

---

## 📱 Device vs Simulator

### Simulator:
- Will show permission dialog
- May use fake GPS location (set in Features menu)
- Good for testing the UI

### Real Device:
- Shows actual permission dialog
- Uses real GPS
- **Required for final testing**
- Test outdoors for accurate coordinates

---

## ✨ That's It!

This one simple addition to Info.plist:
- ✅ Fixes location crashes
- ✅ Passes App Store review requirements
- ✅ Provides clear user communication
- ✅ Enables GPS functionality

Just add it and you're done! 🎉
