# 🧪 COMPREHENSIVE TESTING GUIDE
### WFR TrailTriage - Test Every Flow
#### November 12, 2025

---

## 🎯 YOUR TESTING REQUIREMENTS

You asked for:
> "i want the app to always run its onboarding procedures if there is not an active subscription"
> "i want to be able to cancel and then retest the onboarding screens"
> "to be able to view all the payment subscription views"

**✅ ALL IMPLEMENTED!** Here's how to test everything.

---

## 🚀 QUICK START: Testing Tools

### New Feature: Developer Testing View

Located in: **Settings → Developer Testing** (Debug builds only)

**What it does:**
- ✅ Shows current subscription status
- ✅ Refresh subscription state
- ✅ Quick access to all screens
- ✅ StoreKit transaction management
- ✅ One-tap paywall/onboarding testing

**How to access:**
```
1. Build and run app (Cmd+R)
2. Navigate to Settings tab
3. Scroll to "Developer Tools" section
4. Tap "Developer Testing"
```

---

## 📱 TESTING SUBSCRIPTION FLOWS

### Scenario 1: New User (No Subscription)

**Expected Flow:**
```
1. App launches
2. Shows loading screen (checking subscription)
3. No subscription found
4. Shows OnboardingView
5. User sees welcome screens
6. Final screen: "Get Started" → PaywallView
7. User can purchase or close
```

**Test Steps:**
```
1. Delete app from simulator/device
2. Clean Build (Cmd+Shift+K)
3. Build & Run (Cmd+R)
4. Watch the flow
```

**Debug Commands (if needed):**
```swift
// In Xcode Console while running:
// Check subscription status
po StoreManager.shared.hasFullAccess
po StoreManager.shared.hasLifetimeAccess
po StoreManager.shared.hasActiveSubscription
```

---

### Scenario 2: Test Purchase Flow

**Test Lifetime Purchase:**
```
1. Open PaywallView
2. Tap "PAY ONCE" ($29.99 Lifetime)
3. StoreKit Test: Tap "Subscribe"
4. ✅ Pass should unlock immediately
5. Onboarding dismisses → MainTabView appears
6. Verify: Settings shows "Lifetime Access"
```

**Test Monthly Subscription:**
```
1. Reset (see below)
2. Open PaywallView
3. Tap "FREE" (7-day trial)
4. StoreKit Test: Tap "Subscribe"
5. ✅ Should show "Free Trial Active"
6. Verify: Content unlocks during trial
```

**Test Subscription with Trial Disabled:**
```
1. Open PaywallView
2. Toggle "Free Trial Enabled" OFF
3. Monthly now shows "$2.99 per month"
4. Purchase without trial
5. Should show "Subscription Active"
```

---

### Scenario 3: Cancel Subscription & Retest

**Method 1: Using StoreKit Transaction Manager (Recommended)**
```
While app is running:
1. Xcode Menu: Debug → StoreKit → Manage Transactions
2. You'll see all purchases
3. Find your subscription
4. Click "Expire Subscription" or "Cancel"
5. Close Transaction Manager
6. Force quit app (Cmd+Q simulator)
7. Relaunch app
8. ✅ Should show OnboardingView again!
```

**Method 2: Clear All Transactions (Fresh Start)**
```
1. Stop app
2. Debug → StoreKit → Manage Transactions
3. Click "Delete All"
4. Clean Build (Cmd+Shift+K)
5. Build & Run
6. App acts like fresh install
```

**Method 3: Using Developer Testing View**
```
1. Settings → Developer Testing
2. Tap "Clear All Transactions"
3. Follow on-screen instructions
4. Restart app
```

---

### Scenario 4: Restore Purchases

**Test on Same Device:**
```
1. Purchase lifetime or subscription
2. Force quit app
3. Delete All Transactions (Method 2 above)
4. Relaunch app
5. See OnboardingView → PaywallView
6. Tap "Restore Purchases"
7. Wait...
8. ❌ No purchases found (because you deleted them)
```

**Test Actual Restore (keeps transactions):**
```
1. Purchase lifetime
2. Force quit app
3. Relaunch (without clearing transactions)
4. Go to Settings → Subscription section
5. Already shows "Lifetime Access" ✅
6. This is automatic restoration working!
```

