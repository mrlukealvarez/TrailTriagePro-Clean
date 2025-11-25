import os

ASSETS_DIR = "../TrailTriagePro/Assets.xcassets"

def main():
    if not os.path.exists(ASSETS_DIR):
        print(f"Assets directory not found: {ASSETS_DIR}")
        return

    print(f"Scanning {ASSETS_DIR}...")
    
    count = 0
    for item in os.listdir(ASSETS_DIR):
        if item.startswith("module_") and item.endswith(".imageset"):
            dir_path = os.path.join(ASSETS_DIR, item)
            if os.path.isdir(dir_path):
                # List files in the imageset
                files = os.listdir(dir_path)
                for file in files:
                    if file == "Contents.json":
                        continue
                    if file == "page.jpg":
                        continue
                    
                    # Remove any other file
                    file_path = os.path.join(dir_path, file)
                    print(f"Removing unassigned file: {file_path}")
                    os.remove(file_path)
                    count += 1
                    
    print(f"Cleanup complete. Removed {count} files.")

if __name__ == "__main__":
    main()
