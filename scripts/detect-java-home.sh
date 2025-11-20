#!/bin/bash
# Auto-detect JAVA_HOME if not set
# This script tries multiple methods to find Java installation

if [ -n "$JAVA_HOME" ] && [ -d "$JAVA_HOME" ]; then
    echo "$JAVA_HOME"
    exit 0
fi

# Try macOS method
if [[ "$OSTYPE" == "darwin"* ]]; then
    JAVA_HOME_MAC=$(/usr/libexec/java_home 2>/dev/null)
    if [ -n "$JAVA_HOME_MAC" ] && [ -d "$JAVA_HOME_MAC" ]; then
        echo "$JAVA_HOME_MAC"
        exit 0
    fi
fi

# Try common Linux locations
if command -v java &> /dev/null; then
    JAVA_PATH=$(which java)
    # Resolve symlinks
    if [ -L "$JAVA_PATH" ]; then
        JAVA_PATH=$(readlink -f "$JAVA_PATH" 2>/dev/null || readlink "$JAVA_PATH" 2>/dev/null || echo "$JAVA_PATH")
    fi
    
    # Try to find JAVA_HOME from java path (usually in bin/java)
    if [[ "$JAVA_PATH" == *"/bin/java" ]]; then
        POSSIBLE_HOME=$(dirname "$(dirname "$JAVA_PATH")")
        if [ -d "$POSSIBLE_HOME" ] && [ -f "$POSSIBLE_HOME/bin/java" ]; then
            echo "$POSSIBLE_HOME"
            exit 0
        fi
    fi
    
    # Try common Linux locations
    for POSSIBLE_HOME in \
        "/usr/lib/jvm/default-java" \
        "/usr/lib/jvm/java-11-openjdk" \
        "/usr/lib/jvm/java-17-openjdk" \
        "/usr/lib/jvm/java-21-openjdk" \
        "/usr/lib/jvm/java-11" \
        "/usr/lib/jvm/java-17" \
        "/usr/lib/jvm/java-21" \
        "/usr/java/latest" \
        "/opt/java" \
        "$HOME/.sdkman/candidates/java/current" \
        "/Library/Java/JavaVirtualMachines"/*/Contents/Home; do
        if [ -d "$POSSIBLE_HOME" ] && [ -f "$POSSIBLE_HOME/bin/java" ]; then
            echo "$POSSIBLE_HOME"
            exit 0
        fi
    done
fi

# If nothing found, return empty (caller should handle)
exit 1

