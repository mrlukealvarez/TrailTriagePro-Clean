# Onboarding & Authentication Setup Guide

## Overview
TrailTriage now uses a modern onboarding flow that automatically starts users on a free trial and handles authentication via OAuth.

## What Changed

### 1. **Onboarding Flow** (New)
- 5-step onboarding shown on first app launch
- Collects user info, permissions, and starts trial automatically
- Users always have full app access after completing onboarding

### 2. **Authentication** (Sign in with Apple)
- Primary: Sign in with Apple (OAuth)
- Secondary: Google Sign-In (coming soon)
- No local accounts - uses system OAuth providers

### 3. **Subscription Model** (Simplified)
- Free 3-day trial starts during onboarding
- After trial: $9.99/year auto-renews
- Users are automatically removed if they cancel
- No paywalls in app - everyone has full access

## Required Info.plist Entries

Add these to your `Info.plist`:

```xml
<!-- Sign in with Apple -->
<key>NSAppleSignInEnabled</key>
<true/>

<!-- Location Permission (for GPS in SOAP notes) -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>TrailTriage uses your location to add GPS coordinates to incident reports for accurate EMS handoff.</string>

<!-- CloudKit/iCloud -->
<key>NSUbiquitousContainers</key>
<dict>
    <key>iCloud.com.blackelkmountainmedicine.trailtriage</key>
    <dict>
        <key>NSUbiquitousContainerIsDocumentScopePublic</key>
        <true/>
        <key>NSUbiquitousContainerName</key>
        <string>TrailTriage</string>
        <key>NSUbiquitousContainerSupportedFolderLevels</key>
        <string>Any</string>
    </dict>
</dict>
```

## Xcode Project Capabilities

### 1. Sign in with Apple
1. Select your app target
2. Go to **Signing & Capabilities**
3. Click **+ Capability**
4. Add **Sign in with Apple**

### 2. iCloud
Already configured in your code with:
```swift
ModelConfiguration(
    schema: schema,
    cloudKitDatabase: .automatic
)
```

Make sure you have:
1. **iCloud** capability enabled in Xcode
2. **CloudKit** container selected
3. Container name: `iCloud.com.blackelkmountainmedicine.trailtriage`

### 3. In-App Purchases
Already set up via StoreKit 2:
- Product ID: `com.blackelkmountainmedicine.trailtriage.yearly`
- Type: Auto-renewable subscription
- Duration: 1 year
- Free trial: 3 days

## App Store Connect Setup

### 1. Enable Sign in with Apple
1. Go to **App Store Connect**
2. Select your app
3. Go to **App Information**
4. Enable **Sign in with Apple**

### 2. Configure Subscription
1. Go to **App Store Connect > Your App > Subscriptions**
2. Create subscription group: "TrailTriage Pro"
3. Add subscription:
   - Reference name: "TrailTriage Pro Annual"
   - Product ID: `com.blackelkmountainmedicine.trailtriage.yearly`
   - Duration: 1 Year
   - Price: $9.99/year (or your preferred tier)
4. Add free trial offer:
   - Duration: 3 days
   - Type: Introductory offer
   - Applied automatically for new subscribers

### 3. Testing
For sandbox testing:
1. Create sandbox test accounts in App Store Connect
2. Sign out of real App Store on device
3. Run app and it will prompt for sandbox account when purchasing

## User Flow

### First Launch (Onboarding)
1. **Welcome** - App introduction
2. **Sign In** - Sign in with Apple (or Google)
3. **Profile** - Collect name, agency, certifications
4. **Permissions** - Request location, check iCloud
5. **Subscription** - Start 3-day free trial
6. **Complete** - Enter app with full access

### Subsequent Launches
- App opens directly to main interface
- Full access to all features
- StoreKit automatically validates subscription

### Subscription Expires/Cancelled
- StoreKit detects inactive subscription
- User is automatically logged out
- App returns to onboarding flow
- User must re-subscribe to continue

## How Auto-Kick Works

The `SubscriptionManager` automatically monitors subscription status:

```swift
// In SubscriptionManager
private func listenForTransactions() async {
    for await result in Transaction.updates {
        if case .verified(let transaction) = result {
            await transaction.finish()
            await checkSubscriptionStatus()
        }
    }
}
```

When a subscription expires:
1. StoreKit sends transaction update
2. `checkSubscriptionStatus()` runs
3. `hasActiveSubscription` becomes `false`
4. App could optionally show a re-subscribe screen
5. User must complete onboarding again to re-subscribe

## Optional: Adding Google Sign-In

To add Google Sign-In (currently placeholder):

### 1. Install Google Sign-In SDK
```bash
# Via SPM (Swift Package Manager)
# Add: https://github.com/google/GoogleSignIn-iOS
```

### 2. Configure in Google Cloud Console
1. Create OAuth 2.0 Client ID for iOS
2. Add URL scheme to Info.plist
3. Get Client ID

### 3. Update OnboardingView.swift
Replace the Google button placeholder with actual GoogleSignIn implementation.

## Privacy & Data

### What We Store Locally
- User ID from Sign in with Apple (encrypted token)
- User profile info (name, agency, etc.) - saved to AppSettings
- SOAP notes - saved to SwiftData with iCloud sync

### What We DON'T Store
- Passwords (OAuth providers handle authentication)
- Payment info (handled by Apple's StoreKit)
- Personal medical data outside of SOAP notes

### User Data Rights
- Users can delete their account data anytime
- iCloud data automatically syncs/deletes across devices
- Uninstalling app removes local data
- iCloud data persists until manually deleted

## Testing Checklist

- [ ] First launch shows onboarding
- [ ] Sign in with Apple works
- [ ] Profile information saves correctly
- [ ] Location permission request works
- [ ] iCloud status detected correctly
- [ ] Trial subscription starts successfully
- [ ] App accessible after onboarding
- [ ] Second launch skips onboarding
- [ ] Subscription status shows correctly in More > Subscription
- [ ] Can manage subscription via Settings app
- [ ] Can restore purchases

## Troubleshooting

### Onboarding Shows Every Launch
- Check: `UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")`
- Should be `true` after completing onboarding
- Delete and reinstall app to reset

### Sign in with Apple Fails
- Ensure capability is enabled in Xcode
- Check device is signed in to iCloud
- Try signing out and back in to Apple ID

### Subscription Not Loading
- Check internet connection
- Verify product ID matches App Store Connect
- Try: `await subscriptionManager.loadProducts()`
- Check Xcode console for StoreKit errors

### iCloud Not Working
- Verify user is signed in to iCloud on device
- Check Xcode capabilities include iCloud + CloudKit
- Ensure container ID matches

## Future Enhancements

Possible additions for v1.1+:
- [ ] Account deletion flow
- [ ] Profile editing in Settings
- [ ] Anonymous mode (no sign-in for those who don't need sync)
- [ ] Family sharing for subscriptions
- [ ] Monthly subscription option
- [ ] Lifetime purchase option

---

*Last updated: November 9, 2025*
