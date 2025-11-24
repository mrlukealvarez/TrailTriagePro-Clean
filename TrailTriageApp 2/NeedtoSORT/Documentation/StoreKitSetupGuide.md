//
//  StoreKitSetupGuide.md
//  WFR TrailTriage
//
//  Created by Luke Alvarez on 11/10/25.
//

# StoreKit Setup Guide for WFR TrailTriage

This guide will help you set up in-app purchases, subscriptions, and consumables (donations/tips) in App Store Connect.

## Step 1: Create In-App Purchases in App Store Connect

### Log into App Store Connect
1. Go to https://appstoreconnect.apple.com
2. Select your app (WFR TrailTriage)
3. Navigate to **Features** → **In-App Purchases**

---

## Step 2: Create Your Products

### A. Lifetime Purchase (Non-Consumable)

1. Click **+** to create a new in-app purchase
2. Select **Non-Consumable**
3. Configure:
   - **Product ID**: `com.wfr.trailtriage.lifetime`
   - **Reference Name**: `WFR TrailTriage Lifetime Access`
   - **Price**: $14.99 (Tier 15)
   - **Localized Description**: 
     - Display Name: "Lifetime Access"
     - Description: "One-time purchase for unlimited lifetime access to all WFR protocols and reference materials"
   - **Review Screenshot**: Upload a screenshot of your app's content

---

### B. Monthly Subscription (Auto-Renewable)

1. Create a new **Subscription Group**:
   - Name: `WFR TrailTriage Premium`
   - Reference Name: `Premium Access`

2. Add subscription:
   - **Product ID**: `com.wfr.trailtriage.monthly`
   - **Reference Name**: `WFR TrailTriage Monthly Subscription`
   - **Subscription Duration**: 1 Month
   - **Price**: $1.99/month

3. Configure **Introductory Offer**:
   - Type: Free Trial
   - Duration: 3 Days
   - Click **Add** under Introductory Offers
   - Select **Free Trial** and set duration to **3 Days**

4. **Localized Information**:
   - Display Name: "Monthly Premium"
   - Description: "Monthly subscription with 3-day free trial. Access all WFR protocols and reference materials. Cancel anytime."

---

### C. Donation Products (Consumables)

Create 4 consumable products for Friends of Custer Search and Rescue:

#### Donation Small
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.donation.small`
- **Reference Name**: `Custer SAR Donation - Small`
- **Price**: $5.00
- **Display Name**: "$5 Donation"
- **Description**: "Support Friends of Custer Search and Rescue with a $5 donation"

#### Donation Medium
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.donation.medium`
- **Reference Name**: `Custer SAR Donation - Medium`
- **Price**: $10.00
- **Display Name**: "$10 Donation"
- **Description**: "Support Friends of Custer Search and Rescue with a $10 donation"

#### Donation Large
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.donation.large`
- **Reference Name**: `Custer SAR Donation - Large`
- **Price**: $25.00
- **Display Name**: "$25 Donation"
- **Description**: "Support Friends of Custer Search and Rescue with a $25 donation"

#### Donation XLarge
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.donation.xlarge`
- **Reference Name**: `Custer SAR Donation - Extra Large`
- **Price**: $50.00
- **Display Name**: "$50 Donation"
- **Description**: "Support Friends of Custer Search and Rescue with a $50 donation"

---

### D. Developer Tip Products (Consumables)

Create 3 consumable products for developer tips:

#### Tip Small
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.tip.small`
- **Reference Name**: `Developer Tip - Coffee`
- **Price**: $2.99
- **Display Name**: "Coffee Tip"
- **Description**: "Buy the developer a coffee"

#### Tip Medium
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.tip.medium`
- **Reference Name**: `Developer Tip - Lunch`
- **Price**: $4.99
- **Display Name**: "Trail Lunch Tip"
- **Description**: "Buy the developer a trail lunch"

#### Tip Large
- **Type**: Consumable
- **Product ID**: `com.wfr.trailtriage.tip.large`
- **Reference Name**: `Developer Tip - Gear`
- **Price**: $9.99
- **Display Name**: "Climbing Rope Tip"
- **Description**: "Help the developer get new gear"

---

## Step 3: Create StoreKit Configuration File for Testing

1. In Xcode, go to **File** → **New** → **File**
2. Search for "StoreKit Configuration File"
3. Name it `Products.storekit`
4. Add all your products with the same Product IDs and prices

Your configuration should look like this:

```json
{
  "identifier": "WFRTrailTriageProducts",
  "nonRenewingSubscriptions": [],
  "products": [
    {
      "displayPrice": "14.99",
      "familyShareable": false,
      "internalID": "6670358485",
      "localizations": [
        {
          "description": "One-time purchase for unlimited lifetime access",
          "displayName": "Lifetime Access",
          "locale": "en_US"
        }
      ],
      "productID": "com.wfr.trailtriage.lifetime",
      "referenceName": "Lifetime Access",
      "type": "NonConsumable"
    },
    {
      "displayPrice": "2.99",
      "familyShareable": false,
      "internalID": "6670358486",
      "localizations": [
        {
          "description": "Buy the developer a coffee",
          "displayName": "Coffee Tip",
          "locale": "en_US"
        }
      ],
      "productID": "com.wfr.trailtriage.tip.small",
      "referenceName": "Developer Tip Small",
      "type": "Consumable"
    }
  ],
  "settings": {
    "askToBuyEnabled": false
  },
  "subscriptions": [
    {
      "adHocOffers": [],
      "codeOffers": [],
      "displayPrice": "1.99",
      "familyShareable": false,
      "groupNumber": 1,
      "internalID": "6670358487",
      "introductoryOffer": {
        "internalID": "6670358488",
        "numberOfPeriods": 1,
        "paymentMode": "free",
        "subscriptionPeriod": "P3D"
      },
      "localizations": [
        {
          "description": "Monthly subscription with 3-day free trial",
          "displayName": "Monthly Premium",
          "locale": "en_US"
        }
      ],
      "productID": "com.wfr.trailtriage.monthly",
      "recurringSubscriptionPeriod": "P1M",
      "referenceName": "Monthly Subscription",
      "subscriptionGroupNumber": 1,
      "type": "RecurringSubscription"
    }
  ],
  "version": {
    "major": 2,
    "minor": 0
  }
}
```

