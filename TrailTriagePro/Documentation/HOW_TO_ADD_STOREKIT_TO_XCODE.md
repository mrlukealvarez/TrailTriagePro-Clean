# How to Add StoreKit Configuration to Xcode
## Step-by-Step with Screenshots Guide

This guide walks you through adding the `TrailTriage.storekit` file to your Xcode project so you can test in-app purchases locally without needing App Store Connect.

---

## ✅ Step 1: Locate the StoreKit Configuration File

The file has been created for you: **`TrailTriage.storekit`**

This JSON file contains all your product definitions for local testing.

---

## ✅ Step 2: Add File to Xcode Project

### Option A: Drag and Drop (Easiest)

1. **Find the file** in Finder (it should be in your project folder)
2. **Open Xcode** and make sure your project navigator is visible (⌘+1)
3. **Drag** `TrailTriage.storekit` into your Xcode project navigator
4. In the dialog that appears:
   - ✅ Check **"Copy items if needed"**
   - ✅ Check your **app target** (TrailTriage or WFR TrailTriage)
   - Click **"Add"**

### Option B: Add Files Menu

1. **Right-click** in the Xcode project navigator (in the file list area)
2. Choose **"Add Files to [Your Project Name]..."**
3. Navigate to `TrailTriage.storekit`
4. Make sure these options are selected:
   - ✅ **"Copy items if needed"**
   - ✅ **"Create groups"** (not "Create folder references")
   - ✅ Your **app target** is checked
5. Click **"Add"**

### Verify It Was Added

- You should now see `TrailTriage.storekit` in your project navigator
- It should have a small shopping cart icon 🛒 next to it
- Click on it to view the products in Xcode's StoreKit editor

---

## ✅ Step 3: Enable StoreKit Configuration in Your Scheme

This tells Xcode to use your local StoreKit file instead of real App Store purchases.

1. **Open Scheme Editor**:
   - Click the **scheme selector** (next to the play/stop buttons at top)
   - It should say something like "WFR TrailTriage" or "TrailTriage"
   - Click it → Choose **"Edit Scheme..."**
   - **OR** use keyboard shortcut: **⌘+<** (Command + Shift + Comma)

2. **Configure StoreKit**:
   - In the left sidebar, select **"Run"**
   - Click the **"Options"** tab at the top
   - Find **"StoreKit Configuration"**
   - Change dropdown from **"None"** to **"TrailTriage.storekit"**

3. **Close**:
   - Click **"Close"**
   - Your scheme is now configured!

---

## ✅ Step 4: Test the Configuration

### Run Your App

1. **Build and run** (⌘+R) your app in the simulator or on a device
2. **Complete onboarding** until you reach the subscription screen
3. You should see:
   - ✅ Products loading successfully
   - ✅ "TrailTriage Pro (Annual)" - $9.99
   - ✅ "TrailTriage Pro (Lifetime)" - $49.99
   - ✅ All other products

### Make a Test Purchase

1. Tap **"Start Free Trial"** (or any other product)
2. The system purchase sheet appears
3. **Authentication**: 
   - In simulator: Just tap "Subscribe" or "Buy"
   - On device: You might see a Face ID prompt (just confirm)
4. **Success!** The purchase completes instantly (fake transaction)
5. The app should now grant you access

### Important Notes:

- ⚠️ **No real money is charged** - these are fake transactions
- ⚠️ **Transactions reset** when you restart the app
- ⚠️ **Subscriptions don't actually expire** in local testing
- ⚠️ **You can "purchase" as many times as you want**

---

## ✅ Step 5: Use the StoreKit Transaction Manager

Xcode has a built-in tool to inspect and manage test transactions.

### Open Transaction Manager:

1. While your app is running, go to Xcode menu:
   - **Debug** → **StoreKit** → **Manage Transactions...**
   
2. A new window opens showing:
   - All transactions made
   - Purchase dates
   - Expiration dates (for subscriptions)
   - Transaction IDs

### What You Can Do:

- ✅ **View all transactions** (purchases, subscriptions, consumables)
- ✅ **Refund a transaction** (test refund handling)
- ✅ **Expire a subscription** (test subscription expiration)
- ✅ **Speed up time** (test renewals without waiting)
- ✅ **Clear all transactions** (reset to fresh state)

### Common Actions:

#### Clear All Purchases (Start Fresh):
1. Open Manage Transactions
2. Select all transactions
3. Click **"Delete"** or press **Delete** key
4. Restart your app

#### Test Subscription Expiration:
1. Purchase the subscription in your app
2. Open Manage Transactions
3. Find the subscription transaction
4. Click **"Expire Subscription"**
5. Your app should detect the expired subscription

#### Test Refund:
1. Purchase something
2. Open Manage Transactions
3. Select the transaction
4. Click **"Refund Purchase"**
5. Your app should handle the refund event

---

## ✅ Step 6: Use the Debug Menu in Your App

Your app has a built-in debug menu (only in DEBUG builds).

### How to Access:

1. Run your app in DEBUG mode
2. Complete onboarding (or skip with debug button)
3. Go to **More** tab (bottom right)
4. Scroll to the bottom → **"🐛 Debug Menu"**
5. Tap it to open

### What You Can Do:

- ✅ **Reset Onboarding** - See onboarding again
- ✅ **Load Products** - Manually trigger product loading
- ✅ **Show All Products** - See what products loaded
- ✅ **Check Subscription Status** - See current access level
- ✅ **Refresh Status** - Update purchased products
- ✅ **Restore Purchases** - Test restore flow

