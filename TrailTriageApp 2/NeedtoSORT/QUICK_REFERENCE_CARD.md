# 🎯 QUICK REFERENCE CARD
### Daily Development Shortcuts

---

## 🚀 TESTING SHORTCUTS

### Access Developer Tools
```
Settings → Developer Testing
```

### Show Onboarding
```
Developer Testing → "Show Onboarding"
```

### Show Paywall
```
Developer Testing → "Show Paywall"
```

### View All Screens
```
Developer Testing → "View All Screens"
```

### Check Subscription Status
```
Developer Testing → Top section shows current state
```

---

## 🧪 RESET FOR TESTING

### Quick Reset (Keep App)
```
1. Debug → StoreKit → Manage Transactions
2. Select subscription → "Expire" or "Cancel"
3. Force quit app (Cmd+Q)
4. Relaunch app
✅ Onboarding appears
```

### Full Reset (Fresh Start)
```
1. Stop app
2. Debug → StoreKit → Manage Transactions → "Delete All"
3. Clean Build (Cmd+Shift+K)
4. Run app (Cmd+R)
✅ Like fresh install
```

---

## ⚡️ BUILD OPTIMIZATION

### Slow Build Fix
```
1. Product → Clean Build Folder (Cmd+Shift+K)
2. Delete Derived Data:
   ~/Library/Developer/Xcode/DerivedData/
3. Restart Xcode
4. Build (Cmd+B)
```

### Enable Faster Debug Builds
```
Build Settings → Debug Information Format
Debug: DWARF (not DWARF with dSYM)
```

---

## 🎮 COMMON TESTING FLOWS

### Test New User
```
1. Delete All Transactions
2. Clean Build
3. Run
4. See onboarding → purchase → unlock
```

### Test Subscription Cancel
```
1. Purchase subscription
2. Expire in Transaction Manager
3. Relaunch app
4. See onboarding return
```

### Test Restore Purchases
```
1. Purchase lifetime
2. Keep transactions
3. Relaunch app
4. Should auto-restore
```

---

## 📱 KEY APP FLOWS

### No Subscription Flow
```
App Launch → Loading → OnboardingView → PaywallView → Purchase → MainTabView
```

### Has Subscription Flow
```
App Launch → Loading → MainTabView
```

### Expired Subscription Flow
```
App Launch → Loading → Check subscription → Expired → OnboardingView
```

---

## 🔍 DEBUG CONSOLE CHECKS

### Check Subscription Status
```swift
po StoreManager.shared.hasFullAccess
po StoreManager.shared.hasLifetimeAccess
po StoreManager.shared.hasActiveSubscription
po StoreManager.shared.isInFreeTrial
```

### Check Products Loaded
```swift
po StoreManager.shared.products.count
po StoreManager.shared.purchasedProductIDs
```

---

## 📊 STOREKIT TRANSACTION MANAGER

### Access
```
While app running:
Xcode → Debug → StoreKit → Manage Transactions
```

### Actions
- View all purchases
- Cancel subscriptions
- Expire subscriptions
- Delete transactions
- Speed up renewal
- Test refunds

---

## 🎨 WALLET INTEGRATION

### Preview UI
```
Developer Testing → View All Screens → Wallet Integration
```

### Setup Required
1. Create Pass Type ID in Apple Developer Portal
2. Get signing certificate
3. Add pass images
4. Test on device

### Documentation
```
See: WALLET_INTEGRATION_GUIDE.md
```

---

## 📝 KEYBOARD SHORTCUTS

```
Cmd+R       : Run app
Cmd+.       : Stop app
Cmd+B       : Build
Cmd+Shift+K : Clean Build Folder
Cmd+Q       : Quit Simulator
Cmd+Shift+A : Quick Actions
```

---

## 🐛 COMMON ISSUES

### "Products not loading"
✅ Check StoreKit config selected in scheme

### "Subscription not updating"
✅ Force quit and relaunch app

### "Onboarding won't dismiss"
✅ Check if purchase actually completed

### "Builds are slow"
✅ Clean Build Folder + Delete Derived Data

---

## 📚 DOCUMENTATION

**Testing:** COMPREHENSIVE_TESTING_GUIDE.md
**Build:** BUILD_PERFORMANCE_GUIDE.md
**Wallet:** WALLET_INTEGRATION_GUIDE.md
**Summary:** REVIEW_DAY_SUMMARY.md

---

## ✅ DAILY CHECKLIST

**Before Starting Work:**
- [ ] Clean Build if needed
- [ ] Check console for errors
- [ ] Verify StoreKit config

**After Code Changes:**
- [ ] Test affected screens
- [ ] Quick flow test
- [ ] Check for crashes

**Before Committing:**
- [ ] Full flow test
- [ ] All screens accessible
- [ ] No console errors

---

**Keep this handy for quick reference! 📌**
