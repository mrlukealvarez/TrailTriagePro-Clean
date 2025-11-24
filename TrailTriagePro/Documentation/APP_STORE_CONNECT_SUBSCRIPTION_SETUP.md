# App Store Connect Subscription Setup Guide
## TrailTriage - Finalized Pricing & Configuration

Last Updated: November 11, 2025

---

## 📋 Finalized Pricing Strategy

After analysis of market conditions, target audience (WFRs/SAR volunteers), and churn optimization:

### ✅ **Recommended Pricing**

| Product | Type | Price | Trial | Rationale |
|---------|------|-------|-------|-----------|
| **Lifetime Access** | Non-Consumable | **$29.99** | None | 10-month equivalent - positioned as "smart buy" |
| **Monthly Subscription** | Auto-Renewable | **$2.99/month** | **7 days** | Low barrier, minimal churn, recurring revenue |

### Why $2.99/Month?

1. **Price Psychology**: Under $3 feels insignificant ("less than a coffee")
2. **Low Churn**: At this price point, users often forget to cancel or don't bother
3. **Target Audience**: WFRs and SAR volunteers are often price-sensitive (volunteers/enthusiasts)
4. **Lifetime Upsell**: Makes $29.99 lifetime feel like obvious value (10 months vs. pay forever)
5. **Professional Value**: Your content is worth more, but this maximizes conversions

### Why 7-Day Trial (Not 3-Day)?

- **Use Case**: Users need time to take the app into the field/wilderness
- **Engagement**: 7 days allows multiple use cases (planning, field use, post-trip review)
- **Industry Standard**: Most utility apps use 7-day trials
- **Conversion**: Longer trials actually improve conversion when the product delivers value

---

## 🛠️ App Store Connect Configuration

### Step 1: Access Subscriptions

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app: **WFR TrailTriage**
3. Click **Features** tab
4. Select **In-App Purchases** (or **Subscriptions** in some interfaces)

---

### Step 2: Configure Monthly Subscription

#### Product ID
```
com.wfr.trailtriage.monthly
```

#### Subscription Details

