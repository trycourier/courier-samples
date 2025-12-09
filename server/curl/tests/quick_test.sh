#!/bin/bash
# Quick test script for all curl/bash samples
# This script validates syntax and structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all curl/bash samples..."
echo ""

# Run the test script
bash test_all.sh

echo ""
echo "💡 Note: These tests check syntax and structure only."
echo "   To fully test, ensure you have:"
echo "   - bash installed"
echo "   - curl installed"
echo "   - .env file configured in ../server/.env"

