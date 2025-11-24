#!/usr/bin/env python3
"""
Remove .md files from Xcode project's Copy Bundle Resources phase
Fixes: "Multiple commands produce" build errors
"""

import os
import re
import sys
from pathlib import Path

def find_project_file():
    """Find the .xcodeproj/project.pbxproj file"""
    current_dir = Path.cwd()
    
    # Look for .xcodeproj directories
    xcodeproj_dirs = list(current_dir.glob("*.xcodeproj"))
    
    if not xcodeproj_dirs:
        print("❌ Error: No .xcodeproj found in current directory")
        sys.exit(1)
    
    project_file = xcodeproj_dirs[0] / "project.pbxproj"
    
    if not project_file.exists():
        print(f"❌ Error: project.pbxproj not found in {xcodeproj_dirs[0]}")
        sys.exit(1)
    
    return project_file

def remove_md_files_from_resources(project_file):
    """Remove .md file references from Copy Bundle Resources phase"""
    
    print(f"📂 Reading: {project_file}")
    
    with open(project_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Pattern to match file references with .md extensions in buildFile sections
    # Example: 4B1234567890ABCD /* QUICK_REFERENCE.md in Resources */ = {isa = PBXBuildFile; fileRef = 4B0987654321EFGH /* QUICK_REFERENCE.md */; };
    
    # Find and remove complete buildFile entries for .md files
    md_build_file_pattern = r'\t\t[A-F0-9]+ /\* [^/]+\.md in Resources \*/ = \{isa = PBXBuildFile; fileRef = [A-F0-9]+ /\* [^/]+\.md \*/; \};\n'
    content = re.sub(md_build_file_pattern, '', content)
    
    # Also remove references in the files array within PBXResourcesBuildPhase
    # Example: 4B1234567890ABCD /* QUICK_REFERENCE.md in Resources */,
    md_resource_ref_pattern = r'\t\t\t\t[A-F0-9]+ /\* [^/]+\.md in Resources \*/,\n'
    content = re.sub(md_resource_ref_pattern, '', content)
    
    if content == original_content:
        print("ℹ️  No .md files found in Copy Bundle Resources phase")
        print("   The build error may be caused by:")
        print("   1. Duplicate file references in Xcode")
        print("   2. .md files still checked in Target Membership")
        print("")
        print("   Try this in Xcode:")
        print("   • Select each .md file in Project Navigator")
        print("   • Open File Inspector (⌥⌘1)")
        print("   • Uncheck 'WFR TrailTriage' under Target Membership")
        return False
    
    # Create backup
    backup_file = project_file.parent / "project.pbxproj.backup"
    with open(backup_file, 'w', encoding='utf-8') as f:
        f.write(original_content)
    print(f"💾 Backup created: {backup_file}")
    
    # Write modified content
    with open(project_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("✅ Removed .md files from Copy Bundle Resources phase")
    return True

def main():
    print("🔧 Xcode .md File Remover")
    print("=" * 50)
    
    try:
        project_file = find_project_file()
        modified = remove_md_files_from_resources(project_file)
        
        if modified:
            print("")
            print("✅ Project file updated successfully!")
            print("")
            print("Next steps:")
            print("  1. Open Xcode")
            print("  2. Press ⌘+Shift+K (Clean Build Folder)")
            print("  3. Press ⌘+B (Build)")
            print("")
            print("If the error persists, check Target Membership for each .md file")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
