#!/bin/bash
# Quick test script for all Node.js samples
# This script validates syntax and structure without requiring dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all Node.js samples..."
echo ""

# Run the Node.js test script
node test_all.js

echo ""
echo "💡 To fully test with dependencies, run:"
echo "   cd .."
echo "   npm install"
echo "   cd tests"
echo "   node test_all.js"

