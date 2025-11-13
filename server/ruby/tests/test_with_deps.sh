#!/bin/bash
# Comprehensive test script that installs dependencies and tests all Ruby samples

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "📦 Installing dependencies..."

bundle install --quiet --path vendor/bundle
echo "✓ Dependencies installed"

echo ""
echo "🧪 Running tests..."
echo ""

# Run the test script from the tests directory
cd "$SCRIPT_DIR"
bundle exec ruby test_all.rb

echo ""
echo "✅ Testing complete!"

