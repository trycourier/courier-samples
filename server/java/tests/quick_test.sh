#!/bin/bash
# Quick test script for all Java samples
# This script validates syntax and structure without requiring dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "🔍 Quick test of all Java samples..."
echo ""

# Check if Maven is available
if command -v mvn &> /dev/null; then
    echo "📦 Maven detected - attempting full test..."
    echo ""
    cd "$SCRIPT_DIR"
    
    # Try to compile and run with Maven
    cd "$PARENT_DIR"
    if mvn clean compile -q 2>/dev/null; then
        echo "✓ Project compiled successfully"
        echo ""
        echo "🧪 Running tests..."
        echo ""
        cd "$SCRIPT_DIR"
        CLASSPATH=$(cd "$PARENT_DIR" && mvn dependency:build-classpath -q -Dmdep.outputFile=/dev/stdout 2>/dev/null)
        if [ -n "$CLASSPATH" ]; then
            CLASSPATH="target/classes:$CLASSPATH"
            javac -cp "$CLASSPATH" TestAll.java 2>/dev/null && java -cp ".:$CLASSPATH" TestAll
        else
            echo "⚠️  Could not build classpath, falling back to simple test"
            bash "$SCRIPT_DIR/quick_test_simple.sh"
        fi
    else
        echo "⚠️  Maven compilation failed, falling back to simple test"
        bash "$SCRIPT_DIR/quick_test_simple.sh"
    fi
else
    echo "⚠️  Maven not found - running simple structure validation"
    echo ""
    bash "$SCRIPT_DIR/quick_test_simple.sh"
fi