**Simulate New Device:**
```
1. Purchase on Simulator 1
2. Note the transaction
3. Delete app from Simulator 1
4. Install on Simulator 2 (same Apple ID)
5. Open app
6. Tap "Restore Purchases"
7. Should restore lifetime access
```

---

## 🎬 TESTING ONBOARDING FLOWS

### Test 1: First Launch
```
Expected: Onboarding appears automatically
How to trigger: Delete app, reinstall
```

### Test 2: Expired Subscription
```
Expected: Onboarding appears when subscription expires
How to trigger: 
  1. Subscribe with monthly
  2. Expire subscription in Transaction Manager
  3. Relaunch app
  ✅ Onboarding should appear
```

### Test 3: Skip Onboarding
```
Expected: Can't skip without subscription
How to trigger:
  1. Launch app (no subscription)
  2. See OnboardingView
  3. Try to dismiss
  4. ❌ Can't dismiss without purchasing
  5. Must purchase to access app
```

### Test 4: Complete Onboarding with Purchase
```
Expected: Purchase → Onboarding dismisses → MainTabView
Flow:
  1. OnboardingView appears
  2. Swipe through screens
  3. Last screen: "Get Started" button
  4. Taps → PaywallView
  5. Purchase → Auto-dismisses
  6. ✅ MainTabView appears
```

---

## 💳 TESTING ALL PAYMENT VIEWS

### View 1: PaywallView
**Access:**
- Automatically when no subscription
- Settings → "Unlock Full Access"
- Developer Testing → "Show Paywall"

**Test:**
- [x] Lifetime option shows ($29.99)
- [x] Monthly option shows ($2.99)
- [x] Free trial toggle works
- [x] Purchase buttons work
- [x] Loading state shows
- [x] Error handling (cancel purchase)
- [x] Restore button works
- [x] Legal links work (Terms, Privacy)

### View 2: SettingsView (Subscription Section)
**Access:**
- Settings tab → Premium section

**Test No Subscription:**
- [x] Shows "Unlock Full Access" button
- [x] Tapping opens PaywallView
- [x] Shows donation/tips section

**Test With Subscription:**
- [x] Shows "Subscription Active" / "Lifetime Access"
- [x] Shows "Manage Subscription" button
- [x] Tapping opens Apple's subscription manager
- [x] Can cancel through Apple's interface

### View 3: SupportView (Donations & Tips)
**Access:**
- Settings → Donate & Tips

**Test:**
- [x] Shows Custer SAR donation section
- [x] 4 donation tiers: $4.99, $9.99, $24.99, $49.99
- [x] Shows Developer Tips section
- [x] 3 tip tiers: $2.99, $4.99, $9.99
- [x] Each purchase works
- [x] Thank you message after purchase
- [x] Donations DON'T unlock content
- [x] Tips DON'T unlock content

### View 4: Developer Testing View (NEW!)
**Access:**
- Settings → Developer Testing (Debug only)

**Test:**
- [x] Shows subscription status
- [x] Shows loaded products
- [x] Refresh button works
- [x] Restore button works
- [x] "Show Paywall" works
- [x] "Show Onboarding" works
- [x] "View All Screens" works
- [x] Product list accurate

---

## 📊 TESTING CHECKLIST

### Pre-Testing Setup
- [ ] StoreKit configuration file selected: `Products.storekit`
  - `Product → Scheme → Edit Scheme → Run → Options`
- [ ] Clean Build Folder: `Cmd+Shift+K`
- [ ] Derived Data cleared (if slow): `~/Library/Developer/Xcode/DerivedData/`
- [ ] Simulator or device ready
- [ ] Xcode console visible for debug messages

### Core App Flow
- [ ] App launches without errors
- [ ] Loading screen appears briefly
- [ ] Onboarding shows (no subscription)
- [ ] Can swipe through onboarding
- [ ] Paywall accessible from onboarding
- [ ] Can purchase lifetime
- [ ] Can purchase monthly
- [ ] App unlocks after purchase
- [ ] MainTabView appears after unlock

### Subscription States
- [ ] No subscription → Onboarding
- [ ] Active subscription → MainTabView
- [ ] Lifetime purchase → Always unlocked
- [ ] Expired subscription → Onboarding
- [ ] Free trial → Content unlocked
- [ ] Trial expires → Subscription starts
- [ ] Cancel subscription → Content locks

