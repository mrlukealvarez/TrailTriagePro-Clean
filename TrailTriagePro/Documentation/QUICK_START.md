//
//  QUICK_START.md
//  WFR TrailTriage - StoreKit Integration
//
//  Created by Luke Alvarez on 11/10/25.
//

# 🚀 Quick Start - Get This Running in 10 Minutes

## Step 1: Enable StoreKit Testing (2 minutes)

### In Xcode:

1. **Product** menu → **Scheme** → **Edit Scheme**
2. Click **Run** in the left sidebar
3. Go to **Options** tab
4. Under **StoreKit Configuration**, select: **`Products.storekit`**
5. Click **Close**

✅ **Done!** You can now test purchases without App Store Connect.

---

## Step 2: Build and Run (1 minute)

1. Select your device or simulator
2. Press **⌘R** (or click the Play button)
3. App launches!

---

## Step 3: Test the Features (5 minutes)

### Test Paywall

1. Open your app
2. Go to **Settings** (gear icon)
3. Tap **"Unlock Full Access"**
4. You should see:
   - **Lifetime Access** - $14.99
   - **Monthly** - Try Free (3-day trial)

### Make a Test Purchase

1. Tap **"Try Free"** on Monthly
2. Approve with Face ID/Touch ID (it's fake - no real charge!)
3. Wait for purchase to complete
4. You should see "Subscribed" in Settings

### Test Access Control

1. Go to Reference Book
2. Tap any chapter
3. **Before purchase**: Should show lock screen
4. **After purchase**: Should show full content

### Test Donations

1. Go to Settings
2. Tap **"Support & Donate"**
3. Tap **"Donate to SAR"** tab
4. Choose any donation amount
5. Complete test purchase
6. See thank you message

### Test Tips

1. Same screen, tap **"Tip Developer"** tab
2. Choose any tip amount
3. Complete test purchase
4. See thank you message

---

## Step 4: View Test Transactions (Optional)

Want to see what's happening behind the scenes?

1. While app is running, go to: **Debug** menu → **StoreKit** → **Manage Transactions**
2. You'll see:
   - All purchases
   - Subscription status
   - When free trial ends
   - Can cancel/renew subscriptions

---

## What Should Work Right Now

✅ **Working:**
- Lifetime purchase grants access
- Monthly subscription grants access
- 3-day free trial (accelerated to ~3 minutes in testing)
- Content locks when subscription cancelled
- Donations process successfully
- Tips process successfully
- "Restore Purchases" works

❌ **Not Working Yet:**
- Real purchases (need App Store Connect setup)
- Actual 3-day trial duration (testing is accelerated)
- Real Custer SAR charity info (needs their input)

---

## Common Issues

### "Products not loading"

**Fix:** Wait ~30 seconds after app launch. Products load asynchronously.

### "Subscription not showing free trial"

**Fix:** Check the `Products.storekit` file - introductoryOffer should be present.

### "Content still locked after purchase"

**Fix:** Force-quit and relaunch the app. Transaction processing may take a moment.

### "Can't make purchase"

**Fix:** Make sure you selected the StoreKit configuration file in the scheme (Step 1).

---

## Next Steps

### For Production Release:

1. **Create products in App Store Connect** (see `StoreKitSetupGuide.md`)
2. **Get Custer SAR info** and update donation screen
3. **Test on TestFlight** with real Apple ID
4. **Submit to App Store**

### For Local Testing:

You're all set! Everything works in the simulator/device right now.

---

## File Reference

All the files you need are ready:

### Core Implementation
- ✅ `StoreManager.swift` - Purchase logic
- ✅ `PaywallView.swift` - Subscription screen
- ✅ `SupportView.swift` - Donations & tips
- ✅ `SettingsView.swift` - Settings with subscription management
- ✅ `AccessControlledView.swift` - Content locking
- ✅ `ReferenceBookView_New.swift` - Updated with access control

### Testing
- ✅ `Products.storekit` - Test products configuration

### Documentation
- ✅ `StoreKitSetupGuide.md` - App Store Connect setup
- ✅ `README_StoreKit_Implementation.md` - Complete overview
- ✅ `QUICK_START.md` - This file

---

## 🎉 You're Ready!

**To test right now:**
1. Build and run
2. Go to Settings
3. Try purchasing/subscribing
4. Watch content unlock/lock

**For production:**
1. Read `StoreKitSetupGuide.md`
2. Set up App Store Connect
3. Get Custer SAR info
4. Submit for review

---

## Visual Flow

```
User Opens App
    ↓
Tries to View Chapter
    ↓
Has Access? ─── YES ──→ Show Content
    ↓ NO
    ↓
Show Lock Screen
    ↓
User Taps "Unlock"
    ↓
Show Paywall
    ├─→ Monthly ($1.99/mo with 3-day trial)
    └─→ Lifetime ($14.99 one-time)
    ↓
User Purchases
    ↓
Content Unlocks! ✅
```

```
User Wants to Support
    ↓
Opens Settings
    ↓
Taps "Support & Donate"
    ↓
Choose Tab:
    ├─→ Donate to SAR ($5/$10/$25/$50)
    └─→ Tip Developer ($2.99/$4.99/$9.99)
    ↓
Make Donation/Tip
    ↓
See Thank You Message 🙏
    ↓
NO ACCESS GRANTED (these are just donations)
```

---

## Quick Commands

### Build and Run
```
⌘R
```

### Open Transaction Manager
```
Debug → StoreKit → Manage Transactions
```

### Clear All Purchases (Start Fresh)
```
Debug → StoreKit → Delete All Transactions
```

---

## That's It!

You now have a fully functional StoreKit implementation with:
- ✅ Subscriptions with free trial
- ✅ Lifetime purchase option
- ✅ Charity donations
- ✅ Developer tips
- ✅ Automatic access control
- ✅ Settings integration

Everything works locally right now. When you're ready for production, follow the App Store Connect guide.

**Questions?** Check `README_StoreKit_Implementation.md` for detailed explanations.

**Happy coding! 🏔️**
