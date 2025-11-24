#!/usr/bin/env python3
"""
Chapter 1 OCR Extraction Script
Processes only Chapter 1 photos (2 images) with visible progress
"""

import os
import json
import sys
import time
from pathlib import Path
from typing import Dict, List

try:
    from paddleocr import PaddleOCR
except ImportError:
    print("ERROR: PaddleOCR not installed. Run: pip install paddlepaddle paddleocr")
    sys.exit(1)

# Initialize PaddleOCR
print("Initializing PaddleOCR (this may take 10-20 seconds on first run)...")
try:
    ocr = PaddleOCR(use_textline_orientation=True, lang='en')
    print("✅ PaddleOCR initialized\n")
except Exception as e:
    print(f"❌ ERROR initializing PaddleOCR: {e}")
    sys.exit(1)


def extract_text_from_image(image_path: str, image_num: int, total_images: int) -> Dict:
    """
    Extract text from a single image using PaddleOCR
    
    Args:
        image_path: Path to the image file
        image_num: Current image number (for progress display)
        total_images: Total number of images to process
        
    Returns:
        Dictionary with extracted text and structured data
    """
    if not os.path.exists(image_path):
        print(f"❌ ERROR: Image not found: {image_path}")
        return None
    
    image_name = os.path.basename(image_path)
    print(f"📄 Processing image {image_num} of {total_images}: {image_name}")
    
    try:
        start_time = time.time()
        
        print(f"   Running OCR (this may take 30-90 seconds per image)...")
        print(f"   ⏱️  Started at {time.strftime('%H:%M:%S')}")
        
        # Use ocr.predict() - the current PaddleOCR method
        # Note: Large images may take 1-2 minutes to process
        result = ocr.predict(image_path)
        
        elapsed_time = time.time() - start_time
        print(f"   ⏱️  OCR completed in {elapsed_time:.1f} seconds")
        
        # PaddleOCR returns a list where first element is the page results
        # Each page is a list of detected text lines
        if not result or not result[0] or len(result[0]) == 0:
            print(f"   ⚠️  No text detected in {image_name}")
            return {
                'image_path': image_path,
                'image_name': image_name,
                'text': '',
                'structured_text': [],
                'line_count': 0
            }
        
        # Extract text and structure from OCR results
        # Format: [[[x1,y1], [x2,y2], [x3,y3], [x4,y4]], ('text', confidence)]
        extracted_text = []
        structured_blocks = []
        
        for line_result in result[0]:
            if line_result and len(line_result) >= 2:
                # line_result[0] is the bounding box coordinates
                # line_result[1] is a tuple: ('text', confidence)
                box = line_result[0]
                text_info = line_result[1]
                
                if isinstance(text_info, (list, tuple)) and len(text_info) >= 1:
                    text_content = text_info[0]
                    confidence = text_info[1] if len(text_info) > 1 else 0.0
                    
                    extracted_text.append(text_content)
                    structured_blocks.append({
                        'box': [list(coord) for coord in box] if box else [],
                        'text': text_content,
                        'confidence': float(confidence)
                    })
        
        full_text = "\n".join(extracted_text)
        line_count = len(extracted_text)
        
        avg_confidence = sum(b['confidence'] for b in structured_blocks) / line_count if line_count > 0 else 0.0
        print(f"   ✅ Extracted {line_count} lines of text (avg confidence: {avg_confidence:.2f})")
        
        return {
            'image_path': image_path,
            'image_name': image_name,
            'text': full_text,
            'structured_text': structured_blocks,
            'line_count': line_count
        }
        
    except Exception as e:
        print(f"   ❌ ERROR processing {image_name}: {e}")
        return None


def process_chapter_01():
    """Process all images in Chapter 1 folder"""
    
    # Get project paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    
    chapter_folder = project_root / "WFR TrailTriage" / "OldRefBook" / "01_Chapter_Photos"
    output_folder = project_root / "WFR TrailTriage" / "OldRefBook" / "ExtractedText" / "Chapter_01"
    
    print("=" * 80)
    print("CHAPTER 1 OCR EXTRACTION")
    print("=" * 80)
    print(f"Chapter folder: {chapter_folder}")
    print(f"Output folder:  {output_folder}")
    print("=" * 80)
    print()
    
    # Check if chapter folder exists
    if not chapter_folder.exists():
        print(f"❌ ERROR: Chapter folder not found: {chapter_folder}")
        sys.exit(1)
    
    # Get all image files
    image_extensions = {'.jpg', '.jpeg', '.JPG', '.JPEG', '.png', '.PNG'}
    image_files = []
    for file in sorted(chapter_folder.iterdir()):
        if file.suffix in image_extensions:
            image_files.append(file)
    
    if not image_files:
        print(f"❌ ERROR: No images found in {chapter_folder}")
        sys.exit(1)
    
    print(f"Found {len(image_files)} images to process\n")
    
    # Create output folder
    output_folder.mkdir(parents=True, exist_ok=True)
    
    # Process each image
    all_extracted = []
    successful_count = 0
    
    for idx, image_file in enumerate(image_files, start=1):
        result = extract_text_from_image(str(image_file), idx, len(image_files))
        
        if result:
            # Save individual JSON file
            json_output = output_folder / f"{image_file.stem}_extracted.json"
            with open(json_output, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            print(f"   💾 Saved JSON: {json_output.name}")
            
            # Save individual text file
            txt_output = output_folder / f"{image_file.stem}_extracted.txt"
            with open(txt_output, 'w', encoding='utf-8') as f:
                f.write(result['text'])
            print(f"   💾 Saved TXT:  {txt_output.name}")
            
            all_extracted.append(result)
            successful_count += 1
        
        print()  # Blank line between images
    
    # Save combined results
    if all_extracted:
        # Combined JSON
        combined_json = output_folder / "chapter_01_combined.json"
        with open(combined_json, 'w', encoding='utf-8') as f:
            json.dump({
                'chapter': 'Chapter 01',
                'total_images': len(image_files),
                'successful_extractions': successful_count,
                'extractions': all_extracted
            }, f, indent=2, ensure_ascii=False)
        print(f"💾 Saved combined JSON: {combined_json.name}")
        
        # Combined text file
        combined_txt = output_folder / "chapter_01_combined.txt"
        with open(combined_txt, 'w', encoding='utf-8') as f:
            f.write("=" * 80 + "\n")
            f.write("CHAPTER 1 - COMBINED EXTRACTED TEXT\n")
            f.write("=" * 80 + "\n\n")
            
            for extraction in all_extracted:
                f.write(f"\n{'─' * 80}\n")
                f.write(f"SOURCE: {extraction['image_name']}\n")
                f.write(f"LINES: {extraction['line_count']}\n")
                f.write(f"{'─' * 80}\n\n")
                f.write(extraction['text'])
                f.write("\n\n")
        
        print(f"💾 Saved combined TXT:  {combined_txt.name}")
    
    # Print summary
    print()
    print("=" * 80)
    print("EXTRACTION COMPLETE")
    print("=" * 80)
    print(f"✅ Successfully processed: {successful_count} of {len(image_files)} images")
    print(f"📁 Output location: {output_folder}")
    print()
    print("Next steps:")
    print("1. Review the extracted text files to verify OCR quality")
    print("2. Check chapter_01_combined.txt for the full chapter content")
    print("3. If everything looks good, we can process Chapter 2 next")
    print("=" * 80)


if __name__ == "__main__":
    try:
        process_chapter_01()
    except KeyboardInterrupt:
        print("\n\n⚠️  Process interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n❌ FATAL ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

