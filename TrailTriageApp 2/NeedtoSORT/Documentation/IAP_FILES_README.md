# 📦 In-App Purchase Files - README

Welcome! This folder contains everything you need to configure in-app purchases for TrailTriage.

---

## 📚 Files Overview

### 🎯 **Start Here**
- **`IAP_SETUP_SUMMARY.md`** ← **READ THIS FIRST!**
  - High-level overview of the entire setup
  - Quick start guide
  - Testing checklist
  - Launch day checklist

### 📖 **Detailed Guides**

1. **`HOW_TO_ADD_STOREKIT_TO_XCODE.md`**
   - Step-by-step: Add StoreKit configuration to Xcode
   - How to test purchases locally
   - Using StoreKit Transaction Manager
   - Troubleshooting local testing issues
   - **Start here if you want to test purchases immediately**

2. **`IN_APP_PURCHASE_SETUP.md`**
   - Complete guide to App Store Connect setup
   - How to create each of the 9 products
   - Sandbox testing instructions
   - Production preparation
   - **Use this when you're ready for App Store Connect**

3. **`PRODUCT_IDS_QUICK_REFERENCE.md`**
   - Quick copy/paste reference for all product details
   - Summary table of all 9 products
   - Product descriptions for App Store Connect
   - **Keep this open when creating products in ASC**

### ⚙️ **Configuration Files**

- **`TrailTriage.storekit`**
  - StoreKit configuration file for local testing
  - Contains all 9 in-app purchase products
  - Drag this into your Xcode project
  - **This is the actual file you need to add to Xcode**

---

## 🚀 Quick Start (5 Minutes)

Want to test purchases RIGHT NOW? Here's the fastest path:

### Step 1: Add StoreKit File to Xcode
```
1. Drag TrailTriage.storekit into Xcode
2. Check "Copy items if needed"
3. Ensure app target is checked
4. Click "Add"
```

### Step 2: Enable StoreKit in Scheme
```
1. Product → Scheme → Edit Scheme...
2. Run → Options tab
3. StoreKit Configuration: TrailTriage.storekit
4. Close
```

### Step 3: Test!
```
1. Build and run (⌘+R)
2. Complete onboarding
3. Try purchasing subscription
4. Should work instantly! ✅
```

**Need more details?** → See `HOW_TO_ADD_STOREKIT_TO_XCODE.md`

---

## 🎯 Your Product Lineup

### **Primary Access** (Required)
- **Annual Subscription**: $9.99/year (3-day free trial)
- **Lifetime Purchase**: $49.99 one-time

### **Donations** (Optional, for Custer SAR)
- Small: $4.99
- Medium: $9.99
- Large: $24.99
- Extra Large: $49.99

### **Tips** (Optional, for developer)
- Small: $2.99 ☕
- Medium: $4.99 🍕
- Large: $9.99 🍽️

**Total: 9 Products**

---

## 📋 Complete Setup Workflow

### Phase 1: Local Testing (30 minutes)
1. Add `TrailTriage.storekit` to Xcode
2. Enable in scheme
3. Run and test all purchases
4. Use Debug Menu to verify
5. Check Transaction Manager

**Guide**: `HOW_TO_ADD_STOREKIT_TO_XCODE.md`

### Phase 2: App Store Connect (2-3 hours)
1. Create app in App Store Connect
2. Create subscription group
3. Create all 9 products
4. Add descriptions and pricing
5. Submit products for review
6. Wait 24-48 hours for approval

**Guide**: `IN_APP_PURCHASE_SETUP.md`

### Phase 3: Sandbox Testing (1 hour)
1. Create sandbox tester accounts
2. Test on real device
3. Purchase subscription
4. Test restore purchases
5. Test all product types
6. Verify access gating

**Guide**: `IN_APP_PURCHASE_SETUP.md` (Sandbox section)

### Phase 4: Launch! 🚀
1. Final testing with approved products
2. Submit app for review
3. Wait 1-3 days for app approval
4. Release to App Store
5. Monitor reviews and analytics

**Checklist**: `IAP_SETUP_SUMMARY.md` (Launch section)

---

## 🐛 Quick Troubleshooting

### Products Not Loading?
→ Check Xcode console for errors  
→ Verify StoreKit config is enabled in scheme  
→ Make sure product IDs match exactly  

### Purchases Not Working?
→ Check Transaction Manager to see if recorded  
→ Use Debug Menu → Subscription Status  
→ Add logging to `StoreManager.purchase()`  

### Free Trial Not Working?
→ Create new sandbox tester (each gets one trial)  
→ Verify introductory offer in ASC  
→ Check subscription period is 1 Year, not Monthly  

**More solutions**: See troubleshooting sections in each guide

---

## 📱 Where Products Appear in App

### Onboarding (Required)
- User **must subscribe or purchase** to access app
- Shows annual subscription (with 3-day trial)
- Option to see full paywall

