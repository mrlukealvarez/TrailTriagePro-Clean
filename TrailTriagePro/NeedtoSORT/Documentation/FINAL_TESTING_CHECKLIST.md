# 🎯 Final Testing Checklist - TrailTriage IAP
## Before App Store Submission

Last Updated: November 11, 2025

---

## ✅ App Store Connect Configuration Status

### Products Created
- ✅ **Monthly Subscription**
  - Product ID: `com.wfr.trailtriage.monthly`
  - Apple ID: 6755152197
  - Reference Name: TrailTriage Pro: Monthly Access

- ✅ **Lifetime Purchase**
  - Product ID: `com.wfr.trailtriage.lifetime`
  - Apple ID: 6755152503
  - Reference Name: TrailTriage Lifetime Access

---

## 📋 App Store Connect - Complete These Steps

### Monthly Subscription (`com.wfr.trailtriage.monthly`)

- [ ] **Pricing Set**
  - Price: $2.99 USD (Tier 3)
  - Availability: All Countries/Regions

- [ ] **Free Trial Added**
  - Type: Free Trial
  - Duration: 7 Days
  - Eligibility: New subscribers only

- [ ] **Localization Added**
  - Display Name: "TrailTriage Pro - Monthly"
  - Description: (see APP_STORE_CONNECT_SUBSCRIPTION_SETUP.md)

- [ ] **Submitted for Review**
  - Status should show: "Waiting for Review" or "In Review"

---

### Lifetime Purchase (`com.wfr.trailtriage.lifetime`)

- [ ] **Pricing Set**
  - Price: $29.99 USD (Tier 30)
  - Availability: All Countries/Regions

- [ ] **Localization Added**
  - Display Name: "TrailTriage Pro - Lifetime"
  - Description: (see APP_STORE_CONNECT_SUBSCRIPTION_SETUP.md)

- [ ] **Submitted for Review**
  - Status should show: "Waiting for Review" or "In Review"

---

## 🧪 Testing in Xcode (Simulator)

### Setup StoreKit Configuration File

- [ ] Created `Products.storekit` file in Xcode
- [ ] Added monthly subscription:
  - Product ID: `com.wfr.trailtriage.monthly`
  - Price: $2.99
  - Duration: 1 Month
  - Free trial: 7 Days
- [ ] Added lifetime purchase:
  - Product ID: `com.wfr.trailtriage.lifetime`
  - Price: $29.99
- [ ] Enabled StoreKit file in scheme settings

### Test Scenarios in Simulator

- [ ] **App Launch**
  - Fresh install shows onboarding
  - Onboarding progresses through all steps

- [ ] **Subscription Step Shows Correctly**
  - Shows 🦝 raccoon mascot
  - Shows "Start 7-Day Free Trial" button
  - Shows "Then $2.99/month" under button
  - Shows "Lifetime Access - BEST VALUE" option
  - Shows "Pay once: $29.99" under lifetime option
  - Shows "Restore Purchases" link

- [ ] **Purchase Monthly Trial**
  - Tap "Start 7-Day Free Trial"
  - StoreKit sheet appears
  - Click "Subscribe"
  - Sheet dismisses
  - Onboarding completes
  - Main app appears

- [ ] **Purchase Lifetime**
  - Go through onboarding again (delete app, reinstall)
  - Tap "Lifetime Access" button
  - StoreKit sheet appears
  - Click "Buy"
  - Sheet dismisses
  - Onboarding completes
  - Main app appears

- [ ] **Content Lock Test**
  - While app is running with active subscription
  - Open Debug → StoreKit → Manage Transactions
  - Find subscription, click "Expire"
  - Force quit app (swipe up)
  - Relaunch app
  - Should show PaywallView (NOT main app)
  - Should see same pricing options with raccoon

- [ ] **Restore Purchases**
  - Delete app
  - Reinstall
  - Go through onboarding
  - On subscription step, tap "Restore Purchases"
  - Should restore previous purchase
  - Should complete onboarding
  - Should show main app

---

## 📱 Testing on Real Device (iPhone)

### Setup Sandbox Account

- [ ] Created sandbox tester in App Store Connect
  - Email: ____________________
  - Password: ____________________

- [ ] Signed in on iPhone:
  - Settings → App Store → SANDBOX ACCOUNT
  - Signed in with test account

