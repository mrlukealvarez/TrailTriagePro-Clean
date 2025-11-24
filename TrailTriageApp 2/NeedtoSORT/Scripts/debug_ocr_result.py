#!/usr/bin/env python3
"""
Debug script to see what PaddleOCR actually returns
"""

import sys
import json
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
print("Running OCR...\n")

# Get result
result = ocr.predict(str(test_image))

print("="*60)
print("RAW RESULT TYPE AND STRUCTURE:")
print("="*60)
print(f"Type of result: {type(result)}")
print(f"Is None: {result is None}")
print(f"Length: {len(result) if result else 'N/A'}\n")

if result:
    print(f"Result[0] type: {type(result[0]) if len(result) > 0 else 'N/A'}")
    if len(result) > 0:
        print(f"Result[0] length: {len(result[0]) if hasattr(result[0], '__len__') else 'N/A'}")
        if len(result[0]) > 0:
            print(f"First element type: {type(result[0][0])}")
            print(f"First element: {result[0][0]}\n")

# Try to print raw result structure (first 500 chars)
print("="*60)
print("RAW RESULT (JSON representation, truncated):")
print("="*60)
try:
    # Convert to JSON-safe format
    def make_json_safe(obj):
        if isinstance(obj, (str, int, float, bool, type(None))):
            return obj
        elif isinstance(obj, (list, tuple)):
            return [make_json_safe(item) for item in obj[:5]]  # First 5 items
        elif isinstance(obj, dict):
            return {str(k): make_json_safe(v) for k, v in list(obj.items())[:5]}
        else:
            return str(type(obj))
    
    safe_result = make_json_safe(result)
    result_json = json.dumps(safe_result, indent=2)
    print(result_json[:1000])
except Exception as e:
    print(f"Could not convert to JSON: {e}")
    print(f"String representation: {str(result)[:500]}")

print("\n" + "="*60)



