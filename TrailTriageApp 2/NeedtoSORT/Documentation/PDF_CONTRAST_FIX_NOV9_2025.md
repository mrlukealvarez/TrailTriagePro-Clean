# PDF Export Contrast Fix - November 9, 2025

## Problem
When exporting SOAP notes as PDFs and viewing them, the text appeared extremely light/ghost white and was almost impossible to read. This was a color rendering issue in the PDF generation.

## Root Cause
The PDF generation code was using system colors like `UIColor.black` and `UIColor.darkGray` which can sometimes be affected by:
1. Dynamic color schemes (light/dark mode)
2. PDF viewer rendering inconsistencies
3. Color space conversion issues

## Solution
Updated `PCRFormatter.swift` to use explicit RGBA color values instead of system colors:

### Changes Made:

1. **Text Colors**: Replaced all `UIColor.black` with explicit `UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)`
2. **Gray Colors**: Replaced `UIColor.darkGray` and `UIColor.gray` with explicit RGB values
3. **Background Colors**: Added explicit white background to all PDF pages
4. **Table Elements**: Updated header and row backgrounds to use explicit RGB colors

### Specific Updates:

```swift
// Title and body text - now solid black
.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)

// Subtitle - dark gray
.foregroundColor: UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)

// Footer - medium gray
.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)

// Page background - white
context.cgContext.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
context.cgContext.fill(pageRect)

// Table header - light gray
context.setFillColor(CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0))

// Alternating rows - very light gray
context.setFillColor(CGColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0))
```

## Testing
After this fix:
- PDF exports should show clear, readable black text
- Proper contrast between text and white background
- Consistent appearance across all PDF viewers (iOS Files, Adobe, Preview, etc.)
- Works in both light and dark mode viewing

## Files Modified
- `PCRFormatter.swift` - All color definitions updated to explicit RGBA values

## Impact
- `SOAPNoteCardView.swift` - Uses PCRFormatter, automatically fixed
- `ShareMultipleNotesView.swift` - Uses PCRFormatter, automatically fixed
- All PDF exports throughout the app now have proper contrast

## Next Steps
The user mentioned two other improvements:
1. Age input - Replace separate number field and slider with single slider, allow choice between DOB (left) or age number (right)
2. Vitals overview - Already has Timeline tab with graphs, no changes needed there
