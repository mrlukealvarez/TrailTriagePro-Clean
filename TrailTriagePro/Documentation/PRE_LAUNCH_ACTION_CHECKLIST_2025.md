# 🚀 Pre-Launch Action Checklist
**TrailTriage v1.0**  
Last Updated: November 13, 2025

---

## ✅ Completed Today

- [x] **Medical Disclaimer Added** - Professional disclaimers in AboutView
- [x] **Haptic Feedback System** - Added HapticFeedback.swift helper
- [x] **Purchase Haptics** - Success feedback on subscription purchase
- [x] **Code Review** - Comprehensive architecture review completed

---

## 🔴 CRITICAL - Must Complete Before Submission

### Legal & Compliance
- [ ] **Privacy Policy**
  - [ ] Generate at iubenda.com ($27-50) OR termly.io (free basic)
  - [ ] Include: GPS, iCloud, StoreKit, user data handling
  - [ ] Host at: `blackelkmountainmedicine.com/privacy`
  - [ ] Update PrivacyPolicyView to show web view

- [ ] **Terms of Service**
  - [ ] Generate at iubenda.com or termly.io
  - [ ] Include: Subscription terms, refund policy, disclaimers
  - [ ] Host at: `blackelkmountainmedicine.com/terms`
  - [ ] Update TermsOfServiceView to show web view

### App Store Assets
- [ ] **App Icon** (1024x1024 PNG)
  - Tool: Canva, Figma, or Fiverr designer ($25-100)
  - No transparency, no rounded corners
  - Must represent medical/wilderness theme

- [ ] **Screenshots** (Required for all device sizes)
  - [ ] iPhone 6.7" (iPhone 15 Pro Max - 1290x2796)
  - [ ] iPhone 6.5" (iPhone 11 Pro Max - 1242x2688)
  - [ ] iPhone 5.5" (iPhone 8 Plus - 1242x2208) ⚠️ Still required!
  - [ ] iPad Pro 12.9" 2nd gen (2048x2732)
  - [ ] iPad Pro 12.9" 6th gen (2048x2732)
  
  **How to capture**:
  1. Open Simulator
  2. Navigate to key screens
  3. Cmd+S to save screenshot
  4. Use https://www.appscreenshot.ai or similar to add device frames

- [ ] **App Description** (Write 4000 char max)
  ```
  Template:
  
  TrailTriage: Professional SOAP note documentation for wilderness first responders.
  
  KEY FEATURES:
  • Unlimited SOAP notes with professional templates
  • GPS location tracking for incident documentation
  • PDF export for EMS handoff
  • 80+ hours of WFR protocols (offline!)
  • Vital signs tracking with trends
  • iCloud sync across all devices
  
  PERFECT FOR:
  • Wilderness First Responders (WFR/WEMT)
  • Search and Rescue teams
  • Outdoor guides and instructors
  • Backcountry medical professionals
  
  WHY TRAILTRIAGE?
  [Your pitch here]
  
  SUBSCRIPTION:
  7-day free trial, then $2.99/month or $29.99 lifetime
  
  DISCLAIMERS:
  [Medical disclaimer]
  [HIPAA notice]
  ```

- [ ] **Keywords** (100 characters total, comma-separated)
  ```
  wilderness,medicine,wfr,soap,notes,first,responder,emergency,rescue,medical,emt,outdoor,backcountry
  ```

- [ ] **Promotional Text** (170 characters, can update anytime)
  ```
  🏔️ NEW: Professional SOAP notes + GPS tracking + offline protocols. 7-day free trial!
  ```

### Testing
- [ ] **Test on Physical Device**
  - [ ] Sign in with Apple works
  - [ ] Subscription purchase works (sandbox)
  - [ ] Restore purchases works
  - [ ] GPS location capture works
  - [ ] PDF export works
  - [ ] iCloud sync works
  - [ ] Offline mode works

- [ ] **Test Subscription Flows**
  - [ ] Free trial → Monthly subscription
  - [ ] Direct monthly purchase
  - [ ] Lifetime purchase
  - [ ] Restore purchases (with active sub)
  - [ ] Restore purchases (no sub - shows error)

- [ ] **Test Onboarding**
  - [ ] Complete onboarding start to finish
  - [ ] Skip options work (DEBUG mode)
  - [ ] Sign in with Apple (real device only)
  - [ ] Profile info saves correctly
  - [ ] Permissions requests work

### App Store Connect Setup
- [ ] **App Information**
  - [ ] Name: "TrailTriage: Wilderness Medicine"
  - [ ] Subtitle: "SOAP Notes for First Responders"
  - [ ] Category: Medical
  - [ ] Secondary Category: Education OR Lifestyle
  - [ ] Age Rating: 12+ or 17+ (medical content)

- [ ] **Review Information**
  - [ ] Demo account (if login required)
  - [ ] Contact: Your phone, email, address
  - [ ] Notes: Explain subscription, GPS usage, wilderness context
  
- [ ] **Export Compliance**
  - [ ] Does app use encryption? YES (iCloud)
  - [ ] Select: "App uses standard encryption only"
  - [ ] Select: "Exempt from export compliance"

---

## 🟡 IMPORTANT - Should Do Before Launch

### Code Improvements
- [ ] **Add Error Handling Examples**
  - [ ] "GPS Failed" → "Open Settings" button
  - [ ] "Purchase Failed" → "Retry" button
  - [ ] "iCloud Sync Failed" → Queue for retry

- [ ] **Add Success Feedback**
  - [x] Haptic feedback on purchase
  - [ ] Haptic feedback on note save
  - [ ] Haptic feedback on tab change
  - [ ] Toast notification "Note Saved" (optional)

