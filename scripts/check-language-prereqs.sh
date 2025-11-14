#!/bin/bash
# Check prerequisites for a specific language
# Usage: check-language-prereqs.sh <language>
# Language can be: ruby, python, node, go, php, java, kotlin, csharp

set -e

LANGUAGE=$1

if [ -z "$LANGUAGE" ]; then
    echo "Usage: $0 <language>" >&2
    exit 1
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

check_and_exit() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}✗ $2 is not installed${NC}" >&2
        echo -e "${YELLOW}$3${NC}" >&2
        exit 1
    fi
}

case "$LANGUAGE" in
    ruby)
        check_and_exit "ruby" "Ruby" "Install Ruby: https://www.ruby-lang.org/en/downloads/"
        check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler"
        ;;
    python)
        check_and_exit "python3" "Python 3" "Install Python: https://www.python.org/downloads/"
        ;;
    node)
        check_and_exit "node" "Node.js" "Install Node.js: https://nodejs.org/"
        check_and_exit "npm" "npm" "npm comes with Node.js"
        ;;
    go)
        check_and_exit "go" "Go" "Install Go: https://golang.org/dl/"
        ;;
    php)
        check_and_exit "php" "PHP" "Install PHP: https://www.php.net/downloads.php"
        check_and_exit "composer" "Composer" "Install Composer: https://getcomposer.org/download/"
        ;;
    java)
        check_and_exit "java" "Java" "Install Java: https://www.java.com/download/"
        if [ -z "$JAVA_HOME" ]; then
            # Try to set JAVA_HOME automatically on macOS
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # First try macOS's java_home utility
                JAVA_HOME_CANDIDATE=$(/usr/libexec/java_home 2>/dev/null || echo "")
                
                # If that fails, check for Homebrew Java installation
                if [ -z "$JAVA_HOME_CANDIDATE" ]; then
                    if [ -d "/usr/local/opt/openjdk" ]; then
                        JAVA_HOME_CANDIDATE="/usr/local/opt/openjdk"
                    elif [ -d "/opt/homebrew/opt/openjdk" ]; then
                        JAVA_HOME_CANDIDATE="/opt/homebrew/opt/openjdk"
                    fi
                fi
                
                if [ -n "$JAVA_HOME_CANDIDATE" ]; then
                    export JAVA_HOME="$JAVA_HOME_CANDIDATE"
                    export PATH="$JAVA_HOME/bin:$PATH"
                else
                    echo -e "${RED}✗ JAVA_HOME is not set${NC}" >&2
                    echo -e "${YELLOW}Java requires JAVA_HOME to be set to your Java installation directory.${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}To fix this:${NC}" >&2
                    echo -e "${YELLOW}1. If Java is installed via Homebrew:${NC}" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=/usr/local/opt/openjdk${NC} (Intel Mac)" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=/opt/homebrew/opt/openjdk${NC} (Apple Silicon Mac)" >&2
                    echo "" >&2
                    echo -e "${YELLOW}2. If Java is installed via other methods:${NC}" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=\$(/usr/libexec/java_home)${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}3. Set JAVA_HOME permanently (recommended):${NC}" >&2
                    echo -e "   Add to your ~/.zshrc or ~/.bash_profile:${NC}" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=/usr/local/opt/openjdk${NC} (or use java_home command)" >&2
                    echo -e "   Then run: ${BLUE}source ~/.zshrc${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}4. Verify it's set:${NC}" >&2
                    echo -e "   ${BLUE}echo \$JAVA_HOME${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}If Java is not installed, install it first:${NC}" >&2
                    echo -e "   ${BLUE}brew install openjdk${NC} (via Homebrew)" >&2
                    echo -e "   Or download from: https://www.java.com/download/" >&2
                    exit 1
                fi
            else
                echo -e "${RED}✗ JAVA_HOME is not set${NC}" >&2
                echo -e "${YELLOW}Java requires JAVA_HOME to be set to your Java installation directory.${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}To fix this:${NC}" >&2
                echo -e "${YELLOW}1. Find your Java installation:${NC}" >&2
                echo -e "   ${BLUE}which java${NC} or ${BLUE}readlink -f \$(which java)${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}2. Set JAVA_HOME (replace /path/to/java with your actual path):${NC}" >&2
                echo -e "   ${BLUE}export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64${NC}" >&2
                echo -e "   ${BLUE}export PATH=\"\$JAVA_HOME/bin:\$PATH\"${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}3. Make it permanent by adding to ~/.bashrc or ~/.zshrc:${NC}" >&2
                echo -e "   ${BLUE}export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64${NC}" >&2
                echo -e "   ${BLUE}export PATH=\"\$JAVA_HOME/bin:\$PATH\"${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}If Java is not installed:${NC}" >&2
                echo -e "   Ubuntu/Debian: ${BLUE}sudo apt-get install openjdk-11-jdk${NC}" >&2
                echo -e "   Or download from: https://www.java.com/download/" >&2
                exit 1
            fi
        fi
        ;;
    kotlin)
        check_and_exit "kotlinc" "Kotlin" "Install Kotlin: brew install kotlin or https://kotlinlang.org/docs/command-line.html"
        check_and_exit "java" "Java" "Install Java: https://www.java.com/download/"
        if [ -z "$JAVA_HOME" ]; then
            # Try to set JAVA_HOME automatically on macOS
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # First try macOS's java_home utility
                JAVA_HOME_CANDIDATE=$(/usr/libexec/java_home 2>/dev/null || echo "")
                
                # If that fails, check for Homebrew Java installation
                if [ -z "$JAVA_HOME_CANDIDATE" ]; then
                    if [ -d "/usr/local/opt/openjdk" ]; then
                        JAVA_HOME_CANDIDATE="/usr/local/opt/openjdk"
                    elif [ -d "/opt/homebrew/opt/openjdk" ]; then
                        JAVA_HOME_CANDIDATE="/opt/homebrew/opt/openjdk"
                    fi
                fi
                
                if [ -n "$JAVA_HOME_CANDIDATE" ]; then
                    export JAVA_HOME="$JAVA_HOME_CANDIDATE"
                    export PATH="$JAVA_HOME/bin:$PATH"
                else
                    echo -e "${RED}✗ JAVA_HOME is not set${NC}" >&2
                    echo -e "${YELLOW}Kotlin requires JAVA_HOME to be set to your Java installation directory.${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}To fix this:${NC}" >&2
                    echo -e "${YELLOW}1. If Java is installed via Homebrew:${NC}" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=/usr/local/opt/openjdk${NC} (Intel Mac)" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=/opt/homebrew/opt/openjdk${NC} (Apple Silicon Mac)" >&2
                    echo "" >&2
                    echo -e "${YELLOW}2. If Java is installed via other methods:${NC}" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=\$(/usr/libexec/java_home)${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}3. Set JAVA_HOME permanently (recommended):${NC}" >&2
                    echo -e "   Add to your ~/.zshrc or ~/.bash_profile:${NC}" >&2
                    echo -e "   ${BLUE}export JAVA_HOME=/usr/local/opt/openjdk${NC} (or use java_home command)" >&2
                    echo -e "   Then run: ${BLUE}source ~/.zshrc${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}4. Verify it's set:${NC}" >&2
                    echo -e "   ${BLUE}echo \$JAVA_HOME${NC}" >&2
                    echo "" >&2
                    echo -e "${YELLOW}If Java is not installed, install it first:${NC}" >&2
                    echo -e "   ${BLUE}brew install openjdk${NC} (via Homebrew)" >&2
                    echo -e "   Or download from: https://www.java.com/download/" >&2
                    exit 1
                fi
            else
                echo -e "${RED}✗ JAVA_HOME is not set${NC}" >&2
                echo -e "${YELLOW}Kotlin requires JAVA_HOME to be set to your Java installation directory.${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}To fix this:${NC}" >&2
                echo -e "${YELLOW}1. Find your Java installation:${NC}" >&2
                echo -e "   ${BLUE}which java${NC} or ${BLUE}readlink -f \$(which java)${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}2. Set JAVA_HOME (replace /path/to/java with your actual path):${NC}" >&2
                echo -e "   ${BLUE}export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64${NC}" >&2
                echo -e "   ${BLUE}export PATH=\"\$JAVA_HOME/bin:\$PATH\"${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}3. Make it permanent by adding to ~/.bashrc or ~/.zshrc:${NC}" >&2
                echo -e "   ${BLUE}export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64${NC}" >&2
                echo -e "   ${BLUE}export PATH=\"\$JAVA_HOME/bin:\$PATH\"${NC}" >&2
                echo "" >&2
                echo -e "${YELLOW}If Java is not installed:${NC}" >&2
                echo -e "   Ubuntu/Debian: ${BLUE}sudo apt-get install openjdk-11-jdk${NC}" >&2
                echo -e "   Or download from: https://www.java.com/download/" >&2
                exit 1
            fi
        fi
        ;;
    csharp)
        check_and_exit "dotnet" ".NET SDK" "Install .NET SDK: https://dotnet.microsoft.com/download"
        ;;
    curl)
        check_and_exit "curl" "curl" "Install curl: https://curl.se/download.html (usually pre-installed)"
        ;;
    *)
        echo "Unknown language: $LANGUAGE" >&2
        exit 1
        ;;
esac

# All checks passed
exit 0