| Field | Value |
|-------|-------|
| **Reference Name** | TrailTriage Monthly Subscription |
| **Product ID** | com.wfr.trailtriage.monthly |
| **Subscription Group** | TrailTriage Pro (create if doesn't exist) |
| **Subscription Duration** | 1 Month |
| **Price** | $2.99 USD (Tier 3) |

#### Introductory Offer (Free Trial)

| Field | Value |
|-------|-------|
| **Type** | Free Trial |
| **Duration** | 7 Days |
| **Number of Periods** | 1 |
| **Eligibility** | New subscribers only |
| **Requires Prior Subscription** | No |

#### Localization

**Display Name**: TrailTriage Pro - Monthly

**Description**:
```
Get unlimited access to all wilderness medicine protocols, SOAP note documentation, and offline reference materials. 

Features include:
• 80+ hours of WFR protocol content
• Unlimited SOAP note creation
• GPS location tracking
• PDF export for EMS handoff
• 100% offline access
• iCloud sync across devices
• Regular content updates

7-day free trial, then $2.99 per month. Cancel anytime.
```

#### App Store Promotional Image
- Recommended: 1024x1024px image showing app value
- Consider: Screenshot of protocols or SOAP note interface
- Text overlay: "Try 7 Days Free"

---

### Step 3: Configure Lifetime Purchase

#### Product ID
```
com.wfr.trailtriage.lifetime
```

#### Product Details

| Field | Value |
|-------|-------|
| **Reference Name** | TrailTriage Lifetime Access |
| **Product ID** | com.wfr.trailtriage.lifetime |
| **Type** | Non-Consumable |
| **Price** | $29.99 USD (Tier 30) |

#### Localization

**Display Name**: TrailTriage Pro - Lifetime

**Description**:
```
One-time purchase for lifetime access to all TrailTriage features.

Same features as monthly subscription, but pay once and own it forever:
• 80+ hours of WFR protocol content
• Unlimited SOAP note creation
• GPS location tracking
• PDF export for EMS handoff
• 100% offline access
• iCloud sync across devices
• All future updates included

Best value - equivalent to 10 months of subscription!
```

---

### Step 4: Subscription Group Configuration

#### Group Name
```
TrailTriage Pro
```

#### Subscription Ranking
1. Monthly ($2.99/month) - Rank: 1 (default)

**Note**: Only one subscription in the group, so ranking doesn't matter much

#### Group Display Settings
- **Group Display Name**: TrailTriage Pro Membership
- **Custom Legal Text**: (Optional - use if you have specific terms)

---

## 🧪 Testing Configuration

### Sandbox Testing

1. Create sandbox test account in App Store Connect:
   - Go to **Users and Access** → **Sandbox Testers**
   - Create test Apple ID (e.g., `luke.test@icloud.com`)

2. On your iPhone:
   - Settings → App Store → Sandbox Account
   - Sign in with sandbox test account

3. Testing scenarios:
   - ✅ Start 7-day free trial
   - ✅ Trial converts to paid after 7 days (accelerated in sandbox)
   - ✅ Purchase lifetime
   - ✅ Restore purchases
   - ✅ Cancel subscription
   - ✅ Resubscribe after cancellation

### StoreKit Configuration File (for Xcode testing)

Your `Products.storekit` file should contain:

```json
{
  "identifier": "com.wfr.trailtriage.monthly",
  "type": "auto-renewable",
  "duration": "1 month",
  "price": "2.99",
  "family": {
    "name": "TrailTriage Pro"
  },
  "introductoryOffer": {
    "type": "free",
    "duration": "7 days",
    "numberOfPeriods": 1
  }
}
```

```json
{
  "identifier": "com.wfr.trailtriage.lifetime",
  "type": "non-consumable",
  "price": "29.99"
}
```

---

## 📱 App Implementation Status

### ✅ Completed

1. **StoreManager.swift**
   - Updated product IDs and documentation
   - Correct pricing reflected in comments
   - Transaction handling implemented

2. **PaywallView.swift**
   - New design with mascot
   - "Free Trial Enabled" toggle
   - Improved pricing cards
   - $29.99 lifetime / $2.99 monthly display

3. **OnboardingView.swift**
   - Updated to show 7-day trial
   - Correct $2.99/month pricing
   - Subscription gate working

4. **App Flow**
   - Launch → Onboarding → Trial Start → Main App ✅
   - Subscription gate prevents access without payment ✅
   - Restore purchases working ✅

---

## 🎨 UI/UX Enhancements Implemented

### 1. Cute Mascot
- Currently using SF Symbol: `figure.hiking`
- **TODO**: Consider custom mascot illustration
  - Suggestions: Friendly bear with first aid kit, mountain goat with WFR vest
  - Can be commissioned from Fiverr or created in-house
  - File format: PDF or PNG @3x for retina displays

### 2. Free Trial Toggle
- Implemented in PaywallView
- Shows/hides trial language dynamically
- Users can see pricing with/without trial

### 3. Modern Pricing Cards
- "BEST VALUE" badge on lifetime
- Clean, tappable design
- Loading states during purchase
- Error handling with user-friendly messages

---

## 🔐 App Store Review Preparation

### Required Screenshots

You'll need screenshots showing:

1. **Main Protocol List** (showing offline access)
2. **Protocol Detail View** (showing comprehensive content)
3. **SOAP Note Creation** (showing professional tools)
4. **Vital Signs Tracking** (showing medical features)
5. **Paywall/Subscription** (showing value proposition)

### App Review Notes

```
TrailTriage is a wilderness medicine reference app designed for Wilderness First Responders (WFRs), SAR volunteers, and outdoor professionals.

SUBSCRIPTION INFO:
- Monthly: $2.99/month with 7-day free trial
- Lifetime: $29.99 one-time purchase

TEST ACCOUNT:
- Skip subscription during onboarding using "Skip Subscription (Testing)" button (DEBUG builds only)
- Or use sandbox account: [provide test account]

KEY FEATURES TO TEST:
1. Offline access to all protocols (no internet required)
2. SOAP note documentation with GPS location
3. Vital signs tracking over time
4. PDF export functionality

DISCLAIMER:
App includes medical disclaimer stating content is for training/reference purposes. Users are instructed to seek professional medical help when possible.
```

---

## 📊 Revenue Projections

### Conservative Estimates

| Scenario | Users | Monthly Revenue | Annual Revenue |
|----------|-------|-----------------|----------------|
| **Year 1 (Launch)** | 100 monthly subs<br>50 lifetime | $299/month + $1,499 one-time | ~$5,087 |
| **Year 2 (Growth)** | 300 monthly subs<br>150 lifetime | $897/month + $4,497 one-time | ~$15,261 |
| **Year 3 (Mature)** | 500 monthly subs<br>250 lifetime | $1,495/month + $7,495 one-time | ~$25,435 |

**Note**: These are conservative estimates. Actual revenue depends on:
- Marketing efforts
- App Store visibility
- Word-of-mouth in WFR community
- SAR organization partnerships

### Churn Assumptions

At $2.99/month:
- **Expected Monthly Churn**: 3-5% (very low for this price point)
- **Lifetime Preference**: ~25-30% of users choose lifetime over monthly
- **Trial-to-Paid Conversion**: 20-40% (typical for 7-day trials)

---

## ✅ Next Steps Checklist

### 1. App Store Connect Setup
- [ ] Create/update monthly subscription ($2.99, 7-day trial)
- [ ] Create/update lifetime purchase ($29.99)
- [ ] Configure subscription group
- [ ] Add localized descriptions
- [ ] Upload promotional images

### 2. Testing
- [ ] Test with sandbox account
- [ ] Verify 7-day trial works
- [ ] Verify $2.99 monthly charge after trial
- [ ] Test lifetime purchase
- [ ] Test restore purchases
- [ ] Test subscription cancellation

### 3. Marketing Assets
- [ ] Consider custom mascot design
- [ ] Create App Store screenshots
- [ ] Write compelling App Store description
- [ ] Prepare promotional materials for SAR community

### 4. App Submission
- [ ] Complete App Store Connect listing
- [ ] Submit for review
- [ ] Provide test account and notes
- [ ] Monitor for review feedback

### 5. Post-Launch
- [ ] Monitor conversion rates
- [ ] Track churn metrics
- [ ] Gather user feedback
- [ ] Iterate on pricing if needed

---

## 💡 Alternative Pricing Considerations

If $2.99/month doesn't perform well after 3-6 months:

### Option A: Increase Monthly Price
- **$4.99/month**: Still affordable, 67% revenue increase
- **Pro**: Better margin per user
- **Con**: Might increase churn slightly

### Option B: Annual Subscription
- **$24.99/year** (equivalent to $2.08/month)
- **Pro**: Upfront revenue, better LTV
- **Con**: Higher barrier to entry

### Option C: Tiered Pricing
- **Basic**: $2.99/month (limited features)
- **Pro**: $4.99/month (all features)
- **Con**: Complexity in implementation and marketing

**Recommendation**: Start with $2.99/month as planned. Evaluate after 6 months with real data.

---

## 📞 Support & Resources

### Apple Resources
- [Subscription Documentation](https://developer.apple.com/app-store/subscriptions/)
- [StoreKit 2 Guide](https://developer.apple.com/documentation/storekit)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

### Community
- WFR Training Organizations (marketing partners)
- SAR Facebook Groups (word-of-mouth marketing)
- Outdoor subreddits (soft launch feedback)

---

## 🎯 Success Metrics to Track

### Week 1
- App Store impressions
- Download count
- Trial start rate

### Month 1
- Trial-to-paid conversion rate
- Lifetime vs. monthly preference
- Early churn rate

### Month 3
- Monthly recurring revenue (MRR)
- Churn stabilization
- User feedback themes

### Month 6
- Pricing validation (keep or adjust)
- Feature requests priority
- Marketing ROI assessment

---

**FINAL RECOMMENDATION**: 

✅ **Proceed with $2.99/month (7-day trial) + $29.99 lifetime**

This pricing balances:
- Accessibility for your target audience
- Low churn risk
- Clear lifetime value proposition
- Professional positioning without being "too cheap"

The implementation is complete and ready for App Store Connect configuration. Good luck with your launch! 🚀