### Test Scenarios on Device

- [ ] **Fresh Install**
  - Install app via Xcode
  - Launch app
  - Complete onboarding

- [ ] **Start Free Trial**
  - On subscription step, tap "Start 7-Day Free Trial"
  - Sign in with sandbox account (if prompted)
  - Tap "Subscribe"
  - Verify shows "Subscribed" confirmation
  - Complete onboarding
  - Verify main app loads

- [ ] **Check Subscription Status**
  - Settings → Apple ID → Subscriptions
  - Should see "TrailTriage Pro - Monthly"
  - Should show "Free Trial - Expires [date]"

- [ ] **Purchase Lifetime (Separate Test)**
  - Delete app, reinstall
  - Go through onboarding
  - Tap "Lifetime Access - BEST VALUE"
  - Complete purchase
  - Verify main app loads

- [ ] **Cancel Subscription**
  - Settings → Apple ID → Subscriptions
  - Tap TrailTriage subscription
  - Tap "Cancel Subscription"
  - Confirm cancellation
  - App should still work until trial ends

- [ ] **Trial Expiration**
  - Wait for trial to expire (accelerated in sandbox - ~5 minutes)
  - OR: Use Xcode → Debug → StoreKit → Expire Subscription
  - Force quit app
  - Relaunch app
  - Should show PaywallView (content locked)

- [ ] **Restore Purchases**
  - Delete app
  - Reinstall
  - Go through onboarding
  - Tap "Restore Purchases"
  - Should restore access
  - Should show main app

- [ ] **Offline Mode**
  - Turn on Airplane Mode
  - Launch app (with active subscription)
  - Should still work (StoreKit caches entitlements)

---

## 🎨 Visual Verification

### Onboarding Subscription Step

- [ ] Raccoon mascot visible (🦝 emoji or custom art)
- [ ] "Start Your Free Trial" headline
- [ ] "7 days free, then $2.99/month" subheadline
- [ ] Feature checkmarks visible:
  - ✓ Unlimited SOAP notes
  - ✓ GPS location tracking
  - ✓ PDF export for EMS handoff
  - ✓ iCloud sync across devices
  - ✓ Advanced assessment tools
  - ✓ Offline reference protocols
- [ ] "Start 7-Day Free Trial" button (blue)
- [ ] "Lifetime Access - BEST VALUE" button (gray)
- [ ] "Restore Purchases" link
- [ ] Terms & Privacy links at bottom

### PaywallView (When Locked)

- [ ] Raccoon mascot visible
- [ ] "Unlock Pro Access" headline
- [ ] Feature list with colored icons
- [ ] "Lifetime Access - BEST VALUE" card (with green badge)
- [ ] "7-Day Trial" or "Monthly Plan" card
- [ ] "Free Trial Enabled" toggle
- [ ] "Restore Purchases" button
- [ ] Terms & Privacy links

---

## 🔐 Security Verification

- [ ] **Transaction Verification**
  - Check Xcode console for "✅ Loaded X products"
  - Check for "✅ Found entitlement: [product ID]"
  - No "❌ Unverified transaction" errors

- [ ] **Content Gate Working**
  - Without subscription: Shows PaywallView
  - With active subscription: Shows MainTabView
  - With expired subscription: Shows PaywallView
  - After restore: Shows MainTabView

---

## 📊 Analytics (Optional but Recommended)

Consider adding these events for monitoring:

- [ ] Track "onboarding_started"
- [ ] Track "onboarding_completed"
- [ ] Track "trial_started"
- [ ] Track "lifetime_purchased"
- [ ] Track "subscription_expired"
- [ ] Track "restore_purchases_tapped"

**Tools**: Firebase Analytics, TelemetryDeck, or Apple's built-in analytics

---

## 🚀 Pre-Submission Checklist

### Code Review

- [ ] No DEBUG skip buttons in production
- [ ] Product IDs match App Store Connect exactly:
  - Monthly: `com.wfr.trailtriage.monthly`
  - Lifetime: `com.wfr.trailtriage.lifetime`
- [ ] Pricing displayed correctly in UI
- [ ] No hardcoded prices (using `product.displayPrice`)
- [ ] Error handling for failed purchases
- [ ] Loading states during purchase

