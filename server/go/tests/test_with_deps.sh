#!/bin/bash
# Comprehensive test script that installs dependencies and tests all Go samples

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "📦 Installing dependencies..."

go mod tidy
go get
echo "✓ Dependencies installed"

echo ""
echo "🧪 Running tests..."
echo ""

# Run the test script from the tests directory
cd "$SCRIPT_DIR"
go run test_all.go

echo ""
echo "✅ Testing complete!"

