# In-App Purchase Setup Guide
## TrailTriage App

This guide walks you through setting up in-app purchases for TrailTriage in both local testing (Xcode) and production (App Store Connect).

---

## 📦 Product Catalog

### **1. Primary Monetization**

#### **Annual Subscription** (Recommended)
- **Product ID**: `com.wfr.trailtriage.monthly`
- **Type**: Auto-Renewable Subscription
- **Price**: $9.99/year (USD)
- **Free Trial**: 3 days
- **Subscription Group**: "TrailTriage Pro Subscription"
- **Features**:
  - Unlimited SOAP notes
  - GPS location tracking
  - PDF export for EMS handoff
  - Advanced assessments (AVPU, CSM, PERRL)
  - Vitals trending over time
  - Complete reference protocols
  - iCloud sync
  - Offline functionality

#### **Lifetime Purchase** (Alternative)
- **Product ID**: `com.wfr.trailtriage.lifetime`
- **Type**: Non-Consumable
- **Price**: $49.99 (USD) - *You can adjust this*
- **Features**: Same as subscription, but one-time payment
- **Benefits**: Higher upfront revenue, appeals to users who don't like subscriptions

---

### **2. Donation Tiers** (Friends of Custer Search and Rescue)

These are **consumable** products that users can purchase multiple times to support the SAR organization.

#### **Small Donation**
- **Product ID**: `com.wfr.trailtriage.donation.small`
- **Type**: Consumable
- **Price**: $4.99 (USD)
- **Display Name**: "Small Donation ($5)"

#### **Medium Donation**
- **Product ID**: `com.wfr.trailtriage.donation.medium`
- **Type**: Consumable
- **Price**: $9.99 (USD)
- **Display Name**: "Medium Donation ($10)"

#### **Large Donation**
- **Product ID**: `com.wfr.trailtriage.donation.large`
- **Type**: Consumable
- **Price**: $24.99 (USD)
- **Display Name**: "Large Donation ($25)"

#### **Extra Large Donation**
- **Product ID**: `com.wfr.trailtriage.donation.xlarge`
- **Type**: Consumable
- **Price**: $49.99 (USD)
- **Display Name**: "Extra Large Donation ($50)"

---

### **3. Tip Jar** (Support the Developer)

These are **consumable** products that users can purchase to support continued development.

#### **Small Tip**
- **Product ID**: `com.wfr.trailtriage.tip.small`
- **Type**: Consumable
- **Price**: $2.99 (USD)
- **Display Name**: "Small Tip ($3)" - Buy a coffee!

#### **Medium Tip**
- **Product ID**: `com.wfr.trailtriage.tip.medium`
- **Type**: Consumable
- **Price**: $4.99 (USD)
- **Display Name**: "Medium Tip ($5)" - Buy a lunch!

#### **Large Tip**
- **Product ID**: `com.wfr.trailtriage.tip.large`
- **Type**: Consumable
- **Price**: $9.99 (USD)
- **Display Name**: "Large Tip ($10)" - Buy a dinner!

---

## 🧪 Local Testing with StoreKit Configuration File

### Step 1: Add StoreKit Configuration to Xcode

1. **The file is already created**: `TrailTriage.storekit`
2. **Add to Xcode**:
   - In Xcode, right-click your project navigator
   - Choose "Add Files to [Project]..."
   - Select `TrailTriage.storekit`
   - Make sure it's added to your main app target

### Step 2: Enable StoreKit Testing

1. **Edit your scheme**:
   - In Xcode: Product → Scheme → Edit Scheme...
   - Select "Run" on the left
   - Go to the "Options" tab
   - Under "StoreKit Configuration", select `TrailTriage.storekit`

2. **Test purchases**:
   - Run your app in the simulator or on a device
   - All purchases will use fake transactions
   - No real money is charged
   - Transactions reset when you restart the app

### Step 3: Test Each Purchase Type

Test these scenarios:
- ✅ Start free trial (annual subscription)
- ✅ Purchase lifetime access
- ✅ Make a donation
- ✅ Leave a tip
- ✅ Restore purchases
- ✅ Cancel subscription (in StoreKit Transaction Manager)
- ✅ App behavior when subscription expires

**Debug Tool**: Use the built-in Debug Menu (DEBUG builds only):
- Open the app
- Go to More → Debug Menu (at bottom)
- Check subscription status, load products, etc.

---

## 🚀 Production Setup in App Store Connect

### Step 1: Create Your App

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps" → "+" → "New App"
3. Fill in:
   - **Platform**: iOS
   - **Name**: TrailTriage
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: (Your bundle ID)
   - **SKU**: (e.g., `wfr-trailtriage-001`)
   - **User Access**: Full Access

