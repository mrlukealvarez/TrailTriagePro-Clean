# Quick Setup Checklist for Onboarding

## ✅ Step-by-Step Implementation

### 1. Add Capabilities in Xcode (2 minutes)

**Sign in with Apple:**
1. Select `WFR TrailTriage` target
2. Signing & Capabilities tab
3. Click `+ Capability`
4. Search for and add: **Sign in with Apple**

**CloudKit (should already be there):**
- Verify `iCloud` capability exists
- Check that `CloudKit` is enabled
- Container: `iCloud.com.blackelkmountainmedicine.trailtriage`

### 2. Update Info.plist (1 minute)

Add this location permission description:

**Key:** `NSLocationWhenInUseUsageDescription`  
**Value:** `TrailTriage uses your location to add GPS coordinates to incident reports for accurate EMS handoff.`

In Xcode:
1. Open `Info.plist`
2. Right-click → Add Row
3. Select "Privacy - Location When In Use Usage Description"
4. Enter the description above

### 3. Configure App Store Connect (5 minutes)

**Enable Sign in with Apple:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Your App → App Information
3. Under "Sign in with Apple": Enable it

**Set up Subscription:**
1. Your App → Subscriptions → Create
2. **Subscription Group Name:** TrailTriage Pro
3. **Product ID:** `com.blackelkmountainmedicine.trailtriage.yearly`
4. **Duration:** 1 Year
5. **Price:** $9.99 USD (Tier 10)
6. **Introductory Offer:**
   - Type: Free Trial
   - Duration: 3 Days
   - Eligibility: New subscribers

### 4. Test in Simulator/Device (2 minutes)

**First Launch Test:**
```
1. Delete app if previously installed
2. Run from Xcode
3. Should see onboarding welcome screen
4. Tap through all steps:
   ✓ Welcome
   ✓ Sign in (use sandbox Apple ID)
   ✓ Profile (enter test data)
   ✓ Permissions (grant location)
   ✓ Subscription (start trial with sandbox)
5. Should land on main tab interface
6. Quit and relaunch - should skip onboarding
```

**Subscription Test:**
1. Go to More → Subscription
2. Should show "Free Trial Active"
3. Should show trial end date
4. Can tap "Manage Subscription" (opens Settings)

## 📱 User Experience Flow

### New User Journey:
```
Install App
    ↓
Welcome Screen (tap "Get Started")
    ↓
Sign in with Apple (authenticate)
    ↓
Enter profile info (name, agency, certs)
    ↓
Grant permissions (location, check iCloud)
    ↓
Start free trial (auto-subscribe)
    ↓
✅ Full app access for 3 days
    ↓
Day 4: Charged $9.99 (unless cancelled)
    ↓
✅ Continues with full access
```

### Cancelled Subscription:
```
User cancels in iOS Settings
    ↓
Subscription ends at period completion
    ↓
StoreKit notifies app
    ↓
App shows re-subscribe screen
    ↓
User must re-complete onboarding to continue
```

## 🧪 Sandbox Testing

### Create Test Account:
1. App Store Connect → Users and Access → Sandbox Testers
2. Click `+` to add tester
3. Create test Apple ID (can be fake email)
4. Remember password!

### Test on Device:
1. Settings → App Store → Sign out of real account
2. Run your app from Xcode
3. When prompted for Apple ID, use sandbox account
4. Subscription will be free/instant in sandbox
5. Can test subscription lifecycle (cancel, renew, etc.)

### Sandbox Subscription Timeline:
In sandbox, time is accelerated:
- 3 days free trial = **3 minutes**
- 1 year subscription = **1 hour**

Perfect for testing!

## 🎯 What Users See

### On Install (Always):
1. **Welcome** - "Welcome to TrailTriage"
2. **Sign In** - "Sign in with Apple" button (+ Google option)
3. **Profile** - Form to enter their info
4. **Permissions** - Location and iCloud status
5. **Trial** - "Start Your Free Trial" with feature list
6. **Done!** - Main app interface

### After Onboarding:
- Full access to all features
- No "upgrade" prompts
- No locked features
- Clean, professional UX

### If Subscription Lapses:
- Could show modal: "Your subscription expired"
- Button: "Renew Subscription"
- Or: Auto-return to onboarding flow

## 🔒 Security & Privacy

### What's Secure:
✅ Apple handles all authentication  
✅ No passwords stored in your app  
✅ User ID is encrypted token from Apple  
✅ Payment handled by Apple (PCI compliant)  
✅ iCloud data encrypted at rest  

### Privacy Compliance:
✅ Location only used when creating notes  
✅ No tracking/analytics (unless you add them)  
✅ No data sold or shared  
✅ User controls iCloud sync  
✅ Can delete all data by uninstalling  

## 🚀 Ready to Ship

Once you've completed the checklist above:
- [ ] Test onboarding flow completely
- [ ] Test with real Apple ID (not sandbox)
- [ ] Verify subscription shows in iOS Settings
- [ ] Test on iPhone SE (smallest screen)
- [ ] Test on iPad (if supporting)
- [ ] Submit for App Review

## 📝 App Review Notes

When submitting to Apple, include:

**Sign in with Apple:**
- "Required for iCloud sync and subscription management"
- "No alternative sign-in needed"

**In-App Purchase:**
- "3-day free trial, then $9.99/year"
- "Full app access during trial"
- "Auto-renewable subscription"

**Location:**
- "Used to add GPS coordinates to incident reports"
- "Only captured when user creates a SOAP note"
- "Optional - user can skip permission"

## ⚠️ Common Issues

**Issue:** Onboarding shows every time
**Fix:** Check `UserDefaults` is being saved correctly in `OnboardingCoordinator.completeOnboarding()`

**Issue:** Sign in with Apple button doesn't work
**Fix:** Verify capability is added in Xcode, device is signed in to iCloud

**Issue:** Subscription products don't load
**Fix:** Check product ID matches exactly in App Store Connect and code

**Issue:** StoreKit says "Cannot connect"
**Fix:** Wait 24 hours after creating products in App Store Connect

## 🎉 Success Metrics

You'll know it's working when:
- [x] Onboarding completes smoothly
- [x] User stays signed in across launches
- [x] Subscription status shows correctly
- [x] Notes sync via iCloud
- [x] Location appears in new notes
- [x] Profile info appears in exported PDFs

---

**Questions?** Check `ONBOARDING_SETUP.md` for detailed explanations.

**Ready to go!** Your app now has professional onboarding and subscription management! 🚀
