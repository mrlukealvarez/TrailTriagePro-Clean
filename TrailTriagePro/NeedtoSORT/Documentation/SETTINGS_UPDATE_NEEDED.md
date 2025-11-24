# Settings View Update Needed

## Add Second Certification Field

In your Settings view (wherever responder information is edited), add this field after the existing certification field:

```swift
TextField("Second Certification (optional)", text: $settings.responderCertification2)
    .textFieldStyle(.roundedBorder)
```

The `AppSettings` class already has the `responderCertification2` property set up, and the `combinedCertifications` computed property will automatically join them with a comma.

## Example Usage in Settings Form:

```swift
Section("Responder Information") {
    TextField("Name", text: $settings.responderName)
    
    TextField("Agency", text: $settings.responderAgency)
    
    TextField("ID/Rescue Number", text: $settings.responderRescueNumber)
    
    TextField("Certification (e.g., WFR)", text: $settings.responderCertification)
    
    TextField("Second Certification (e.g., CPR)", text: $settings.responderCertification2)
        .foregroundStyle(.secondary)
}
```

This will allow users to enter "WFR" in the first field and "CPR" in the second, and it will export as "WFR, CPR".
