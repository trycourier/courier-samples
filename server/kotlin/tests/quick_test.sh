#!/bin/bash
# Quick test script for all Kotlin samples
# This script validates syntax and structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all Kotlin samples..."
echo ""

# Run the bash test script
bash test_all.sh

echo ""
echo "💡 Note: These tests check syntax and structure only."
echo "   To fully test, ensure you have:"
echo "   - Kotlin installed"
echo "   - Java installed (for running compiled scripts)"
echo "   - .env file configured in ../server/.env"

