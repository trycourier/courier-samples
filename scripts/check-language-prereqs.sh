#!/bin/bash
# Check prerequisites for a specific language
# Usage: check-language-prereqs.sh <language>
# Language can be: ruby, python, node, go, php, java, kotlin, csharp
# This script will attempt to auto-install missing dependencies when possible

set -e

LANGUAGE=$1

if [ -z "$LANGUAGE" ]; then
    echo "Usage: $0 <language>" >&2
    exit 1
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

# Detect OS and package manager
detect_package_manager() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            echo "brew"
            return 0
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "apt"
            return 0
        elif command -v yum &> /dev/null; then
            echo "yum"
            return 0
        elif command -v dnf &> /dev/null; then
            echo "dnf"
            return 0
        fi
    fi
    echo "none"
    return 1
}

# Attempt to install a package using the detected package manager
try_install() {
    local cmd=$1
    local name=$2
    local package_name=$3
    local pm=$(detect_package_manager)
    
    if [ "$pm" = "none" ]; then
        return 1
    fi
    
    echo -e "${BLUE}Attempting to install $name...${NC}" >&2
    
    case "$pm" in
        brew)
            if brew install "$package_name" >/dev/null 2>&1; then
                echo -e "${GREEN}✓ $name has been installed${NC}" >&2
                # Refresh PATH in case brew installed to a new location
                if [ -f "$HOME/.zshrc" ] || [ -f "$HOME/.bash_profile" ]; then
                    eval "$(brew shellenv)" 2>/dev/null || true
                fi
                return 0
            fi
            ;;
        apt)
            if sudo apt-get update -qq >/dev/null 2>&1 && sudo apt-get install -y "$package_name" >/dev/null 2>&1; then
                echo -e "${GREEN}✓ $name has been installed${NC}" >&2
                return 0
            fi
            ;;
        yum)
            if sudo yum install -y "$package_name" >/dev/null 2>&1; then
                echo -e "${GREEN}✓ $name has been installed${NC}" >&2
                return 0
            fi
            ;;
        dnf)
            if sudo dnf install -y "$package_name" >/dev/null 2>&1; then
                echo -e "${GREEN}✓ $name has been installed${NC}" >&2
                return 0
            fi
            ;;
    esac
    
    return 1
}

# Check if command exists, try to install if missing
check_and_install() {
    local cmd=$1
    local name=$2
    local install_instructions=$3
    local package_name=${4:-$cmd}  # Default package name is the command itself
    
    if command -v "$cmd" &> /dev/null; then
        return 0
    fi
    
    echo -e "${YELLOW}⚠ $name is not installed${NC}" >&2
    
    # Try to auto-install
    if try_install "$cmd" "$name" "$package_name"; then
        # Verify installation
        if command -v "$cmd" &> /dev/null; then
            return 0
        fi
    fi
    
    # Auto-install failed, show instructions
    echo -e "${RED}✗ Could not auto-install $name${NC}" >&2
    echo -e "${YELLOW}$install_instructions${NC}" >&2
    exit 1
}

# Legacy function for backward compatibility (now uses check_and_install)
check_and_exit() {
    check_and_install "$1" "$2" "$3" "$1"
}

