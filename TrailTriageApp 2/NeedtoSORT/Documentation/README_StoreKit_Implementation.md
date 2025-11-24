//
//  README_StoreKit_Implementation.md
//  WFR TrailTriage
//
//  Created by Luke Alvarez on 11/10/25.
//

# StoreKit Implementation Summary

## 🎉 What's Been Implemented

Your app now has a complete monetization system with:

### 1. **Two Payment Tiers for Your App**
- **Lifetime Purchase**: $14.99 one-time payment
- **Monthly Subscription**: $1.99/month with a 3-day free trial

### 2. **Donation System for Friends of Custer Search and Rescue**
- $5, $10, $25, and $50 donation options
- Includes their charity information and mission statement
- Tax-deductible notice (501c3)
- All donations are consumables (don't grant app access)

### 3. **Developer Tip Jar**
- $2.99 (Coffee), $4.99 (Lunch), $9.99 (Gear) tips
- Personal message from you to users
- Also consumables (don't grant app access)

---

## 📁 Files Created

### Core Files
1. **`StoreManager.swift`** - Manages all StoreKit operations
2. **`PaywallView.swift`** - Subscription/purchase screen
3. **`SupportView.swift`** - Donations and tips combined view
4. **`SettingsView.swift`** - Settings screen with subscription management
5. **`AccessControlledView.swift`** - Locks content for non-subscribers
6. **`StoreKitSetupGuide.md`** - Complete setup instructions
7. **`README_StoreKit_Implementation.md`** - This file

### Updated Files
- **`ReferenceBookView_New.swift`** - Added access control and settings

---

## 🚀 How It Works

### Access Control Logic

```swift
// User has access if:
- They purchased lifetime access ($14.99), OR
- They have an active monthly subscription

// Users do NOT get access from:
- Donations to Custer SAR
- Tips to the developer
```

### Free Trial Flow

1. User taps "Monthly" subscription
2. Gets 3-day free trial (no charge)
3. After 3 days, automatically converts to $1.99/month
4. User can cancel anytime from Settings → Manage Subscription

### Content Locking

When a user's subscription expires or they cancel:
- Content automatically locks
- They see a "Premium Content" screen
- Can unlock by subscribing again

---

## 🛠️ Next Steps

### 1. Set Up Products in App Store Connect

Follow the comprehensive guide in `StoreKitSetupGuide.md`:
- Create the lifetime product
- Create the monthly subscription with free trial
- Create donation products (4 tiers)
- Create tip products (3 tiers)

### 2. Get Friends of Custer SAR Information

Contact them and ask for:
- [ ] Official name and mission statement
- [ ] Website URL
- [ ] Contact email
- [ ] Physical address (if they want it displayed)
- [ ] Their 501(c)(3) EIN/Tax ID
- [ ] Approved language for the donation screen
- [ ] Any logos or images they want used

Update `SupportView.swift` with their information.

### 3. Test Everything

Use the StoreKit Configuration file to test:
- [ ] Lifetime purchase grants access
- [ ] Monthly subscription grants access
- [ ] Free trial works (3 days)
- [ ] Trial converts to paid subscription
- [ ] Cancelling subscription locks content
- [ ] Restore purchases works
- [ ] Donations process (don't grant access)
- [ ] Tips process (don't grant access)

### 4. Update Your App's Main Entry Point

Make sure your app initializes the StoreManager:

```swift
@main
struct WFRTrailTriageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Initialize store on launch
                    await StoreManager.shared.loadProducts()
                }
        }
    }
}
```

---

## 💰 Where to Show Payment Options

### Paywall (Subscription/Purchase)
Show the paywall when:
- User tries to view locked content
- User taps "Unlock" button
- From Settings → Subscription section

```swift
// Example: Show paywall
@State private var showPaywall = false

Button("Unlock Full Access") {
    showPaywall = true
}
.sheet(isPresented: $showPaywall) {
    PaywallView()
}
```

### Support View (Donations/Tips)
Show from:
- Settings screen (already implemented)
- Optional: Add a "Support" button in main navigation
- Optional: Show after they subscribe as a thank you

```swift
// Example: Show support view
@State private var showSupport = false

Button("Support & Donate") {
    showSupport = true
}
.sheet(isPresented: $showSupport) {
    SupportView()
}
```

---

## 🎨 UI Integration Examples

### Example 1: Lock a Specific Chapter

```swift
NavigationLink {
    ChapterDetailView(chapter: chapter)
        .requiresFullAccess() // This shows paywall if no access
} label: {
    ChapterRow(chapter: chapter)
}
```

### Example 2: Conditional Access Badge

```swift
HStack {
    Text("Premium Chapter")
    
    if !storeManager.hasFullAccess {
        Image(systemName: "lock.fill")
            .foregroundStyle(.yellow)
    }
}
```

### Example 3: Subscription Status Display

```swift
if storeManager.hasLifetimeAccess {
    Label("Lifetime Access", systemImage: "checkmark.seal.fill")
        .foregroundStyle(.green)
} else if storeManager.isInFreeTrial {
    Label("Free Trial Active", systemImage: "clock")
        .foregroundStyle(.blue)
} else if storeManager.hasActiveSubscription {
    Label("Subscribed", systemImage: "checkmark.circle")
        .foregroundStyle(.green)
}
```

---

## 📊 Testing the Free Trial

### In Development (StoreKit Configuration File)

The free trial is accelerated:
- "3 days" becomes ~3 minutes
- Watch Transaction Manager to see subscription timeline
- Test cancellation and renewal

### Steps to Test:
1. Build and run with StoreKit config enabled
2. Subscribe to monthly plan
3. Verify "Free Trial Active" shows
4. Open Debug → StoreKit → Manage Transactions
5. See subscription in "Free Trial" state
6. Wait 3 minutes (accelerated time)
7. Verify it converts to "Subscribed"

### Test Cancellation:
1. While subscribed, cancel in Transaction Manager
2. App should immediately lock content
3. Verify "Unlock" screen shows

---

## 🔒 Privacy & Security

### What Gets Tracked
- Purchase history (for access control)
- Subscription status (active/expired/trial)
- Product availability

### What Doesn't Get Tracked
- No personal information
- No analytics without user consent
- Donations and tips are anonymous

### Receipts
- Apple handles all receipt validation
- Transactions are verified automatically
- No sensitive data stored locally

---

## 💡 Pro Tips

### 1. Show Value Before Paywall
Let users:
- Browse chapter titles (free)
- View cover and title page (free)
- See 1-2 sample chapters (optional)
Then prompt for subscription

### 2. Highlight Free Trial
Make the free trial obvious:
- "Try FREE for 3 days"
- "No charge until [date]"
- Makes users more likely to subscribe

### 3. Lifetime vs Subscription Strategy

**Recommend Lifetime if:**
- User is a professional WFR
- Outdoor guide or instructor
- Frequent wilderness traveler

**Recommend Monthly if:**
- Casual user
- Taking one-time WFR course
- Wants to try before committing

### 4. Donation Prompts

Good times to suggest donations:
- After user subscribes (feeling generous)
- In Settings under "Support"
- Never on paywall (keeps it focused)

---

## 🧪 Example Test Checklist

Before releasing to App Store:

**Purchase Flow:**
- [ ] Lifetime purchase completes successfully
- [ ] Monthly subscription starts with free trial
- [ ] Free trial shows correct end date
- [ ] Subscription auto-renews after trial
- [ ] "Restore Purchases" works for lifetime
- [ ] "Restore Purchases" works for subscription

**Access Control:**
- [ ] Content locks when not subscribed
- [ ] Content unlocks after lifetime purchase
- [ ] Content unlocks during free trial
- [ ] Content unlocks with active subscription
- [ ] Content locks when subscription cancelled
- [ ] Unlock button shows paywall

**Donations & Tips:**
- [ ] All donation amounts work
- [ ] Donations show thank you message
- [ ] Donations don't grant access
- [ ] All tip amounts work
- [ ] Tips show thank you message
- [ ] Tips don't grant access

**UI/UX:**
- [ ] Settings shows correct subscription status
- [ ] "Manage Subscription" opens iOS settings
- [ ] Access badge shows in menu
- [ ] Locked content shows lock icon
- [ ] Error messages are user-friendly

---

## 🐛 Troubleshooting

### "Products Not Loading"

**Problem:** `products` array is empty

**Solutions:**
1. Check Product IDs match exactly
2. Wait 2-4 hours after creating products
3. Verify products are "Ready to Submit"
4. Try restarting Xcode

### "Subscription Not Showing Free Trial"

**Problem:** Shows full price instead of "Free"

**Solutions:**
1. Verify introductory offer is configured
2. Check offer type is "Free Trial" not "Pay As You Go"
3. Ensure offer duration is 3 days
4. Rebuild StoreKit configuration file

### "Access Not Unlocking After Purchase"

**Problem:** Content still locked after successful purchase

**Solutions:**
1. Check `updatePurchasedProducts()` is called
2. Verify transaction is finished
3. Ensure Product IDs match in all places
4. Try calling restore purchases

### "Can't Test Subscriptions"

**Problem:** Subscription options don't appear

**Solutions:**
1. Ensure StoreKit config is set in scheme
2. Check subscription is in config file
3. Verify subscription group is configured
4. Try with both simulator and device

---

## 📱 App Store Submission

### Required Assets

1. **Screenshots** showing:
   - What users get with subscription
   - Paywall with pricing clearly visible
   - Features available to subscribers

2. **App Privacy** section:
   - Set "Data Not Collected" (if true)
   - Or declare any analytics you use

3. **In-App Purchase Screenshots**:
   - Upload for each product
   - Show value proposition

### Review Notes

Include this for App Reviewers:

```
TEST ACCOUNT FOR REVIEW:
Subscription is required for full content access.
Test products are configured in StoreKit.

DONATION FEATURE:
Donations to "Friends of Custer Search and Rescue" 
are 501(c)(3) charitable donations. They do NOT 
grant app access - they are consumable purchases 
supporting the charity.

TIPS:
Developer tips are also consumable and do NOT 
grant app features.
```

---

## 🎓 Resources

- **StoreKit Setup Guide**: See `StoreKitSetupGuide.md`
- **Apple StoreKit Docs**: https://developer.apple.com/storekit
- **App Store Connect**: https://appstoreconnect.apple.com
- **Testing Guide**: https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox

---

## ✅ Quick Start Checklist

1. [ ] Read `StoreKitSetupGuide.md`
2. [ ] Create products in App Store Connect
3. [ ] Create StoreKit configuration file
4. [ ] Contact Friends of Custer SAR for info
5. [ ] Update donation screen with their info
6. [ ] Test lifetime purchase
7. [ ] Test monthly subscription + free trial
8. [ ] Test donations (all 4 tiers)
9. [ ] Test tips (all 3 tiers)
10. [ ] Test restore purchases
11. [ ] Test content locking/unlocking
12. [ ] Submit to App Store

---

## 🙋 Need Help?

Common questions:

**Q: Can I change prices later?**
A: Yes, in App Store Connect. Existing subscribers keep their price.

**Q: Can users have both lifetime AND subscription?**
A: No need - the code checks for either one. If someone bought lifetime, they won't see subscription option.

**Q: How do refunds work?**
A: Apple handles all refunds. You don't need to do anything.

**Q: What if Custer SAR gets donations outside the app?**
A: That's fine! These are separate. Apple takes 30% of in-app donations (15% for small businesses).

**Q: Can I add more donation amounts?**
A: Yes! Create new consumable products and add to `StoreManager.ProductID.donation*`

**Q: Should I offer a longer free trial?**
A: 3 days is good. Too short = not enough time. Too long = people forget.

---

## 🎉 You're All Set!

Your app now has:
- ✅ Professional paywall
- ✅ Subscription with free trial
- ✅ Lifetime purchase option
- ✅ Charity donation system
- ✅ Developer tip jar
- ✅ Automatic access control
- ✅ Restore purchases
- ✅ Settings integration

Everything follows Apple's best practices and Human Interface Guidelines.

Good luck with your launch! 🚀
