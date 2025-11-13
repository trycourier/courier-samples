#!/bin/bash
# Quick test script for all C# samples
# This script validates syntax and structure by building each project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🔍 Quick test of all C# samples..."
echo ""

# Check if dotnet is available
if ! command -v dotnet &> /dev/null; then
    echo "❌ Error: dotnet command not found"
    echo "   Please install .NET SDK: https://dotnet.microsoft.com/download"
    exit 1
fi

# Run the C# test script
dotnet run --project test_all/test_all.csproj

echo ""
echo "💡 To fully test with dependencies, ensure all projects have restored packages:"
echo "   cd .."
echo "   for dir in */; do cd \"\$dir\" && dotnet restore && cd ..; done"

