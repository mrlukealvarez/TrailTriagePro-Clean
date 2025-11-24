# StoreKit Subscription Setup Guide

## ✅ What I've Built for You

### 1. **SubscriptionManager.swift**
- Handles all StoreKit 2 logic
- Loads products from App Store
- Manages purchase flow
- Checks subscription status
- Listens for transaction updates
- Handles restore purchases

### 2. **Updated PaywallView**
- Shows 3-day free trial offer
- Displays features list
- Purchase button with StoreKit integration
- Restore purchase button
- Error handling

### 3. **SubscriptionStatusView.swift**
- Shows current subscription status
- Lists enabled features
- Manage subscription button
- Restore purchase option
- Subscription info

### 4. **TrailTriageStoreKit.storekit**
- StoreKit testing configuration file
- Pre-configured with yearly subscription ($9.99)
- 3-day free trial setup
- Use for local testing

---

## 📋 Your Next Steps

### Step 1: Xcode Configuration (5 min)

1. **Add StoreKit Configuration File**
   - In Xcode, select the project in navigator
   - Go to "Signing & Capabilities" tab
   - Click "+ Capability"
   - Add "In-App Purchase"

2. **Enable StoreKit Testing**
   - Product menu → Scheme → Edit Scheme
   - Run → Options tab
   - StoreKit Configuration: Select "TrailTriageStoreKit.storekit"

### Step 2: App Store Connect Setup (15 min)

1. **Login to App Store Connect**
   - Go to https://appstoreconnect.apple.com
   - Select your app

2. **Create Subscription Group**
   - Go to "Features" → "Subscriptions"
   - Click "+" to create subscription group
   - Name: "TrailTriage Pro"

3. **Add Subscription Product**
   - Click "+" under the subscription group
   - **Reference Name**: TrailTriage Pro Annual
   - **Product ID**: `com.trailtriage.pro.yearly` (MUST match code!)
   - **Subscription Duration**: 1 Year
   - **Price**: $9.99 USD (Tier 10)

4. **Add Free Trial**
   - In product settings, scroll to "Subscription Prices"
   - Click "Add Introductory Offer"
   - **Duration**: 3 days
   - **Type**: Free trial
   - **Number of periods**: 1

5. **Add Localization**
   - Click "+" under Subscription Localizations
   - **Locale**: English (U.S.)
   - **Display Name**: TrailTriage Pro
   - **Description**: "Professional wilderness first responder documentation with unlimited SOAP notes, advanced assessments, vitals tracking, and more."

6. **Submit for Review**
   - Fill in required metadata (screenshots, etc.)
   - Submit subscription for review
   - ⚠️ Must be approved before going live

### Step 3: Update Product ID (2 min)

In `SubscriptionManager.swift`, line 27:
```swift
private let yearlySubscriptionID = "com.trailtriage.pro.yearly"
```

**Make sure this EXACTLY matches** your Product ID in App Store Connect!

### Step 4: Add Subscription Manager to App (5 min)

In your main app file (probably `WFRTrailTriageApp.swift`), add:

```swift
import SwiftUI

@main
struct WFRTrailTriageApp: App {
    @State private var subscriptionManager = SubscriptionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(subscriptionManager)
        }
    }
}
```

### Step 5: Add Subscription Status to Settings (2 min)

In your Settings view, add a navigation link:

```swift
NavigationLink {
    SubscriptionStatusView()
} label: {
    HStack {
        Label("Subscription", systemImage: "creditcard.fill")
        Spacer()
        // Optional: Show status badge
        Text(subscriptionManager.subscriptionStatus.displayText)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
```

---

## 🧪 Testing Your Subscription

### Local Testing (Xcode)

1. **Run with StoreKit Configuration**
   - Run app in simulator/device
   - StoreKit uses test configuration (no real money!)
   - Test purchase flow
   - Test restore flow
   - Verify trial period

2. **Testing Scenarios**
   - Fresh install (should show paywall)
   - Purchase subscription
   - Close app, reopen (should remember subscription)
   - Restore purchase on new device

### Sandbox Testing (Real Devices)

1. **Create Sandbox Tester**
   - App Store Connect → Users and Access → Sandbox Testers
   - Add a test Apple ID (use a fake email like `test@example.com`)

2. **Sign Out of App Store**
   - Settings → App Store → Sign Out
   - Don't sign in yet!

3. **Run App from Xcode**
   - Install on real device
   - When purchasing, it will prompt for Apple ID
   - Use sandbox tester account
   - Test full flow

---

## 🎯 Testing Checklist

- [ ] App launches without errors
- [ ] PaywallView shows correct price ($9.99/year)
- [ ] "3-Day Free Trial" badge displays
- [ ] Can tap "Start Free Trial" button
- [ ] Purchase sheet appears
- [ ] Can complete purchase (sandbox)
- [ ] Subscription status updates to "In Trial"
- [ ] Features are unlocked
- [ ] App remembers subscription after restart
- [ ] "Restore Purchase" works
- [ ] "Manage Subscription" opens App Store sheet

---

## 🚨 Common Issues & Fixes

### "Failed to load products"
- Check product ID matches exactly
- Ensure In-App Purchase capability is enabled
- Wait 24 hours after creating product in App Store Connect
- Make sure StoreKit configuration is selected in scheme

### "Purchase failed"
- Verify sandbox tester is set up correctly
- Sign out of real Apple ID first
- Check device/simulator supports StoreKit

### "Subscription doesn't persist"
- Make sure SubscriptionManager is in app's environment
- Check transaction listener is running
- Verify entitlement check logic

---

## 📱 Going Live

### Before Submission:
1. ✅ Test thoroughly in sandbox
2. ✅ Submit subscription for review in App Store Connect
3. ✅ Add subscription terms to app description
4. ✅ Include screenshots showing subscription flow
5. ✅ Add privacy policy URL (required for subscriptions)

### App Store Review Notes:
Include these points:
- "This app offers a 3-day free trial"
- "Subscription auto-renews at $9.99/year"
- "Users can manage/cancel in Settings"
- Provide test account credentials

---

## 💰 Expected Revenue Flow

| Scenario | Your Revenue |
|----------|-------------|
| User subscribes (Year 1) | $6.99 (after 30% Apple fee) |
| User renews (Year 2+) | $8.49 (after 15% Apple fee) |
| User cancels during trial | $0.00 |

**Churn estimates:**
- ~30-40% typically cancel during/after trial
- ~60-70% of trial users convert to paying
- After Year 1, retention ~70-80%

---

## 🎓 Resources

- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Subscription Best Practices](https://developer.apple.com/app-store/subscriptions/)

---

## ✅ You're Ready!

The code is complete and ready to use. Just follow the setup steps above, and you'll have a fully functional subscription system with:

- ✅ 3-day free trial
- ✅ $9.99/year auto-renewing subscription
- ✅ Restore purchases
- ✅ Manage subscription
- ✅ Transaction verification
- ✅ Offline support

**Questions?** Let me know if you need help with any step! 🚀
