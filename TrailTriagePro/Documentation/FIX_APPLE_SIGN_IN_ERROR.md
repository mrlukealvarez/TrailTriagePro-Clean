# Fixing Apple Sign In Error (Error 1000)

## The Error
```
The operation could not be completed.
Authentication Services auth error 1000
```

## Why This Happens
Apple Sign In requires proper configuration in your Xcode project. The error means the Sign in with Apple capability isn't enabled or configured.

## How to Fix

### Step 1: Enable Sign in with Apple Capability
1. Open your Xcode project
2. Select your **app target** (WFR TrailTriage) in the left sidebar
3. Click the **Signing & Capabilities** tab at the top
4. Click the **+ Capability** button
5. Search for "Sign in with Apple"
6. Double-click **"Sign in with Apple"** to add it

### Step 2: Verify Your Team & Bundle ID
1. In **Signing & Capabilities** tab
2. Make sure **Team** is selected (your Apple Developer account)
3. Make sure **Bundle Identifier** is unique (e.g., `com.blackelkmountainmedicine.trailtriage`)

### Step 3: Configure on Apple Developer Portal (If Publishing)
When you're ready to publish, you'll need to:

1. Go to [developer.apple.com](https://developer.apple.com)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers**
4. Select your App ID (or create one)
5. Enable **Sign in with Apple** capability
6. Save

### Step 4: Test Again
1. Clean build folder: **Product → Clean Build Folder** (Shift+Cmd+K)
2. Rebuild and run
3. Try Sign in with Apple again

## For Development Testing

If you don't want to configure Apple Sign In right now, you can use the **DEBUG skip button** I added:

```swift
#if DEBUG
Button("Skip Sign In (Testing Only)") {
    coordinator.userID = "test-user-id"
    coordinator.userName = "Test User"
    coordinator.nextStep()
}
#endif
```

This button only appears in DEBUG builds and lets you skip authentication during development.

## Important Notes

⚠️ **For App Store Submission:**
- You MUST enable Sign in with Apple capability
- You MUST remove all DEBUG skip buttons
- Test with real Apple ID in TestFlight

✅ **For Local Testing:**
- Use the DEBUG skip buttons
- Focus on UI/UX flow first
- Configure Apple Sign In when ready for real testing

## Quick Test Checklist

- [ ] Added "Sign in with Apple" capability in Xcode
- [ ] Selected a development team
- [ ] Bundle ID is set correctly
- [ ] Cleaned and rebuilt project
- [ ] Tested Sign in with Apple button
- [ ] If still testing, use DEBUG skip button

## Alternative: Use Skip Button for Now

Since you're still building and testing, you can:
1. Use the red **"Skip Sign In (Testing Only)"** button
2. This will let you test the full onboarding flow
3. Configure Apple Sign In later when you're ready for real testing

---

**Need help?** Check the Xcode console for more detailed error messages.
