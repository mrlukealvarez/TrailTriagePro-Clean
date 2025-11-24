# 📚 Content Migration & Rebranding - Antigravity Prompt
## Using Gemini 3 + Nano Banana Pro to Recreate WFR Reference Book

**Project:** TrailTriage: WFR Toolkit  
**Developer:** BlackElkMountainMedicine.com  
**Mascot:** 🦝 Jimmothy the Raccoon WFR  
**Date:** November 22, 2025

---

## 🎯 MISSION: Recreate Legacy Reference Book in Modern Format

### Current Situation

We have **legacy reference book content** that was created under the old branding:
- **Old Brand:** Desert Mountain Medicine
- **Old Format:** Chapter-based structure
- **Old Format Name:** "SOAA'P notes" (outdated terminology)
- **Content:** 80+ hours of WFR curriculum (9 chapters, 183+ pages)

We're in the process of:
1. **Extracting content** from book photos using PaddleOCR (chapter by chapter)
2. **Processing is slow** - OCR extraction taking time (7-9 minutes per image)
3. **Needing to modernize** - Convert to new module-based structure with current branding

### Our Goal

**Transform the legacy content into a modern, branded reference system:**

**New Brand:** Black Elk Mountain Medicine  
**New Format:** Topic-based modules (WFRModule structure)  
**New Terminology:** "SOAPNote" (modern, professional)  
**New Design:** Modern SwiftUI card-based interface  
**New Features:** Location randomization, improved organization

---

## 📸 WHAT WE HAVE: Book Photos & OCR Extraction

### Source Material

**Location:** `WFR TrailTriage/OldRefBook/`

**Structure:**
```
OldRefBook/
├── 00_TableOfContents/
│   └── 2 pages
├── 01_Chapter_Photos/
│   └── 2 images (COMPLETED - Chapter 1 extracted)
├── 02_Chapter_Photos/
│   └── 11 images (IN PROGRESS - OCR running slowly)
├── 03_Chapter_Photos/
│   └── 4 images
├── 04_Chapter_Photos/
│   └── 8 images
├── 05_Chapter_Photos/
│   └── 8 images
├── 06_Chapter_Photos/
│   └── 42 images
├── 07_Chapter_Photos/
│   └── 65 images (largest chapter)
├── 08_Chapter_Photos/
│   └── 34 images
└── 09_Chapter_Photos/
    └── 11 images

Total: ~183 images
```

### OCR Extraction Status

**Current Process:**
- Using PaddleOCR Python script (`extract_single_chapter.py`)
- Processing chapter by chapter (slow but manageable)
- **Chapter 1:** ✅ Complete (2 images, text extracted successfully)
- **Chapter 2:** 🔄 In Progress (11 images, OCR taking 7-9 minutes per image)
- **Chapters 3-9:** ⏳ Pending

**Output Location:** `WFR TrailTriage/OldRefBook/ExtractedText/Chapter_XX/`

**Output Files Per Chapter:**
- Individual text files per image: `IMG_XXXX.txt`
- Individual JSON files: `IMG_XXXX_extracted.json`
- Combined text: `chapter_XX_combined.txt`
- Combined JSON: `chapter_XX_combined.json`

### OCR Challenges

**Current Issues:**
- ⏱️ **Very slow** - 7-9 minutes per image
- 📄 **Some images return 0 lines** - May be graphics-heavy pages or poor quality
- 📊 **Needs cleaning** - OCR errors, formatting issues
- 🔤 **Old terminology** - References to "SOAA'P notes", "Desert Mountain Medicine"

---

## 🎨 WHAT WE NEED: Gemini 3 + Nano Banana Pro Solution

### The Vision

Instead of waiting for slow OCR and manual processing, we want to use **Antigravity's Gemini 3 + Nano Banana Pro** to:

