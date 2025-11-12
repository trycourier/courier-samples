#!/bin/bash
# Comprehensive test script that sets up venv and tests all Python samples

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PARENT_DIR"

VENV_DIR="$PARENT_DIR/venv"

echo "🐍 Setting up Python virtual environment..."

# Create venv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi

# Activate venv
source "$VENV_DIR/bin/activate"

echo "📦 Installing dependencies..."
pip install -q -r requirements.txt
echo "✓ Dependencies installed"

echo ""
echo "🧪 Running tests..."
echo ""

# Run the test script from the tests directory
cd "$SCRIPT_DIR"
python3 test_all.py

echo ""
echo "✅ Testing complete!"
echo ""
echo "To deactivate the virtual environment, run:"
echo "  deactivate"

