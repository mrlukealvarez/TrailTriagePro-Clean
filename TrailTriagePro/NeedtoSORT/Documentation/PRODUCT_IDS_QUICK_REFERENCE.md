# Quick Reference: Product IDs & Descriptions
## Copy/Paste for App Store Connect

---

## 📱 ANNUAL SUBSCRIPTION

**Product ID**: `com.wfr.trailtriage.monthly`  
**Reference Name**: Annual Subscription  
**Type**: Auto-Renewable Subscription  
**Duration**: 1 Year  
**Price**: $9.99 USD  
**Free Trial**: 3 Days (Introductory Offer)  
**Subscription Group**: TrailTriage Pro Subscription  

**Display Name**: TrailTriage Pro (Annual)

**Description**:
```
Annual subscription to TrailTriage Pro. Includes unlimited SOAP notes, GPS tracking, PDF export, advanced assessments, and complete reference protocols. 3-day free trial, then $9.99/year.
```

---

## 💎 LIFETIME PURCHASE

**Product ID**: `com.wfr.trailtriage.lifetime`  
**Reference Name**: Lifetime Access  
**Type**: Non-Consumable  
**Price**: $49.99 USD  

**Display Name**: TrailTriage Pro (Lifetime)

**Description**:
```
One-time purchase for lifetime access to all TrailTriage Pro features. Never pay again! Includes everything: unlimited SOAP notes, GPS tracking, PDF export, advanced assessments, reference protocols, and iCloud sync.
```

---

## 💙 DONATION: SMALL

**Product ID**: `com.wfr.trailtriage.donation.small`  
**Reference Name**: Donation - Small  
**Type**: Consumable  
**Price**: $4.99 USD  

**Display Name**: Small Donation ($5)

**Description**:
```
Support Friends of Custer Search and Rescue with a small donation. Every bit helps support training, equipment, and life-saving missions in the Black Hills.
```

---

## 💙 DONATION: MEDIUM

**Product ID**: `com.wfr.trailtriage.donation.medium`  
**Reference Name**: Donation - Medium  
**Type**: Consumable  
**Price**: $9.99 USD  

**Display Name**: Medium Donation ($10)

**Description**:
```
Support Friends of Custer Search and Rescue with a medium donation. Your contribution helps fund critical rescue operations and wilderness safety programs.
```

---

## 💙 DONATION: LARGE

**Product ID**: `com.wfr.trailtriage.donation.large`  
**Reference Name**: Donation - Large  
**Type**: Consumable  
**Price**: $24.99 USD  

**Display Name**: Large Donation ($25)

**Description**:
```
Support Friends of Custer Search and Rescue with a generous donation. Thank you for helping us maintain readiness and save lives in the backcountry!
```

---

## 💙 DONATION: EXTRA LARGE

**Product ID**: `com.wfr.trailtriage.donation.xlarge`  
**Reference Name**: Donation - Extra Large  
**Type**: Consumable  
**Price**: $49.99 USD  

**Display Name**: Extra Large Donation ($50)

**Description**:
```
Support Friends of Custer Search and Rescue with a major donation. Your generosity directly funds essential equipment, training, and emergency response capabilities. Thank you!
```

---

## ☕ TIP: SMALL

**Product ID**: `com.wfr.trailtriage.tip.small`  
**Reference Name**: Tip - Small  
**Type**: Consumable  
**Price**: $2.99 USD  

**Display Name**: Small Tip ($3)

**Description**:
```
Buy the developer a coffee! Small tips help support continued development of TrailTriage and keep the app improving.
```

---

## 🍕 TIP: MEDIUM

**Product ID**: `com.wfr.trailtriage.tip.medium`  
**Reference Name**: Tip - Medium  
**Type**: Consumable  
**Price**: $4.99 USD  

**Display Name**: Medium Tip ($5)

**Description**:
```
Buy the developer a nice lunch! Your support is greatly appreciated and helps fund new features and improvements.
```

---

## 🍽️ TIP: LARGE

**Product ID**: `com.wfr.trailtriage.tip.large`  
**Reference Name**: Tip - Large  
**Type**: Consumable  
**Price**: $9.99 USD  

**Display Name**: Large Tip ($10)

**Description**:
```
Treat the developer to a fancy dinner! Your generosity makes this app possible and supports ongoing development. Thank you!
```

---

## 📋 SUMMARY TABLE

| Product | Product ID | Type | Price |
|---------|-----------|------|-------|
| Annual Subscription | `com.wfr.trailtriage.monthly` | Auto-Renewable | $9.99/year |
| Lifetime Access | `com.wfr.trailtriage.lifetime` | Non-Consumable | $49.99 |
| Small Donation | `com.wfr.trailtriage.donation.small` | Consumable | $4.99 |
| Medium Donation | `com.wfr.trailtriage.donation.medium` | Consumable | $9.99 |
| Large Donation | `com.wfr.trailtriage.donation.large` | Consumable | $24.99 |
| XL Donation | `com.wfr.trailtriage.donation.xlarge` | Consumable | $49.99 |
| Small Tip | `com.wfr.trailtriage.tip.small` | Consumable | $2.99 |
| Medium Tip | `com.wfr.trailtriage.tip.medium` | Consumable | $4.99 |
| Large Tip | `com.wfr.trailtriage.tip.large` | Consumable | $9.99 |

**Total Products**: 9 (1 subscription + 1 non-consumable + 7 consumables)

---

## 🚀 QUICK SETUP CHECKLIST

### In App Store Connect:

1. **Create Subscription Group**
   - [ ] Name: "TrailTriage Pro Subscription"
   - [ ] Create annual subscription with 3-day free trial

2. **Create In-App Purchases**
   - [ ] Lifetime purchase (non-consumable)
   - [ ] 4 donation tiers (consumable)
   - [ ] 3 tip tiers (consumable)

3. **Submit for Review**
   - [ ] Add screenshots for each product
   - [ ] Fill in review notes
   - [ ] Submit

### In Xcode:

4. **Add StoreKit Configuration**
   - [ ] Add `TrailTriage.storekit` to project
   - [ ] Enable in scheme: Product → Scheme → Edit Scheme → Options
   - [ ] Test locally

5. **Test with Sandbox**
   - [ ] Create sandbox tester accounts in ASC
   - [ ] Test on device with sandbox account
   - [ ] Verify purchases work

---

## 📞 SUPPORT INFO FOR APP REVIEW

**App Review Notes**:
```
This app offers an annual subscription ($9.99/year) with a 3-day free trial for professional wilderness medical documentation tools. Users can also purchase lifetime access ($49.99) as an alternative.

Optional donations support Friends of Custer Search and Rescue (non-profit SAR organization). Optional tips support continued development.

To test: Complete onboarding, start free trial using provided sandbox account. Full app access requires active subscription or lifetime purchase.
```

---

## 🎯 TESTING WORKFLOW

1. **In Xcode Simulator**:
   - Enable StoreKit configuration file
   - Run app, test subscription flow
   - Check Debug Menu (More → Debug Menu)

2. **On Real Device (Sandbox)**:
   - Sign out of App Store (Settings → Media & Purchases)
   - Run app from Xcode
   - Use sandbox tester credentials when prompted
   - Test purchase, restore, and cancellation

3. **Before Production Release**:
   - Wait for products to be approved in ASC
   - Test with approved products and sandbox account
   - Verify everything works before launch

---

**Ready to set up?** Follow the steps in `IN_APP_PURCHASE_SETUP.md` for detailed instructions!