### Step 2: Create Subscription Group

1. In your app, go to **"Subscriptions"**
2. Click **"Create"** to make a new subscription group
3. **Group Reference Name**: `TrailTriage Pro Subscription`
4. Click **"Create"**

### Step 3: Create Annual Subscription

1. Inside the subscription group, click **"Create Subscription"**
2. Fill in:
   - **Product ID**: `com.wfr.trailtriage.monthly`
   - **Reference Name**: `Annual Subscription`
   - **Subscription Duration**: `1 Year`
   - **Subscription Prices**: $9.99 USD (set for all territories)

3. **Add Introductory Offer (Free Trial)**:
   - Click **"Introductory Offers"**
   - **Type**: Free
   - **Duration**: 3 Days
   - Click **"Save"**

4. **Localization** (English - U.S.):
   - **Display Name**: `TrailTriage Pro (Annual)`
   - **Description**: 
   ```
   Annual subscription to TrailTriage Pro. Includes unlimited SOAP notes, GPS tracking, PDF export, advanced assessments, and complete reference protocols. 3-day free trial, then $9.99/year.
   ```

5. **App Store Information**:
   - Click **"App Store Information"**
   - Add promotional text and images (optional)

6. **Review Information**:
   - Add screenshots showing the subscription features
   - Add a demo account if needed

7. Click **"Save"** and **"Submit for Review"**

### Step 4: Create Lifetime Purchase

1. Go to **"In-App Purchases"**
2. Click **"Manage"** → **"Create In-App Purchase"**
3. Select **"Non-Consumable"**
4. Fill in:
   - **Product ID**: `com.wfr.trailtriage.lifetime`
   - **Reference Name**: `Lifetime Access`
   - **Price**: $49.99 USD (Tier 50) - *Adjust as needed*

5. **Localization** (English - U.S.):
   - **Display Name**: `TrailTriage Pro (Lifetime)`
   - **Description**:
   ```
   One-time purchase for lifetime access to all TrailTriage Pro features. Never pay again! Includes everything: unlimited SOAP notes, GPS tracking, PDF export, advanced assessments, reference protocols, and iCloud sync.
   ```

6. **Review Information**:
   - Add screenshots
   - Explain what users get

7. Click **"Save"** and **"Submit for Review"**

### Step 5: Create Donation Tiers (4 products)

For each donation tier, repeat these steps:

1. Go to **"In-App Purchases"** → **"Create In-App Purchase"**
2. Select **"Consumable"**
3. Fill in the details for each:

#### Small Donation
- **Product ID**: `com.wfr.trailtriage.donation.small`
- **Reference Name**: `Donation - Small`
- **Price**: $4.99 USD
- **Display Name**: `Small Donation ($5)`
- **Description**:
```
Support Friends of Custer Search and Rescue with a small donation. Every bit helps support training, equipment, and life-saving missions in the Black Hills.
```

#### Medium Donation
- **Product ID**: `com.wfr.trailtriage.donation.medium`
- **Reference Name**: `Donation - Medium`
- **Price**: $9.99 USD
- **Display Name**: `Medium Donation ($10)`
- **Description**:
```
Support Friends of Custer Search and Rescue with a medium donation. Your contribution helps fund critical rescue operations and wilderness safety programs.
```

#### Large Donation
- **Product ID**: `com.wfr.trailtriage.donation.large`
- **Reference Name**: `Donation - Large`
- **Price**: $24.99 USD
- **Display Name**: `Large Donation ($25)`
- **Description**:
```
Support Friends of Custer Search and Rescue with a generous donation. Thank you for helping us maintain readiness and save lives in the backcountry!
```

#### Extra Large Donation
- **Product ID**: `com.wfr.trailtriage.donation.xlarge`
- **Reference Name**: `Donation - Extra Large`
- **Price**: $49.99 USD
- **Display Name**: `Extra Large Donation ($50)`
- **Description**:
```
Support Friends of Custer Search and Rescue with a major donation. Your generosity directly funds essential equipment, training, and emergency response capabilities. Thank you!
```

### Step 6: Create Tip Jar Tiers (3 products)

For each tip tier, repeat these steps:

1. Go to **"In-App Purchases"** → **"Create In-App Purchase"**
2. Select **"Consumable"**

#### Small Tip
- **Product ID**: `com.wfr.trailtriage.tip.small`
- **Reference Name**: `Tip - Small`
- **Price**: $2.99 USD
- **Display Name**: `Small Tip ($3)`
- **Description**:
```
Buy the developer a coffee! Small tips help support continued development of TrailTriage and keep the app improving.
```

