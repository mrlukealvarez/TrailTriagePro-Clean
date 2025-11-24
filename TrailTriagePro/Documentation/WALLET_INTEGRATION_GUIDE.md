# 📱 APPLE WALLET INTEGRATION GUIDE
### TrailTriage - Quick Lock Screen Access
#### November 12, 2025

---

## 🎯 WHAT YOU'RE BUILDING

Like the Amazon example you shared, you'll create an "Add to Apple Wallet" button that lets users:

1. **Quick access from lock screen** - Double-click side button
2. **Live Activity integration** - Real-time vitals tracking
3. **Offline functionality** - Works without internet
4. **NFC support** - Share with other responders

---

## 🏗️ IMPLEMENTATION PHASES

### PHASE 1: Basic Wallet Pass (Week 1)
- [ ] Set up Pass Type ID in Apple Developer Portal
- [ ] Create basic pass design
- [ ] Implement "Add to Wallet" button
- [ ] Test on device

### PHASE 2: Dynamic Updates (Week 2)
- [ ] Set up web service for pass updates
- [ ] Implement subscription status sync
- [ ] Add recent notes to pass
- [ ] Update pass when content changes

### PHASE 3: Live Activities (Week 3)
- [ ] Integrate with vitals tracking
- [ ] Show active patient info on lock screen
- [ ] Dynamic Island support
- [ ] Push notifications for updates

---

## 📋 SETUP REQUIREMENTS

### Apple Developer Portal Setup

1. **Create Pass Type ID**
   ```
   1. Go to: developer.apple.com/account
   2. Certificates, Identifiers & Profiles
   3. Identifiers → (+) New
   4. Select "Pass Type IDs"
   5. Description: "TrailTriage Wallet Pass"
   6. Identifier: pass.com.blackelkmountain.trailtriage
   7. Register
   ```

2. **Create Pass Type ID Certificate**
   ```
   1. In Pass Type IDs section, select your pass
   2. Click "Create Certificate"
   3. Follow CSR upload process
   4. Download certificate
   5. Double-click to add to Keychain
   ```

3. **Update App Capabilities**
   ```
   Xcode → Target → Signing & Capabilities
   (+) Add: Wallet
   ```

---

## 💻 CODE INTEGRATION

### Step 1: Add PassKit Framework

Already done! The `WalletPassManager.swift` file includes:
- Pass creation logic
- Add to Wallet button
- Status tracking

### Step 2: Add to Settings or Paywall

**Option A: In PaywallView (After Purchase)**
```swift
// Add after successful purchase
if StoreManager.shared.hasFullAccess {
    Section {
        NavigationLink {
            WalletIntegrationView()
        } label: {
            Label("Add to Apple Wallet", systemImage: "wallet.pass.fill")
        }
    } header: {
        Text("Quick Access")
    }
}
```

**Option B: In Settings (Always Available)**
```swift
// Add to SettingsView.swift
Section {
    NavigationLink {
        WalletIntegrationView()
    } label: {
        HStack {
            Label("Apple Wallet", systemImage: "wallet.pass.fill")
            Spacer()
            if WalletPassManager.shared.passStatus == .added {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
    }
} header: {
    Text("Quick Access")
}
```

### Step 3: Create Pass JSON

Create `pass.json` file:
```json
{
  "formatVersion": 1,
  "passTypeIdentifier": "pass.com.blackelkmountain.trailtriage",
  "serialNumber": "TRAIL-001",
  "teamIdentifier": "YOUR_TEAM_ID",
  "organizationName": "Black Elk Mountain Medicine",
  "description": "TrailTriage - WFR Quick Access",
  
  "logoText": "TrailTriage",
  "foregroundColor": "rgb(255, 255, 255)",
  "backgroundColor": "rgb(0, 122, 255)",
  "labelColor": "rgb(255, 255, 255)",
  
  "storeCard": {
    "headerFields": [
      {
        "key": "status",
        "label": "STATUS",
        "value": "Pro Active"
      }
    ],
    "primaryFields": [
      {
        "key": "name",
        "label": "APP",
        "value": "TrailTriage WFR"
      }
    ],
    "secondaryFields": [
      {
        "key": "subscription",
        "label": "ACCESS",
        "value": "Lifetime"
      }
    ],
    "auxiliaryFields": [
      {
        "key": "recent",
        "label": "RECENT",
        "value": "3 notes today"
      }
    ],
    "backFields": [
      {
        "key": "terms",
        "label": "Terms",
        "value": "Professional medical tool for trained wilderness first responders."
      },
      {
        "key": "website",
        "label": "Website",
        "value": "https://blackelkmountainmedicine.com"
      }
    ]
  },
  
  "barcode": {
    "message": "TRAIL-TRIAGE-2025",
    "format": "PKBarcodeFormatQR",
    "messageEncoding": "iso-8859-1"
  },
  
  "webServiceURL": "https://yourserver.com/passes/",
  "authenticationToken": "your-secret-token"
}
```

