#!/bin/bash
# Simple quick test script for all Java samples
# This script validates file structure without requiring compilation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "🔍 Quick test of all Java samples (structure validation)..."
echo ""

# Check if Java files exist
java_files=$(find . -maxdepth 1 -name "*.java" -not -name "CourierClient.java" -not -name "EnvLoader.java" 2>/dev/null)
file_count=$(echo "$java_files" | grep -v "^$" | wc -l | tr -d ' ')

echo "Found $file_count Java sample files"
echo ""

# Check each file for basic structure
passed=0
failed=0

for file in $java_files; do
    if [ -z "$file" ]; then
        continue
    fi
    
    filename=$(basename "$file")
    echo "📄 Checking: $filename"
    
    checks_passed=0
    checks_total=0
    
    # Check for public class
    if grep -q "public class" "$file"; then
        echo "  ✓ Has public class"
        checks_passed=$((checks_passed + 1))
    else
        echo "  ✗ Missing public class"
    fi
    checks_total=$((checks_total + 1))
    
    # Check for main method
    if grep -q "public static void main" "$file"; then
        echo "  ✓ Has main method"
        checks_passed=$((checks_passed + 1))
    else
        echo "  ✗ Missing main method"
    fi
    checks_total=$((checks_total + 1))
    
    # Check for CourierClient usage
    if grep -q "CourierClient" "$file"; then
        echo "  ✓ Uses CourierClient"
        checks_passed=$((checks_passed + 1))
    else
        echo "  ⚠ Missing CourierClient usage"
    fi
    checks_total=$((checks_total + 1))
    
    # Check for EnvLoader usage
    if grep -q "EnvLoader" "$file"; then
        echo "  ✓ Uses EnvLoader"
        checks_passed=$((checks_passed + 1))
    else
        echo "  ⚠ Missing EnvLoader usage"
    fi
    checks_total=$((checks_total + 1))
    
    # Check brace balance (basic)
    open_braces=$(grep -o '{' "$file" | wc -l | tr -d ' ')
    close_braces=$(grep -o '}' "$file" | wc -l | tr -d ' ')
    if [ "$open_braces" -eq "$close_braces" ]; then
        echo "  ✓ Braces balanced"
        checks_passed=$((checks_passed + 1))
    else
        echo "  ✗ Braces unbalanced ($open_braces open, $close_braces close)"
    fi
    checks_total=$((checks_total + 1))
    
    if [ $checks_passed -eq $checks_total ]; then
        echo "  ✅ All checks passed"
        passed=$((passed + 1))
    else
        echo "  ⚠️  Some checks failed ($checks_passed/$checks_total)"
        failed=$((failed + 1))
    fi
    echo ""
done

# Summary
echo "=" | tr -d '\n' | head -c 60
echo ""
echo "Summary:"
echo ""
echo "  ✅ Passed: $passed"
echo "  ⚠️  Issues: $failed"
echo "  📊 Total:  $file_count"
echo ""

if [ $failed -eq 0 ]; then
    echo "✅ All files passed basic structure checks!"
    exit 0
else
    echo "⚠️  Some files need attention"
    echo ""
    echo "💡 For full compilation testing, install Maven and run:"
    echo "   cd $PARENT_DIR"
    echo "   mvn clean compile"
    echo "   cd tests"
    echo "   ./test_with_deps.sh"
    exit 1
fi

