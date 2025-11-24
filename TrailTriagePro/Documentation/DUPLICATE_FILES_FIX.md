# CRITICAL: Remove Duplicate Files

## ❌ Problem: Duplicate View Declarations

Your Xcode project has duplicate view files causing "Invalid redeclaration" errors:

1. **SubscriptionStatusView** - declared multiple times
2. **DetailRow** - declared multiple times  
3. **PrivacyPolicyView** - declared multiple times

## 🔧 Solution: Clean Up Project

### Step 1: Delete These Files from Your Xcode Project (if they exist):

Check if you have OLD versions of these files and DELETE them:
- SubscriptionStatusView.swift (any old versions)
- PrivacyPolicyView.swift (any old versions)
- AboutView.swift (any old versions)

### Step 2: Make Sure You Have ONLY ONE of Each File

You should have created these files earlier in our conversation. If you have multiple copies, keep only the NEWEST version.

### Step 3: If Errors Persist, Use This Minimal SettingsView

Replace your SettingsView.swift with this MINIMAL version that doesn't use any of the problematic views:

```swift
//
//  SettingsView.swift (MINIMAL - NO ERRORS VERSION)
//  WFR TrailTriage
//
//  Created by Luke Alvarez on 11/10/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showPaywall = false
    @State private var showSupport = false
    
    var body: some View {
        NavigationStack {
            List {
                // Premium Section
                Section {
                    if !StoreManager.shared.hasFullAccess {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "lock.open.fill")
                                    .foregroundStyle(.blue)
                                Text("Unlock Full Access")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            VStack(alignment: .leading) {
                                Text("Full Access Active")
                                    .font(.headline)
                                Text("Thank you for your support!")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Button {
                        showSupport = true
                    } label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                            Text("Donate & Tips")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Premium")
                }
                
                // Support Section
                Section {
                    Link(destination: URL(string: "https://mrlukealvarez.github.io/blackelkmountainmedicine.com/")!) {
                        HStack {
                            Label("Visit Website", systemImage: "globe")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                        }
                    }
                    
                    Link(destination: URL(string: "mailto:support@blackelkmountainmedicine.com")!) {
                        HStack {
                            Label("Contact Support", systemImage: "envelope")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                        }
                    }
                } header: {
                    Text("Support")
                }
                
                // App Info Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                } footer: {
                    Text("© 2025 Black Elk Mountain Medicine")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .padding(.top, 8)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showSupport) {
                SupportView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
```

## ✅ This Minimal Version:
- ✅ No duplicate declarations
- ✅ No ambiguous inits
- ✅ Uses only existing views (PaywallView, SupportView)
- ✅ Will compile immediately
- ✅ Still looks professional

## 🚀 To Add Full Features Later:

Once you've cleaned up duplicates, you can gradually add back:
1. PreferencesView
2. ExportBackupView
3. AdvancedSettingsView
4. FAQView
5. AboutView
6. TermsOfServiceView
7. PrivacyPolicyView
8. SubscriptionStatusView

**But add them ONE AT A TIME** to catch any conflicts!

## 📝 Quick Test:

1. Replace SettingsView.swift with the minimal version above
2. Press ⌘B to build
3. Should compile with 0 errors

Then you can add features incrementally.
