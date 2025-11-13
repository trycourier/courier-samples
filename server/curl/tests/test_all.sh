#!/bin/bash
# Test script to validate all curl/bash code samples.
# This script checks:
# 1. Bash syntax validity
# 2. Script structure validation
# 3. Required environment variable references

set -e

# Colors for output
GREEN='\033[92m'
RED='\033[91m'
YELLOW='\033[93m'
BLUE='\033[94m'
RESET='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

check_syntax() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    
    # Use bash -n to check syntax without executing
    if bash -n "$file_path" 2>&1; then
        echo -e "  ${GREEN}✓ Syntax valid${RESET}"
        return 0
    else
        echo -e "  ${RED}✗ Syntax error${RESET}"
        return 1
    fi
}

check_structure() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    
    local checks=0
    local issues=()
    
    # Check for required patterns
    if grep -q "COURIER_API_KEY" "$file_path"; then
        ((checks++))
    else
        issues+=("Missing COURIER_API_KEY reference")
    fi
    
    if grep -q "curl.*--request" "$file_path" || grep -q "curl.*-X" "$file_path"; then
        ((checks++))
    else
        issues+=("Missing curl command")
    fi
    
    if grep -q "Authorization.*Bearer" "$file_path"; then
        ((checks++))
    else
        issues+=("Missing Authorization header")
    fi
    
    if [ $checks -ge 2 ]; then
        echo -e "  ${GREEN}✓ Structure valid${RESET}"
        return 0
    else
        echo -e "  ${YELLOW}⚠ Structure issues: ${issues[*]}${RESET}"
        return 1
    fi
}

main() {
    # Find all .sh files in parent directory
    sh_files=($(find "$PARENT_DIR" -maxdepth 1 -name "*.sh" -type f | sort))
    
    # Exclude this test script
    sh_files=($(printf '%s\n' "${sh_files[@]}" | grep -v "test_all.sh"))
    
    if [ ${#sh_files[@]} -eq 0 ]; then
        echo -e "${RED}No bash files found to test${RESET}"
        return 1
    fi
    
    echo -e "${BLUE}Testing ${#sh_files[@]} bash sample files...${RESET}\n"
    
    results=()
    for file_path in "${sh_files[@]}"; do
        file_name=$(basename "$file_path")
        echo -e "${BLUE}Testing: ${file_name}${RESET}"
        
        syntax_ok=false
        structure_ok=false
        
        if check_syntax "$file_path"; then
            syntax_ok=true
        fi
        
        if check_structure "$file_path"; then
            structure_ok=true
        fi
        
        all_ok=false
        if [ "$syntax_ok" = true ] && [ "$structure_ok" = true ]; then
            all_ok=true
        fi
        
        results+=("$file_name:$all_ok")
        echo ""
    done
    
    # Summary
    echo -e "${BLUE}$(printf '=%.0s' {1..60})${RESET}"
    echo -e "${BLUE}Summary:${RESET}\n"
    
    passed=0
    total=${#results[@]}
    
    for result in "${results[@]}"; do
        file_name="${result%%:*}"
        ok="${result##*:}"
        if [ "$ok" = "true" ]; then
            echo -e "  ${GREEN}✓ PASS${RESET} - ${file_name}"
            ((passed++))
        else
            echo -e "  ${YELLOW}⚠ PARTIAL${RESET} - ${file_name}"
        fi
    done
    
    echo -e "\n${BLUE}Results: ${passed}/${total} files passed all checks${RESET}"
    
    if [ $passed -eq $total ]; then
        echo -e "${GREEN}All files are valid! ✓${RESET}"
        return 0
    else
        echo -e "${YELLOW}Some files need attention${RESET}"
        return 1
    fi
}

main "$@"