#### Medium Tip
- **Product ID**: `com.wfr.trailtriage.tip.medium`
- **Reference Name**: `Tip - Medium`
- **Price**: $4.99 USD
- **Display Name**: `Medium Tip ($5)`
- **Description**:
```
Buy the developer a nice lunch! Your support is greatly appreciated and helps fund new features and improvements.
```

#### Large Tip
- **Product ID**: `com.wfr.trailtriage.tip.large`
- **Reference Name**: `Tip - Large`
- **Price**: $9.99 USD
- **Display Name**: `Large Tip ($10)`
- **Description**:
```
Treat the developer to a fancy dinner! Your generosity makes this app possible and supports ongoing development. Thank you!
```

---

## 📝 Review Notes for App Store

When submitting your app, include these notes in the **App Review Information** section:

### Subscription Notes:
```
SUBSCRIPTION INFORMATION:

TrailTriage offers an annual subscription ($9.99/year) with a 3-day free trial. This subscription provides:
- Unlimited SOAP note creation and storage
- GPS location tracking for incident documentation
- PDF export for EMS handoff
- Advanced medical assessment tools
- Complete wilderness medicine reference protocols
- iCloud sync across devices

Users can also purchase lifetime access ($49.99) as an alternative to the subscription.

TESTING THE SUBSCRIPTION:
1. Complete the onboarding flow
2. Select "Start Free Trial" on the subscription screen
3. Use the provided sandbox test account credentials
4. After purchase, you'll have full access to the app

The subscription is required to access the main app features. This is a professional medical documentation tool for certified wilderness first responders, and the subscription model ensures ongoing support and updates.
```

### Donation/Tip Notes:
```
DONATIONS & TIPS:

TrailTriage includes optional consumable in-app purchases:

1. Donations (4 tiers: $5, $10, $25, $50) - 100% of proceeds go to Friends of Custer Search and Rescue, a non-profit volunteer organization.

2. Tips (3 tiers: $3, $5, $10) - Optional way for users to support the developer and fund continued app development.

These are entirely optional and separate from the core subscription. Users can access these from the "More" tab → "Donate & Tips" and "Upgrade Options".
```

---

## 🧑‍💻 Testing with Sandbox Accounts

### Create Sandbox Testers

1. Go to **App Store Connect** → **Users and Access** → **Sandbox Testers**
2. Click **"+"** to add a new tester
3. Create at least 2-3 test accounts:
   - Email: Use unique emails (e.g., `test1@example.com`)
   - Password: Make it memorable
   - Country/Region: United States
   - Save the credentials

### Test on Device

1. **Sign out of your real Apple ID on your test device**:
   - Settings → [Your Name] → Media & Purchases → Sign Out
   - **DO NOT sign out of iCloud** - only Media & Purchases

2. **Run your app** from Xcode on the device

3. **When prompted to sign in to App Store**, use your sandbox tester credentials

4. **Test purchasing**:
   - Start the free trial
   - Sandbox account will be charged $0.00
   - Test restore purchases
   - Test canceling subscription (goes to real App Store settings, but uses sandbox)

### Sandbox Purchase Testing Checklist

- [ ] Purchase annual subscription (with trial)
- [ ] Verify app grants access after purchase
- [ ] Restore purchases on same device
- [ ] Restore purchases on different device (same sandbox account)
- [ ] Purchase lifetime access instead
- [ ] Make a donation
- [ ] Leave a tip
- [ ] Test subscription cancellation
- [ ] Test subscription expiration
- [ ] Test subscription renewal
- [ ] Verify free trial is 3 days

---

## 💰 Pricing Strategy

### Why $9.99/year?

- **Affordable for professionals**: Most WFRs are volunteers or seasonal workers
- **Sustainable**: Covers server costs (if needed), development, and support
- **Perceived value**: Less than $1/month feels like a no-brainer
- **Free trial**: 3 days lets users evaluate before committing
- **Competitive**: Similar apps charge $5-15/month; you're charging annually

### Why $49.99 for Lifetime?

- **5x annual price**: Standard pricing model (5 years = break-even)
- **Appeals to power users**: Some users hate subscriptions
- **Higher LTV**: Lifetime customers are often your biggest fans
- **Flexibility**: Gives users choice

### Pricing Tips:

- **Don't go too low**: $9.99/year is already very affordable
- **Don't undervalue your work**: This is a professional medical tool
- **Consider annual price increases**: iOS allows existing users to stay at old price
- **Test price points**: Use App Store A/B testing (available in ASC)

---

## 📊 Revenue Split

