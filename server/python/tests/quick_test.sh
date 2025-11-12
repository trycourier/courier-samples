#!/bin/bash
# Quick test script for all Python samples
# This script validates syntax and structure without requiring dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all Python samples..."
echo ""

# Run the Python test script
python3 test_all.py

echo ""
echo "💡 To fully test with dependencies, run:"
echo "   cd .."
echo "   python3 -m venv venv"
echo "   source venv/bin/activate"
echo "   pip install -r requirements.txt"
echo "   cd tests"
echo "   python3 test_all.py"