- [ ] **Search Functionality**
  - [ ] Add search bar to NotesListView
  - [ ] Search by patient name, date, injury type
  - [ ] Consider for v1.1 if time-constrained

- [ ] **Bulk Export**
  - [ ] Export all notes as ZIP of PDFs
  - [ ] "Export & Delete" option in settings
  - [ ] Consider for v1.1 if time-constrained

### Analytics (Optional for v1.0)
- [ ] **TelemetryDeck Setup** (Recommended)
  - [ ] Sign up at telemetrydeck.com
  - [ ] Add Swift package
  - [ ] Track: Onboarding completion, subscription conversion, feature usage
  - Cost: $10-30/month (free tier available)

---

## 🟢 NICE TO HAVE - Can Wait for v1.1

### Post-Launch Features
- [ ] Annual subscription ($24.99/year - saves 30%)
- [ ] Family Sharing for lifetime purchase
- [ ] Siri Shortcuts integration
- [ ] Home screen widgets
- [ ] Lock screen widgets
- [ ] Photo attachments to notes
- [ ] Apple Watch companion app
- [ ] Deep linking support
- [ ] App Clips (lightweight version)

### Marketing & Community
- [ ] Beta testing group (TestFlight)
- [ ] Website landing page
- [ ] Social media presence (optional)
- [ ] Reddit/forum outreach (r/Bushcraft, r/preppers, etc.)
- [ ] Contact WFR training programs for endorsement

---

## 📅 Recommended Timeline

### This Week (Days 1-3)
**Goal**: Gather legal documents and assets

1. **Day 1 (Today)**
   - ✅ Code improvements (disclaimers, haptics)
   - Generate privacy policy (iubenda.com)
   - Generate terms of service
   - Host both on your website

2. **Day 2**
   - Design or commission app icon
   - Take screenshots on all device sizes
   - Add device frames to screenshots
   - Write app description

3. **Day 3**
   - Test on physical device (all features)
   - Test subscription flows thoroughly
   - Fix any discovered bugs

### Next Week (Days 4-7)
**Goal**: Submit to App Store

4. **Day 4**
   - Set up App Store Connect listing
   - Upload app icon and screenshots
   - Fill in all app information

5. **Day 5**
   - Update PrivacyPolicyView with web view to policy
   - Update TermsOfServiceView with web view to terms
   - Final testing round

6. **Day 6**
   - Create archive build
   - Upload to App Store Connect
   - Submit for review

7. **Day 7**
   - Wait for review (typically 24-48 hours)
   - Prepare marketing materials
   - Set up TestFlight for beta testing

### While Waiting for Review (Days 8-14)
- Add TelemetryDeck analytics
- Implement search in notes
- Add bulk export feature
- Create v1.1 feature roadmap
- Reach out to WFR community

---

## 🎯 Success Criteria

### Minimum Viable Product (MVP) for Launch:
✅ All core features work:
- SOAP note creation
- PDF export
- GPS location
- Offline protocols
- Subscription & restore purchases

✅ All legal requirements met:
- Privacy policy
- Terms of service
- Medical disclaimers
- HIPAA disclaimer

✅ All App Store requirements met:
- App icon
- Screenshots (5 device sizes)
- Description and keywords
- Test account (if needed)

✅ No critical bugs:
- App doesn't crash
- Subscriptions work
- Data persists correctly

### Nice to Have for Launch:
- Analytics integration
- Search functionality
- Bulk export
- Enhanced error messages

---

## 📞 Important Contacts & Resources

### Legal
- **iubenda**: https://www.iubenda.com (Privacy policy generator)
- **Termly**: https://termly.io (Free/paid policy generator)

### Design
- **Fiverr**: https://www.fiverr.com (App icon designers, $25-100)
- **Canva**: https://www.canva.com (DIY icon design)
- **Figma**: https://www.figma.com (Professional design tool)

### Screenshot Tools
- **App Screenshot**: https://www.appscreenshot.ai (Add device frames)
- **Screely**: https://www.screely.com (Free mockup generator)

### Analytics
- **TelemetryDeck**: https://telemetrydeck.com (Privacy-first analytics)
- **Firebase**: https://firebase.google.com (Free, more complex)

### Apple Resources
- **App Store Connect**: https://appstoreconnect.apple.com
- **Developer Portal**: https://developer.apple.com
- **Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **TestFlight**: Built into App Store Connect

---

## 💡 Pro Tips

1. **Don't overthink v1.0** - Ship with core features, improve based on real feedback
2. **Use TestFlight** - Get beta testers before public launch
3. **Promo codes** - Give free subscriptions to WFR instructors for testimonials
4. **Support response time** - Respond to all emails within 24 hours
5. **Monitor reviews** - Reply to all App Store reviews, especially negative ones
6. **Update regularly** - Monthly updates show App Store you're active
7. **Pricing is flexible** - You can always adjust prices, test what works
8. **Screenshot A/B testing** - Change screenshots monthly to improve conversion

---

## ✨ You've Got This!

You're in **great shape** for a first-time app launch. Your code is clean, architecture is solid, and UX is polished. The remaining tasks are mostly **administrative** (legal docs, screenshots) which are straightforward.

**Focus on these 3 things this week:**
1. Privacy Policy & Terms of Service
2. App Icon & Screenshots
3. Physical device testing

Everything else can wait or be done while waiting for App Store review.

**Questions?** Check the FIRST_TIME_APP_DESIGNER_REVIEW.md for detailed guidance on any topic.

---

**Last Updated**: November 13, 2025  
**Next Review**: After App Store submission
