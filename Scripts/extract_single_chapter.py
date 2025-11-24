#!/usr/bin/env python3
"""
Extract text from a single chapter using PaddleOCR
Usage: python3 extract_single_chapter.py <chapter_number>
Example: python3 extract_single_chapter.py 2
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
    print("ERROR: PaddleOCR not installed. Run: pip install paddlepaddle paddleocr", flush=True)
    sys.exit(1)

try:
    from PIL import Image
except ImportError:
    print("ERROR: Pillow not installed. Run: pip install Pillow", flush=True)
    sys.exit(1)

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
    
    print(f"   📏 Resized from {img.width}x{img.height} to {max_width}x{new_height}", flush=True)
    sys.stdout.flush()
    return temp_path

def extract_text(image_path: str, image_num: int, total: int, ocr) -> dict:
    """Extract text from image"""
    img_name = os.path.basename(image_path)
    print(f"\n📄 Image {image_num}/{total}: {img_name}", flush=True)
    sys.stdout.flush()
    
    # Resize first for speed
    resized_path = resize_image_for_ocr(image_path, max_width=2000)
    is_temp = resized_path != Path(image_path)
    
    try:
        start = time.time()
        print(f"   🔍 Running OCR...", flush=True)
        sys.stdout.flush()
        
        # Use predict method (same as working Chapter 1 script)
        result = ocr.predict(str(resized_path))
        elapsed = time.time() - start
        
        # Clean up temp file
        if is_temp:
            try:
                resized_path.unlink()
            except:
                pass
        
        if not result or not result[0]:
            print(f"   ⚠️  No text found (took {elapsed:.1f}s)", flush=True)
            sys.stdout.flush()
            return {'text': '', 'lines': 0, 'structured_text': []}
        
        # Extract text
        lines = []
        structured_text = []
        for item in result[0]:
            if isinstance(item, list) and len(item) >= 2:
                # Get bounding box (if available)
                box = item[0] if len(item) > 0 and isinstance(item[0], list) else []
                # Get text info
                text_info = item[1]
                if isinstance(text_info, (list, tuple)) and len(text_info) > 0:
                    text = text_info[0]
                    confidence = text_info[1] if len(text_info) > 1 else 1.0
                    lines.append(text)
                    structured_text.append({
                        'box': box,
                        'text': text,
                        'confidence': confidence
                    })
        
        print(f"   ✅ Found {len(lines)} lines (took {elapsed:.1f}s)", flush=True)
        sys.stdout.flush()
        return {
            'text': '\n'.join(lines),
            'lines': len(lines),
            'structured_text': structured_text
        }
        
    except Exception as e:
        if is_temp:
            try:
                resized_path.unlink()
            except:
                pass
        print(f"   ❌ Error: {e}", flush=True)
        import traceback
        traceback.print_exc()
        sys.stdout.flush()
        return {'text': '', 'lines': 0, 'structured_text': []}

def process_chapter(chapter_num: int):
    """Process a single chapter"""
    chapter_num_str = f"{chapter_num:02d}"
    chapter_folder_name = f"{chapter_num_str}_Chapter_Photos"
    
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    chapter_folder = project_root / "WFR TrailTriage" / "OldRefBook" / chapter_folder_name
    output_folder = project_root / "WFR TrailTriage" / "OldRefBook" / "ExtractedText" / f"Chapter_{chapter_num_str}"
    output_folder.mkdir(parents=True, exist_ok=True)
    
    # Check if chapter folder exists
    if not chapter_folder.exists():
        print(f"❌ Chapter folder not found: {chapter_folder}", flush=True)
        sys.exit(1)
    
    # Find all images
    images = sorted(chapter_folder.glob("*.JPG")) + sorted(chapter_folder.glob("*.jpg")) + sorted(chapter_folder.glob("*.jpeg")) + sorted(chapter_folder.glob("*.JPEG"))
    
    if not images:
        print(f"❌ No images found in {chapter_folder}", flush=True)
        sys.exit(1)
    
    print("\n" + "="*70, flush=True)
    print(f"CHAPTER {chapter_num} - Processing {len(images)} images", flush=True)
    print("="*70, flush=True)
    sys.stdout.flush()
    
    # Initialize PaddleOCR (skip orientation detection for speed)
    print("\nInitializing PaddleOCR (faster mode, no orientation detection)...", flush=True)
    sys.stdout.flush()
    ocr = PaddleOCR(lang='en', use_textline_orientation=False)
    print("✅ Ready\n", flush=True)
    sys.stdout.flush()
    
    all_results = []
    for i, img_path in enumerate(images, 1):
        result = extract_text(str(img_path), i, len(images), ocr)
        result['image_path'] = str(img_path)
        result['image_name'] = img_path.name
        all_results.append(result)
        
        # Save individual text file
        txt_file = output_folder / f"{img_path.stem}.txt"
        with open(txt_file, 'w', encoding='utf-8') as f:
            f.write(result['text'])
        
        # Save individual JSON file
        json_file = output_folder / f"{img_path.stem}_extracted.json"
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump({
                'image_path': str(img_path),
                'image_name': img_path.name,
                'text': result['text'],
                'structured_text': result['structured_text']
            }, f, indent=2, ensure_ascii=False)
    
    # Save combined text file
    combined_txt = output_folder / f"chapter_{chapter_num_str}_combined.txt"
    with open(combined_txt, 'w', encoding='utf-8') as f:
        f.write(f"CHAPTER {chapter_num} - COMBINED EXTRACTED TEXT\n")
        f.write("="*70 + "\n\n")
        for r in all_results:
            f.write(f"\n{'─'*70}\nSOURCE: {r['image_name']}\nLINES: {r['lines']}\n{'─'*70}\n\n")
            f.write(r['text'])
            f.write("\n\n")
    
    # Save combined JSON file
    combined_json = output_folder / f"chapter_{chapter_num_str}_combined.json"
    with open(combined_json, 'w', encoding='utf-8') as f:
        json.dump({
            'chapter': f"Chapter {chapter_num_str}",
            'total_images': len(images),
            'successful_extractions': len([r for r in all_results if r['lines'] > 0]),
            'extractions': all_results
        }, f, indent=2, ensure_ascii=False)
    
    total_lines = sum(r['lines'] for r in all_results)
    print("\n" + "="*70, flush=True)
    print(f"✅ Chapter {chapter_num} COMPLETE!", flush=True)
    print(f"   📊 {len(images)} images processed", flush=True)
    print(f"   📝 {total_lines} total lines extracted", flush=True)
    print(f"   📁 Output: {output_folder}", flush=True)
    print("="*70 + "\n", flush=True)
    sys.stdout.flush()

# Main
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 extract_single_chapter.py <chapter_number>", flush=True)
        print("Example: python3 extract_single_chapter.py 2", flush=True)
        sys.exit(1)
    
    try:
        chapter_num = int(sys.argv[1])
        if chapter_num < 1 or chapter_num > 9:
            print(f"❌ Chapter number must be between 1 and 9. Got: {chapter_num}", flush=True)
            sys.exit(1)
    except ValueError:
        print(f"❌ Invalid chapter number: {sys.argv[1]}. Must be a number.", flush=True)
        sys.exit(1)
    
    try:
        process_chapter(chapter_num)
    except KeyboardInterrupt:
        print("\n\n⚠️  Interrupted by user", flush=True)
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error processing Chapter {chapter_num:02d}: {e}", flush=True)
        import traceback
        traceback.print_exc()
        sys.exit(1)

