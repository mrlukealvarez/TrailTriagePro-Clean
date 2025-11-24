# Onboarding Flow Documentation

## Overview
TrailTriage uses a one-time onboarding flow that **requires** users to complete subscription before accessing the main app.

## Flow Diagram

```
First Launch
    ↓
Welcome Screen (Get Started button)
    ↓
Sign In with Apple (Required)
    ↓
Profile Setup (Name & Agency Required)
    ↓
Permissions (Location & iCloud - Optional)
    ↓
Subscription (Start Free Trial - REQUIRED) ← User MUST subscribe here
    ↓
Main App (New Note, My Notes, Reference, etc.)
```

## Key Implementation Details

### 1. App Entry Point (`WFR_TrailTriageApp.swift`)
- Checks `UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")`
- If `false`: Shows **ONLY** OnboardingView (not an overlay)
- If `true`: Shows **ONLY** MainTabView (never shows onboarding again)

```swift
if showOnboarding {
    OnboardingView(isPresented: $showOnboarding)
        .environment(appSettings)
} else {
    MainTabView()
        .environment(appSettings)
        .environment(subscriptionManager)
}
```

### 2. Onboarding Coordinator
Tracks progress through steps and enforces rules:

**Step Requirements:**
- ✅ **Welcome**: No requirements (always can proceed)
- 🔐 **Sign In**: Must sign in with Apple (userID != nil)
- 📝 **Profile**: Must provide name and agency (both non-empty)
- ⚙️ **Permissions**: Optional (always can proceed)
- 💳 **Subscription**: **MUST start trial or restore purchase** (hasStartedTrial == true)

### 3. Subscription Enforcement

#### During Onboarding
```swift
func canProceedFromCurrentStep() -> Bool {
    switch currentStep {
    case .subscription:
        // MUST subscribe or start trial to proceed
        return hasStartedTrial
    // ... other cases
    }
}
```

#### After Onboarding
- Once `hasCompletedOnboarding = true` is saved to UserDefaults, onboarding never shows again
- StoreKit automatically monitors subscription status
- If subscription expires/is cancelled, StoreKit will handle access restrictions
- Users can manage subscription in Settings → Subscription

### 4. Testing Mode

For development and testing, there's a DEBUG-only skip button:

```swift
#if DEBUG
Button("Skip (Testing Only)") {
    coordinator.hasStartedTrial = true
    coordinator.nextStep()
}
#endif
```

**⚠️ IMPORTANT**: Remove this before App Store submission!

### 5. Restore Purchases

Users who already have an active subscription can use "Restore Purchases":
- Checks StoreKit for existing valid subscriptions
- If found: Proceeds to main app
- If not found: Shows error message

## User Experience

### First Time User
1. Opens app → Sees welcome screen with app logo
2. Taps "Get Started" → Moves to Sign In
3. Signs in with Apple → Gets user ID and name
4. Fills out profile (name, agency, certifications) → Saves to AppSettings
5. Reviews permissions (optional) → Can grant or skip
6. **Must start free trial** → Cannot skip this step
7. After successful subscription → Saves onboarding completion flag
8. App closes onboarding → Shows MainTabView with all features

### Returning User
1. Opens app → Immediately sees MainTabView
2. No onboarding screen
3. Full access to all features

### User Who Cancels Subscription
1. StoreKit detects expired subscription
2. App continues to work (data is still accessible)
3. User can resubscribe in Settings → Subscription
4. Can also restore purchases if subscription is still valid

## Data Persistence

### Onboarding Completion
```swift
UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
UserDefaults.standard.set(userID, forKey: "userID")
```

### User Profile
Saved to `AppSettings` (@Observable class):
- `responderName`
- `responderAgency`
- `responderRescueNumber`
- `responderCertification`
- `responderCertification2`

### Subscription Status
- Managed by StoreKit 2
- `SubscriptionManager` monitors transaction updates
- Automatically syncs across devices via Apple ID

## Best Practices Implemented

✅ **One-time onboarding**: Never shown again after completion
✅ **Required subscription**: Cannot access app without subscribing
✅ **Restore purchases**: Easy path for existing subscribers
✅ **Testing mode**: DEBUG skip button for development
✅ **Clear progress**: Page dots show current step
✅ **Error handling**: Shows alerts if subscription fails
✅ **Professional flow**: Sign in → Profile → Subscribe
✅ **Data persistence**: All user info saved properly

## Future Enhancements

Consider adding:
- [ ] Progress indicator (Step 1 of 5)
- [ ] Back button on steps (if you want users to go back)
- [ ] Animation transitions between steps
- [ ] Haptic feedback on completion
- [ ] Analytics tracking for each step
- [ ] A/B testing different subscription copy

## Security Notes

🔒 **Sign in with Apple**: Provides secure, privacy-focused authentication
🔒 **StoreKit 2**: Built-in receipt validation and fraud prevention
🔒 **iCloud Sync**: End-to-end encrypted user data
🔒 **Local-first**: App works offline, no server dependencies

## App Store Requirements

Before submission:
1. ✅ Remove DEBUG skip button
2. ✅ Add privacy policy URL
3. ✅ Add terms of service
4. ✅ Configure App Store Connect with subscription product
5. ✅ Test subscription flow in Sandbox environment
6. ✅ Add screenshots showing value proposition
7. ✅ Clearly communicate free trial terms (3 days)

## Support Scenarios

### "I already paid but seeing subscription screen"
→ Tap "Restore Purchases" button

### "I want to cancel my trial"
→ Settings → Subscription → Manage Subscription (opens App Store)

### "I completed onboarding but still seeing it"
→ Check UserDefaults for "hasCompletedOnboarding" key
→ Possible solution: Delete and reinstall app (edge case)

### "Can I try the app before subscribing?"
→ No, subscription is required. But 3-day free trial allows full access.

## Code Locations

- **Main App**: `WFR_TrailTriageApp.swift` (lines 16-17, 34-44)
- **Onboarding**: `OnboardingView.swift` (entire file)
- **Subscription Manager**: `SubscriptionManager.swift`
- **Main App Interface**: `MainTabView.swift`

---

**Last Updated**: November 9, 2025
**Version**: 1.0
