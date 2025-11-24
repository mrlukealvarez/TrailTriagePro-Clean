# Quick Reference Guide
## TrailTriage: WFR Toolkit Development

**🦝 Jimmothy's Quick Facts**

---

## App Identity

```
Official Name:     TrailTriage: WFR Toolkit
Short Name:        TrailTriage
Developer:         BlackElkMountainMedicine.com
Mascot:            Jimmothy the Raccoon WFR
Bundle ID:         com.blackelkmountainmedicine.trailtriage
```

---

## Jimmothy Quick Facts

- **Full Name:** Jimmothy the Raccoon WFR
- **Certification:** Wilderness First Responder (WFR)
- **Favorite Feature:** Offline protocol access
- **Known For:** Excellent documentation and organization skills
- **Appears On:** Onboarding, empty states, success messages, tips
- **Asset Names:** 
  - `RaccoonMascotWaving` (Sign In & Subscription)
  - `RaccoonMascotDab` (Completion screen)

---

## File Header Template

```swift
//  FileName.swift
//  TrailTriage: WFR Toolkit
//
//  Created by [Your Name] on [Date]
//  BlackElkMountainMedicine.com
//
//  🦝 Jimmothy Approved: [Brief description]
//
```

---

## Commit Message Template

```
[Type] Brief description

Jimmothy's Note: [Why this matters]

- Detail 1
- Detail 2

Refs: #[issue]
```

**Types:** `[Feature]` `[Fix]` `[Docs]` `[Style]` `[Refactor]` `[Test]` `[Jimmothy]`

---

## Release Notes Structure

1. 🦝 **Jimmothy's Welcome** - Fun intro (2-3 sentences)
2. ✨ **New Features** - What's new
3. 🔧 **Improvements** - What's better
4. 🐛 **Bug Fixes** - What's fixed
5. 🦝 **Jimmothy's Pro Tip** - Practical advice

---

## Jimmothy Message Examples

### Empty State
```swift
Text("Jimmothy is waiting for your first note!")
```

### Success
```swift
Text("🦝 Jimmothy approved!")
```

### Loading
```swift
Text("Jimmothy is gathering your protocols...")
```

### Error Recovery
```swift
Text("Oops! Even Jimmothy makes mistakes sometimes. Let's try that again.")
```

### Tips
```swift
Text("💡 Jimmothy's Tip: Document vitals every 15 minutes")
```

---

## When to Use Jimmothy

### ✅ DO Use:
- Empty states
- Onboarding flows
- Success confirmations
- Tips and education
- Error recovery (non-critical)
- Loading states
- Achievements

### ❌ DON'T Use:
- Critical errors
- Legal/HIPAA content
- Patient data displays
- Emergency instructions

---

## Testing Requirements

**Jimmothy's Field Test Standards:**
- ✅ Works offline
- ✅ Low battery tested
- ✅ Poor GPS conditions
- ✅ Works with gloves
- ✅ Visible in sunlight
- ✅ Cold weather tested (-20°F)
- ✅ High altitude tested (10,000+ ft)

---

## Performance Targets

- **App Launch:** < 2 seconds
- **Note Creation:** < 1 second
- **PDF Generation:** < 3 seconds
- **Protocol Search:** < 0.5 seconds
- **Battery (Active):** < 10% per hour
- **Battery (Background):** < 2% per hour

*Jimmothy's Rule: "One Mississippi, two Mississippi, three Mississippi" = too slow*

---

## Branding Quick Checks

### App Name
- ✅ TrailTriage: WFR Toolkit
- ✅ TrailTriage (short form)
- ❌ WFR TrailTriage
- ❌ Trail Triage
- ❌ TrailTriage WFR

### Developer
- ✅ BlackElkMountainMedicine.com
- ✅ Black Elk Mountain Medicine
- ❌ Black Elk
- ❌ BEMM (public)

### Mascot
- ✅ Jimmothy the Raccoon WFR
- ✅ Jimmothy
- ❌ Jimmy, Jim, James, Timothy

---

## Documentation Links

- **Branding & Lore:** `JIMMOTHY_LORE_AND_BRANDING.md`
- **Release Notes:** `RELEASE_NOTES_TEMPLATE.md`
- **Code Standards:** `CODE_STANDARDS_AND_SOP.md`

---

## Pre-Commit Checklist

- [ ] Code compiles without warnings
- [ ] Tests pass
- [ ] No force unwrapping without safety
- [ ] Error handling present
- [ ] Documentation updated
- [ ] Works offline (if applicable)
- [ ] Dark mode compatible
- [ ] Accessibility labels added
- [ ] Jimmothy would approve

---

## Pre-Release Checklist

- [ ] Version number updated
- [ ] Release notes with Jimmothy
- [ ] All tests pass
- [ ] Screenshots updated
- [ ] Beta tested (10+ responders)
- [ ] Battery impact measured
- [ ] Offline functionality verified
- [ ] HIPAA compliance checked
- [ ] Privacy policy current
- [ ] Crash logs reviewed

---

## Common Code Patterns

### Empty State with Jimmothy
```swift
VStack(spacing: 16) {
    Image("RaccoonMascotWaving")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
    
    Text("No Items Yet")
        .font(.headline)
    
    Text("Jimmothy is ready to help you get started!")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    
    Button("Get Started") {
        // Action
    }
}
```

### Success Alert with Jimmothy
```swift
.alert("Success!", isPresented: $showSuccess) {
    Button("OK") { }
} message: {
    Text("🦝 Jimmothy approved!")
}
```

### Tip Banner
```swift
HStack {
    Image(systemName: "lightbulb.fill")
        .foregroundStyle(.yellow)
    
    VStack(alignment: .leading, spacing: 4) {
        Text("🦝 Jimmothy's Tip")
            .font(.caption.bold())
        
        Text("Your tip here")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
.padding()
.background(Color(.secondarySystemBackground))
.cornerRadius(12)
```

---

## Asset Names Reference

### Jimmothy Assets
- `RaccoonMascotWaving` - General use, welcoming
- `RaccoonMascotDab` - Celebration, achievements

### SF Symbols for Wilderness Medicine
- `cross.case.fill` - Medical kit
- `heart.text.square.fill` - Patient care
- `waveform.path.ecg` - Vitals
- `mappin.circle.fill` - Location
- `doc.text.fill` - Documentation
- `book.fill` - Protocols

---

## Support Contacts

### Development Issues
1. Check documentation files
2. Review code standards
3. Ask: "What would Jimmothy do?"

### Branding Questions
1. Review `JIMMOTHY_LORE_AND_BRANDING.md`
2. Confirm app name format
3. Verify Jimmothy usage guidelines

---

## Jimmothy's Wisdom

> *"Good code is like a good SOAP note—clear, complete, and helps the next person understand exactly what happened. Document your work, test thoroughly, and always ask: 'Would this help save a life in the backcountry?'"*
> 
> —🦝 Jimmothy the Raccoon WFR

---

**Last Updated:** November 13, 2025  
**Version:** 1.0  
**Maintained By:** BlackElkMountainMedicine.com  

*Pin this to your desk. Jimmothy approves! 🦝*