### Step 4: Add Images

Create pass images:
- `icon.png` (29x29 @1x, 58x58 @2x, 87x87 @3x)
- `icon@2x.png`
- `icon@3x.png`
- `logo.png` (160x50)
- `logo@2x.png` (320x100)
- `logo@3x.png` (480x150)

Use SF Symbols for quick prototyping:
```swift
// Export SF Symbol as image
let image = UIImage(systemName: "cross.case.fill")
```

### Step 5: Sign the Pass

You'll need a server-side script to:
1. Create `manifest.json` (SHA1 hashes of all files)
2. Sign manifest with your certificate
3. Create `signature` file
4. Zip everything into `.pkpass` file

**Simple Node.js example:**
```javascript
const { createPass } = require('passkit-generator');

async function generatePass() {
  const pass = await createPass({
    model: './PassModels/TrailTriage',
    certificates: {
      wwdr: './certs/wwdr.pem',
      signerCert: './certs/signerCert.pem',
      signerKey: './certs/signerKey.pem',
      signerKeyPassphrase: 'your-passphrase'
    }
  });
  
  return pass.getAsBuffer();
}
```

---

## 🚀 QUICK START (Testing Without Server)

For **testing only**, you can use Apple's sample passes:

1. **Download Apple's Sample Pass**
   ```
   developer.apple.com/wallet/
   Download "Wallet Developer Guide" PDF
   Extract sample pass
   ```

2. **Modify for TrailTriage**
   - Update pass.json with your identifiers
   - Change colors to match your brand
   - Add your logo

3. **Test on Device**
   - Email .pkpass file to yourself
   - Open on iPhone
   - Tap "Add" to add to Wallet

---

## 🎨 DESIGN RECOMMENDATIONS

### Color Scheme
```swift
// Match your app's brand
foregroundColor: "rgb(255, 255, 255)" // White text
backgroundColor: "rgb(0, 122, 255)"   // Blue (medical)
labelColor: "rgb(255, 255, 255)"       // White labels
```

### Information Hierarchy
**Front of Card:**
1. **Header**: Subscription status (Pro Active / Trial / Expired)
2. **Primary**: App name & logo
3. **Secondary**: Access type (Lifetime / Monthly)
4. **Auxiliary**: Recent activity (3 notes today)

**Back of Card:**
1. Emergency contact info
2. Custer SAR info
3. App website
4. Terms & disclaimers

---

## 🔄 DYNAMIC UPDATES

### Update Pass When:
1. Subscription changes (Pro → Expired)
2. New note is created
3. Vitals are updated
4. Content is synced

### Implementation:
```swift
extension WalletPassManager {
    func updatePass(with info: PassUpdateInfo) async {
        // 1. Create new pass.json with updated data
        // 2. Sign the pass
        // 3. Send push notification to user's device
        // 4. iOS fetches updated pass from your server
        
        // This requires a web service endpoint
        // See: developer.apple.com/documentation/walletpasses/updating_a_pass
    }
}
```

---

## 🎯 USE CASES FOR TRAILTRIAGE

### Emergency Access
```
Scenario: User needs quick access during emergency
1. Double-click side button on iPhone
2. TrailTriage pass appears
3. Tap to open app
4. Already at protocol screen
```

