#!/bin/bash
# Check prerequisites for running Courier examples
# This script verifies that required tools and dependencies are installed

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Checking prerequisites for Courier examples...${NC}\n"

ERRORS=0
WARNINGS=0

# Function to check if a command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        if [ -n "$2" ]; then
            VERSION=$($1 $2 2>&1 | head -1)
            echo -e "  ${BLUE}  Version: $VERSION${NC}"
        fi
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        if [ -n "$3" ]; then
            echo -e "  ${YELLOW}  $3${NC}"
        fi
        ((ERRORS++))
        return 1
    fi
}

# Function to check optional command
check_optional() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        if [ -n "$2" ]; then
            VERSION=$($1 $2 2>&1 | head -1)
            echo -e "  ${BLUE}  Version: $VERSION${NC}"
        fi
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $1 is NOT installed (optional)"
        if [ -n "$3" ]; then
            echo -e "  ${YELLOW}  $3${NC}"
        fi
        ((WARNINGS++))
        return 1
    fi
}

echo -e "${BLUE}=== Language Runtimes ===${NC}\n"

# Ruby
echo "Ruby:"
if check_command "ruby" "--version" "Install Ruby: https://www.ruby-lang.org/en/downloads/"; then
    RUBY_VERSION=$(ruby --version | cut -d' ' -f2)
    MAJOR=$(echo $RUBY_VERSION | cut -d'.' -f1)
    MINOR=$(echo $RUBY_VERSION | cut -d'.' -f2)
    if [ "$MAJOR" -lt 2 ] || ([ "$MAJOR" -eq 2 ] && [ "$MINOR" -lt 6 ]); then
        echo -e "  ${RED}  ⚠ Ruby 2.6+ required, found $RUBY_VERSION${NC}"
        ((ERRORS++))
    fi
fi
check_command "bundle" "--version" "Install bundler: gem install bundler"

# Python
echo -e "\nPython:"
check_command "python3" "--version" "Install Python: https://www.python.org/downloads/"
check_optional "pip3" "--version" "pip3 is recommended for package management"

# Node.js
echo -e "\nNode.js:"
check_command "node" "--version" "Install Node.js: https://nodejs.org/"
check_command "npm" "--version" "npm comes with Node.js"

# Go
echo -e "\nGo:"
check_optional "go" "version" "Install Go: https://golang.org/dl/"

# PHP
echo -e "\nPHP:"
check_optional "php" "--version" "Install PHP: https://www.php.net/downloads.php"
check_optional "composer" "--version" "Install Composer: https://getcomposer.org/download/"

# Java
echo -e "\nJava:"
if check_command "java" "-version" "Install Java: https://www.java.com/download/"; then
    # Check JAVA_HOME
    if [ -z "$JAVA_HOME" ]; then
        echo -e "  ${YELLOW}⚠ JAVA_HOME is not set${NC}"
        echo -e "  ${YELLOW}  On macOS, run: export JAVA_HOME=\$(/usr/libexec/java_home)${NC}"
        echo -e "  ${YELLOW}  Add to ~/.bashrc or ~/.zshrc to make permanent${NC}"
        ((WARNINGS++))
    else
        echo -e "  ${GREEN}✓ JAVA_HOME is set: $JAVA_HOME${NC}"
    fi
fi

# Kotlin
echo -e "\nKotlin:"
check_optional "kotlinc" "-version" "Install Kotlin: brew install kotlin or https://kotlinlang.org/docs/command-line.html"

# C# / .NET
echo -e "\nC# / .NET:"
if check_optional "dotnet" "--version" "Install .NET SDK: https://dotnet.microsoft.com/download"; then
    DOTNET_VERSION=$(dotnet --version)
    MAJOR=$(echo $DOTNET_VERSION | cut -d'.' -f1)
    if [ "$MAJOR" -lt 6 ]; then
        echo -e "  ${YELLOW}  ⚠ .NET SDK 6.0+ recommended, found $DOTNET_VERSION${NC}"
        ((WARNINGS++))
    fi
fi

# Curl (usually pre-installed)
echo -e "\nCurl:"
check_command "curl" "--version" "Install curl: https://curl.se/download.html"

echo -e "\n${BLUE}=== Summary ===${NC}\n"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All required prerequisites are installed!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All required prerequisites are installed!${NC}"
    echo -e "${YELLOW}⚠ $WARNINGS optional tool(s) missing (see above)${NC}"
    exit 0
else
    echo -e "${RED}✗ $ERRORS required prerequisite(s) missing${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ $WARNINGS optional tool(s) missing${NC}"
    fi
    echo -e "\n${BLUE}Please install the missing prerequisites and run this script again.${NC}"
    exit 1
fi