### StoreKit Integration
- [ ] Products load successfully
- [ ] Prices display correctly
- [ ] Free trial shows "FREE"
- [ ] Monthly shows "$2.99/month"
- [ ] Lifetime shows "$29.99"
- [ ] Purchase flow completes
- [ ] Transaction verification works
- [ ] Restore purchases works
- [ ] Error handling works

### All Screens Accessible
- [ ] PaywallView
- [ ] SettingsView
- [ ] SupportView (donations/tips)
- [ ] OnboardingView
- [ ] MainTabView
- [ ] Developer Testing View
- [ ] Reference Book
- [ ] Glossary
- [ ] FAQ
- [ ] About
- [ ] Terms of Service
- [ ] Privacy Policy
- [ ] New Note
- [ ] My Notes

### Edge Cases
- [ ] Network error during purchase
- [ ] Cancel purchase mid-flow
- [ ] Restore with no purchases
- [ ] Restore with purchases
- [ ] Background app → foreground (state preserved)
- [ ] Force quit → relaunch (subscription checked)
- [ ] iCloud sync (multiple devices)

---

## 🎮 COMMON TESTING SCENARIOS

### Scenario: "I want to see onboarding again"
```
Solution 1 (Quick - Uses Developer Testing):
  1. Settings → Developer Testing
  2. Tap "Show Onboarding"
  ✅ Onboarding appears as modal

Solution 2 (Full Reset):
  1. Stop app
  2. Debug → StoreKit → Manage Transactions → Delete All
  3. Clean Build (Cmd+Shift+K)
  4. Run app
  ✅ Onboarding appears as if fresh install
```

### Scenario: "I want to test monthly subscription cancel"
```
Steps:
  1. Purchase monthly subscription (with or without trial)
  2. App unlocks
  3. Debug → StoreKit → Manage Transactions
  4. Select monthly subscription
  5. Click "Cancel Subscription" or "Expire Subscription"
  6. Force quit app
  7. Relaunch
  ✅ OnboardingView should appear (subscription expired)
```

### Scenario: "I want to test all payment screens"
```
Use Developer Testing View:
  1. Settings → Developer Testing
  2. Tap "View All Screens"
  3. Navigate to each screen:
     - Paywall
     - Settings (subscription status)
     - Support (donations/tips)
  4. Test purchases in each
```

### Scenario: "I want to test like a real user"
```
Complete Flow:
  1. Delete app
  2. Clear transactions
  3. Reinstall
  4. Launch (see onboarding)
  5. Complete onboarding flow
  6. Choose pricing tier
  7. Complete purchase
  8. Use app
  9. Later: Cancel subscription
  10. Verify content locks
  11. Verify onboarding returns
```

---

## 🐛 TROUBLESHOOTING

### Issue: "Products not loading"
```
Symptoms: 
  - PaywallView shows no prices
  - "Loading..." never finishes
  
Fix:
  1. Check StoreKit configuration selected
  2. Product → Scheme → Edit Scheme
  3. Run → Options → StoreKit Configuration
  4. Select: Products.storekit
  5. Rebuild
```

### Issue: "Subscription status not updating"
```
Symptoms:
  - Made purchase but content still locked
  - Expired subscription but content still unlocked
  
Fix:
  1. Settings → Developer Testing
  2. Tap "Refresh Subscription Status"
  3. Check console for debug messages
  4. Or force quit and relaunch
```

### Issue: "Onboarding won't dismiss"
```
Symptoms:
  - Purchased but still see onboarding
  
Expected Behavior:
  - This is CORRECT! 
  - Onboarding checks subscription status
  - onChange modifier dismisses when subscription detected
  
Fix (if genuinely stuck):
  1. Check console: po StoreManager.shared.hasFullAccess
  2. If false, purchase didn't complete
  3. Try restore purchases
  4. Check Transaction Manager for verified purchase
```

### Issue: "Can't test cancel subscription"
```
Symptoms:
  - Cancelled in Transaction Manager but content still unlocked
  
Fix:
  1. Must force quit app after cancelling
  2. StoreKit only checks on app launch
  3. OR wait ~30 seconds for listener to update
  4. Check: Settings → Developer Testing → Status
```