### Donations to Custer SAR:
- **100% of proceeds** should go to the organization
- Apple takes 30% (or 15% for small businesses)
- You absorb the Apple fee as a donation

### Example:
- User donates $10
- Apple keeps $3 (30%)
- You receive $7
- You donate **$10 to Custer SAR** (eating the $3 fee)

**OR** (More Sustainable):
- You receive $7 from Apple
- You donate **$7 to Custer SAR**
- Make it clear: "Less Apple's 30% processing fee"

### Tips:
- These go to you (the developer)
- Use for coffee, equipment, development costs
- Funding future features

---

## 🔒 Important Legal Considerations

### Subscriptions
- Must clearly show price and billing frequency
- Must allow easy cancellation (handled by iOS)
- Must honor free trial period
- Can't auto-renew after cancellation

### Medical Disclaimers
Your app already has good disclaimers, but make sure:
- Users understand this is a **documentation tool**, not medical advice
- Subscription doesn't imply certification or authorization to practice
- Always follow your training and local protocols

### Donations
- Be transparent about where donations go
- If you're a 501(c)(3), you can offer tax deduction info
- If not, make it clear donations are not tax-deductible
- Consider adding a link to Custer SAR's website

---

## 🐛 Troubleshooting

### "Invalid Product ID"
- Product IDs in code don't match App Store Connect
- Products haven't been approved yet (they need review first)
- Using wrong StoreKit configuration file
- Bundle ID doesn't match

### "Products Not Loading"
- Check network connection
- Wait a few minutes after creating products in ASC
- Verify product IDs are exact matches (case-sensitive!)
- Check Xcode console for specific errors

### "Subscription Not Granting Access"
- Transaction not being verified correctly
- Check `StoreManager.updatePurchasedProducts()`
- Add debug logging to see transaction status
- Verify `hasFullAccess` logic

### "Free Trial Not Working"
- Sandbox account has already used trial
- Create a new sandbox tester
- Delete app and reinstall
- Check introductory offer is configured correctly in ASC

### "Restore Purchases Does Nothing"
- No purchases to restore (test with valid purchase first)
- Transaction hasn't been properly verified
- Check StoreKit transaction manager logs

---

## ✅ Pre-Launch Checklist

Before submitting to App Store:

### Product Setup
- [ ] All product IDs created in App Store Connect
- [ ] Subscription group created
- [ ] Free trial configured (3 days)
- [ ] All products submitted for review
- [ ] Products approved (can take 24-48 hours)
- [ ] Localizations complete
- [ ] Pricing set for all territories

### Testing
- [ ] Tested in Xcode with StoreKit configuration file
- [ ] Tested on device with sandbox account
- [ ] Tested free trial
- [ ] Tested lifetime purchase
- [ ] Tested donations
- [ ] Tested tips
- [ ] Tested restore purchases
- [ ] Tested subscription expiration
- [ ] Tested app behavior without subscription

### Code
- [ ] Product IDs match exactly
- [ ] StoreManager loads all products
- [ ] Subscription status checked correctly
- [ ] Access gating works (can't use app without subscription)
- [ ] Error handling for failed purchases
- [ ] Receipt validation implemented (StoreKit 2 handles this)

### UI/UX
- [ ] Paywall is clear and compelling
- [ ] Pricing displayed correctly
- [ ] Terms and Privacy Policy linked
- [ ] Subscription management instructions clear
- [ ] Donation/tip screens well-designed

### Legal
- [ ] Terms of Service complete
- [ ] Privacy Policy complete
- [ ] Medical disclaimers clear
- [ ] Subscription terms clear (price, duration, renewal)
- [ ] Donation transparency (where money goes)

---

## 📚 Additional Resources

- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [In-App Purchase Guide](https://developer.apple.com/in-app-purchase/)
- [Subscription Best Practices](https://developer.apple.com/app-store/subscriptions/)
- [App Store Review Guidelines (3.1 - In-App Purchase)](https://developer.apple.com/app-store/review/guidelines/#in-app-purchase)
- [Testing In-App Purchases](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox)

---

## 🎯 Next Steps

1. **Add StoreKit configuration file to Xcode** → `TrailTriage.storekit`
2. **Test locally** with Debug Menu
3. **Create products in App Store Connect** (follow guide above)
4. **Test with sandbox accounts** on real devices
5. **Submit app for review** (include subscription test instructions)
6. **Launch!** 🚀

---

**Questions?** Check the troubleshooting section or refer to Apple's documentation. Good luck with your launch!

**Black Elk Mountain Medicine** | TrailTriage | Wilderness Medicine Documentation
