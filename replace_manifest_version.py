import os
import re
import sys

def replace_versions(base_dir, new_version='1.0'):
    """
    Replace version numbers in __manifest__.py files
    using the pattern: ('version':\s')(?:\d+\.\d+\.\d+\.\d+\.\d+)(',)
    and replacement: $1{new_version}$2
    """
    pattern = re.compile(r"('version':\s')(?:\d+\.\d+\.\d+\.\d+\.\d+)(',)")
    updated_count = 0

    for root, _, files in os.walk(base_dir):
        if '__manifest__.py' in files:
            file_path = os.path.join(root, '__manifest__.py')
            with open(file_path, 'r+', encoding='utf-8') as f:
                content = f.read()
                new_content, replacements = pattern.subn(
                    rf"\g<1>{new_version}\g<2>",  # Using named groups to avoid ambiguity
                    content
                )

                if replacements > 0:
                    f.seek(0)
                    f.truncate()
                    f.write(new_content)
                    updated_count += 1
                    print(f"Updated {file_path} to version '{new_version}'")
    
    print(f"\nTotal files updated: {updated_count}")

if __name__ == "__main__":
    
    new_version = '1.0'

    if len(sys.argv) < 2:
        print("Usage: python version_updater.py <directory> [new_version]")
        print(f"Default version: {new_version}")
        sys.exit(1)
    
    target_dir = sys.argv[1]
    version = sys.argv[2] if len(sys.argv) > 2 else new_version
    
    if not os.path.isdir(target_dir):
        print(f"Error: Directory not found - {target_dir}")
        sys.exit(1)
    
    replace_versions(target_dir, version)
