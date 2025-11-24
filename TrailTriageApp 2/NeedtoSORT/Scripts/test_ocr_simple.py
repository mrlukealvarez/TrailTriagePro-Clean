#!/usr/bin/env python3
"""
Very simple test - just see what PaddleOCR returns
"""

from pathlib import Path
from paddleocr import PaddleOCR

# Initialize (faster without orientation)
print("Initializing PaddleOCR...")
ocr = PaddleOCR(lang='en', use_textline_orientation=False)
print("✅ Ready\n")

# Test image
img_path = Path("WFR TrailTriage/OldRefBook/01_Chapter_Photos/IMG_2905.JPG").resolve()

if not img_path.exists():
    print(f"❌ Image not found: {img_path}")
    exit(1)

print(f"Processing: {img_path.name}\n")

# Run OCR
result = ocr.predict(str(img_path))

# Print what we got
print("="*60)
print("RESULT:")
print("="*60)
print(f"Type: {type(result)}")
print(f"Length: {len(result) if result else 0}")

if result and len(result) > 0:
    print(f"\nResult[0] type: {type(result[0])}")
    print(f"Result[0] length: {len(result[0]) if hasattr(result[0], '__len__') else 'N/A'}")
    
    if len(result[0]) > 0:
        print(f"\nFirst line structure:")
        print(f"  Type: {type(result[0][0])}")
        print(f"  Value: {result[0][0]}")
        
        # Try to extract text
        print(f"\nExtracting text lines...")
        for i, line in enumerate(result[0][:5]):  # First 5 lines
            print(f"  Line {i+1}: {line}")

print("\n" + "="*60)



