#!/bin/bash
# Initialize Courier C# SDK submodule if it doesn't exist

SDK_PATH="../../courier-csharp"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SDK_FULL_PATH="$PROJECT_ROOT/server/courier-csharp"

# Check if SDK directory exists and has content
if [ ! -d "$SDK_FULL_PATH" ] || [ -z "$(ls -A "$SDK_FULL_PATH" 2>/dev/null)" ]; then
    echo "📦 Courier C# SDK submodule not found. Initializing..."
    cd "$PROJECT_ROOT"
    
    # Try to initialize submodule (try all submodules first, then specific path)
    if [ -f "$PROJECT_ROOT/.gitmodules" ]; then
        # Try to initialize all submodules first
        if git submodule update --init --recursive 2>/dev/null; then
            echo "✓ Courier C# SDK initialized successfully"
        # If that fails, try the specific path from .gitmodules
        elif grep -q "server/courier-csharp" "$PROJECT_ROOT/.gitmodules" 2>/dev/null; then
            if git submodule update --init --recursive server/courier-csharp 2>/dev/null; then
                echo "✓ Courier C# SDK initialized successfully"
            else
                echo "⚠ Warning: Could not initialize submodule automatically."
                echo "  Please run manually: git submodule update --init --recursive"
                exit 1
            fi
        else
            echo "⚠ Warning: server/courier-csharp not found in .gitmodules."
            echo "  Please clone the Courier SDK manually: git clone https://github.com/trycourier/courier-csharp.git server/courier-csharp"
            exit 1
        fi
    else
        echo "⚠ Warning: .gitmodules not found. This may not be a git repository."
        echo "  Please clone the Courier SDK manually: git clone https://github.com/trycourier/courier-csharp.git server/courier-csharp"
        exit 1
    fi
fi

