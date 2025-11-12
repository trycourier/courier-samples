#!/usr/bin/env python3
"""
Quick test script to validate all Python code samples.
This script checks:
1. Python syntax validity
2. Import dependencies
3. Basic structure validation
"""

import ast
import importlib.util
import sys
from pathlib import Path
from typing import List, Tuple

# Colors for output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def check_syntax(file_path: Path) -> Tuple[bool, str]:
    """Check if a Python file has valid syntax."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            source = f.read()
        ast.parse(source, filename=str(file_path))
        return True, "✓ Syntax valid"
    except SyntaxError as e:
        return False, f"✗ Syntax error: {e.msg} at line {e.lineno}"
    except Exception as e:
        return False, f"✗ Error reading file: {e}"

def check_imports(file_path: Path) -> Tuple[bool, str]:
    """Check if required imports can be resolved."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            source = f.read()
        
        tree = ast.parse(source)
        imports = []
        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                for alias in node.names:
                    imports.append(alias.name)
            elif isinstance(node, ast.ImportFrom):
                if node.module:
                    imports.append(node.module)
        
        # Check if critical imports exist
        # Note: trycourier package is imported as 'courier'
        required_imports = ['courier', 'dotenv']
        missing = []
        for imp in required_imports:
            if any(imp in i for i in imports):
                try:
                    if imp == 'courier':
                        import courier  # This comes from trycourier package
                    elif imp == 'dotenv':
                        import dotenv  # This comes from python-dotenv package
                except ImportError:
                    # Map import names to package names for error messages
                    package_name = 'trycourier' if imp == 'courier' else 'python-dotenv'
                    missing.append(package_name)
        
        if missing:
            return False, f"✗ Missing dependencies: {', '.join(missing)}"
        return True, "✓ Imports valid"
    except Exception as e:
        return False, f"✗ Error checking imports: {e}"

def check_structure(file_path: Path) -> Tuple[bool, str]:
    """Check basic structure - Courier client initialization."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            source = f.read()
        
        # Check for key patterns
        checks = []
        if 'from courier import Courier' in source or 'import courier' in source:
            checks.append("Courier import")
        if 'Courier(' in source or 'courier.Courier(' in source:
            checks.append("Courier client initialization")
        if 'load_dotenv' in source:
            checks.append("Environment loading")
        
        if len(checks) >= 2:
            return True, f"✓ Structure valid ({', '.join(checks)})"
        else:
            return False, f"✗ Missing key components: {checks}"
    except Exception as e:
        return False, f"✗ Error checking structure: {e}"

def main():
    """Main test runner."""
    # Test files are in tests/ directory, but Python samples are one level up
    script_dir = Path(__file__).parent.parent
    python_files = sorted(script_dir.glob("*.py"))
    
    # Exclude this test script and any other test files
    python_files = [f for f in python_files if f.name != "test_all.py" and not f.name.startswith("test_")]
    
    if not python_files:
        print(f"{RED}No Python files found to test{RESET}")
        return 1
    
    print(f"{BLUE}Testing {len(python_files)} Python sample files...{RESET}\n")
    
    results = []
    for file_path in python_files:
        print(f"{BLUE}Testing: {file_path.name}{RESET}")
        
        syntax_ok, syntax_msg = check_syntax(file_path)
        imports_ok, imports_msg = check_imports(file_path)
        structure_ok, structure_msg = check_structure(file_path)
        
        all_ok = syntax_ok and imports_ok and structure_ok
        
        if syntax_ok:
            print(f"  {GREEN}{syntax_msg}{RESET}")
        else:
            print(f"  {RED}{syntax_msg}{RESET}")
        
        if imports_ok:
            print(f"  {GREEN}{imports_msg}{RESET}")
        else:
            print(f"  {YELLOW}{imports_msg}{RESET} (install with: pip install -r requirements.txt)")
        
        if structure_ok:
            print(f"  {GREEN}{structure_msg}{RESET}")
        else:
            print(f"  {YELLOW}{structure_msg}{RESET}")
        
        results.append((file_path.name, all_ok))
        print()
    
    # Summary
    print(f"{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}Summary:{RESET}\n")
    
    passed = sum(1 for _, ok in results if ok)
    total = len(results)
    
    for name, ok in results:
        status = f"{GREEN}✓ PASS{RESET}" if ok else f"{YELLOW}⚠ PARTIAL{RESET}"
        print(f"  {status} - {name}")
    
    print(f"\n{BLUE}Results: {passed}/{total} files passed all checks{RESET}")
    
    if passed == total:
        print(f"{GREEN}All files are valid! ✓{RESET}")
        return 0
    else:
        print(f"{YELLOW}Some files need attention (likely missing dependencies){RESET}")
        print(f"{YELLOW}Run: pip install -r requirements.txt{RESET}")
        return 1

if __name__ == "__main__":
    sys.exit(main())

