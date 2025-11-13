#!/bin/bash
# Quick test script for all Ruby samples
# This script validates syntax and structure without requiring dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all Ruby samples..."
echo ""

# Run the Ruby test script
ruby test_all.rb

echo ""
echo "💡 To fully test with dependencies, run:"
echo "   cd .."
echo "   bundle install"
echo "   cd tests"
echo "   ruby test_all.rb"