case "$LANGUAGE" in
    ruby)
        # Ruby package names vary by package manager
        if ! command -v ruby &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                brew) try_install "ruby" "Ruby" "ruby" || check_and_exit "ruby" "Ruby" "Install Ruby: https://www.ruby-lang.org/en/downloads/" ;;
                apt) try_install "ruby" "Ruby" "ruby-full" || check_and_exit "ruby" "Ruby" "Install Ruby: sudo apt-get install ruby-full" ;;
                yum|dnf) try_install "ruby" "Ruby" "ruby" || check_and_exit "ruby" "Ruby" "Install Ruby: sudo yum install ruby" ;;
                *) check_and_exit "ruby" "Ruby" "Install Ruby: https://www.ruby-lang.org/en/downloads/" ;;
            esac
        fi
        
        # Bundler - try gem install first, then package manager
        if ! command -v bundle &> /dev/null; then
            echo -e "${BLUE}Attempting to install Bundler...${NC}" >&2
            if gem install bundler >/dev/null 2>&1; then
                echo -e "${GREEN}✓ Bundler has been installed${NC}" >&2
                # Verify it's now available
                if command -v bundle &> /dev/null; then
                    : # Success
                else
                    # gem install succeeded but bundle not in PATH, try package manager
                    pm=$(detect_package_manager)
                    case "$pm" in
                        brew) try_install "bundle" "Bundler" "bundler" || check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                        apt) try_install "bundle" "Bundler" "ruby-bundler" || check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                        yum|dnf) try_install "bundle" "Bundler" "rubygem-bundler" || check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                        *) check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                    esac
                fi
            else
                pm=$(detect_package_manager)
                case "$pm" in
                    brew) try_install "bundle" "Bundler" "bundler" || check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                    apt) try_install "bundle" "Bundler" "ruby-bundler" || check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                    yum|dnf) try_install "bundle" "Bundler" "rubygem-bundler" || check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                    *) check_and_exit "bundle" "Bundler" "Install bundler: gem install bundler" ;;
                esac
            fi
        fi
        ;;
    python)
        pm=$(detect_package_manager)
        case "$pm" in
            brew) check_and_install "python3" "Python 3" "Install Python: https://www.python.org/downloads/" "python3" ;;
            apt) check_and_install "python3" "Python 3" "Install Python: sudo apt-get install python3" "python3" ;;
            yum|dnf) check_and_install "python3" "Python 3" "Install Python: sudo yum install python3" "python3" ;;
            *) check_and_exit "python3" "Python 3" "Install Python: https://www.python.org/downloads/" ;;
        esac
        ;;
    node)
        pm=$(detect_package_manager)
        case "$pm" in
            brew) check_and_install "node" "Node.js" "Install Node.js: https://nodejs.org/" "node" ;;
            apt) check_and_install "node" "Node.js" "Install Node.js: sudo apt-get install nodejs npm" "nodejs" ;;
            yum|dnf) check_and_install "node" "Node.js" "Install Node.js: sudo yum install nodejs npm" "nodejs" ;;
            *) check_and_exit "node" "Node.js" "Install Node.js: https://nodejs.org/" ;;
        esac
        # npm usually comes with node, but verify
        if ! command -v npm &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                apt) try_install "npm" "npm" "npm" || echo -e "${YELLOW}⚠ npm should come with Node.js${NC}" >&2 ;;
                yum|dnf) try_install "npm" "npm" "npm" || echo -e "${YELLOW}⚠ npm should come with Node.js${NC}" >&2 ;;
                *) echo -e "${YELLOW}⚠ npm should come with Node.js${NC}" >&2 ;;
            esac
        fi
        ;;
    go)
        pm=$(detect_package_manager)
        case "$pm" in
            brew) check_and_install "go" "Go" "Install Go: https://golang.org/dl/" "go" ;;
            apt) check_and_install "go" "Go" "Install Go: sudo apt-get install golang-go" "golang-go" ;;
            yum|dnf) check_and_install "go" "Go" "Install Go: sudo yum install golang" "golang" ;;
            *) check_and_exit "go" "Go" "Install Go: https://golang.org/dl/" ;;
        esac
        ;;
    php)
        pm=$(detect_package_manager)
        case "$pm" in
            brew) check_and_install "php" "PHP" "Install PHP: https://www.php.net/downloads.php" "php" ;;
            apt) check_and_install "php" "PHP" "Install PHP: sudo apt-get install php php-cli" "php-cli" ;;
            yum|dnf) check_and_install "php" "PHP" "Install PHP: sudo yum install php php-cli" "php-cli" ;;
            *) check_and_exit "php" "PHP" "Install PHP: https://www.php.net/downloads.php" ;;
        esac
        
        # Composer - try downloading script first, then package manager
        if ! command -v composer &> /dev/null; then
            echo -e "${BLUE}Attempting to install Composer...${NC}" >&2
            # Try package manager first
            pm=$(detect_package_manager)
            case "$pm" in
                brew) 
                    if try_install "composer" "Composer" "composer"; then
                        : # Success
                    else
                        check_and_exit "composer" "Composer" "Install Composer: https://getcomposer.org/download/"
                    fi
                    ;;
                apt)
                    if try_install "composer" "Composer" "composer"; then
                        : # Success
                    else
                        check_and_exit "composer" "Composer" "Install Composer: https://getcomposer.org/download/"
                    fi
                    ;;
                yum|dnf)
                    if try_install "composer" "Composer" "composer"; then
                        : # Success
                    else
                        check_and_exit "composer" "Composer" "Install Composer: https://getcomposer.org/download/"
                    fi
                    ;;
                *)
                    check_and_exit "composer" "Composer" "Install Composer: https://getcomposer.org/download/"
                    ;;
            esac
        fi
        ;;
    java)
        # Try to install Java first if missing
        if ! command -v java &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                brew) 
                    echo -e "${BLUE}Attempting to install Java...${NC}" >&2
                    if brew install openjdk 2>&1; then
                        echo -e "${GREEN}✓ Java has been installed${NC}" >&2
                        # Set JAVA_HOME for Homebrew installation
                        if [ -d "/opt/homebrew/opt/openjdk" ]; then
                            export JAVA_HOME="/opt/homebrew/opt/openjdk"
                        elif [ -d "/usr/local/opt/openjdk" ]; then
                            export JAVA_HOME="/usr/local/opt/openjdk"
                        fi
                        export PATH="$JAVA_HOME/bin:$PATH"
                    else
                        check_and_exit "java" "Java" "Install Java: brew install openjdk or https://www.java.com/download/"
                    fi
                    ;;
                apt)
                    echo -e "${BLUE}Attempting to install Java...${NC}" >&2
                    if sudo apt-get update -qq >/dev/null 2>&1 && sudo apt-get install -y openjdk-11-jdk >/dev/null 2>&1; then
                        echo -e "${GREEN}✓ Java has been installed${NC}" >&2
                        # Try to set JAVA_HOME automatically
                        if command -v java &> /dev/null; then
                            JAVA_HOME_CANDIDATE=$(dirname "$(dirname "$(readlink -f "$(which java)" 2>/dev/null || which java)")" 2>/dev/null || echo "")
                            if [ -z "$JAVA_HOME_CANDIDATE" ] && [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
                                JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-11-openjdk-amd64"
                            elif [ -z "$JAVA_HOME_CANDIDATE" ] && [ -d "/usr/lib/jvm/java-11-openjdk" ]; then
                                JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-11-openjdk"
                            fi
                            if [ -n "$JAVA_HOME_CANDIDATE" ] && [ -d "$JAVA_HOME_CANDIDATE" ]; then
                                export JAVA_HOME="$JAVA_HOME_CANDIDATE"
                                export PATH="$JAVA_HOME/bin:$PATH"
                            fi
                        fi
                    else
                        check_and_exit "java" "Java" "Install Java: sudo apt-get install openjdk-11-jdk"
                    fi
                    ;;
                yum|dnf)
                    echo -e "${BLUE}Attempting to install Java...${NC}" >&2
                    if (sudo yum install -y java-11-openjdk-devel >/dev/null 2>&1 || sudo dnf install -y java-11-openjdk-devel >/dev/null 2>&1); then
                        echo -e "${GREEN}✓ Java has been installed${NC}" >&2
                        # Try to set JAVA_HOME automatically
                        if command -v java &> /dev/null; then
                            JAVA_HOME_CANDIDATE=$(dirname "$(dirname "$(readlink -f "$(which java)" 2>/dev/null || which java)")" 2>/dev/null || echo "")
                            if [ -z "$JAVA_HOME_CANDIDATE" ] && [ -d "/usr/lib/jvm/java-11-openjdk" ]; then
                                JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-11-openjdk"
                            fi
                            if [ -n "$JAVA_HOME_CANDIDATE" ] && [ -d "$JAVA_HOME_CANDIDATE" ]; then
                                export JAVA_HOME="$JAVA_HOME_CANDIDATE"
                                export PATH="$JAVA_HOME/bin:$PATH"
                            fi
                        fi
                    else
                        check_and_exit "java" "Java" "Install Java: sudo yum install java-11-openjdk-devel"
                    fi
                    ;;
                *)
                    check_and_exit "java" "Java" "Install Java: https://www.java.com/download/"
                    ;;
            esac
        fi
        
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
        # Check for Gradle (required for Kotlin samples with dependencies)
        if ! command -v gradle &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                brew) 
                    echo -e "${BLUE}Attempting to install Gradle...${NC}" >&2
                    if brew install gradle 2>&1; then
                        echo -e "${GREEN}✓ Gradle has been installed${NC}" >&2
                    else
                        check_and_exit "gradle" "Gradle" "Install Gradle: brew install gradle or https://gradle.org/install/"
                    fi
                    ;;
                apt)
                    echo -e "${BLUE}Attempting to install Gradle...${NC}" >&2
                    if sudo apt-get update -qq >/dev/null 2>&1 && sudo apt-get install -y gradle >/dev/null 2>&1; then
                        echo -e "${GREEN}✓ Gradle has been installed${NC}" >&2
                    else
                        check_and_exit "gradle" "Gradle" "Install Gradle: sudo apt-get install gradle or https://gradle.org/install/"
                    fi
                    ;;
                yum|dnf)
                    echo -e "${BLUE}Attempting to install Gradle...${NC}" >&2
                    if sudo yum install -y gradle >/dev/null 2>&1; then
                        echo -e "${GREEN}✓ Gradle has been installed${NC}" >&2
                    else
                        check_and_exit "gradle" "Gradle" "Install Gradle: https://gradle.org/install/"
                    fi
                    ;;
                *)
                    check_and_exit "gradle" "Gradle" "Install Gradle: https://gradle.org/install/"
                    ;;
            esac
        fi
        
        # Try to install Kotlin first if missing
        if ! command -v kotlinc &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                brew) 
                    echo -e "${BLUE}Attempting to install Kotlin...${NC}" >&2
                    if brew install kotlin 2>&1; then
                        echo -e "${GREEN}✓ Kotlin has been installed${NC}" >&2
                    else
                        check_and_exit "kotlinc" "Kotlin" "Install Kotlin: brew install kotlin or https://kotlinlang.org/docs/command-line.html"
                    fi
                    ;;
                apt)
                    echo -e "${BLUE}Attempting to install Kotlin...${NC}" >&2
                    # Kotlin isn't in standard apt repos, try snap or manual install
                    if command -v snap &> /dev/null && sudo snap install kotlin --classic 2>&1; then
                        echo -e "${GREEN}✓ Kotlin has been installed${NC}" >&2
                    else
                        check_and_exit "kotlinc" "Kotlin" "Install Kotlin: sudo snap install kotlin --classic or https://kotlinlang.org/docs/command-line.html"
                    fi
                    ;;
                yum|dnf)
                    # Kotlin isn't in standard yum repos
                    check_and_exit "kotlinc" "Kotlin" "Install Kotlin: https://kotlinlang.org/docs/command-line.html"
                    ;;
                *)
                    check_and_exit "kotlinc" "Kotlin" "Install Kotlin: https://kotlinlang.org/docs/command-line.html"
                    ;;
            esac
        fi
        
        # Check/install Java (reuse Java installation logic)
        if ! command -v java &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                brew) 
                    echo -e "${BLUE}Attempting to install Java...${NC}" >&2
                    if brew install openjdk 2>&1; then
                        echo -e "${GREEN}✓ Java has been installed${NC}" >&2
                        if [ -d "/opt/homebrew/opt/openjdk" ]; then
                            export JAVA_HOME="/opt/homebrew/opt/openjdk"
                        elif [ -d "/usr/local/opt/openjdk" ]; then
                            export JAVA_HOME="/usr/local/opt/openjdk"
                        fi
                        export PATH="$JAVA_HOME/bin:$PATH"
                    else
                        check_and_exit "java" "Java" "Install Java: brew install openjdk or https://www.java.com/download/"
                    fi
                    ;;
                apt)
                    echo -e "${BLUE}Attempting to install Java...${NC}" >&2
                    if sudo apt-get update -qq >/dev/null 2>&1 && sudo apt-get install -y openjdk-11-jdk >/dev/null 2>&1; then
                        echo -e "${GREEN}✓ Java has been installed${NC}" >&2
                        # Try to set JAVA_HOME automatically
                        if command -v java &> /dev/null; then
                            JAVA_HOME_CANDIDATE=$(dirname "$(dirname "$(readlink -f "$(which java)" 2>/dev/null || which java)")" 2>/dev/null || echo "")
                            if [ -z "$JAVA_HOME_CANDIDATE" ] && [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
                                JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-11-openjdk-amd64"
                            elif [ -z "$JAVA_HOME_CANDIDATE" ] && [ -d "/usr/lib/jvm/java-11-openjdk" ]; then
                                JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-11-openjdk"
                            fi
                            if [ -n "$JAVA_HOME_CANDIDATE" ] && [ -d "$JAVA_HOME_CANDIDATE" ]; then
                                export JAVA_HOME="$JAVA_HOME_CANDIDATE"
                                export PATH="$JAVA_HOME/bin:$PATH"
                            fi
                        fi
                    else
                        check_and_exit "java" "Java" "Install Java: sudo apt-get install openjdk-11-jdk"
                    fi
                    ;;
                yum|dnf)
                    echo -e "${BLUE}Attempting to install Java...${NC}" >&2
                    if (sudo yum install -y java-11-openjdk-devel >/dev/null 2>&1 || sudo dnf install -y java-11-openjdk-devel >/dev/null 2>&1); then
                        echo -e "${GREEN}✓ Java has been installed${NC}" >&2
                        # Try to set JAVA_HOME automatically
                        if command -v java &> /dev/null; then
                            JAVA_HOME_CANDIDATE=$(dirname "$(dirname "$(readlink -f "$(which java)" 2>/dev/null || which java)")" 2>/dev/null || echo "")
                            if [ -z "$JAVA_HOME_CANDIDATE" ] && [ -d "/usr/lib/jvm/java-11-openjdk" ]; then
                                JAVA_HOME_CANDIDATE="/usr/lib/jvm/java-11-openjdk"
                            fi
                            if [ -n "$JAVA_HOME_CANDIDATE" ] && [ -d "$JAVA_HOME_CANDIDATE" ]; then
                                export JAVA_HOME="$JAVA_HOME_CANDIDATE"
                                export PATH="$JAVA_HOME/bin:$PATH"
                            fi
                        fi
                    else
                        check_and_exit "java" "Java" "Install Java: sudo yum install java-11-openjdk-devel"
                    fi
                    ;;
                *)
                    check_and_exit "java" "Java" "Install Java: https://www.java.com/download/"
                    ;;
            esac
        fi
        
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
        pm=$(detect_package_manager)
        case "$pm" in
            brew) 
                echo -e "${BLUE}Attempting to install .NET SDK...${NC}" >&2
                if brew install --cask dotnet-sdk 2>&1 || brew install dotnet 2>&1; then
                    echo -e "${GREEN}✓ .NET SDK has been installed${NC}" >&2
                else
                    check_and_exit "dotnet" ".NET SDK" "Install .NET SDK: brew install --cask dotnet-sdk or https://dotnet.microsoft.com/download"
                fi
                ;;
            apt)
                # .NET requires adding Microsoft's repository, which is complex
                # For now, provide instructions
                check_and_exit "dotnet" ".NET SDK" "Install .NET SDK: https://dotnet.microsoft.com/download (apt installation requires adding Microsoft repository)"
                ;;
            yum|dnf)
                # .NET requires adding Microsoft's repository
                check_and_exit "dotnet" ".NET SDK" "Install .NET SDK: https://dotnet.microsoft.com/download (yum/dnf installation requires adding Microsoft repository)"
                ;;
            *)
                check_and_exit "dotnet" ".NET SDK" "Install .NET SDK: https://dotnet.microsoft.com/download"
                ;;
        esac
        ;;
    curl)
        # curl is usually pre-installed, but try to install if missing
        if ! command -v curl &> /dev/null; then
            pm=$(detect_package_manager)
            case "$pm" in
                brew) try_install "curl" "curl" "curl" || check_and_exit "curl" "curl" "Install curl: brew install curl" ;;
                apt) try_install "curl" "curl" "curl" || check_and_exit "curl" "curl" "Install curl: sudo apt-get install curl" ;;
                yum|dnf) try_install "curl" "curl" "curl" || check_and_exit "curl" "curl" "Install curl: sudo yum install curl" ;;
                *) check_and_exit "curl" "curl" "Install curl: https://curl.se/download.html" ;;
            esac
        fi
        ;;
    *)
        echo "Unknown language: $LANGUAGE" >&2
        exit 1
        ;;
esac

# All checks passed
exit 0

