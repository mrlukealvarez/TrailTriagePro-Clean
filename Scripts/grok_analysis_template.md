# Grok Analysis Template for Chapter [XX]

Use this template when asking Grok to analyze a chapter. Copy and paste this into Grok with the chapter images.

---

## Instructions for Grok

I need you to analyze these scanned pages from a Wilderness First Responder (WFR) reference book. Please provide a comprehensive analysis following this structure.

### Images Provided
[Upload all images from the chapter folder]

### Analysis Request

Please analyze these images and provide:

1. **Complete Text Extraction**
   - Extract ALL text from every page
   - Include headings, subheadings, paragraphs, lists, tables, captions
   - Preserve the exact wording - this is medical content that must be accurate
   - Note any text that is unclear or partially visible

2. **Chapter Identification**
   - Chapter title
   - Main topic/subject
   - Chapter number (if visible)

3. **Section Structure**
   - Identify all major sections
   - Section titles
   - Section subtitles (if any)
   - Order of sections

4. **Content Breakdown**
   - For each section, identify:
     - Headings and subheadings
     - Paragraphs
     - Bulleted lists
     - Numbered lists
     - Procedures/step-by-step instructions
     - Warnings or cautions
     - Tips or notes
     - Tables or charts
     - Definitions
     - Examples or scenarios
     - Any other content types

5. **Image Inventory**
   - List every image, diagram, chart, illustration on the pages
   - For each image, provide:
     - Description of what it shows
     - Type (anatomical diagram, flowchart, illustration, photo, chart, etc.)
     - Which page it appears on
     - What section it relates to
     - Purpose (educational, reference, etc.)

6. **Special Content**
   - Identify any scenarios or case studies
   - Note any location references (national parks, etc.)
   - Identify any brand names or product references
   - Note any terminology that might need updating (e.g., SOAA'P)

### Output Format

Please provide your analysis in JSON format with this structure:

```json
{
  "chapterNumber": "[number]",
  "chapterTitle": "[title]",
  "topic": "[main topic]",
  "subtitle": "[subtitle if any]",
  "pageImages": [
    {
      "filename": "IMG_XXXX.JPG",
      "pageNumber": 1,
      "description": "Page 1 of chapter"
    }
  ],
  "sections": [
    {
      "title": "Section Title",
      "subtitle": "Section Subtitle (if any)",
      "orderIndex": 1,
      "content": [
        {
          "type": "heading",
          "content": "Heading text",
          "orderIndex": 1
        },
        {
          "type": "paragraph",
          "content": "Paragraph text...",
          "orderIndex": 2
        },
        {
          "type": "bulletList",
          "content": "Main list text",
          "items": ["Item 1", "Item 2", "Item 3"],
          "orderIndex": 3
        },
        {
          "type": "table",
          "content": "Table description",
          "tableData": {
            "headers": ["Header 1", "Header 2"],
            "rows": [
              ["Row 1 Col 1", "Row 1 Col 2"],
              ["Row 2 Col 1", "Row 2 Col 2"]
            ]
          },
          "orderIndex": 4
        }
      ]
    }
  ],
  "imageInventory": [
    {
      "pageImage": "IMG_XXXX.JPG",
      "description": "Detailed description of the image",
      "type": "anatomical_diagram",
      "section": "Section Title",
      "purpose": "Shows bone structure for reference"
    }
  ],
  "specialContent": {
    "scenarios": [],
    "locationReferences": [],
    "brandNames": [],
    "terminologyUpdates": []
  }
}
```

### CRITICAL REQUIREMENTS - READ CAREFULLY

1. **COMPLETE CONTENT EXTRACTION - NO OMISSIONS**
   - Extract EVERY section, EVERY paragraph, EVERY list item
   - Do NOT use phrases like "omitted for brevity" or "additional sections follow"
   - Include ALL content from ALL pages - this is a complete extraction, not a summary
   - If you run out of space, continue in a follow-up response - but extract everything

2. **USE ACTUAL FILENAMES**
   - Look at the actual filename of each uploaded image
   - Use the EXACT filename (e.g., "IMG_2905.JPG", "IMG_2906.JPG")
   - Do NOT use generic names like "IMG_1.JPG" or "page_1.jpg"
   - Match each page's content to its actual filename

3. **CHAPTER NUMBER**
   - If the chapter number is visible on the pages, include it
   - If not visible, determine it from the folder name or image sequence
   - Do NOT use "N/A" - make your best determination

4. **COMPLETE SECTION LISTING**
   - List EVERY section from EVERY page
   - Include all subsections
   - Do not skip any topics or sections
   - If there are 25 sections, list all 25 - not just a sample

5. **FULL TEXT CONTENT**
   - For each section, extract ALL text content
   - Include complete paragraphs, not summaries
   - Include all list items, not just a sample
   - Preserve exact medical terminology

### Output Requirements

- **Complete JSON** - Include ALL sections and ALL content
- **No placeholders** - Do not say "additional sections follow" - include them all
- **Actual filenames** - Use the real image filenames you see
- **Full text** - Extract complete text, not summaries

### If Response is Too Long

If the JSON response would be too long, you may:
1. Provide the complete JSON in multiple parts
2. Or provide a complete JSON file
3. But DO NOT omit sections or use "for brevity" - we need everything

Thank you for the thorough, complete analysis!

