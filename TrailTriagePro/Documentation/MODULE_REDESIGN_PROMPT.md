# 📚 WFR Reference Book Module Redesign - Complete Project Prompt

**Project:** TrailTriage: WFR Toolkit  
**Developer:** BlackElkMountainMedicine.com  
**Date:** November 2025  
**Purpose:** Transform scanned reference book into modern digital "book in the palm of your hand"

---

## 🎯 PROJECT OBJECTIVES

### Primary Goals

1. **Preserve Original Content Structure**
   - Maintain all 9 original chapters as "modules"
   - Keep familiar layout for readers who know the book
   - Preserve the original text content with modern updates

2. **Modernize and Update Content**
   - Update brand names and terminology (e.g., SOAA'P → SOAP Note)
   - Apply current industry-standard terminology
   - Update any outdated references while preserving core medical content

3. **Create "Book in the Palm of Your Hand" Experience**
   - Second main selling point (first is SOAP Notes feature)
   - Book-style navigation with scanned pages as background
   - Text overlay on refreshed/regenerated images
   - Familiar layout matching original book structure

4. **Image Enhancement Strategy**
   - Extract and identify all images/diagrams from scanned pages
   - Generate refreshed versions of diagrams (e.g., skeleton diagrams, anatomical illustrations)
   - Use AI-generated images that match the original design intent
   - Place text content on backgrounds with these refreshed images

---

## 📖 MODULE STRUCTURE (9 Main Topics)

The original book contains 9 chapters that will become 9 modules:

1. **Module 1:** [Topic TBD - Analyze Chapter 01]
2. **Module 2:** [Topic TBD - Analyze Chapter 02]
3. **Module 3:** [Topic TBD - Analyze Chapter 03]
4. **Module 4:** [Topic TBD - Analyze Chapter 04]
5. **Module 5:** [Topic TBD - Analyze Chapter 05]
6. **Module 6:** [Topic TBD - Analyze Chapter 06]
7. **Module 7:** [Topic TBD - Analyze Chapter 07]
8. **Module 8:** [Topic TBD - Analyze Chapter 08]
9. **Module 9:** [Topic TBD - Analyze Chapter 09]

**Expected Topics (based on WFR curriculum):**
- Patient Assessment
- Environmental Medicine
- Medical Emergencies
- Traumatic Injuries
- Backcountry Problems
- Micromedics
- Evacuation
- Communication
- General WFR Topics

---

## 🔍 CONTENT EXTRACTION PROCESS

### Step 1: Analyze Scanned Photos with Grok

For each chapter folder (`01_Chapter_Photos` through `09_Chapter_Photos`):

1. **Upload all images** from the chapter folder to Grok
2. **Request comprehensive analysis:**
   - Extract ALL text content (verify completeness - we don't trust previous OCR)
   - Identify chapter title and main topic
   - Identify all sections and subsections
   - Identify all images, diagrams, charts, tables
   - Note the purpose/type of each image (anatomical diagram, flowchart, illustration, etc.)
   - Identify any scenarios or examples
   - Note any location references (national parks, etc.)

3. **Output Format:**
   - Complete text extraction in structured format
   - List of all images with descriptions
   - Section hierarchy
   - Table of contents for the chapter

### Step 2: Content Organization

For each chapter/module:

1. **Identify Module Title and Category**
   - Determine the main topic
   - Assign appropriate `ModuleCategory` (assessment, environmental, medical, trauma, minor, evacuation, communication, general)

2. **Organize into Sections**
   - Each major section becomes a `WFRModuleSection`
   - Maintain original section titles where appropriate
   - Preserve section order

3. **Break Down into Content Blocks**
   - Headings → `heading` or `subheading`
   - Paragraphs → `paragraph`
   - Lists → `bulletList` or `numberedList`
   - Procedures → `procedure`
   - Warnings/Tips → `warning` or `tip`
   - Tables → `table` (with metadata JSON)
   - Scenarios → `scenario`
   - Definitions → `definition`
   - Examples → `example`

4. **Image Mapping**
   - For each identified image in the original:
     - Note its location (which page, which section)
     - Describe what it shows
     - Determine if it should be:
       - **Regenerated:** Create new AI-generated version (e.g., skeleton diagram, anatomical illustration)
       - **Extracted:** Use original scanned image
       - **Placeholder:** Mark for future generation with description

---

## ✏️ CONTENT UPDATES AND EDITING

### Required Updates

1. **Terminology Updates**
   - SOAA'P → SOAP Note (throughout)
   - Update any outdated brand names
   - Update any outdated medical terminology to current standards
   - Keep industry-standard terminology (don't over-modernize)

2. **Text Preservation**
   - **PRESERVE** the original text content
   - Only update where necessary (terminology, brand names)
   - Minor paraphrasing acceptable for clarity, but maintain source text integrity
   - The source text is standard to the WFR industry - respect that

3. **Location References** (Future Enhancement)
   - Note any location references (national parks, etc.)
   - These will be updated later - don't modify now
   - Just identify and flag them

### Editing Guidelines

- **Do:** Update terminology, fix brand names, improve clarity
- **Don't:** Change medical content, alter procedures, remove important information
- **Preserve:** Original structure, section organization, familiar layout

---

## 🎨 IMAGE STRATEGY

### Image Types and Handling

1. **Anatomical Diagrams** (e.g., skeleton, body systems)
   - **Action:** Generate refreshed AI version matching the original design
   - **Prompt Template:** "Generate a medical illustration of [description] matching the style and content of the original diagram. Professional medical illustration style, clear labels, educational purpose."

2. **Flowcharts and Algorithms**
   - **Action:** Generate refreshed version or extract original if clear
   - **Style:** Clean, modern, professional medical flowchart

3. **Charts and Tables**
   - **Action:** Extract as data, render as `table` content block
   - **Metadata:** Store table data as JSON in `metadata` field

4. **Illustrations and Photos**
   - **Action:** Extract original or generate placeholder
   - **Placeholder Format:** "Will be a generated photo of [description]"

5. **Background Images**
   - **Action:** Use scanned page as background
   - **Text Overlay:** Place extracted text on top of background
   - **Enhanced Version:** Eventually replace with refreshed diagram/image

### Image Generation Notes

- **If Grok can generate images:** Use Grok to create refreshed versions
- **If Grok cannot generate images:** 
  - Extract original images
  - Create placeholders: "Will be a generated photo of [description]"
  - Note in metadata for future generation

---

## 📐 DATA STRUCTURE

### WFRModule Structure

```swift
WFRModule {
    moduleTitle: String          // Chapter title (e.g., "Environmental Medicine")
    moduleSubtitle: String?       // Optional subtitle
    category: ModuleCategory      // assessment, environmental, medical, trauma, etc.
    orderIndex: Int              // 1-9 for the 9 modules
    sections: [WFRModuleSection] // All sections within this module
    pageImageNames: [String]?    // Scanned page asset names for book navigation
}
```

### WFRModuleSection Structure

```swift
WFRModuleSection {
    title: String                 // Section title
    subtitle: String?            // Optional subtitle
    orderIndex: Int              // Order within module
    content: [WFRModuleContentBlock] // All content blocks
}
```

### WFRModuleContentBlock Structure

```swift
WFRModuleContentBlock {
    type: ModuleContentBlockType  // heading, paragraph, bulletList, etc.
    content: String              // Text content
    orderIndex: Int              // Order within section
    metadata: String?            // JSON for tables, lists, etc.
    pageImageNames: [String]?    // Related scanned page images
}
```

---

## 📋 WORKFLOW FOR EACH CHAPTER

### Phase 1: Analysis (Grok)

1. Upload all images from chapter folder to Grok
2. Request complete text extraction and analysis
3. Receive structured output:
   - Complete text
   - Image inventory
   - Section structure
   - Content breakdown

### Phase 2: Organization

1. Determine module title and category
2. Create module structure
3. Organize sections
4. Break down into content blocks
5. Map images to content blocks

### Phase 3: Content Updates

1. Apply terminology updates (SOAA'P → SOAP Note, etc.)
2. Update brand names
3. Flag location references for future update
4. Preserve original medical content

### Phase 4: Image Processing

1. For each identified image:
   - Determine type (diagram, chart, illustration, etc.)
   - Decide: regenerate, extract, or placeholder
   - Create image generation prompt or extraction note
   - Map to appropriate content block

### Phase 5: Data Generation

1. Create SwiftData-compatible JSON structure
2. Generate WFRModule instances
3. Include all sections and content blocks
4. Link page images for book navigation
5. Add metadata for images (regeneration prompts, placeholders)

---

## 🎯 SUCCESS CRITERIA

### Content Completeness
- ✅ All text extracted from all 9 chapters
- ✅ No missing content (verify against original)
- ✅ All sections identified and organized
- ✅ All images identified and categorized

### Content Quality
- ✅ Original text preserved with necessary updates
- ✅ Terminology updated (SOAA'P → SOAP Note, etc.)
- ✅ Industry-standard terminology maintained
- ✅ Familiar layout preserved

### Image Strategy
- ✅ All images identified and mapped
- ✅ Regeneration prompts created for diagrams
- ✅ Placeholders created where needed
- ✅ Original images extracted where appropriate

### Data Structure
- ✅ All 9 modules created
- ✅ Proper section hierarchy
- ✅ Content blocks properly typed
- ✅ Page images linked for book navigation

---

## 📝 OUTPUT FORMAT

### For Each Module, Generate:

1. **Module Metadata**
   ```json
   {
     "moduleTitle": "Environmental Medicine",
     "moduleSubtitle": null,
     "category": "environmental",
     "orderIndex": 2,
     "pageImageNames": ["IMG_2907", "IMG_2908", ...]
   }
   ```

2. **Sections Array**
   ```json
   {
     "sections": [
       {
         "title": "Hypothermia",
         "subtitle": null,
         "orderIndex": 1,
         "content": [...]
       }
     ]
   }
   ```

3. **Content Blocks Array** (within each section)
   ```json
   {
     "content": [
       {
         "type": "heading",
         "content": "Hypothermia Overview",
         "orderIndex": 1
       },
       {
         "type": "paragraph",
         "content": "Hypothermia occurs when...",
         "orderIndex": 2
       },
       {
         "type": "heroImage",
         "content": "Temperature regulation diagram",
         "orderIndex": 3,
         "metadata": "{\"imageType\": \"diagram\", \"regenerate\": true, \"prompt\": \"Generate medical illustration of body temperature regulation...\"}"
       }
     ]
   }
   ```

4. **Image Inventory**
   ```json
   {
     "images": [
       {
         "pageImage": "IMG_2907",
         "description": "Skeleton diagram showing bone structure",
         "type": "anatomical_diagram",
         "action": "regenerate",
         "prompt": "Generate medical illustration of human skeleton...",
         "contentBlockIndex": 5
       }
     ]
   }
   ```

---

## 🚀 NEXT STEPS AFTER EXTRACTION

1. **Review and Verify**
   - Compare extracted content with original
   - Verify all text captured
   - Check image inventory completeness

2. **Generate Images** (if using Grok or other AI)
   - Use regeneration prompts to create refreshed diagrams
   - Replace placeholders with generated images
   - Store generated images in assets

3. **Implement Book Navigation**
   - Link scanned pages to modules
   - Create book-style page turning interface
   - Overlay text on page backgrounds

4. **Final Integration**
   - Import module data into SwiftData
   - Test book navigation
   - Verify all content displays correctly

---

## 📌 IMPORTANT NOTES

- **Preserve Original Structure:** The book layout is familiar to readers - maintain it
- **Complete Extraction:** We're reanalyzing because we don't trust previous OCR - be thorough
- **Industry Standards:** The source text is standard WFR content - respect it
- **Image Strategy:** Extract now, regenerate later - we need the content first
- **Location Updates:** National park references will be updated later - just flag them now
- **Book Experience:** This is "the book in the palm of your hand" - make it feel like the original

---

## 🦝 JIMMOTHY'S APPROVAL

*"This is going to be amazing! We're taking the trusted reference book that WFRs know and love, and making it available digitally with all the modern conveniences. But we're keeping what makes it familiar - the structure, the content, the way it's organized. That's the key! 🦝"*

—Jimmothy the Raccoon WFR

---

**Ready to begin analysis? Start with Chapter 01 and work through all 9 chapters systematically!**

