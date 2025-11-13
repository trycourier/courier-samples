#!/bin/bash

# Quick test script to validate all Kotlin code samples.
# This script checks:
# 1. Kotlin syntax validity
# 2. Basic structure validation (e.g., presence of API key, HTTP client, Authorization header)

# Colors for output
GREEN='\033[92m'
RED='\033[91m'
YELLOW='\033[93m'
BLUE='\033[94m'
RESET='\033[0m'

check_syntax() {
    local file_path=$1
    # Compile to check syntax (output to /dev/null)
    if kotlinc "$file_path" -include-runtime -d /tmp/test_$(basename "$file_path" .kt).jar 2>/dev/null; then
        rm -f /tmp/test_$(basename "$file_path" .kt).jar
        echo "✓ Syntax valid"
        return 0
    else
        echo "✗ Syntax error"
        return 1
    fi
}

check_structure() {
    local file_path=$1
    local source=$(cat "$file_path")
    local all_checks_ok=0
    
    # Check for API key reference
    if [[ "$source" =~ "COURIER_API_KEY" ]]; then
        echo "✓ API Key reference found"
        all_checks_ok=$((all_checks_ok + 1))
    else
        echo "✗ API Key reference missing"
    fi
    
    # Check for HTTP client
    if [[ "$source" =~ "HttpURLConnection" ]] || [[ "$source" =~ "java.net" ]]; then
        echo "✓ HTTP client found"
        all_checks_ok=$((all_checks_ok + 1))
    else
        echo "✗ HTTP client missing"
    fi
    
    # Check for Authorization header
    if [[ "$source" =~ "Authorization" ]] && [[ "$source" =~ "Bearer" ]]; then
        echo "✓ Authorization header found"
        all_checks_ok=$((all_checks_ok + 1))
    else
        echo "✗ Authorization header missing"
    fi
    
    # Check for environment loading
    if [[ "$source" =~ "loadEnv" ]] || [[ "$source" =~ ".env" ]]; then
        echo "✓ Environment loading found"
        all_checks_ok=$((all_checks_ok + 1))
    else
        echo "✗ Environment loading missing"
    fi
    
    if [ "$all_checks_ok" -eq 4 ]; then
        return 0
    else
        return 1
    fi
}

main() {
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    parent_dir="$(cd "$script_dir/.." && pwd)"
    
    kt_files=()
    while IFS= read -r -d $'\0'; do
        kt_files+=("$REPLY")
    done < <(find "$parent_dir" -maxdepth 1 -type f -name "*.kt" -print0)
    
    # Exclude test scripts
    kt_files=($(echo "${kt_files[@]}" | tr ' ' '\n' | grep -v "test_all" | sort -u))
    
    if [ ${#kt_files[@]} -eq 0 ]; then
        echo -e "${RED}No Kotlin files found to test${RESET}"
        return 1
    fi
    
    echo -e "${BLUE}Testing ${#kt_files[@]} Kotlin sample files...${RESET}\n"
    
    results=()
    for file_path in "${kt_files[@]}"; do
        file_name=$(basename "$file_path")
        echo -e "${BLUE}Testing: ${file_name}${RESET}"
        
        syntax_ok=0
        if check_syntax "$file_path"; then
            syntax_ok=1
        fi
        
        structure_ok=0
        if check_structure "$file_path"; then
            structure_ok=1
        fi
        
        all_ok=$((syntax_ok && structure_ok))
        
        results+=("$file_name:$all_ok")
        echo ""
    done
    
    # Summary
    echo -e "${BLUE}$(printf '=%.0s' {1..60})${RESET}"
    echo -e "${BLUE}Summary:${RESET}\n"
    
    passed=0
    total=${#results[@]}
    
    for result in "${results[@]}"; do
        file_name="${result%:*}"
        status_code="${result#*:}"
        
        if [ "$status_code" -eq 1 ]; then
            status="${GREEN}✓ PASS${RESET}"
            passed=$((passed + 1))
        else
            status="${YELLOW}⚠ PARTIAL${RESET}"
        fi
        echo -e "  ${status} - ${file_name}"
    done
    
    echo -e "\n${BLUE}Results: ${passed}/${total} files passed all checks${RESET}"
    
    if [ "$passed" -eq "$total" ]; then
        echo -e "${GREEN}All files are valid! ✓${RESET}"
        return 0
    else
        echo -e "${YELLOW}Some files need attention.${RESET}"
        return 1
    fi
}

main "$@"

