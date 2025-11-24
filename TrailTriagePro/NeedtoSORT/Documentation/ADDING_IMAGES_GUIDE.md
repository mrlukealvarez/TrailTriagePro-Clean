# Adding Images to Your WFR TrailTriage App

## Images to Add

You have two images to add to your app:

1. **Black Elk Peak photo** - The beautiful poster-style image showing the lookout tower
2. **Black Elk Mountain Medicine logo** - Your company logo (when ready)

## How to Add Images in Xcode

### Step 1: Open Assets Catalog

1. In Xcode's Project Navigator (left sidebar), look for **Assets.xcassets**
2. Click on it to open the Assets catalog

### Step 2: Add Black Elk Peak Photo

1. In the Assets catalog, right-click in the empty space
2. Select **"New Image Set"**
3. Name it exactly: `BlackElkPeak`
4. Drag your Black Elk Peak image file into one of the slots:
   - **1x** for standard resolution
   - **2x** for retina displays (recommended - most common)
   - **3x** for super retina displays

**Tip**: If you only have one image, just drag it to the **2x** slot. iOS will handle the scaling.

### Step 3: Add Your Logo (When Ready)

1. Create another new image set
2. Name it exactly: `BlackElkMountainMedicineLogo`
3. Drag your logo file into the appropriate slot(s)
4. After adding, uncomment these lines in `ReferenceBookCoverView.swift`:

```swift
// Currently commented out (around line 35):
// Image("BlackElkMountainMedicineLogo")
//     .resizable()
//     .scaledToFit()
//     .frame(width: 90, height: 90)
//     .clipShape(Circle())
```

Remove the `//` from those lines and comment out or delete the placeholder icon below it.

### Step 4: Similar Update for Title Page

If you want your logo on the title page too (around line 23 of `ReferenceBookTitlePageView.swift`), replace:

```swift
Image(systemName: "cross.case.fill")
    .font(.system(size: 50))
    .foregroundStyle(.blue)
```

With:

```swift
Image("BlackElkMountainMedicineLogo")
    .resizable()
    .scaledToFit()
    .frame(width: 80, height: 80)
```

## Where Images Are Used

### Cover Page (`ReferenceBookCoverView.swift`)
- **Logo** at the top (circular, 100x100 pt)
- **Black Elk Peak photo** in the middle (full width, 300 pt height)

### Title Page (`ReferenceBookTitlePageView.swift`)
- **Logo** at the top (optional, 80x80 pt)
- **Black Elk Peak photo** in the middle (rounded corners, 200 pt height)

## Image Specifications

For best results:

### Black Elk Peak Photo
- **Recommended size**: At least 1000px wide
- **Format**: PNG or JPEG
- **Aspect ratio**: The current image is roughly 4:5 (portrait), but landscape works too

### Logo
- **Recommended size**: At least 300x300 px (for 3x retina = 900px)
- **Format**: PNG with transparent background preferred
- **Shape**: Works best as a square or circular logo

## Testing

After adding the images:

1. Build and run the app (⌘R)
2. Navigate to the Reference tab
3. You should see:
   - Cover page with your images
   - Tap "Enter Reference Library"
   - Title page with Black Elk Peak photo and all your info
   - Tap "Continue to Reference"

## Troubleshooting

**Image doesn't appear?**
- Check the spelling: `BlackElkPeak` (exactly, case-sensitive)
- Make sure the image is in the **2x** slot at minimum
- Clean build folder: Product → Clean Build Folder (⇧⌘K)
- Rebuild the app

**Image looks stretched or cropped weird?**
- Try adjusting the `.aspectRatio(contentMode:)` in the code
- `.fill` crops to fit the frame
- `.fit` shows the whole image, may have letterboxing

## Need Help?

If you have issues adding the images or want to adjust how they display, just let me know!
