#!/bin/bash
# Quick test script for all Go samples
# This script validates syntax and structure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all Go samples..."
echo ""

# Run the Go test script
go run test_all.go

echo ""
echo "💡 To fully test with dependencies, run:"
echo "   cd .."
echo "   go mod tidy"
echo "   go get"
echo "   cd tests"
echo "   go run test_all.go"

