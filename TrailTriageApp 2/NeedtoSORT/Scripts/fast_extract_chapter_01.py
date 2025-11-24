#!/usr/bin/env python3
"""
Fast Chapter 1 extraction - resizes images first for speed
"""

import os
import json
import sys
import time
from pathlib import Path
from PIL import Image

try:
    from paddleocr import PaddleOCR
except ImportError:
    print("ERROR: PaddleOCR not installed. Run: pip install paddlepaddle paddleocr")
    sys.exit(1)

try:
    from PIL import Image
except ImportError:
    print("ERROR: Pillow not installed. Run: pip install Pillow")
    sys.exit(1)

# Initialize PaddleOCR (skip orientation detection for speed)
print("Initializing PaddleOCR (faster mode, no orientation detection)...")
ocr = PaddleOCR(lang='en', use_textline_orientation=False)
print("✅ Ready\n")

def resize_image_for_ocr(image_path: str, max_width: int = 2000) -> Path:
    """
    Resize image to max_width while maintaining aspect ratio
    This speeds up OCR significantly
    """
    img = Image.open(image_path)
    if img.width <= max_width:
        # Already small enough
        return Path(image_path)
    
    # Calculate new size
    ratio = max_width / img.width
    new_height = int(img.height * ratio)
    
    # Resize
    resized = img.resize((max_width, new_height), Image.Resampling.LANCZOS)
    
    # Save to temp file
    temp_path = Path(image_path).parent / f"temp_{Path(image_path).name}"
    resized.save(temp_path, quality=85, optimize=True)
    
    print(f"   📏 Resized from {img.width}x{img.height} to {max_width}x{new_height}")
    return temp_path

def extract_text(image_path: str, image_num: int, total: int) -> dict:
    """Extract text from image"""
    img_name = os.path.basename(image_path)
    print(f"\n📄 Image {image_num}/{total}: {img_name}")
    
    # Resize first for speed
    resized_path = resize_image_for_ocr(image_path, max_width=2000)
    is_temp = resized_path != Path(image_path)
    
    try:
        start = time.time()
        print(f"   🔍 Running OCR...")
        result = ocr.predict(str(resized_path))
        elapsed = time.time() - start
        
        # Clean up temp file
        if is_temp:
            resized_path.unlink()
        
        if not result or not result[0]:
            print(f"   ⚠️  No text found (took {elapsed:.1f}s)")
            return {'text': '', 'lines': 0}
        
        # Extract text
        lines = []
        for item in result[0]:
            if isinstance(item, list) and len(item) >= 2:
                text_info = item[1]
                if isinstance(text_info, (list, tuple)) and len(text_info) > 0:
                    lines.append(text_info[0])
        
        print(f"   ✅ Found {len(lines)} lines (took {elapsed:.1f}s)")
        return {
            'text': '\n'.join(lines),
            'lines': len(lines)
        }
        
    except Exception as e:
        if is_temp:
            resized_path.unlink()
        print(f"   ❌ Error: {e}")
        return {'text': '', 'lines': 0}

# Main
script_dir = Path(__file__).parent
project_root = script_dir.parent
chapter_folder = project_root / "WFR TrailTriage" / "OldRefBook" / "01_Chapter_Photos"
output_folder = project_root / "WFR TrailTriage" / "OldRefBook" / "ExtractedText" / "Chapter_01"
output_folder.mkdir(parents=True, exist_ok=True)

images = sorted(chapter_folder.glob("*.JPG")) + sorted(chapter_folder.glob("*.jpg"))

if not images:
    print(f"❌ No images found in {chapter_folder}")
    sys.exit(1)

print(f"Found {len(images)} images\n")
print("="*60)

all_results = []
for i, img_path in enumerate(images, 1):
    result = extract_text(str(img_path), i, len(images))
    result['image'] = img_path.name
    all_results.append(result)
    
    # Save individual file
    txt_file = output_folder / f"{img_path.stem}.txt"
    with open(txt_file, 'w', encoding='utf-8') as f:
        f.write(result['text'])

# Save combined
combined_txt = output_folder / "chapter_01_combined.txt"
with open(combined_txt, 'w', encoding='utf-8') as f:
    f.write("CHAPTER 1 - COMBINED EXTRACTION\n")
    f.write("="*60 + "\n\n")
    for r in all_results:
        f.write(f"\n{'─'*60}\n{r['image']}\n{'─'*60}\n\n")
        f.write(r['text'])
        f.write("\n\n")

print("\n" + "="*60)
print("✅ COMPLETE!")
print(f"📁 Output: {output_folder}")
print("="*60)

