#!/usr/bin/env python3
"""
PaddleOCR Book Content Extraction Script
Extracts text from reference book photos and organizes by chapter/topic
"""

import os
import json
import sys
from pathlib import Path
from typing import List, Dict, Optional
import re

try:
    from paddleocr import PaddleOCR
except ImportError:
    print("ERROR: PaddleOCR not installed. Run: pip install paddlepaddle paddleocr")
    sys.exit(1)

# Initialize PaddleOCR
# Use GPU if available, otherwise CPU
# Set use_textline_orientation=True for rotated text, lang='en' for English
ocr = PaddleOCR(use_textline_orientation=True, lang='en')


def extract_text_from_image(image_path: str) -> Dict:
    """
    Extract text from a single image using PaddleOCR
    
    Returns:
        Dictionary with extracted text, bounding boxes, and structure info
    """
    if not os.path.exists(image_path):
        print(f"ERROR: Image not found: {image_path}")
        return None
    
    print(f"Processing: {os.path.basename(image_path)}")
    
    try:
        # Run OCR on image
        result = ocr.predict(image_path)
        
        if not result or not result[0]:
            print(f"  No text detected in {os.path.basename(image_path)}")
            return {
                'image_path': image_path,
                'text': '',
                'structured_text': [],
                'raw_result': []
            }
        
        # Extract text and structure
        extracted_text = []
        structured_blocks = []
        
        for line in result[0]:
            if line:
                bbox = line[0]  # Bounding box coordinates
                text_info = line[1]  # (text, confidence)
                text = text_info[0]
                confidence = text_info[1]
                
                if confidence > 0.5:  # Filter low-confidence results
                    extracted_text.append(text)
                    
                    # Calculate approximate position (top to bottom)
                    avg_y = sum([point[1] for point in bbox]) / 4
                    
                    structured_blocks.append({
                        'text': text,
                        'confidence': confidence,
                        'bbox': bbox,
                        'y_position': avg_y,
                        'is_heading': _detect_heading(text),
                        'is_list_item': _detect_list_item(text)
                    })
        
        # Sort by Y position (top to bottom)
        structured_blocks.sort(key=lambda x: x['y_position'])
        
        # Join all text
        full_text = '\n'.join(extracted_text)
        
        return {
            'image_path': image_path,
            'text': full_text,
            'structured_text': structured_blocks,
            'raw_result': result
        }
        
    except Exception as e:
        print(f"ERROR processing {image_path}: {str(e)}")
        return None


def _detect_heading(text: str) -> bool:
    """Detect if text is likely a heading"""
    # Headings are often:
    # - All caps
    # - Short (less than 50 chars)
    # - Start with Chapter, Section, etc.
    text_upper = text.upper()
    heading_patterns = [
        r'^CHAPTER\s+\d+',
        r'^SECTION\s+\d+',
        r'^\d+\.\s+[A-Z]',
        r'^[A-Z]{2,}\s+[A-Z]{2,}',  # Multiple capitalized words
    ]
    
    if len(text) < 50 and (text.isupper() or text.istitle()):
        return True
    
    for pattern in heading_patterns:
        if re.match(pattern, text.upper()):
            return True
    
    return False


def _detect_list_item(text: str) -> bool:
    """Detect if text is likely a list item"""
    list_patterns = [
        r'^[•\-\*]\s+',  # Bullet points
        r'^\d+[\.\)]\s+',  # Numbered lists
        r'^[a-z][\.\)]\s+',  # Lettered lists
    ]
    
    for pattern in list_patterns:
        if re.match(pattern, text):
            return True
    
    return False


def process_book_folder(book_folder: str, output_folder: str) -> None:
    """
    Process all images in the OldRefBook folder
    
    Args:
        book_folder: Path to folder containing book photos
        output_folder: Path to save extracted text
    """
    book_path = Path(book_folder)
    output_path = Path(output_folder)
    
    # Create output folder if it doesn't exist
    output_path.mkdir(parents=True, exist_ok=True)
    
    # Supported image formats
    image_extensions = {'.jpg', '.jpeg', '.png', '.JPG', '.JPEG', '.PNG', '.tiff', '.TIFF'}
    
    # Find all images recursively
    image_files = []
    for ext in image_extensions:
        image_files.extend(book_path.rglob(f'*{ext}'))
    
    if not image_files:
        print(f"WARNING: No images found in {book_folder}")
        return
    
    print(f"Found {len(image_files)} images to process")
    
    # Process each image
    all_extracted = []
    for img_path in sorted(image_files):
        relative_path = img_path.relative_to(book_path)
        print(f"\nProcessing: {relative_path}")
        
        result = extract_text_from_image(str(img_path))
        
        if result:
            # Save individual file extraction
            output_file = output_path / f"{img_path.stem}_extracted.json"
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            
            # Also save plain text version
            text_file = output_path / f"{img_path.stem}_extracted.txt"
            with open(text_file, 'w', encoding='utf-8') as f:
                f.write(result['text'])
            
            all_extracted.append({
                'source_file': str(relative_path),
                'extracted_data': result
            })
    
    # Save combined extraction
    combined_file = output_path / 'all_extracted_combined.json'
    with open(combined_file, 'w', encoding='utf-8') as f:
        json.dump(all_extracted, f, indent=2, ensure_ascii=False)
    
    # Create a readable combined text file
    combined_text_file = output_path / 'all_extracted_combined.txt'
    with open(combined_text_file, 'w', encoding='utf-8') as f:
        for item in all_extracted:
            f.write(f"\n{'='*80}\n")
            f.write(f"SOURCE: {item['source_file']}\n")
            f.write(f"{'='*80}\n\n")
            f.write(item['extracted_data']['text'])
            f.write("\n\n")
    
    print(f"\n✅ Extraction complete!")
    print(f"   Processed {len(image_files)} images")
    print(f"   Output saved to: {output_folder}")


def main():
    """Main entry point"""
    # Get project root (assuming script is in Scripts/ folder)
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    
    # Check multiple possible locations for photos
    possible_locations = [
        project_root / "WFR TrailTriage" / "ReferenceContent",
        project_root / "WFR TrailTriage" / "OldRefBook",
    ]
    
    book_folder = None
    for location in possible_locations:
        if location.exists():
            # Check if folder has image files
            image_files = list(location.rglob("*.jpg")) + list(location.rglob("*.jpeg")) + list(location.rglob("*.png"))
            if image_files:
                book_folder = location
                break
    
    # Default to ReferenceContent if not found
    if book_folder is None:
        book_folder = project_root / "WFR TrailTriage" / "ReferenceContent"
    
    output_folder = project_root / "WFR TrailTriage" / "OldRefBook" / "ExtractedText"
    
    print("="*80)
    print("PaddleOCR Book Content Extraction")
    print("="*80)
    print(f"Book folder: {book_folder}")
    print(f"Output folder: {output_folder}")
    print("="*80)
    
    if not book_folder.exists():
        print(f"ERROR: Book folder not found: {book_folder}")
        print("Please create the folder and add book photos.")
        sys.exit(1)
    
    process_book_folder(str(book_folder), str(output_folder))


if __name__ == "__main__":
    main()