### Vitals Tracking (Live Activity)
```
Scenario: Monitoring patient vitals
1. Start vitals tracking in app
2. Pass updates on lock screen
3. Shows last recorded vitals
4. Countdown to next check
```

### Share with Team
```
Scenario: Multiple responders on scene
1. User taps "Share Pass"
2. NFC or AirDrop to teammate
3. Team has same reference material
4. Coordinated response
```

### Offline Verification
```
Scenario: No cell service in wilderness
1. QR code on pass
2. Contains: User ID, Cert level, Expiry
3. Other responders can verify training
4. All offline-capable
```

---

## 🧪 TESTING CHECKLIST

- [ ] Pass appears in Wallet app
- [ ] Lock screen access works (double-click side button)
- [ ] Tapping pass opens TrailTriage app
- [ ] Pass updates when subscription changes
- [ ] Colors and branding match app
- [ ] QR code scans correctly
- [ ] Back of card shows correct info
- [ ] Pass works offline
- [ ] Pass syncs across devices (iCloud)

---

## 🚨 IMPORTANT NOTES

### Privacy
- Don't include sensitive patient data on pass
- Only show general status (e.g., "3 notes today")
- HIPAA considerations for any patient info

### Performance
- Keep pass file size < 500KB
- Optimize images (use PNG-8 when possible)
- Minimize update frequency (max once per hour)

### User Experience
- Explain benefits before adding to Wallet
- Show preview before download
- Allow removal from Wallet
- Respect user's choice to not add

---

## 📱 LIVE ACTIVITY INTEGRATION

### For Active Patient Monitoring

**When user starts vitals tracking:**
```swift
// Start Live Activity
let attributes = VitalsActivityAttributes(patientID: patient.id)
let contentState = VitalsActivityAttributes.ContentState(
    heartRate: 72,
    respiratoryRate: 16,
    bloodPressure: "120/80",
    lastCheck: Date()
)

let activity = try Activity.request(
    attributes: attributes,
    contentState: contentState,
    pushType: .token
)

// This appears in Dynamic Island and Lock Screen
// AND updates the Wallet pass simultaneously!
```

**Result:**
- Dynamic Island shows live vitals
- Lock Screen widget updates
- Wallet pass reflects current status
- All synchronized automatically

---

## 🎉 RECOMMENDED FLOW

### For Your App:

1. **After Purchase/Subscription**
   ```
   ✅ Purchase successful
   "Want quick access from your lock screen?"
   [Add to Apple Wallet] [Maybe Later]
   ```

2. **During Onboarding** (Optional)
   ```
   Page 4 of onboarding:
   "Quick Access Tip"
   - Show Wallet pass preview
   - Explain lock screen access
   - Option to add later in Settings
   ```

3. **Settings Section**
   ```
   Settings → Quick Access → Apple Wallet
   - Current status: Added / Not Added
   - Preview of pass
   - "Add to Wallet" button
   - Explanation of benefits
   ```

---

## 🔗 RESOURCES

- [Apple Wallet Developer Guide](https://developer.apple.com/wallet/)
- [PassKit Framework](https://developer.apple.com/documentation/passkit/)
- [Pass Design Guidelines](https://developer.apple.com/design/human-interface-guidelines/wallet)
- [Sample Passes](https://developer.apple.com/wallet/get-started/)

---

## 💡 NEXT STEPS

1. **This Week**: 
   - Set up Pass Type ID in Developer Portal
   - Add "Add to Wallet" button to Settings
   - Create pass preview UI

2. **Next Week**:
   - Implement basic pass creation
   - Test on physical device
   - Gather user feedback

3. **Future**:
   - Set up web service for updates
   - Integrate Live Activities
   - Add team sharing features

---

## ✅ IMPLEMENTATION STATUS

**Current Status:**
- [x] PassKit framework added
- [x] WalletPassManager created
- [x] UI components built (WalletIntegrationView)
- [x] Preview/demo ready
- [ ] Pass Type ID registered
- [ ] Certificate installed
- [ ] Server setup for signing
- [ ] Live testing

**Next Action:**
Go to Apple Developer Portal and create your Pass Type ID!

---

**This will make your app stand out and significantly improve emergency access times! 🚀**
