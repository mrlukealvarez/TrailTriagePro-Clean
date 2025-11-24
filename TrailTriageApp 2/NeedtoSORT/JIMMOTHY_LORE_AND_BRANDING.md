# 🦝 Jimmothy the Raccoon WFR - Official Lore & Branding Guide

## App Identity

### Official App Name
**TrailTriage: WFR Toolkit**

### Developer
**BlackElkMountainMedicine.com**

### App Store Information
- **Display Name:** TrailTriage: WFR Toolkit
- **Bundle Identifier:** com.blackelkmountainmedicine.trailtriage
- **Category:** Medical / Education
- **Target Audience:** Wilderness First Responders, SAR Teams, Outdoor Professionals

---

## 🦝 Meet Jimmothy the Raccoon WFR

### Character Profile
**Name:** Jimmothy  
**Full Title:** Jimmothy the Raccoon WFR (Wilderness First Responder)  
**Certification:** Wilderness First Responder (fictional but highly competent)  
**Personality:** Helpful, enthusiastic, slightly mischievous, always prepared  
**Favorite Activity:** Teaching wilderness medicine protocols and organizing medical gear  
**Known For:** His impeccable attention to detail and his "trash panda" first aid kit  

### Character Traits
- 🎒 Always carries a perfectly organized medical pack
- 📱 Early adopter of TrailTriage: WFR Toolkit
- 🏔️ Has summited every major peak in the area (usually at night)
- 🦝 Expert at finding creative solutions to backcountry medical challenges
- ⭐ Certified in WFR, CPR, and "Advanced Trash Can Navigation"

### Jimmothy's Backstory
Jimmothy discovered wilderness medicine after helping a lost hiker find their way back to camp one moonlit evening. Since then, he's been an advocate for proper documentation, SOAP notes, and always having your protocols handy. He believes that even in the backcountry, excellent patient care includes excellent record-keeping.

---

## Jimmothy in the App

### Image Assets
- **RaccoonMascotWaving** - Jimmothy welcoming users (Sign In & Subscription screens)
- **RaccoonMascotDab** - Jimmothy celebrating (Completion screen)

### Character Appearances
Jimmothy appears throughout the app at key moments:
1. **Onboarding** - Welcomes new users and guides them through setup
2. **Sign In Screen** - Encourages users to sync their notes
3. **Subscription Screen** - Shows the value of going Pro
4. **Completion Screen** - Celebrates with users after setup (with confetti!)
5. **Easter Eggs** - Randomly appears in loading states and empty states

### Voice & Messaging
When writing copy featuring Jimmothy, use this tone:
- Enthusiastic but professional
- Encouraging and supportive
- Occasionally makes gentle wilderness medicine puns
- Always emphasizes proper documentation and patient care

**Example Jimmothy Lines:**
- "Jimmothy the Raccoon WFR approves this setup!"
- "🦝 Jimmothy says: Don't forget to document those vitals!"
- "Jimmothy reminds you: A good SOAP note saves lives"
- "🦝 Certified by Jimmothy: Your documentation game is strong"

---

## Branding Standards

### App Name Usage
✅ **Correct:**
- TrailTriage: WFR Toolkit
- TrailTriage (short form acceptable)
- The TrailTriage app

❌ **Incorrect:**
- WFR TrailTriage
- Trail Triage (two words)
- TrailTriage WFR (without colon)

### Developer Name Usage
✅ **Correct:**
- BlackElkMountainMedicine.com
- Black Elk Mountain Medicine (spelled out with spaces)
- BEMM (internal abbreviation only)

❌ **Incorrect:**
- Black Elk (incomplete)
- BlackElk
- Black-Elk-Mountain-Medicine

### Taglines
**Primary:**  
"Professional SOAP note documentation for wilderness first responders"

**Secondary:**  
"Document like a pro, even in the backcountry"

**With Jimmothy:**  
"Featuring Jimmothy the Raccoon WFR - Your wilderness medicine documentation companion"

---

## Release Notes Best Practices

### Format for Release Notes
Every release note should include:

1. **Version Number & Date**
2. **Jimmothy's Take** - A fun intro from Jimmothy
3. **New Features** - What's new
4. **Improvements** - What's better
5. **Bug Fixes** - What's fixed
6. **Jimmothy's Tip** - A closing tip or reminder

### Example Release Note Template

```markdown
# TrailTriage: WFR Toolkit v1.2.0
## Released: January 15, 2026

### 🦝 Jimmothy's Welcome
"Hey there, wilderness responders! Jimmothy here with some exciting updates to your favorite backcountry documentation tool. I've been testing these new features on my night runs through the forest, and they're absolutely raccoon-approved!"

### ✨ New Features
- **Advanced Vital Signs Trending** - Jimmothy noticed you wanted better visualization
- **Offline Protocol Access** - Because even raccoons know cell service is spotty in the backcountry
- **Custom SOAP Templates** - Build notes your way (Jimmothy's got templates for his favorite scenarios)

### 🔧 Improvements
- Faster PDF generation (Jimmothy can now export in half the time)
- Better iCloud sync reliability
- Enhanced location accuracy for incident coordinates

### 🐛 Bug Fixes
- Fixed issue where vitals wouldn't save in airplane mode (Jimmothy caught this one while testing at 10,000 feet)
- Resolved crash when exporting very large notes
- Corrected time zone handling for multi-day incidents

### 🦝 Jimmothy's Pro Tip
"Remember: The best SOAP note is the one that's actually documented! Don't wait until you get back to camp—document as you go. Your future self (and the ER doc) will thank you!"

---
**Stay safe out there!**  
🦝 Jimmothy the Raccoon WFR  
BlackElkMountainMedicine.com
```

---

## Code Documentation Standards

### Header Comments
All major Swift files should include:

```swift
//
//  FileName.swift
//  TrailTriage: WFR Toolkit
//
//  Created by [Developer Name] on [Date]
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: [Brief description of what makes this code special]
//
```

### Function Documentation Example
```swift
/// Generates a SOAP note PDF with proper formatting
/// 
/// Jimmothy's Note: This function ensures your documentation
/// meets professional standards for EMS handoff
///
/// - Parameters:
///   - soapNote: The SOAP note to convert to PDF
///   - includeVitals: Whether to include vital signs graphs
/// - Returns: A shareable PDF document
/// - Throws: PDFGenerationError if rendering fails
func generateSOAPNotePDF(from soapNote: SOAPNote, includeVitals: Bool = true) throws -> PDFDocument {
    // Implementation here
}
```

---

## SOP (Standard Operating Procedures)

### Adding Jimmothy to New Features

**Step 1: Concept Review**  
Ask yourself: "Would Jimmothy approve of this feature? Does it help wilderness first responders document better?"

**Step 2: User Experience**  
Consider adding Jimmothy as a guide or mascot in:
- Empty states ("Jimmothy is waiting for your first note!")
- Error messages ("Oops! Even Jimmothy makes mistakes sometimes...")
- Success confirmations ("🦝 Jimmothy approved!")
- Loading states ("Jimmothy is gathering your protocols...")

**Step 3: Documentation**  
Every feature should have:
- Clear documentation
- A "Jimmothy's Take" explaining why it matters
- Examples showing real-world usage

**Step 4: Testing**  
Before shipping:
- [ ] Feature works in backcountry conditions (offline, low battery, poor GPS)
- [ ] Documentation is clear and helpful
- [ ] Jimmothy would be proud of the implementation
- [ ] Code follows project standards

---

## Marketing & Communications

### Social Media Voice
When posting about TrailTriage: WFR Toolkit:
- Use Jimmothy as the voice of the brand
- Share tips from Jimmothy's perspective
- Show real-world scenarios where the app helps
- Emphasize the wilderness medicine community

**Example Posts:**
- "🦝 Jimmothy here! Did you know TrailTriage: WFR Toolkit works 100% offline? Because let's be honest, there's no cell service on that alpine ridge. Download your protocols before you head out!"
- "Pro tip from Jimmothy: A well-documented SOAP note tells the story of your patient care. TrailTriage helps you capture every detail, from first contact to EMS handoff. 📝🏔️"

### App Store Description
Should always include:
- Official app name: TrailTriage: WFR Toolkit
- Developer: BlackElkMountainMedicine.com
- Mention of Jimmothy as the mascot/guide
- Focus on wilderness medicine professionals

---

## Version History with Jimmothy

### Version 1.0.0 (Initial Release)
🦝 "Jimmothy's debut! The beginning of better backcountry documentation."

### Version 1.1.0 
🦝 "Jimmothy learned to sync with iCloud and export prettier PDFs!"

### Version 1.2.0
🦝 "Jimmothy got an upgrade! New protocols, better vitals tracking, and faster performance."

### Future Versions
Every version should include Jimmothy doing something:
- Learning new skills
- Discovering features
- Helping users
- Celebrating milestones

---

## Easter Eggs (Jimmothy Edition)

### Hidden Jimmothy Features
- Tap Jimmothy 10 times during onboarding → He does a little dance
- Shake device while viewing empty state → Jimmothy appears with encouraging message
- Create 10 SOAP notes → Achievement unlocked: "Jimmothy's Apprentice"
- Use app for 30 days straight → "Jimmothy's Dedication Award"

### Fun Error Messages
- "Whoops! Jimmothy knocked over the server rack" (Server error)
- "Jimmothy can't find that note... did you leave it in your other pack?" (404 error)
- "Even Jimmothy needs a break sometimes" (Maintenance mode)

---

## Contact & Feedback

### User Feedback Format
When collecting feedback, ask:
1. What feature would make Jimmothy proud?
2. What would improve your wilderness documentation?
3. Any bugs that Jimmothy should know about?

### Support Email Template
```
Subject: TrailTriage: WFR Toolkit Support

Hello [User Name],

Thanks for reaching out! Jimmothy and the BlackElkMountainMedicine.com team are here to help.

[Response content]

Stay safe out there!
🦝 Jimmothy the Raccoon WFR & The TrailTriage Team
BlackElkMountainMedicine.com
```

---

## Legal & Copyright

### Copyright Notice
© 2025 BlackElkMountainMedicine.com. All rights reserved.

### Trademark
TrailTriage: WFR Toolkit™ and Jimmothy the Raccoon WFR™ are trademarks of BlackElkMountainMedicine.com.

### Licensing
- App: Proprietary software by BlackElkMountainMedicine.com
- Jimmothy Character: Original character owned by BlackElkMountainMedicine.com
- Medical Content: Licensed and verified wilderness medicine protocols

---

## Questions?

**Who is Jimmothy?**  
Jimmothy is the official mascot of TrailTriage: WFR Toolkit—a certified Wilderness First Responder raccoon who believes in the power of proper documentation!

**Can we use Jimmothy in marketing?**  
Yes! Jimmothy is here to help spread the word about better wilderness medicine documentation.

**What's Jimmothy's favorite feature?**  
Offline protocol access. Because even raccoons know cell service is unreliable in the backcountry.

**Does Jimmothy have social media?**  
Not yet, but he's considering it. Stay tuned!

---

**Remember:** Every feature, every line of code, every user interaction should make Jimmothy proud. We're building tools that help wilderness first responders provide better patient care—and that's something worth celebrating! 🦝🏔️

*Last Updated: November 13, 2025*  
*Maintained by: BlackElkMountainMedicine.com*  
*Approved by: 🦝 Jimmothy the Raccoon WFR*