### PaywallView (Upgrade Options)
- Shows subscription vs lifetime comparison
- Available from: More → Upgrade Options
- Clear feature list and pricing

### SupportView (Donations & Tips)
- Donations for Custer SAR (4 tiers)
- Tips for developer (3 tiers)
- Available from: More → Donate & Tips

### SubscriptionStatusView
- Shows current subscription status
- Manage subscription button
- Restore purchases button
- Available from: More → Subscription

---

## 🔍 Testing Tools Built Into App

### Debug Menu (DEBUG builds only)
**Location**: More tab → 🐛 Debug Menu (bottom of list)

**Features**:
- Reset onboarding
- Load products manually
- View all products
- Check subscription status
- Refresh purchases
- Restore purchases
- Reset to fresh install

**How to use**: See `HOW_TO_ADD_STOREKIT_TO_XCODE.md`

### Xcode Transaction Manager
**Location**: Debug menu (while app running) → StoreKit → Manage Transactions

**Features**:
- View all test transactions
- Refund purchases
- Expire subscriptions
- Speed up renewals
- Clear all transactions

**How to use**: See `HOW_TO_ADD_STOREKIT_TO_XCODE.md`

---

## 💰 Revenue Model

### Subscription (Primary)
- $9.99/year with 3-day free trial
- Target: Professional WFRs, outdoor guides, SAR teams
- Value: Unlimited notes, GPS, export, protocols
- Apple takes 30% first year, 15% after

### Lifetime (Alternative)
- $49.99 one-time payment
- Appeals to users who dislike subscriptions
- Higher upfront revenue
- Apple takes 30%

### Donations (Mission-Driven)
- Support Custer SAR organization
- 100% of net proceeds donated
- Builds goodwill in outdoor community
- Tax implications to consider

### Tips (Developer Support)
- Optional support for continued development
- Modest amounts ($3-10)
- Funding for future features
- Shows appreciation

---

## 📞 Need Help?

### Can't figure out local testing?
→ Read: `HOW_TO_ADD_STOREKIT_TO_XCODE.md`  
→ Check: Xcode console for errors  
→ Try: Debug Menu tools  

### Confused about App Store Connect?
→ Read: `IN_APP_PURCHASE_SETUP.md`  
→ Reference: `PRODUCT_IDS_QUICK_REFERENCE.md`  
→ Contact: Apple Developer Support  

### Want the big picture?
→ Read: `IAP_SETUP_SUMMARY.md`  
→ Follow: Complete workflow  
→ Use: Launch checklist  

### Technical issues with code?
→ Check: `StoreManager.swift` (all logic is there)  
→ Use: Debug Menu (More → Debug Menu)  
→ Test: Transaction Manager (Xcode)  

---

## ✅ Pre-Launch Checklist

Copy this to track your progress:

### Setup
- [ ] `TrailTriage.storekit` added to Xcode
- [ ] StoreKit configuration enabled in scheme
- [ ] Local testing complete (all 9 products)
- [ ] Debug Menu working

### App Store Connect
- [ ] App created in ASC
- [ ] Subscription group created
- [ ] Annual subscription created ($9.99/year, 3-day trial)
- [ ] Lifetime purchase created ($49.99)
- [ ] 4 donation products created
- [ ] 3 tip products created
- [ ] All products submitted for review
- [ ] Products approved

### Testing
- [ ] Sandbox tester accounts created (2-3)
- [ ] Tested on device with sandbox account
- [ ] Annual subscription purchase works
- [ ] Free trial period verified (3 days)
- [ ] Lifetime purchase works
- [ ] Donations work (repeatable)
- [ ] Tips work (repeatable)
- [ ] Restore purchases works
- [ ] App grants access after purchase
- [ ] App blocks access without purchase

### Legal & Content
- [ ] Terms of Service complete
- [ ] Privacy Policy complete
- [ ] App description written
- [ ] Screenshots captured
- [ ] App icon finalized
- [ ] Medical disclaimers clear

### Final Steps
- [ ] Build uploaded to TestFlight
- [ ] Beta testing complete
- [ ] App submitted for review
- [ ] Review notes include subscription testing info
- [ ] Support email set up (support@blackelkmountainmedicine.com)
- [ ] Launch announcement prepared

---

## 🎉 You're Ready!

All the tools and documentation you need are in this folder. Pick your starting point:

- **Just want to test?** → `HOW_TO_ADD_STOREKIT_TO_XCODE.md`
- **Ready for production?** → `IN_APP_PURCHASE_SETUP.md`
- **Need quick reference?** → `PRODUCT_IDS_QUICK_REFERENCE.md`
- **Want the overview?** → `IAP_SETUP_SUMMARY.md`

Good luck with your launch! 🚀

---

**Questions?** Check the troubleshooting sections in each guide, or refer to Apple's documentation.

**Black Elk Mountain Medicine** | TrailTriage | Professional Wilderness Medical Documentation