### Build Configuration

- [ ] Archive build (not Debug build)
- [ ] Scheme set to "Release"
- [ ] Code signing configured correctly
- [ ] Build number incremented
- [ ] Version number set (e.g., 1.0)

### App Store Connect

- [ ] Both IAP products submitted for review
- [ ] App metadata complete:
  - Name
  - Subtitle
  - Description
  - Keywords
  - Screenshots (all required sizes)
  - App icon
  - Privacy policy URL
  - Support URL
- [ ] Age rating set
- [ ] App Privacy details filled out
- [ ] Pricing and availability set

---

## 📸 Required Screenshots

Create screenshots showing:

1. **Onboarding - Welcome** (iPhone 6.7" display)
2. **Onboarding - Subscription Step** (showing pricing)
3. **Protocol List** (showing content)
4. **Protocol Detail** (showing offline access)
5. **SOAP Note Creation** (showing features)

**Tools**: 
- Xcode Simulator → Device → Screenshot
- Or use iPhone screenshots
- Use [screenshots.pro](https://screenshots.pro) or [app-mockup.com](https://app-mockup.com) for framing

---

## ✅ Final Verification Before Submit

### Functionality

- [x] App launches without crashing
- [x] Onboarding completes successfully
- [x] Free trial purchase works
- [x] Lifetime purchase works
- [x] Restore purchases works
- [x] Content locks when subscription expires
- [x] All features work offline
- [x] SOAP notes save correctly
- [x] GPS location works
- [x] PDF export works

### Legal & Compliance

- [ ] Terms of Service accessible in app
- [ ] Privacy Policy accessible in app
- [ ] Medical disclaimer visible in app
- [ ] Subscription auto-renewal clearly stated
- [ ] Trial duration clearly stated
- [ ] Price clearly stated before purchase
- [ ] Cancel instructions visible

### Polish

- [ ] No typos in UI
- [ ] All images load correctly
- [ ] Loading indicators work
- [ ] Error messages are user-friendly
- [ ] Navigation flows smoothly
- [ ] No console warnings/errors

---

## 🎉 Ready to Submit!

Once all checkboxes are complete:

1. **Archive your app** in Xcode
2. **Upload to App Store Connect**
3. **Submit for review**
4. **Add review notes**:

```
SUBSCRIPTION INFO:
- Monthly: $2.99/month with 7-day free trial
- Lifetime: $29.99 one-time purchase

TEST CREDENTIALS:
Sandbox Account: [your test email]
Password: [your test password]

TESTING NOTES:
1. Complete onboarding flow
2. On subscription step, tap "Start 7-Day Free Trial"
3. Sign in with sandbox account
4. App should unlock after trial starts

FEATURES TO TEST:
- Offline protocol access (turn off WiFi)
- SOAP note creation with GPS
- PDF export functionality
- Subscription management in Settings

DISCLAIMER:
App includes medical disclaimer. Content is for 
training/reference purposes. Users advised to seek 
professional medical help when possible.
```

---

## 📞 Troubleshooting Common Issues

### "Products not loading"
- Check product IDs match exactly
- Verify products submitted in App Store Connect
- Wait 24 hours after submission
- Try StoreKit configuration file for testing

### "Purchase fails"
- Verify sandbox account signed in
- Check internet connection
- Try different sandbox account
- Check Xcode console for error messages

### "Restore doesn't work"
- Verify transaction listener is running
- Check StoreManager initialization
- Try `AppStore.sync()` in restore function

### "Content doesn't unlock"
- Check `hasFullAccess` logic
- Verify product IDs in `purchasedProductIDs`
- Check `Transaction.currentEntitlements`
- Look for "✅ Found entitlement" in console

---

## 🎯 Success Metrics (Post-Launch)

### Week 1
- [ ] Monitor crash reports
- [ ] Check trial start rate
- [ ] Track download count

### Month 1
- [ ] Calculate trial-to-paid conversion
- [ ] Track lifetime vs. monthly preference
- [ ] Monitor churn rate
- [ ] Read user reviews

### Month 3
- [ ] Evaluate pricing performance
- [ ] Gather feature requests
- [ ] Plan content updates

---

**Good luck with your launch! 🚀🦝**

You've built something that will help save lives in the wilderness. That's incredible. 🏔️
