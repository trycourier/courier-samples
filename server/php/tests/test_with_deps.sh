#!/bin/bash
# Comprehensive test script that installs dependencies and tests all PHP samples

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "📦 Installing dependencies..."

if ! command -v composer &> /dev/null; then
    echo "Error: composer is not installed. Please install it first:"
    echo "  https://getcomposer.org/download/"
    exit 1
fi

composer install --quiet --no-interaction
echo "✓ Dependencies installed"

echo ""
echo "🧪 Running tests..."
echo ""

# Run the test script from the tests directory
cd "$SCRIPT_DIR"
php test_all.php

echo ""
echo "✅ Testing complete!"