1. **Analyze book photos directly** (no OCR needed)
2. **Extract and understand content** (Gemini 3 vision capabilities)
3. **Generate modern UI mockups** (Nano Banana Pro)
4. **Create structured content** (organized into WFRModule format)
5. **Rebrand everything** (Desert Mountain Medicine → Black Elk Mountain Medicine)
6. **Modernize terminology** (SOAA'P → SOAPNote)

### Gemini 3 Vision Capabilities

**Gemini 3 can:**
- Read and understand images directly
- Extract text from photos (better than OCR for many cases)
- Understand context and structure
- Identify chapters, sections, headings
- Recognize medical terminology
- Understand formatting (tables, lists, procedures)

**Example Prompt for Gemini:**
```
"Analyze this book page image and extract all text content. 
Identify headings, paragraphs, procedures, warnings, and tips.
Preserve the hierarchical structure.
Convert any references to 'SOAA'P notes' to 'SOAPNote'.
Replace 'Desert Mountain Medicine' with 'Black Elk Mountain Medicine'."
```

### Nano Banana Pro for Modernization

**Nano Banana Pro can:**
- Generate modern UI mockups showing how content should be displayed
- Create visualizations of module structure
- Design card-based layouts for reference content
- Generate illustrations for procedures and concepts
- Create Jimmothy mascot illustrations for empty states and tips
- Design modern covers and title pages

**Example Prompt for Nano Banana:**
```
"Generate a high-fidelity iOS app mockup showing a modern reference module detail page. 
Style: Modern SwiftUI card-based design with rounded corners, semantic colors (blues/greens), 
SF Symbols icons. Content should show medical procedures with proper hierarchy - headings, 
procedures, warnings, tips. Professional medical aesthetic, accessible typography, 
dark mode compatible. 4K resolution, perfect text rendering."
```

---

## 🔄 CONTENT TRANSFORMATION PROCESS

### Step 1: Content Extraction (Gemini 3 Vision)

**For Each Chapter:**
1. **Analyze photos** - Gemini 3 reads all images in chapter folder
2. **Extract text** - Better accuracy than OCR, understands context
3. **Identify structure** - Headings, sections, content blocks
4. **Preserve hierarchy** - Maintains chapter → section → content organization

**Gemini 3 Prompt Template:**
```
"I need to extract and structure content from wilderness medicine book photos.

Analyze all images in: [CHAPTER_FOLDER_PATH]

For each image:
1. Extract all text content (preserve accuracy)
2. Identify content type: heading, paragraph, procedure, warning, tip, list, table
3. Preserve hierarchical structure (chapter → section → content blocks)
4. Convert branding: 'Desert Mountain Medicine' → 'Black Elk Mountain Medicine'
5. Update terminology: 'SOAA'P notes' → 'SOAPNote'
6. Identify scenarios/locations that can be randomized

Output format: Structured JSON matching WFRModule structure:
- Module title and category
- Sections with titles
- Content blocks with type and content

Please be thorough and accurate - this content will be used by wilderness first responders."
```

### Step 2: Content Organization (Gemini 3)

**Transform extracted content into WFRModule format:**

**From:** Chapter-based structure (old)  
**To:** Topic-based modules (new)

**Categorization:**
- **Patient Assessment** - ABCDE, SAMPLE, OPQRST content
- **Environmental** - Hypothermia, heat illness, altitude
- **Medical** - Cardiac, respiratory, diabetic emergencies
- **Trauma** - Fractures, wounds, head injuries
- **Other** - Evacuation, communication, special situations

**Gemini 3 Prompt:**
```
"Organize this extracted book content into modern topic-based modules.

Take the structured content from Chapter [X] and:
1. Identify main topics/themes
2. Categorize into: Patient Assessment, Environmental, Medical, Trauma, or Other
3. Break into logical sections
4. Format as WFRModule structure (Module → Section → ContentBlock)
5. Add appropriate ModuleCategory
6. Suggest icon names (SF Symbols)
7. Create descriptions for each module

For scenario-based content, identify locations that can be randomized to US National/State Parks.

Output: SwiftData-compatible module definitions in JSON format."
```

### Step 3: Visual Modernization (Nano Banana Pro)

**Generate UI mockups showing modern display:**

**For Each Module Type:**
1. **Generate module list mockup** - Show how modules appear in list view
2. **Generate module detail mockup** - Show how content is displayed
3. **Generate procedure visualization** - Illustrations for complex procedures
4. **Generate scenario illustrations** - Visual aids for scenarios

**Nano Banana Pro Prompt Template:**
```
"Generate a high-fidelity iOS app mockup for a wilderness medicine reference module.

Module: [MODULE_TITLE]
Category: [CATEGORY]

Design Requirements:
- Modern SwiftUI card-based layout
- Rounded 12pt corners
- Semantic colors (blues/greens for medical, reds for critical)
- SF Symbols icons
- Proper typography hierarchy
- Dark mode compatible
- Accessible (WCAG AA)

Content Structure:
- Module title and subtitle
- Category badge
- Sections with headings
- Content blocks: procedures (numbered steps), warnings (highlighted), tips (info boxes)
- Location badge for scenarios

Style: Professional medical app, clean, scannable, backcountry-ready.
4K resolution, perfect text rendering, realistic device frame."
```

### Step 4: Location Randomization (Gemini 3)

**Enhance scenarios with randomized park locations:**

**We have:** `ParkLocations.swift` utility with US National/State Parks database

**Task:** Assign random park locations to scenario-based modules

**Gemini 3 Prompt:**
```
"For each scenario-based module in the reference content:
1. Identify scenarios that mention specific locations
2. Replace with randomized US National/State Park locations
3. Ensure terrain matches scenario type (mountain, desert, forest, etc.)
4. Format as: 'Location: [Random Park Name], [State]'

Example transformations:
- Old: 'A hiker in Yosemite falls...'
- New: 'A hiker in [Random Park] falls...' (assigned from park database)

Use the park database in ParkLocations.swift to ensure appropriate terrain matching."
```

### Step 5: Branding Updates (Gemini 3)

**Systematic rebranding throughout content:**

**Replacements:**
- "Desert Mountain Medicine" → "Black Elk Mountain Medicine"
- "SOAA'P notes" → "SOAPNote"
- "SOAA'P" → "SOAP" (in context)
- Old logo references → New branding
- Update all citations and attributions

**Gemini 3 Prompt:**
```
"Review all extracted content and perform systematic rebranding:

1. Find and replace:
   - 'Desert Mountain Medicine' → 'Black Elk Mountain Medicine'
   - 'SOAA'P notes' → 'SOAPNote'
   - 'SOAA'P' → 'SOAP' (when referring to the format)
   - Old branding elements → New Black Elk Mountain Medicine branding

2. Update all:
   - Instructor attributions
   - Course references
   - Logo mentions
   - Footer text
   - Copyright notices

3. Maintain medical accuracy - don't change medical terminology or procedures.

4. Preserve all medical content exactly - only update branding and format names.

Output: Rebranded content ready for module seeding."
```

### Step 6: SwiftData Seed Data Generation (Gemini 3)

**Convert organized content into SwiftData seed code:**

**Output:** `ModuleSeedData.swift` with all modules, sections, and content blocks

**Gemini 3 Prompt:**
```
"Generate SwiftData seed data code for all WFRModules.

Take the organized module content and create Swift code that:
1. Creates WFRModule instances with proper structure
2. Creates WFRModuleSection instances
3. Creates WFRModuleContentBlock instances
4. Assigns proper categories, order indices, icons
5. Includes randomized locations for scenarios
6. Follows code standards (file headers, Jimmothy approval comments)

Output format: Complete ModuleSeedData.swift file with seedModules() function
that can be called to populate SwiftData database with all reference content.

Ensure all content is properly formatted and escaped for Swift strings."
```

---

## 🎯 COMPLETE ANTIGRAVITY WORKFLOW

### Phase 1: Fast Content Extraction

**Instead of waiting for slow OCR, use Gemini 3 Vision:**

1. **Upload chapter photos** to Antigravity
2. **Gemini 3 analyzes** - "Analyze all images in Chapter 2 folder, extract text and structure"
3. **Get structured output** - JSON format matching WFRModule structure
4. **Repeat for all chapters** - Much faster than OCR (minutes vs hours)

### Phase 2: Content Organization

1. **Gemini 3 organizes** - "Organize extracted content into topic-based modules"
2. **Get categorized modules** - Patient Assessment, Environmental, Medical, Trauma
3. **Verify structure** - Review and refine

### Phase 3: Visual Modernization

1. **Nano Banana generates mockups** - "Generate modern iOS reference module UI mockup"
2. **Review designs** - Approve mockups before coding
3. **Code to match** - Implement SwiftUI matching mockups

### Phase 4: Rebranding & Enhancement

1. **Gemini 3 rebrands** - "Update all branding: Desert Mountain Medicine → Black Elk Mountain Medicine"
2. **Location randomization** - "Assign random park locations to scenarios"
3. **Terminology updates** - "SOAA'P → SOAPNote throughout"

### Phase 5: Code Generation

1. **Gemini 3 generates seed data** - "Create ModuleSeedData.swift with all modules"
2. **Review code** - Check for errors
3. **Integrate** - Add to Xcode project

---

## 📋 SPECIFIC TASKS FOR ANTIGRAVITY AGENT

### Task 1: Extract Chapter Content (Gemini 3 Vision)

**Input:** Folder of book page photos (Chapter 2: 11 images)

**Process:**
```
"Analyze all JPG images in the Chapter 2 folder. For each image:
1. Extract all text accurately
2. Identify content structure (headings, paragraphs, procedures, warnings, tips)
3. Preserve hierarchical organization
4. Note any graphics/diagrams that need separate handling

Output: Combined structured JSON with:
- All extracted text per page
- Content type identification
- Structure preservation
- Confidence scores

This is wilderness medicine content - accuracy is critical."
```

### Task 2: Create Module Structure (Gemini 3)

**Input:** Extracted content from all chapters

**Process:**
```
"Organize all extracted book content into modern WFRModule structure.

Transform from chapter-based (9 chapters) to topic-based modules:
- Identify main topics/themes across all chapters
- Group related content
- Categorize: Patient Assessment, Environmental, Medical, Trauma, Other
- Create logical sections within modules
- Format as ContentBlocks (heading, paragraph, procedure, warning, tip, list, table)

Preserve all medical content - only reorganize structure.

Output: Complete module structure in JSON format ready for SwiftData."
```

### Task 3: Generate Modern UI Mockups (Nano Banana Pro)

**Input:** Module structure and content types

**Process:**
```
"For each module category, generate high-fidelity iOS mockups:

1. Module List View - Card-based grid showing all modules in category
2. Module Detail View - Scrollable content with proper hierarchy
3. Procedure View - Numbered steps with visual aids
4. Warning/Tip Views - Highlighted information boxes

Style: Modern SwiftUI, professional medical app, accessible, dark mode compatible.
Include SF Symbols icons, proper spacing, semantic colors.

4K resolution, perfect text rendering, realistic iOS device frame."
```

### Task 4: Rebrand All Content (Gemini 3)

**Input:** All extracted and organized content

**Process:**
```
"Perform systematic rebranding across all content:

Find and replace:
- 'Desert Mountain Medicine' → 'Black Elk Mountain Medicine'
- 'SOAA'P notes' → 'SOAPNote'
- 'SOAA'P' → 'SOAP'
- Old logo references → 'Black Elk Mountain Medicine'
- Old instructor attributions → Update to new brand

Rules:
- Only change branding and terminology
- Preserve all medical content exactly
- Maintain accuracy of procedures and protocols
- Update citations and attributions

Output: Fully rebranded content ready for app integration."
```

### Task 5: Generate SwiftData Seed Code (Gemini 3)

**Input:** Organized, rebranded module structure

**Process:**
```
"Generate complete ModuleSeedData.swift file with seedModules() function.

Requirements:
- Create WFRModule instances for all modules
- Create WFRModuleSection instances
- Create WFRModuleContentBlock instances
- Assign proper categories, order indices
- Include randomized locations for scenarios
- Follow code standards (file headers with Jimmothy approval)
- Proper Swift string escaping
- Code comments explaining content

Output: Complete, ready-to-use Swift file that seeds all reference content
into SwiftData database when called."
```

---

## 🚀 ADVANTAGES OF ANTIGRAVITY APPROACH

### vs. Current OCR Process

**Current (PaddleOCR Python Scripts):**
- ⏱️ **7-9 minutes per image** = 20+ hours for all images
- 📄 **Some images return 0 lines** - Poor quality handling
- 🔧 **Manual processing needed** - Extract → Clean → Organize → Rebrand
- 📊 **Structure lost** - Plain text, no hierarchy preserved
- 🔤 **OCR errors** - Typos, formatting issues

**With Antigravity (Gemini 3 + Nano Banana Pro):**
- ⚡ **Faster** - Gemini 3 Vision processes images quickly
- 🎯 **Better accuracy** - Understands context, not just OCR
- 🏗️ **Preserves structure** - Maintains hierarchy automatically
- 🔄 **Integrated workflow** - Extract → Organize → Modernize → Code in one flow
- 🎨 **Visual design** - Nano Banana generates UI mockups simultaneously
- 🦝 **Branded from start** - Gemini applies rebranding automatically

### Time Savings

**Current Process:**
- OCR extraction: 20+ hours
- Manual cleaning: 10+ hours
- Organization: 5+ hours
- Rebranding: 5+ hours
- UI design: 10+ hours
- **Total: 50+ hours**

**Antigravity Process:**
- Gemini 3 extraction & organization: ~2 hours
- Nano Banana mockup generation: ~1 hour
- Rebranding & enhancement: ~30 minutes
- Code generation: ~30 minutes
- **Total: ~4 hours**

**Time Saved: 46+ hours!** ⚡

---

## 📋 ANTIGRAVITY PROMPT TEMPLATE

### For Complete Content Migration

Copy this into Antigravity IDE and adjust chapter numbers as needed:

```
I need to migrate legacy wilderness medicine reference book content into a modern iOS app.

PROJECT CONTEXT:
- App: TrailTriage: WFR Toolkit
- Developer: BlackElkMountainMedicine.com
- Project ID: gen-lang-client-0212454764
- Use Nano Banana Pro for all UI mockups

SOURCE MATERIAL:
- Location: WFR TrailTriage/OldRefBook/
- Format: Chapter-based (9 chapters, ~183 page photos)
- Old Brand: Desert Mountain Medicine
- Old Format: SOAA'P notes

DESTINATION FORMAT:
- New Brand: Black Elk Mountain Medicine
- New Format: Topic-based modules (WFRModule structure)
- New Terminology: SOAPNote
- Modern SwiftUI card-based interface

PROCESS:
1. Use Gemini 3 Vision to analyze book photos in [CHAPTER_FOLDER] and extract structured content
2. Organize content into WFRModule format (Module → Section → ContentBlock)
3. Use Nano Banana Pro to generate modern UI mockups showing how content should display
4. Rebrand all content: Desert Mountain Medicine → Black Elk Mountain Medicine, SOAA'P → SOAPNote
5. Randomize scenario locations using US National/State Parks database
6. Generate ModuleSeedData.swift with complete SwiftData seed code

OUTPUT:
- Structured JSON with all modules, sections, content blocks
- Modern UI mockups (Nano Banana Pro)
- Rebranded content
- Complete SwiftData seed code file

This content will be used by wilderness first responders - accuracy and completeness are critical.
```

---

## ✅ SUCCESS CRITERIA

**Content Migration:**
- ✅ All 9 chapters extracted and structured
- ✅ Content organized into topic-based modules
- ✅ All medical content preserved accurately
- ✅ Rebranding complete throughout

**Visual Modernization:**
- ✅ Modern UI mockups generated (Nano Banana Pro)
- ✅ SwiftUI implementation matches mockups
- ✅ Professional medical aesthetic
- ✅ Accessible design (dark mode, Dynamic Type)

**Code Quality:**
- ✅ ModuleSeedData.swift complete and functional
- ✅ Follows code standards (file headers, Jimmothy approval)
- ✅ Proper Swift string escaping
- ✅ Error handling included

**Time Efficiency:**
- ✅ Complete migration in hours, not days
- ✅ No waiting for slow OCR processing
- ✅ Integrated workflow (extract → organize → modernize → code)

---

## 🦝 JIMMOTHY'S NOTE

*"Hey! Jimmothy here! 🦝 Using Antigravity's Gemini 3 + Nano Banana Pro is WAY faster than waiting for slow OCR! We can analyze those book photos directly, understand the content like a human would, and modernize everything at the same time. Plus, Nano Banana can show us exactly how beautiful the new modules will look before we even code them! Let's get this done fast so wilderness responders can have the best reference materials in their hands! 🏔️"*

—Jimmothy the Raccoon WFR

---

**This prompt is designed for Google Antigravity IDE where Gemini 3 can analyze images directly and Nano Banana Pro can generate modern UI mockups, making the content migration process much faster than traditional OCR extraction.**

*Generated: November 22, 2025*  
*For Google Antigravity IDE*  
*Black Elk Mountain Medicine*  
*Approved by: 🦝 Jimmothy the Raccoon WFR*