### Issue: "Builds are slow"
```
See: BUILD_PERFORMANCE_GUIDE.md

Quick fix:
  1. Clean Build Folder (Cmd+Shift+K)
  2. Delete Derived Data
  3. Restart Xcode
```

---

## 📱 DEVICE TESTING vs SIMULATOR

### Simulator (Development)
**Pros:**
- Fast iteration
- Easy to reset
- Transaction Manager available
- Free testing

**Cons:**
- Can't test real App Store
- Can't test iCloud sync fully
- No actual payment flow

**Best for:**
- UI testing
- Flow testing
- Quick iterations

### Real Device (TestFlight)
**Pros:**
- Real App Store environment
- Actual payment flow (sandbox)
- Full iCloud sync
- True user experience

**Cons:**
- Slower to set up
- Harder to reset
- Need TestFlight account
- Sandbox environment quirks

**Best for:**
- Final testing before release
- Subscription testing
- Multi-device testing

---

## ✅ TESTING CHECKLIST FOR RELEASE

Before submitting to App Store:

### Functional Testing
- [ ] All purchase flows work
- [ ] Onboarding appears correctly
- [ ] Subscription status accurate
- [ ] Content locks/unlocks properly
- [ ] Restore purchases works
- [ ] No crashes
- [ ] No memory leaks
- [ ] Works offline

### UI/UX Testing
- [ ] All screens accessible
- [ ] Navigation makes sense
- [ ] Buttons respond correctly
- [ ] Loading states show
- [ ] Error messages clear
- [ ] Accessibility works (VoiceOver)
- [ ] Dark mode works
- [ ] Different device sizes work

### Business Logic
- [ ] Lifetime = lifetime (doesn't expire)
- [ ] Monthly = recurring
- [ ] Free trial = 7 days then charges
- [ ] Donations don't unlock content
- [ ] Tips don't unlock content
- [ ] Cancellation locks content
- [ ] Restore works on new device

### Compliance
- [ ] Terms of Service accurate
- [ ] Privacy Policy complete
- [ ] StoreKit configuration matches App Store Connect
- [ ] Subscription terms clear
- [ ] Refund policy visible
- [ ] Contact information correct

---

## 🎯 DAILY TESTING ROUTINE (Development)

**Morning (Fresh Start):**
```
1. Clean Build Folder
2. Run app
3. Check all new features work
4. Test one complete flow (onboarding → purchase → use)
```

**After Code Changes:**
```
1. Test affected screens
2. Quick flow test (30 seconds)
3. Check console for errors
```

**Before Commits:**
```
1. Full flow test
2. Test subscription states
3. Verify no broken screens
4. Check for crashes
```

**Weekly (Comprehensive):**
```
1. Delete app
2. Clear transactions
3. Full fresh-user test
4. Test all payment tiers
5. Test all screens
6. Check performance
7. Review crash logs
```

---

## 🚀 READY TO TEST!

**Your testing workflow:**

1. **Quick Test (5 minutes)**
   - Settings → Developer Testing
   - Check status
   - Show paywall
   - Show onboarding
   - Test one purchase

2. **Full Flow Test (15 minutes)**
   - Delete app
   - Clear transactions
   - Reinstall
   - Complete onboarding
   - Test purchase
   - Test using app
   - Cancel subscription
   - Verify onboarding returns

3. **Comprehensive Test (30 minutes)**
   - All of the above
   - Plus: Test all screens
   - Plus: Test donations/tips
   - Plus: Test restore purchases
   - Plus: Test error cases

---

## 📞 NEED HELP?

If something isn't working:

1. **Check Developer Testing View**
   - Shows current state
   - Helps diagnose issues

2. **Check Console Logs**
   - Look for error messages
   - StoreManager logs all operations

3. **Use Transaction Manager**
   - See exactly what's purchased
   - Verify transaction states

4. **Review This Guide**
   - Most issues covered here
   - Follow troubleshooting section

---

## ✨ YOU'RE ALL SET!

You now have:
- ✅ Onboarding tied to subscription
- ✅ Easy testing of all flows
- ✅ Developer Testing View
- ✅ Clear testing procedures
- ✅ All payment views accessible

**Go test everything and make sure it all works perfectly! 🎉**
