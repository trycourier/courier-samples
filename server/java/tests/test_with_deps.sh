#!/bin/bash
# Comprehensive test script that sets up Maven and tests all Java samples

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

echo "☕ Setting up Java project with Maven..."

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed. Please install Maven first."
    echo "   Visit: https://maven.apache.org/download.cgi"
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install Java 11 or higher first."
    exit 1
fi

echo "📦 Compiling project..."
mvn clean compile -q
echo "✓ Project compiled"

echo ""
echo "🧪 Running tests..."
echo ""

# Compile test file with classpath
CLASSPATH=$(mvn dependency:build-classpath -q -Dmdep.outputFile=/dev/stdout)
CLASSPATH="target/classes:$CLASSPATH"

cd "$SCRIPT_DIR"
javac -cp "$CLASSPATH" TestAll.java
java -cp ".:$CLASSPATH" TestAll

echo ""
echo "✅ Testing complete!"

