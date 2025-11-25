#!/usr/bin/env python3
"""
Process Grok Analysis Output into WFRModule Structure

This script takes Grok's analysis of scanned book pages and organizes it
into the proper WFRModule data structure for TrailTriage: WFR Toolkit.

Usage:
    python process_grok_analysis.py <chapter_number> <grok_output_file>
    
Example:
    python process_grok_analysis.py 01 grok_chapter_01_analysis.json
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Any
from datetime import datetime

# Module category mapping
CATEGORY_MAP = {
    "assessment": "assessment",
    "patient assessment": "assessment",
    "environmental": "environmental",
    "environmental medicine": "environmental",
    "medical": "medical",
    "medical emergencies": "medical",
    "trauma": "trauma",
    "traumatic injuries": "trauma",
    "backcountry": "minor",
    "backcountry problems": "minor",
    "micromedics": "medical",
    "evacuation": "evacuation",
    "communication": "communication",
    "general": "general"
}

# Content block type mapping
CONTENT_TYPE_MAP = {
    "heading": "heading",
    "title": "heading",
    "subheading": "subheading",
    "subtitle": "subheading",
    "paragraph": "paragraph",
    "text": "paragraph",
    "bullet list": "bulletList",
    "bulleted list": "bulletList",
    "numbered list": "numberedList",
    "ordered list": "numberedList",
    "procedure": "procedure",
    "steps": "numberedSteps",
    "warning": "warning",
    "caution": "warning",
    "tip": "tip",
    "note": "note",
    "table": "table",
    "chart": "table",
    "definition": "definition",
    "example": "example",
    "scenario": "scenario",
    "image": "heroImage",
    "diagram": "heroImage",
    "illustration": "heroImage"
}


def determine_category(topic: str, title: str) -> str:
    """Determine module category from topic or title."""
    combined = (topic + " " + title).lower()
    
    for key, category in CATEGORY_MAP.items():
        if key in combined:
            return category
    
    return "general"


def determine_content_type(content_type: str, content: str) -> str:
    """Determine content block type."""
    content_lower = content_type.lower()
    
    for key, block_type in CONTENT_TYPE_MAP.items():
        if key in content_lower:
            return block_type
    
    # Default based on content
    if content.strip().startswith(("-", "•", "*")):
        return "bulletList"
    elif any(content.strip().startswith(f"{i}.") for i in range(1, 20)):
        return "numberedList"
    else:
        return "paragraph"


def process_grok_analysis(chapter_num: str, grok_output: Dict[str, Any]) -> Dict[str, Any]:
    """Process Grok analysis output into WFRModule structure."""
    
    # Extract module-level information
    module_title = grok_output.get("chapterTitle", f"Module {chapter_num}")
    module_topic = grok_output.get("topic", "")
    category = determine_category(module_topic, module_title)
    
    # Get page images
    page_images = grok_output.get("pageImages", [])
    page_image_names = [img.get("filename", "") for img in page_images if img.get("filename")]
    
    # Process sections
    sections = []
    raw_sections = grok_output.get("sections", [])
    
    for section_idx, raw_section in enumerate(raw_sections):
        section_title = raw_section.get("title", f"Section {section_idx + 1}")
        section_subtitle = raw_section.get("subtitle")
        
        # Process content blocks
        content_blocks = []
        raw_content = raw_section.get("content", [])
        
        for block_idx, raw_block in enumerate(raw_content):
            block_type_str = raw_block.get("type", "paragraph")
            block_content = raw_block.get("content", "")
            block_type = determine_content_type(block_type_str, block_content)
            
            # Handle metadata for tables, lists, etc.
            metadata = None
            if block_type == "table":
                metadata = json.dumps(raw_block.get("tableData", {}))
            elif block_type in ["bulletList", "numberedList"]:
                items = raw_block.get("items", [])
                if items:
                    metadata = json.dumps({"items": items})
            
            # Handle images
            block_images = raw_block.get("images", [])
            block_image_names = [img.get("filename", "") for img in block_images if img.get("filename")]
            
            content_block = {
                "type": block_type,
                "content": block_content,
                "orderIndex": block_idx + 1,
                "metadata": metadata,
                "pageImageNames": block_image_names if block_image_names else None
            }
            
            content_blocks.append(content_block)
        
        section = {
            "title": section_title,
            "subtitle": section_subtitle,
            "orderIndex": section_idx + 1,
            "content": content_blocks
        }
        
        sections.append(section)
    
    # Build module structure
    module = {
        "moduleTitle": module_title,
        "moduleSubtitle": grok_output.get("subtitle"),
        "category": category,
        "orderIndex": int(chapter_num),
        "pageImageNames": page_image_names if page_image_names else None,
        "sections": sections,
        "imageInventory": grok_output.get("imageInventory", [])
    }
    
    return module


def save_module_json(module: Dict[str, Any], output_path: Path):
    """Save module as JSON file."""
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(module, f, indent=2, ensure_ascii=False)
    print(f"✅ Saved module to {output_path}")


def main():
    if len(sys.argv) < 3:
        print("Usage: python process_grok_analysis.py <chapter_number> <grok_output_file>")
        print("Example: python process_grok_analysis.py 01 grok_chapter_01_analysis.json")
        sys.exit(1)
    
    chapter_num = sys.argv[1]
    grok_file = Path(sys.argv[2])
    
    if not grok_file.exists():
        print(f"❌ Error: File not found: {grok_file}")
        sys.exit(1)
    
    # Load Grok output
    print(f"📖 Loading Grok analysis from {grok_file}...")
    with open(grok_file, 'r', encoding='utf-8') as f:
        grok_output = json.load(f)
    
    # Process into module structure
    print(f"🔄 Processing Chapter {chapter_num}...")
    module = process_grok_analysis(chapter_num, grok_output)
    
    # Save output
    output_dir = Path("TrailTriagePro/Data/Modules")
    output_dir.mkdir(parents=True, exist_ok=True)
    output_file = output_dir / f"module_{chapter_num}.json"
    
    save_module_json(module, output_file)
    
    # Print summary
    print(f"\n📊 Module Summary:")
    print(f"   Title: {module['moduleTitle']}")
    print(f"   Category: {module['category']}")
    print(f"   Sections: {len(module['sections'])}")
    total_blocks = sum(len(s['content']) for s in module['sections'])
    print(f"   Content Blocks: {total_blocks}")
    print(f"   Page Images: {len(module['pageImageNames']) if module['pageImageNames'] else 0}")
    print(f"   Images in Inventory: {len(module.get('imageInventory', []))}")


if __name__ == "__main__":
    main()