---

## Step 4: Configure Xcode Scheme for Testing

1. In Xcode, go to **Product** → **Scheme** → **Edit Scheme**
2. Select **Run** in the left sidebar
3. Go to **Options** tab
4. Under **StoreKit Configuration**, select your `Products.storekit` file
5. Click **Close**

Now you can test purchases without connecting to the App Store!

---

## Step 5: Testing Subscriptions

### Test the Free Trial
1. Build and run your app
2. Tap to subscribe to the monthly plan
3. Complete the purchase in the test environment
4. Verify that "Free Trial" shows in your subscription status
5. The trial will auto-convert to paid after 3 days (accelerated in testing)

### Test Subscription Cancellation
1. In the StoreKit testing environment, you can cancel by:
   - Opening the Transaction Manager window (Debug → StoreKit → Manage Transactions)
   - Finding your subscription and clicking "Cancel"
2. Verify that your app correctly locks content when subscription ends

---

## Step 6: Handling Donations vs Purchases

### Important Distinction

**Purchases/Subscriptions** (for your app):
- Grant access to content
- Are tracked via `Transaction.currentEntitlements`
- Remain active until cancelled/expired

**Consumables** (donations and tips):
- Do NOT grant access to content
- Are consumed immediately after purchase
- Are finished right away with `transaction.finish()`

The code handles this correctly:
- Lifetime purchase and active subscription → Full access
- Donations/tips → No access granted, just a "thank you"

---

## Step 7: Update Info.plist

Add privacy usage descriptions:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>We don't track you! This permission is never used.</string>
```

---

## Step 8: Friends of Custer SAR Information

### Update SupportView.swift with Real Information

Once you get their official information, update the following in `SupportView.swift`:

```swift
// Replace the placeholder contact info:
Link("Visit Website", destination: URL(string: "https://www.actual-website.com")!)

Text("Email: actual@email.com")
```

### Copy Their About Statement

Ask Friends of Custer Search and Rescue for:
1. Their official mission statement
2. Approved description of their work
3. Contact information (website, email, phone)
4. Tax ID / EIN for the 501(c)(3) status
5. Any specific language they want used for donations

Update the text in the `DonationView` to match their approved language.

---

## Step 9: Production Release

### Before submitting to App Store:

1. **Remove** or **disable** the StoreKit Configuration in your scheme
2. Ensure all Product IDs in `StoreManager.swift` match App Store Connect exactly
3. Sign an agreement in App Store Connect:
   - Go to **Agreements, Tax, and Banking**
   - Complete the **Paid Applications** agreement
   - Add banking information for receiving payments
4. Submit for review with screenshots showing:
   - The subscription options
   - What users get with purchase
   - How to cancel/restore purchases

---

## Step 10: Legal Requirements for Donations

### Tax Deductibility Notice

The code includes this notice:
> "Friends of Custer Search and Rescue is a 501(c)(3) organization. Your donation may be tax deductible."

**Important**: 
- Verify their 501(c)(3) status with their EIN
- Apple does NOT provide donation receipts
- You may need to coordinate with the charity to provide tax receipts separately
- Consider adding a note: "For a tax receipt, contact Friends of Custer SAR directly"

---

## Testing Checklist

- [ ] Lifetime purchase works and grants access
- [ ] Monthly subscription works with 3-day free trial
- [ ] Free trial converts to paid subscription
- [ ] Restore purchases works correctly
- [ ] Content locks when subscription is cancelled
- [ ] Donations process successfully
- [ ] Tips process successfully
- [ ] "Manage Subscription" button opens subscription settings
- [ ] Multiple purchases are handled correctly (e.g., can't buy lifetime twice)

---

## Troubleshooting

### Products not loading?
- Check that Product IDs match exactly
- Verify products are "Ready to Submit" in App Store Connect
- Wait a few hours after creating products for them to propagate
- Try restarting Xcode

### Free trial not showing?
- Make sure introductory offer is configured in App Store Connect
- Verify the offer is set to "Free Trial" not "Pay as you go" or "Pay up front"

### Subscription not auto-renewing in testing?
- In StoreKit testing, subscriptions renew much faster (every few minutes)
- Use Transaction Manager to view subscription timeline

---

## Support Resources

- [StoreKit Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)
- [StoreKit Testing Guide](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox)

---

## Questions?

If you run into issues, check:
1. Product IDs match exactly
2. StoreKit configuration is set up correctly
3. Products are approved in App Store Connect (for production)
4. Banking and tax info is complete in App Store Connect
