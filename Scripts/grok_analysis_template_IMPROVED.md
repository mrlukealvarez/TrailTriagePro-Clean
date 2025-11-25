# Grok Analysis Template - IMPROVED VERSION

**Use this improved version to get complete analysis with no omissions**

---

## Instructions for Grok

I need a COMPLETE analysis of these scanned pages from a Wilderness First Responder (WFR) reference book. This is Chapter [XX] from folder [XX_Chapter_Photos].

### CRITICAL: Complete Extraction Required

**DO NOT:**
- Use phrases like "omitted for brevity"
- Skip sections or summarize
- Use generic filenames
- Leave chapter number as "N/A"

**DO:**
- Extract EVERY section, EVERY paragraph, EVERY list item
- Use ACTUAL image filenames (e.g., IMG_2905.JPG, IMG_2906.JPG)
- Include ALL content from ALL pages
- Determine chapter number from context if not visible

### Images Provided

I am uploading [X] images from Chapter [XX]:
- [List actual filenames: IMG_2905.JPG, IMG_2906.JPG, etc.]

### Analysis Request

For EACH AND EVERY page, extract:

1. **ALL Text Content**
   - Every heading, subheading, paragraph
   - Every bullet point and numbered item
   - Every table cell
   - Every caption, note, warning, tip
   - Preserve exact wording - this is medical content

2. **Chapter Information**
   - Chapter number (determine from context if needed)
   - Chapter title
   - Main topic
   - Subtitle (if any)

3. **Complete Section List**
   - List EVERY section from EVERY page
   - Include section titles and subtitles
   - Maintain order as they appear
   - Do not skip any sections

4. **Full Content for Each Section**
   - Extract ALL text, not summaries
   - Include complete paragraphs
   - Include all list items (not just samples)
   - Include all tables with full data
   - Include all procedures step-by-step

5. **Image Inventory**
   - For EVERY image/diagram/chart on EVERY page:
     - Actual filename where it appears
     - Detailed description
     - Type (diagram, photo, chart, illustration, etc.)
     - Which section it relates to
     - Purpose

6. **Special Content**
   - All scenarios
   - All location references
   - All brand names
   - All terminology that might need updating

### Output Format

Provide COMPLETE JSON with ALL sections and ALL content. If the response is very long, that's expected - we need everything.

```json
{
  "chapterNumber": "[actual number - not N/A]",
  "chapterTitle": "[full title]",
  "topic": "[main topic]",
  "subtitle": "[if any]",
  "pageImages": [
    {
      "filename": "[ACTUAL filename like IMG_2905.JPG]",
      "pageNumber": 1,
      "description": "What this page contains"
    }
  ],
  "sections": [
    {
      "title": "Section Title",
      "subtitle": "",
      "orderIndex": 1,
      "content": [
        {
          "type": "heading",
          "content": "Complete heading text",
          "orderIndex": 1
        },
        {
          "type": "paragraph",
          "content": "Complete paragraph text - not a summary",
          "orderIndex": 2
        },
        {
          "type": "bulletList",
          "content": "List title",
          "items": ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"],
          "orderIndex": 3
        }
      ]
    }
    // Include ALL sections - do not omit any
  ],
  "imageInventory": [
    {
      "pageImage": "[ACTUAL filename]",
      "description": "Detailed description",
      "type": "diagram",
      "section": "Section Title",
      "purpose": "Educational purpose"
    }
  ],
  "specialContent": {
    "scenarios": ["All scenarios"],
    "locationReferences": ["All location refs"],
    "brandNames": ["All brand names"],
    "terminologyUpdates": ["All terminology notes"]
  }
}
```

### Reminder

- **Complete extraction** - We need ALL content, not a sample
- **Actual filenames** - Use the real image filenames
- **No omissions** - Include every section, every paragraph, every list item
- **Full text** - Complete text, not summaries

Thank you!

