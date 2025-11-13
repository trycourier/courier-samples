#!/bin/bash
# Wrapper script to run Java examples with Maven
# Usage: ./run.sh <MainClass>

set -e

MAIN_CLASS="$1"

if [ -z "$MAIN_CLASS" ]; then
    echo "Error: Main class name required"
    echo "Usage: ./run.sh <MainClass>"
    exit 1
fi

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed or not in PATH"
    echo ""
    echo "To install Maven:"
    echo "  macOS (Homebrew):  brew install maven"
    echo "  Linux (apt):       sudo apt-get install maven"
    echo "  Linux (yum):       sudo yum install maven"
    echo "  Or download from:  https://maven.apache.org/download.cgi"
    echo ""
    echo "After installing Maven, try running the example again."
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed or not in PATH"
    echo ""
    echo "Please install Java 11 or higher."
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Compile and run
echo "📦 Compiling Java project..."
mvn clean compile -q 2>&1 | grep -vE "WARNING:.*(sun.misc.Unsafe|Please consider reporting)" || true

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "❌ Compilation failed"
    exit 1
fi

echo "🚀 Running $MAIN_CLASS..."
echo ""
# Suppress warnings about deprecated sun.misc.Unsafe (from Maven/Guice dependencies)
mvn exec:java -Dexec.mainClass="$MAIN_CLASS" -q 2>&1 | grep -vE "WARNING:.*(sun.misc.Unsafe|Please consider reporting)" || true

