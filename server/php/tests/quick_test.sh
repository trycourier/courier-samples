#!/bin/bash
# Quick test script for all PHP samples
# This script validates syntax and structure without requiring dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all PHP samples..."
echo ""

# Run the PHP test script
php test_all.php

echo ""
echo "💡 To fully test with dependencies, run:"
echo "   cd .."
echo "   composer install"
echo "   cd tests"
echo "   php test_all.php"