### Useful for:

- Testing onboarding multiple times
- Debugging product loading issues
- Checking subscription state
- Verifying purchases are working

---

## ✅ Step 7: Viewing and Editing the StoreKit File

You can edit your products directly in Xcode!

### View Products:

1. Click **`TrailTriage.storekit`** in project navigator
2. Xcode shows a visual editor with all your products
3. You'll see tabs: **Subscriptions**, **In-App Purchases**, **Settings**

### Edit a Product:

1. Click on any product to select it
2. Edit in the right sidebar:
   - Price
   - Display name
   - Description
   - Subscription duration
   - Free trial settings
   - etc.

3. Changes are saved automatically

### Add New Products:

1. Click the **"+"** button at the bottom
2. Choose type:
   - Auto-Renewable Subscription
   - Non-Consumable
   - Consumable
   - Non-Renewing Subscription
3. Fill in details
4. Product is immediately available for testing

### Delete Products:

1. Select the product
2. Press **Delete** key (or right-click → Delete)
3. Product is removed from local testing

---

## 🔍 Troubleshooting

### Products Not Loading

**Problem**: App says "Loading..." but never shows products

**Solutions**:
1. Check the Xcode console for error messages
2. Verify StoreKit configuration is enabled in scheme
3. Make sure `TrailTriage.storekit` is added to your app target
4. Restart Xcode and rebuild
5. Check product IDs in `StoreManager.swift` match exactly

### "Product Not Found" Error

**Problem**: Specific products don't load

**Solutions**:
1. Check spelling of product IDs (case-sensitive!)
2. Verify product exists in `TrailTriage.storekit`
3. Make sure product type is correct (subscription vs consumable)
4. Check Xcode console for specific error

### Purchases Not Working

**Problem**: Tapping "Buy" does nothing

**Solutions**:
1. Make sure StoreKit configuration is enabled
2. Check you're running in DEBUG mode (simulator or device)
3. Look for errors in Xcode console
4. Try clearing transactions (Transaction Manager)
5. Restart app

### Subscription Not Granting Access

**Problem**: Purchased subscription but app still shows "Not Subscribed"

**Solutions**:
1. Check `StoreManager.updatePurchasedProducts()` is being called
2. Add breakpoint or logging to see transaction status
3. Verify `hasFullAccess` computed property logic
4. Look at Debug Menu → Subscription Status
5. Check Transaction Manager to see if purchase recorded

### StoreKit Configuration Not Showing in Scheme

**Problem**: Don't see "TrailTriage.storekit" in dropdown

**Solutions**:
1. Make sure file is added to project (check project navigator)
2. Restart Xcode
3. Make sure file has `.storekit` extension
4. Check file isn't in a nested group

---

## 📋 Testing Checklist

Use this to make sure everything works:

### Initial Setup
- [ ] `TrailTriage.storekit` file added to Xcode project
- [ ] File has shopping cart icon in navigator
- [ ] StoreKit configuration enabled in scheme (Edit Scheme → Run → Options)
- [ ] App builds and runs successfully

### Product Loading
- [ ] Run app in simulator
- [ ] Complete onboarding to subscription screen
- [ ] Products load successfully (see 2 products: subscription + lifetime)
- [ ] Products show correct prices ($9.99/year and $49.99)
- [ ] No errors in Xcode console

### Purchasing
- [ ] Tap "Start Free Trial"
- [ ] System purchase sheet appears
- [ ] Complete purchase (tap Subscribe)
- [ ] Success message or app grants access
- [ ] Transaction appears in Transaction Manager

### Access Gating
- [ ] Fresh install: Can't access main app without subscription
- [ ] After purchase: Main app is accessible
- [ ] All features unlocked (New Note, Reference, etc.)
- [ ] Subscription Status view shows "Subscribed"

### Restore Purchases
- [ ] Delete app from simulator/device
- [ ] Reinstall and run
- [ ] Complete onboarding to subscription screen
- [ ] Tap "Restore Purchases"
- [ ] Previous purchase is restored
- [ ] App grants access

### Other Products
- [ ] Lifetime purchase works
- [ ] Donations can be purchased (4 tiers)
- [ ] Tips can be purchased (3 tiers)
- [ ] Consumables can be bought multiple times

### Debug Tools
- [ ] Debug Menu accessible (More → Debug Menu)
- [ ] Can reset onboarding
- [ ] Can view subscription status
- [ ] Can refresh products
- [ ] Transaction Manager shows all transactions

---

## 🚀 Next Steps

Once local testing works perfectly:

1. **Create products in App Store Connect** (see `IN_APP_PURCHASE_SETUP.md`)
2. **Test with sandbox accounts** on real devices
3. **Submit products for review** (wait for approval)
4. **Test approved products** with sandbox before launch
5. **Submit app to App Store**

---

## 📚 Additional Resources

- **Xcode StoreKit Testing**: [Apple Docs](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode)
- **StoreKit Configuration File**: [Apple Docs](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_storekit_test)
- **Transaction Manager**: [Apple Docs](https://developer.apple.com/documentation/xcode/testing-in-app-purchases-with-storekit-test#Manage-transactions)

---

**You're all set!** Your local StoreKit testing environment is configured and ready to use. Happy testing! 🎉
