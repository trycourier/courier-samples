#!/bin/bash
# Initialize Courier C# SDK submodule if it doesn't exist

SDK_PATH="../../courier-csharp"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SDK_FULL_PATH="$PROJECT_ROOT/courier-csharp"

# Check if SDK directory exists and has content
if [ ! -d "$SDK_FULL_PATH" ] || [ -z "$(ls -A "$SDK_FULL_PATH" 2>/dev/null)" ]; then
    echo "📦 Courier C# SDK submodule not found. Initializing..."
    cd "$PROJECT_ROOT"
    
    # Initialize and update submodules
    git submodule update --init --recursive server/courier-csharp
    
    if [ $? -eq 0 ]; then
        echo "✓ Courier C# SDK initialized successfully"
    else
        echo "⚠ Warning: Could not initialize submodule automatically."
        echo "  Please run manually: git submodule update --init --recursive"
        exit 1
    fi
fi

