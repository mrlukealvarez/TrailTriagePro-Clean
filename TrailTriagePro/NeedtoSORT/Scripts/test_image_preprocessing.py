#!/usr/bin/env python3
"""
Test different preprocessing techniques on a Chapter 2 image
to improve OCR results
"""

import os
import sys
from pathlib import Path
from PIL import Image, ImageEnhance, ImageFilter

try:
    from paddleocr import PaddleOCR
except ImportError:
    print("ERROR: PaddleOCR not installed")
    sys.exit(1)

def preprocess_image_basic(img_path: str, max_width: int = 2000) -> Image.Image:
    """Basic preprocessing: resize only"""
    img = Image.open(img_path)
    if img.width > max_width:
        ratio = max_width / img.width
        new_height = int(img.height * ratio)
        img = img.resize((max_width, new_height), Image.Resampling.LANCZOS)
    return img

def preprocess_image_enhanced(img_path: str, max_width: int = 2000) -> Image.Image:
    """Enhanced preprocessing: resize + contrast + sharpness"""
    img = Image.open(img_path)
    
    # Convert to RGB if needed
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    # Resize first
    if img.width > max_width:
        ratio = max_width / img.width
        new_height = int(img.height * ratio)
        img = img.resize((max_width, new_height), Image.Resampling.LANCZOS)
    
    # Enhance contrast (helps with text visibility)
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(1.5)  # Increase contrast by 50%
    
    # Enhance sharpness (helps OCR accuracy)
    enhancer = ImageEnhance.Sharpness(img)
    img = enhancer.enhance(1.2)  # Increase sharpness by 20%
    
    return img

def preprocess_image_grayscale(img_path: str, max_width: int = 2000) -> Image.Image:
    """Grayscale preprocessing: resize + grayscale + contrast"""
    img = Image.open(img_path)
    
    # Convert to RGB first if needed
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    # Resize first
    if img.width > max_width:
        ratio = max_width / img.width
        new_height = int(img.height * ratio)
        img = img.resize((max_width, new_height), Image.Resampling.LANCZOS)
    
    # Convert to grayscale (often better for OCR)
    img = img.convert('L')
    
    # Enhance contrast
    enhancer = ImageEnhance.Contrast(img)
    img = enhancer.enhance(1.8)  # Higher contrast for grayscale
    
    # Convert back to RGB for PaddleOCR
    img = img.convert('RGB')
    
    return img

def test_ocr_on_image(img: Image.Image, description: str, ocr) -> dict:
    """Test OCR on preprocessed image"""
    # Save to temp file
    temp_path = Path("/tmp/test_ocr_image.jpg")
    img.save(str(temp_path), quality=95)
    
    try:
        print(f"\n   Testing: {description}")
        print(f"   Image size: {img.size[0]}x{img.size[1]}, mode: {img.mode}")
        
        result = ocr.predict(str(temp_path))
        
        lines = []
        if result and result[0]:
            for item in result[0]:
                if isinstance(item, list) and len(item) >= 2:
                    text_info = item[1]
                    if isinstance(text_info, (list, tuple)) and len(text_info) > 0:
                        lines.append(text_info[0])
        
        print(f"   ✅ Found {len(lines)} lines")
        if lines:
            print(f"   Sample text: {lines[0][:80] if len(lines[0]) > 80 else lines[0]}")
        
        return {
            'lines': len(lines),
            'text': '\n'.join(lines[:5])  # First 5 lines as sample
        }
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return {'lines': 0, 'text': ''}
    finally:
        if temp_path.exists():
            temp_path.unlink()

# Main
script_dir = Path(__file__).parent
project_root = script_dir.parent
test_image = project_root / "WFR TrailTriage" / "OldRefBook" / "02_Chapter_Photos" / "IMG_2908.JPG"

if not test_image.exists():
    print(f"❌ Image not found: {test_image}")
    sys.exit(1)

print("="*70)
print("IMAGE PREPROCESSING TEST")
print(f"Testing: {test_image.name}")
print("="*70)

# Initialize OCR
print("\nInitializing PaddleOCR...")
ocr = PaddleOCR(lang='en', use_textline_orientation=False)
print("✅ Ready\n")

# Test different preprocessing methods
print("\n" + "="*70)
print("TESTING DIFFERENT PREPROCESSING METHODS")
print("="*70)

# 1. Basic (current method)
img_basic = preprocess_image_basic(str(test_image))
result_basic = test_ocr_on_image(img_basic, "Basic (resize only)", ocr)

# 2. Enhanced contrast + sharpness
img_enhanced = preprocess_image_enhanced(str(test_image))
result_enhanced = test_ocr_on_image(img_enhanced, "Enhanced (contrast + sharpness)", ocr)

# 3. Grayscale + high contrast
img_grayscale = preprocess_image_grayscale(str(test_image))
result_grayscale = test_ocr_on_image(img_grayscale, "Grayscale + high contrast", ocr)

# Summary
print("\n" + "="*70)
print("RESULTS SUMMARY")
print("="*70)
print(f"Basic (resize only):        {result_basic['lines']} lines")
print(f"Enhanced (contrast+sharp):  {result_enhanced['lines']} lines")
print(f"Grayscale + high contrast:  {result_grayscale['lines']} lines")
print("="*70)

# Recommend best method
results = [
    ('Basic', result_basic),
    ('Enhanced', result_enhanced),
    ('Grayscale', result_grayscale)
]
best = max(results, key=lambda x: x[1]['lines'])

if best[1]['lines'] > 0:
    print(f"\n✅ BEST METHOD: {best[0]} ({best[1]['lines']} lines found)")
    print(f"\nSample text:\n{best[1]['text']}")
else:
    print("\n⚠️  No text found with any preprocessing method")
    print("   This might be a graphics-heavy page or poor quality image")

