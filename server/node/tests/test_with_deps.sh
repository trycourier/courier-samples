#!/bin/bash
# Comprehensive test script that installs dependencies and tests all Node.js samples

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "📦 Installing dependencies..."

if [ ! -d "node_modules" ]; then
    npm install --silent
    echo "✓ Dependencies installed"
else
    echo "✓ Dependencies already installed"
fi

echo ""
echo "🧪 Running tests..."
echo ""

# Run the test script from the tests directory
cd "$SCRIPT_DIR"
node test_all.js

echo ""
echo "✅ Testing complete!"

