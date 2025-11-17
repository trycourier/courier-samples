#!/bin/bash
# Wrapper script to run Kotlin examples with Gradle
# Usage: ./run.sh <MainClass>
# Example: ./run.sh GenerateJwtKt

set -e

MAIN_CLASS="$1"

if [ -z "$MAIN_CLASS" ]; then
    echo "Error: Main class name required"
    echo "Usage: ./run.sh <MainClass>"
    echo "Note: Kotlin main functions are compiled to classes ending with 'Kt'"
    echo "Example: ./run.sh GenerateJwtKt"
    exit 1
fi

# Check if Gradle is installed
if ! command -v gradle &> /dev/null; then
    echo "❌ Gradle is not installed or not in PATH"
    echo ""
    echo "To install Gradle:"
    echo "  macOS (Homebrew):  brew install gradle"
    echo "  Linux (apt):       sudo apt-get install gradle"
    echo "  Or download from:  https://gradle.org/install/"
    echo ""
    echo "After installing Gradle, try running the example again."
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

# Compile
echo "📦 Building Kotlin project..."
gradle build -q --warning-mode none 2>&1 | grep -vE "WARNING|deprecated" || true

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo "🚀 Running $MAIN_CLASS..."
echo ""
# Get the classpath from Gradle
CLASSPATH=$(gradle -q printClasspath 2>/dev/null)

if [ -z "$CLASSPATH" ]; then
    echo "❌ Failed to get classpath"
    exit 1
fi

# Kotlin converts hyphens to underscores in class names
# e.g., generate-jwt.kt -> Generate_jwtKt
# Convert the class name if needed
ACTUAL_CLASS=$(echo "$MAIN_CLASS" | sed 's/-/_/g')

java -cp "$CLASSPATH" "$ACTUAL_CLASS"

