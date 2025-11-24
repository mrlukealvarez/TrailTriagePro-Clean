#!/usr/bin/env python3
"""
Simple test to extract text from ONE image to verify PaddleOCR works
"""

import sys
from pathlib import Path

try:
    from paddleocr import PaddleOCR
except ImportError:
    print("ERROR: PaddleOCR not installed")
    sys.exit(1)

# Initialize
print("Initializing PaddleOCR...")
ocr = PaddleOCR(use_textline_orientation=True, lang='en')
print("✅ Initialized\n")

# Get the first Chapter 1 image
script_dir = Path(__file__).parent
project_root = script_dir.parent
test_image = project_root / "WFR TrailTriage" / "OldRefBook" / "01_Chapter_Photos" / "IMG_2905.JPG"

if not test_image.exists():
    print(f"❌ Image not found: {test_image}")
    sys.exit(1)

print(f"Testing with: {test_image.name}\n")
print("Running OCR (this will take 30-90 seconds)...")

# Simple predict() call - no extra parameters
result = ocr.predict(str(test_image))

print("\n" + "="*60)
print("RESULT:")
print("="*60)

if result and result[0]:
    print(f"Found {len(result[0])} text lines\n")
    
    # Extract text
    text_lines = []
    for line in result[0]:
        if isinstance(line, list) and len(line) >= 2:
            text_info = line[1]
            if isinstance(text_info, (list, tuple)) and len(text_info) > 0:
                text_lines.append(text_info[0])
    
    full_text = "\n".join(text_lines)
    print("EXTRACTED TEXT:")
    print("-"*60)
    print(full_text[:500])  # First 500 chars
    if len(full_text) > 500:
        print(f"\n... ({len(full_text) - 500} more characters)")
    
    # Save to file
    output_file = project_root / "WFR TrailTriage" / "OldRefBook" / "ExtractedText" / "test_single_image.txt"
    output_file.parent.mkdir(parents=True, exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(full_text)
    print(f"\n✅ Full text saved to: {output_file}")
    
else:
    print("❌ No text detected")

print("="*60)



