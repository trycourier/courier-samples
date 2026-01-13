#!/bin/bash

# Script to set environment variables using gum input
# Usage: ./set-env.sh [--dir DIRECTORY] [api_key] [user_id] [email] ...
# This script updates only the specified variables, preserving all other existing values
# If --dir is not specified, defaults to project root
# Note: This script requires bash. Run with: bash set-env.sh or ./set-env.sh (if executable)

# Ensure we're running with bash
if [ -z "$BASH_VERSION" ]; then
    echo "Error: This script requires bash. Please run with: bash $0" >&2
    exit 1
fi

set -e

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default to project root if no directory specified
TARGET_DIR="$PROJECT_ROOT"

# Check if gum is installed, install if not
if ! command -v gum &> /dev/null; then
    echo "gum is not installed. Running check-gum.sh to install it..."
    "$SCRIPT_DIR/check-gum.sh"
fi

# Function to get existing value from .env file
get_env_value() {
    local key=$1
    if [ -f "$ENV_FILE" ]; then
        grep -E "^${key}=" "$ENV_FILE" 2>/dev/null | cut -d '=' -f2- | sed 's/^"//;s/"$//' || echo ""
    else
        echo ""
    fi
}

# Function to extract base variable name from script-specific name
# e.g., upsert_user_email -> email, send_template_to_list_api_key -> api_key
extract_base_var_name() {
    local var=$1
    # Common variable suffixes to look for
    case "$var" in
        *_api_key|*_API_KEY)
            echo "api_key"
            ;;
        *_user_id|*_USER_ID)
            echo "user_id"
            ;;
        *_email|*_EMAIL)
            echo "email"
            ;;
        *_template_id|*_TEMPLATE_ID)
            echo "template_id"
            ;;
        *_list_id|*_LIST_ID)
            echo "list_id"
            ;;
        *_list_name|*_LIST_NAME)
            echo "list_name"
            ;;
        *_name|*_NAME)
            echo "name"
            ;;
        *_phone_number|*_PHONE_NUMBER)
            echo "phone_number"
            ;;
        *_tenant_id|*_TENANT_ID)
            echo "tenant_id"
            ;;
        *_audience_id|*_AUDIENCE_ID)
            echo "audience_id"
            ;;
        *_jwt|*_JWT)
            echo "jwt"
            ;;
        *)
            # If no match, assume it's already a base name
            echo "$var"
            ;;
    esac
}

# Function to normalize variable name (upsert_user_email -> COURIER_UPSERT_USER_EMAIL)
normalize_var_name() {
    local var=$1
    # Convert to uppercase and add COURIER_ prefix
    echo "COURIER_$(echo "$var" | tr '[:lower:]' '[:upper:]' | tr '-' '_')"
}

# Function to get display name for variable
get_display_name() {
    local var=$1
    local base_var=$(extract_base_var_name "$var")
    case "$base_var" in
        api_key|API_KEY)
            echo "Courier API Key"
            ;;
        user_id|USER_ID)
            echo "Courier User ID"
            ;;
        email|EMAIL)
            echo "Courier Email"
            ;;
        jwt|JWT)
            echo "Courier JWT Token"
            ;;
        template_id|TEMPLATE_ID)
            echo "Courier Template ID"
            ;;
        list_id|LIST_ID)
            echo "List ID"
            ;;
        list_name|LIST_NAME)
            echo "List Name"
            ;;
        name|NAME)
            echo "Name"
            ;;
        phone_number|PHONE_NUMBER)
            echo "Phone Number"
            ;;
        tenant_id|TENANT_ID)
            echo "Tenant ID"
            ;;
        audience_id|AUDIENCE_ID)
            echo "Audience ID"
            ;;
        *)
            # Default: capitalize and replace underscores with spaces
            echo "$var" | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g'
            ;;
    esac
}

# Function to quote value if it contains spaces (for PHP Dotenv compatibility)
quote_if_needed() {
    local value="$1"
    # If value contains spaces, quotes, or special characters, quote it
    if [[ "$value" =~ [[:space:]] ]] || [[ "$value" =~ [\"\$\`] ]]; then
        # Escape any existing quotes and wrap in quotes
        value="${value//\"/\\\"}"
        echo "\"$value\""
    else
        echo "$value"
    fi
}

# Function to check if a variable is optional
# For upsert-user operations, only user_id is required; email, name, and phone_number are optional
is_optional_field() {
    local var=$1
    local base_var=$(extract_base_var_name "$var")
    
    # These fields are optional for upsert-user operations
    case "$base_var" in
        email|EMAIL|name|NAME|phone_number|PHONE_NUMBER)
            # Check if this is an upsert-user context by looking at the title or variable name
            # Variable names like "upsert_user_email" should match
            # Check both the original variable name and the title
            if echo "$TITLE" | grep -qiE "upsert.*user" || echo "$var" | grep -qiE "upsert.*user"; then
                return 0  # Optional
            fi
            return 1  # Required
            ;;
        *)
            return 1  # Required by default
            ;;
    esac
}

# Function to get help message for variable
get_help_message() {
    local var=$1
    local base_var=$(extract_base_var_name "$var")
    case "$base_var" in
        api_key|API_KEY)
            echo "Enter your API key.\n\nGet your API key here: https://app.courier.com/settings/api-keys"
            ;;
        user_id|USER_ID)
            echo "Enter a unique user ID. (e.g., 'd290f1ee-6c54-4b01-90e6-d701748f0851')"
            ;;
        email|EMAIL)
            echo "Enter an email address. (e.g., 'name@courier.com')."
            ;;
        template_id|TEMPLATE_ID)
            echo "Enter your template ID.\nSelect or create a template here: https://app.courier.com/assets/templates, click the ⚙️ icon in the top right, then copy the \"Notification ID\""
            ;;
        list_id|LIST_ID)
            echo "Enter a unique id for your list (e.g., 'newsletter-subscribers' or 'newsletterSubscribers')"
            ;;
        list_name|LIST_NAME)
            echo "Enter a name for your list (e.g., 'Newsletter Subscribers')"
            ;;
        name|NAME)
            echo "The user's name (e.g., 'John Doe')."
            ;;
        phone_number|PHONE_NUMBER)
            echo "Phone number in E.164 format (e.g., '+1234567890')."
            ;;
        *)
            echo ""
            ;;
    esac
}

# Parse command-line arguments
VARS_TO_PROMPT=()
TARGET_DIR_SET=0
TITLE=""

# First argument is always the title (unless it's a flag, but in our usage it should always be the title)
if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
    TITLE="$1"
    shift  # Remove title from argument list
fi

# Process remaining arguments
for arg in "$@"; do
    # Check for --dir or -d flag
    if [ "$arg" = "--dir" ] || [ "$arg" = "-d" ]; then
        TARGET_DIR_SET=1
        continue
    fi
    
    # If previous arg was --dir, set the target directory
    if [ $TARGET_DIR_SET -eq 1 ]; then
        # If it's a relative path, make it relative to project root
        if [[ "$arg" != /* ]]; then
            TARGET_DIR="$PROJECT_ROOT/$arg"
        else
            TARGET_DIR="$arg"
        fi
        # Ensure directory exists
        mkdir -p "$TARGET_DIR"
        TARGET_DIR_SET=0
        continue
    fi
    
    # Normalize the argument (handle both api_key and API_KEY)
    normalized=$(echo "$arg" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
    VARS_TO_PROMPT+=("$normalized")
done

# If no arguments provided, prompt for all default variables
if [ ${#VARS_TO_PROMPT[@]} -eq 0 ]; then
    VARS_TO_PROMPT=("api_key" "user_id" "email")
fi

# Set the ENV_FILE path
ENV_FILE="$TARGET_DIR/.env"
ENV_EXAMPLE_FILE="$TARGET_DIR/.env.example"

# If .env doesn't exist but .env.example does, copy it as a starting point
if [ ! -f "$ENV_FILE" ] && [ -f "$ENV_EXAMPLE_FILE" ]; then
    cp "$ENV_EXAMPLE_FILE" "$ENV_FILE"
    gum style --foreground 240 "📋 Initialized .env from .env.example"
    echo ""
fi

# Function to get env key for a variable
# Maps script-specific names to COURIER_ prefixed environment variable names
# Special case: api_key always maps to COURIER_API_KEY (shared across all scripts)
get_env_key() {
    local var=$1
    local base_var=$(extract_base_var_name "$var")
    
    # Special case: api_key always maps to COURIER_API_KEY (shared)
    if [ "$base_var" = "api_key" ]; then
        echo "COURIER_API_KEY"
        return
    fi
    
    # If the extracted base is different from the original, it's a script-specific variable
    if [ "$base_var" != "$var" ]; then
        # Script-specific variable - normalize the full name
        normalize_var_name "$var"
    else
        # Base variable - use legacy mapping for React apps (jwt, template_id, tenant_id need VITE_ prefix)
        # Check if we're in a React app directory
        if echo "$TARGET_DIR" | grep -q "web/react"; then
            case "$var" in
                jwt)
                    echo "VITE_COURIER_JWT"
                    ;;
                template_id)
                    echo "VITE_COURIER_TEMPLATE_ID"
                    ;;
                tenant_id)
                    echo "VITE_COURIER_TENANT_ID"
                    ;;
                *)
                    # For other base variables, normalize with COURIER_ prefix
                    normalize_var_name "$var"
                    ;;
            esac
        else
            case "$var" in
                jwt)
                    echo "VITE_COURIER_JWT"
                    ;;
                *)
                    # For other base variables, normalize with COURIER_ prefix
                    normalize_var_name "$var"
                    ;;
            esac
        fi
    fi
}

# Define all default variables
DEFAULT_VARS="api_key user_id email"

# Get existing values for all default variables
for var in $DEFAULT_VARS; do
    env_key=$(get_env_key "$var")
    eval "EXISTING_${var}=\$(get_env_value \"\$env_key\")"
done

# For user_id, also check VITE_COURIER_USER_ID as a fallback
if [ -z "$EXISTING_user_id" ]; then
    EXISTING_user_id=$(get_env_value "VITE_COURIER_USER_ID")
fi

# For jwt, also check COURIER_JWT as a fallback
EXISTING_jwt=$(get_env_value "VITE_COURIER_JWT")
if [ -z "$EXISTING_jwt" ]; then
    EXISTING_jwt=$(get_env_value "COURIER_JWT")
fi

# For template_id and tenant_id in React apps, check VITE_COURIER_ versions
if echo "$TARGET_DIR" | grep -q "web/react"; then
    EXISTING_template_id=$(get_env_value "VITE_COURIER_TEMPLATE_ID")
    if [ -z "$EXISTING_template_id" ]; then
        EXISTING_template_id=$(get_env_value "COURIER_TEMPLATE_ID")
    fi
    
    EXISTING_tenant_id=$(get_env_value "VITE_COURIER_TENANT_ID")
    if [ -z "$EXISTING_tenant_id" ]; then
        EXISTING_tenant_id=$(get_env_value "COURIER_TENANT_ID")
    fi
fi

# Display header
echo ""
gum style --foreground 212 --bold "🐦 Running Courier Sample: $TITLE"
echo ""

# Prompt for each requested variable and store new values
PROMPTED_VARS_LIST=""
for var in "${VARS_TO_PROMPT[@]}"; do
    env_key=$(get_env_key "$var")
    display_name=$(get_display_name "$var")
    help_message=$(get_help_message "$var")
    
    # Get existing value
    existing_value=""
    case "$var" in
        api_key)
            existing_value="$EXISTING_api_key"
            ;;
        user_id)
            existing_value="$EXISTING_user_id"
            ;;
        email)
            existing_value="$EXISTING_email"
            ;;
        jwt)
            existing_value="$EXISTING_jwt"
            ;;
        template_id)
            existing_value="$EXISTING_template_id"
            ;;
        tenant_id)
            existing_value="$EXISTING_tenant_id"
            ;;
        *)
            existing_value=$(get_env_value "$env_key")
            ;;
    esac
    
    # Mark this variable as prompted
    PROMPTED_VARS_LIST="$PROMPTED_VARS_LIST|$var"
    
    # Show help message if available
    if [ -n "$help_message" ]; then
        # Convert \n escape sequences to actual newlines and split into title/subtitle
        help_formatted=$(printf "%b" "$help_message")
        # Split on first newline (or double newline) to get title and subtitle
        if echo "$help_formatted" | grep -q $'\n'; then
            # Extract title (first line) and subtitle (everything after first newline, removing leading newlines)
            help_title=$(echo "$help_formatted" | head -n 1)
            help_subtitle=$(echo "$help_formatted" | tail -n +2 | sed 's/^\n*//')
            # Display title in white, subtitle in lighter gray
            gum style --foreground 255 "$help_title"
            if [ -n "$help_subtitle" ]; then
                gum style --foreground 240 "$help_subtitle"
            fi
        else
            # Single line - display in white
            gum style --foreground 255 "$help_formatted"
        fi
        echo ""
    fi
    
    # Show link for template_id above the prompt
    if [ "$var" = "template_id" ]; then
        gum style --foreground 240 "Find templates here: https://app.courier.com/assets/templates"
        echo ""
    fi
    
    # Skip prompting for jwt - we'll generate it if needed
    if [ "$var" = "jwt" ]; then
        # Mark jwt as prompted but don't ask for it yet
        # We'll generate it after checking for api_key and user_id
        # But first, check if we already have a value - if so, keep it
        if [ -n "$existing_value" ]; then
            eval "NEW_${var}=\"\$existing_value\""
            gum style --foreground 10 "✓ $display_name: (using existing value)"
        else
            eval "NEW_${var}=\"\""
        fi
    else
        # Prompt for the value with validation loop
        # Use a simpler placeholder that doesn't duplicate the prompt text
        placeholder_text=$(echo "$display_name" | sed 's/(.*)//' | xargs)
        
        # Check if this field is optional
        is_optional=0
        if is_optional_field "$var"; then
            is_optional=1
        fi
        
        while true; do
            # Get input with blue prompt and pre-filled value
            # Create a blue-styled prompt using ANSI codes
            # Add "(optional)" to the prompt if the field is optional
            if [ $is_optional -eq 1 ]; then
                blue_prompt=$(printf '\033[34m%s (optional): \033[0m' "$display_name")
            else
                blue_prompt=$(printf '\033[34m%s: \033[0m' "$display_name")
            fi
            new_value=$(gum input --prompt "$blue_prompt" --value "$existing_value" --placeholder "$placeholder_text")
            
            # Check if empty - allow empty values for optional fields
            if [ -z "$new_value" ]; then
                if [ $is_optional -eq 1 ]; then
                    # Optional field - allow empty value
                    eval "NEW_${var}=\"\""
                    break
                else
                    # Required field - show error
                    gum style --foreground 1 --bold "Error: $display_name is required. Please enter a value."
                    echo ""
                    existing_value=""  # Clear existing value for retry
                    continue
                fi
            fi
            
            # Value is set, break out of loop
            eval "NEW_${var}=\"\$new_value\""
            break
        done
        
        # Show success message with checkmark and value
        if [ -n "$new_value" ]; then
            gum style --foreground 10 "✓ $display_name: $new_value"
        elif [ $is_optional -eq 1 ]; then
            # Show that optional field was skipped
            gum style --foreground 240 "○ $display_name: (skipped)"
        fi
    fi
    
    echo ""
done

# Function to get JWT scopes based on context
get_jwt_scopes() {
    local user_id=$1
    # Check if we're in a Designer context (has template_id or tenant_id)
    if echo "$TARGET_DIR" | grep -q "designer" || echo "$PROMPTED_VARS_LIST" | grep -q "|template_id|" || echo "$PROMPTED_VARS_LIST" | grep -q "|tenant_id|"; then
        # Designer needs specific tenant scopes for GraphQL API access
        echo "user_id:${user_id} tenants:read tenants:notifications:read tenants:notifications:write tenants:brand:read"
    else
        # Standard scopes for other samples
        echo "user_id:${user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands"
    fi
}

# Function to check if JWT is expired
# Returns 0 if expired or invalid, 1 if valid
is_jwt_expired() {
    local jwt=$1
    if [ -z "$jwt" ]; then
        return 0  # Empty JWT is considered expired
    fi
    
    # JWT has three parts separated by dots: header.payload.signature
    # Extract the payload (second part)
    local payload=$(echo "$jwt" | cut -d '.' -f 2)
    if [ -z "$payload" ]; then
        return 0  # Invalid JWT format
    fi
    
    # Decode base64 payload (add padding if needed)
    local padding=$((4 - ${#payload} % 4))
    if [ $padding -ne 4 ]; then
        payload="${payload}$(printf '%*s' $padding | tr ' ' '=')"
    fi
    
    # Try to decode and extract exp field
    # Use base64 -d (Linux) or base64 -D (macOS)
    local decoded=""
    if command -v base64 &> /dev/null; then
        # Try Linux style first (base64 -d)
        decoded=$(echo "$payload" | base64 -d 2>/dev/null || echo "")
        # If that failed, try macOS style (base64 -D)
        if [ -z "$decoded" ]; then
            decoded=$(echo "$payload" | base64 -D 2>/dev/null || echo "")
        fi
    fi
    
    # If we still can't decode, assume expired
    if [ -z "$decoded" ]; then
        return 0
    fi
    
    # Extract exp timestamp (Unix epoch time)
    local exp=""
    if command -v jq &> /dev/null; then
        exp=$(echo "$decoded" | jq -r '.exp // empty' 2>/dev/null)
    fi
    
    # If jq not available, try sed
    if [ -z "$exp" ]; then
        exp=$(echo "$decoded" | sed -n 's/.*"exp"[[:space:]]*:[[:space:]]*\([0-9]*\).*/\1/p')
    fi
    
    # If we can't extract exp, assume expired to be safe
    if [ -z "$exp" ] || [ "$exp" = "null" ]; then
        return 0
    fi
    
    # Get current timestamp
    local current_time=$(date +%s)
    
    # Check if expired (exp < current_time)
    if [ "$exp" -lt "$current_time" ]; then
        return 0  # Expired
    else
        return 1  # Valid
    fi
}

# Check if jwt was requested
JWT_REQUESTED=0
for var in "${VARS_TO_PROMPT[@]}"; do
    if [ "$var" = "jwt" ]; then
        JWT_REQUESTED=1
        break
    fi
done

# If jwt is requested, check if we already have a value or need to generate it
if [ $JWT_REQUESTED -eq 1 ]; then
    # Check if JWT was already provided (from existing value or user input)
    jwt_value=""
    if echo "$PROMPTED_VARS_LIST" | grep -q "|jwt|"; then
        jwt_value="$NEW_jwt"
    else
        jwt_value="$EXISTING_jwt"
    fi
    
    # Get api_key and user_id values (from prompt or existing) - needed for regeneration
    api_key_value=""
    user_id_value=""
    
    # Check if api_key was prompted
    if echo "$PROMPTED_VARS_LIST" | grep -q "|api_key|"; then
        api_key_value="$NEW_api_key"
    else
        api_key_value="$EXISTING_api_key"
    fi
    
    # Check if user_id was prompted
    if echo "$PROMPTED_VARS_LIST" | grep -q "|user_id|"; then
        user_id_value="$NEW_user_id"
    else
        user_id_value="$EXISTING_user_id"
    fi
    
    # Check if JWT exists and is valid
    if [ -n "$jwt_value" ]; then
        # Check if JWT is expired
        if is_jwt_expired "$jwt_value"; then
            gum style --foreground 3 "⚠ Existing JWT token is expired or invalid"
            # If we have API key and user ID, regenerate automatically
            if [ -n "$api_key_value" ] && [ -n "$user_id_value" ]; then
                gum style --foreground 240 "Regenerating JWT token..."
                echo ""
                jwt_value=""  # Clear expired JWT to trigger regeneration
            else
                gum style --foreground 3 "Cannot auto-regenerate: API key and User ID required"
                gum style --foreground 240 "Please provide api_key and user_id to generate a new JWT"
                echo ""
                # Prompt for JWT manually
                jwt_input=$(gum input --prompt "$(printf '\033[34m%s: \033[0m' 'Courier JWT Token')" --placeholder "Enter your JWT token")
                if [ -n "$jwt_input" ]; then
                    NEW_jwt="$jwt_input"
                    gum style --foreground 10 "✓ Courier JWT Token: (provided)"
                    echo ""
                    # Skip to end of JWT handling
                    jwt_value="SKIP"
                else
                    gum style --foreground 1 --bold "Error: JWT token is required."
                    exit 1
                fi
            fi
        else
            gum style --foreground 10 "✓ Using existing JWT token"
            echo ""
        fi
    fi
    
    # If JWT is not provided or was expired and needs regeneration
    if [ -z "$jwt_value" ] || [ "$jwt_value" != "SKIP" ]; then
        # JWT not provided or needs regeneration, try to generate it
        
        # Check if both are missing - if so, prompt user to provide JWT manually
        if [ -z "$api_key_value" ] && [ -z "$user_id_value" ]; then
            gum style --foreground 3 --bold "⚠ Cannot auto-generate JWT. Both API key and User ID are required."
            gum style --foreground 240 "Please provide JWT token manually or provide api_key and user_id to generate it."
            echo ""
            # Prompt for JWT manually
            jwt_input=$(gum input --prompt "$(printf '\033[34m%s: \033[0m' 'Courier JWT Token')" --placeholder "Enter your JWT token")
            if [ -n "$jwt_input" ]; then
                NEW_jwt="$jwt_input"
                gum style --foreground 10 "✓ Courier JWT Token: (provided)"
            else
                gum style --foreground 1 --bold "Error: JWT token is required."
                exit 1
            fi
            echo ""
        # Check if either is missing - show specific error and prompt for JWT
        elif [ -z "$api_key_value" ]; then
            gum style --foreground 3 --bold "⚠ Cannot auto-generate JWT. API key is required."
            gum style --foreground 240 "Please provide JWT token manually or provide api_key to generate it."
            echo ""
            # Prompt for JWT manually
            jwt_input=$(gum input --prompt "$(printf '\033[34m%s: \033[0m' 'Courier JWT Token')" --placeholder "Enter your JWT token")
            if [ -n "$jwt_input" ]; then
                NEW_jwt="$jwt_input"
                gum style --foreground 10 "✓ Courier JWT Token: (provided)"
            else
                gum style --foreground 1 --bold "Error: JWT token is required."
                exit 1
            fi
            echo ""
        elif [ -z "$user_id_value" ]; then
            gum style --foreground 3 --bold "⚠ Cannot auto-generate JWT. User ID is required."
            gum style --foreground 240 "Please provide user_id to generate JWT token."
            echo ""
            # Prompt for user_id so we can generate JWT
            user_id_input=$(gum input --prompt "$(printf '\033[34m%s: \033[0m' 'Courier User ID')" --placeholder "Enter your user ID")
            if [ -n "$user_id_input" ]; then
                user_id_value="$user_id_input"
                NEW_user_id="$user_id_input"  # Save it so it gets persisted to .env
                gum style --foreground 10 "✓ Courier User ID: $user_id_input"
                echo ""
                # Now generate JWT with the provided user_id
                gum style --foreground 240 "Generating JWT token..."
                echo ""
                
                # Set expiration (default to 30 days)
                EXPIRES_IN_DAYS="${COURIER_EXPIRES_IN_DAYS:-30}"
                
                # Get appropriate scopes based on context
                JWT_SCOPES=$(get_jwt_scopes "$user_id_value")
                
                # Generate JWT token directly using curl
                JWT_RESPONSE=$(curl -s -w "\n%{http_code}" --request POST \
                  --url https://api.courier.com/auth/issue-token \
                  --header 'Accept: application/json' \
                  --header "Authorization: Bearer ${api_key_value}" \
                  --header 'Content-Type: application/json' \
                  --data "{
                    \"scope\": \"${JWT_SCOPES}\", 
                    \"expires_in\": \"${EXPIRES_IN_DAYS} days\"
                  }" 2>&1)
                
                # Extract HTTP status code (last line)
                HTTP_CODE=$(echo "$JWT_RESPONSE" | tail -n 1)
                # Extract response body (all but last line) - macOS compatible
                JWT_BODY=$(echo "$JWT_RESPONSE" | sed '$d')
                
                # Check if request was successful
                if [ "$HTTP_CODE" != "200" ] && [ "$HTTP_CODE" != "201" ]; then
                    gum style --foreground 1 --bold "Error: Failed to generate JWT token (HTTP $HTTP_CODE)"
                    gum style --foreground 240 "Response: $JWT_BODY"
                    exit 1
                fi
                
                # Extract token from JSON response
                # Try using jq if available
                if command -v jq &> /dev/null; then
                    JWT_TOKEN=$(echo "$JWT_BODY" | jq -r '.token // empty' 2>/dev/null)
                fi
                
                # If jq didn't work or isn't available, try sed parsing
                if [ -z "$JWT_TOKEN" ]; then
                    # Try to extract token from JSON: {"token": "value"}
                    JWT_TOKEN=$(echo "$JWT_BODY" | sed -n 's/.*"token"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
                fi
                
                # If still empty, try alternative JSON formats
                if [ -z "$JWT_TOKEN" ]; then
                    # Try compact JSON format: {"token":"value"}
                    JWT_TOKEN=$(echo "$JWT_BODY" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
                fi
                
                # If still empty, the response might be just the token string
                if [ -z "$JWT_TOKEN" ]; then
                    # Remove any JSON wrapper and quotes, trim whitespace
                    JWT_TOKEN=$(echo "$JWT_BODY" | sed 's/^{"token":"\(.*\)"}$/\1/' | sed 's/^"\(.*\)"$/\1/' | xargs)
                fi
                
                # Trim whitespace and newlines
                JWT_TOKEN=$(echo "$JWT_TOKEN" | tr -d '\n\r' | xargs)
                
                if [ -n "$JWT_TOKEN" ] && [ "$JWT_TOKEN" != "null" ]; then
                    NEW_jwt="$JWT_TOKEN"
                    # Show truncated JWT for display (first 50 chars)
                    jwt_display=$(echo "$JWT_TOKEN" | cut -c1-50)
                    gum style --foreground 10 "✓ Courier JWT Token: ${jwt_display}..."
                else
                    gum style --foreground 1 --bold "Error: Failed to generate JWT token"
                    gum style --foreground 240 "Response: $JWT_RESPONSE"
                    exit 1
                fi
            else
                gum style --foreground 1 --bold "Error: User ID is required to generate JWT token."
                exit 1
            fi
            echo ""
        else
            # Both are available, generate JWT
            gum style --foreground 240 "Generating JWT token..."
            echo ""
            
            # Set expiration (default to 30 days)
            EXPIRES_IN_DAYS="${COURIER_EXPIRES_IN_DAYS:-30}"
            
            # Get appropriate scopes based on context
            JWT_SCOPES=$(get_jwt_scopes "$user_id_value")
            
            # Generate JWT token directly using curl
            JWT_RESPONSE=$(curl -s -w "\n%{http_code}" --request POST \
              --url https://api.courier.com/auth/issue-token \
              --header 'Accept: application/json' \
              --header "Authorization: Bearer ${api_key_value}" \
              --header 'Content-Type: application/json' \
              --data "{
                \"scope\": \"${JWT_SCOPES}\", 
                \"expires_in\": \"${EXPIRES_IN_DAYS} days\"
              }" 2>&1)
            
            # Extract HTTP status code (last line)
            HTTP_CODE=$(echo "$JWT_RESPONSE" | tail -n 1)
            # Extract response body (all but last line) - macOS compatible
            JWT_BODY=$(echo "$JWT_RESPONSE" | sed '$d')
            
            # Check if request was successful
            if [ "$HTTP_CODE" != "200" ] && [ "$HTTP_CODE" != "201" ]; then
                gum style --foreground 1 --bold "Error: Failed to generate JWT token (HTTP $HTTP_CODE)"
                gum style --foreground 240 "Response: $JWT_BODY"
                exit 1
            fi
            
            # Extract token from JSON response
            # Try using jq if available
            if command -v jq &> /dev/null; then
                JWT_TOKEN=$(echo "$JWT_BODY" | jq -r '.token // empty' 2>/dev/null)
            fi
            
            # If jq didn't work or isn't available, try sed parsing
            if [ -z "$JWT_TOKEN" ]; then
                # Try to extract token from JSON: {"token": "value"}
                JWT_TOKEN=$(echo "$JWT_BODY" | sed -n 's/.*"token"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
            fi
            
            # If still empty, try alternative JSON formats
            if [ -z "$JWT_TOKEN" ]; then
                # Try compact JSON format: {"token":"value"}
                JWT_TOKEN=$(echo "$JWT_BODY" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
            fi
            
            # If still empty, the response might be just the token string
            if [ -z "$JWT_TOKEN" ]; then
                # Remove any JSON wrapper and quotes, trim whitespace
                JWT_TOKEN=$(echo "$JWT_BODY" | sed 's/^{"token":"\(.*\)"}$/\1/' | sed 's/^"\(.*\)"$/\1/' | xargs)
            fi
            
            # Trim whitespace and newlines
            JWT_TOKEN=$(echo "$JWT_TOKEN" | tr -d '\n\r' | xargs)
            
            if [ -n "$JWT_TOKEN" ] && [ "$JWT_TOKEN" != "null" ]; then
                NEW_jwt="$JWT_TOKEN"
                # Show truncated JWT for display (first 50 chars)
                jwt_display=$(echo "$JWT_TOKEN" | cut -c1-50)
                gum style --foreground 10 "✓ Courier JWT Token: ${jwt_display}..."
            else
                gum style --foreground 1 --bold "Error: Failed to generate JWT token"
                gum style --foreground 240 "Response: $JWT_RESPONSE"
                exit 1
            fi
            echo ""
        fi
    fi
fi

# Function to update .env file while preserving existing variables
update_env_file() {
    local temp_file=$(mktemp)
    local file_has_content=0
    
    # Check if file exists and has content
    if [ -f "$ENV_FILE" ] && [ -s "$ENV_FILE" ]; then
        file_has_content=1
    fi
    
    # Process existing .env file if it exists
    if [ $file_has_content -eq 1 ]; then
        # Preserve existing file structure exactly, only updating specified variables
        while IFS= read -r line || [ -n "$line" ]; do
            # Check if this line contains a variable assignment
            if [[ "$line" =~ = ]]; then
                # Split on first '=' to handle values that contain '='
                key="${line%%=*}"
                key=$(echo "$key" | xargs)  # Remove whitespace
                
                # Check if this key should be updated
                should_update=0
                updated_value=""
                for var in "${VARS_TO_PROMPT[@]}"; do
                    env_key=$(get_env_key "$var")
                    if [ "$key" = "$env_key" ]; then
                        should_update=1
                        eval "updated_value=\$NEW_${var}"
                        break
                    fi
                    # Check for VITE_COURIER_USER_ID update
                    if [ "$var" = "user_id" ] && [ "$key" = "VITE_COURIER_USER_ID" ]; then
                        should_update=1
                        eval "updated_value=\$NEW_${var}"
                        break
                    fi
                done
                
                # Also check if user_id was provided during JWT generation but wasn't in prompt list
                if [ $should_update -eq 0 ] && [ -n "$NEW_user_id" ]; then
                    user_id_env_key=$(get_env_key "user_id")
                    if [ "$key" = "$user_id_env_key" ] || [ "$key" = "VITE_COURIER_USER_ID" ]; then
                        should_update=1
                        updated_value="$NEW_user_id"
                    fi
                fi
                
                # If this key should be updated
                if [ $should_update -eq 1 ]; then
                    # If value is empty (user skipped optional field), skip writing this line (remove it)
                    if [ -z "$updated_value" ]; then
                        # Skip this line - effectively removes the variable from .env
                        continue
                    else
                        # Write the new value
                        quoted_value=$(quote_if_needed "$updated_value")
                        printf '%s=%s\n' "$key" "$quoted_value" >> "$temp_file"
                        continue
                    fi
                fi
            fi
            
            # Preserve the line as-is (including empty lines, comments, and non-updated variables)
            printf '%s\n' "$line" >> "$temp_file"
        done < "$ENV_FILE"
        
        # Add any new variables that weren't in the file (only if they have values)
        for var in "${VARS_TO_PROMPT[@]}"; do
            env_key=$(get_env_key "$var")
            eval "value=\$NEW_${var}"
            
            # Check if this variable already exists in the file
            if ! grep -q "^[[:space:]]*${env_key}=" "$ENV_FILE" 2>/dev/null; then
                # Variable doesn't exist, add it
                if [ -n "$value" ]; then
                    quoted_value=$(quote_if_needed "$value")
                    printf '%s=%s\n' "$env_key" "$quoted_value" >> "$temp_file"
                fi
            fi
            
            # For user_id, also check/add VITE_COURIER_USER_ID
            if [ "$var" = "user_id" ] && [ -n "$value" ]; then
                if ! grep -q "^[[:space:]]*VITE_COURIER_USER_ID=" "$ENV_FILE" 2>/dev/null; then
                    quoted_value=$(quote_if_needed "$value")
                    printf '%s=%s\n' "VITE_COURIER_USER_ID" "$quoted_value" >> "$temp_file"
                fi
            fi
            
            # For jwt, also check/add COURIER_JWT (for vanilla web components)
            if [ "$var" = "jwt" ] && [ -n "$value" ]; then
                if ! grep -q "^[[:space:]]*COURIER_JWT=" "$ENV_FILE" 2>/dev/null; then
                    quoted_value=$(quote_if_needed "$value")
                    printf '%s=%s\n' "COURIER_JWT" "$quoted_value" >> "$temp_file"
                fi
            fi
        done
        
        # Also save user_id if it was provided during JWT generation but wasn't in the prompt list
        if [ -n "$NEW_user_id" ] && ! echo "$PROMPTED_VARS_LIST" | grep -q "|user_id|"; then
            env_key=$(get_env_key "user_id")
            # Check if this variable already exists in the file
            if ! grep -q "^[[:space:]]*${env_key}=" "$ENV_FILE" 2>/dev/null; then
                quoted_value=$(quote_if_needed "$NEW_user_id")
                printf '%s=%s\n' "$env_key" "$quoted_value" >> "$temp_file"
            fi
            # Also add VITE_COURIER_USER_ID if it doesn't exist
            if ! grep -q "^[[:space:]]*VITE_COURIER_USER_ID=" "$ENV_FILE" 2>/dev/null; then
                quoted_value=$(quote_if_needed "$NEW_user_id")
                printf '%s=%s\n' "VITE_COURIER_USER_ID" "$quoted_value" >> "$temp_file"
            fi
        fi
    else
        # New file - add header
        echo "# Courier Environment Variables" > "$temp_file"
        echo "# Generated/Updated by set-env.sh" >> "$temp_file"
        echo "" >> "$temp_file"
        
        # Add all prompted variables
        for var in "${VARS_TO_PROMPT[@]}"; do
            env_key=$(get_env_key "$var")
            eval "value=\$NEW_${var}"
            if [ -n "$value" ]; then
                quoted_value=$(quote_if_needed "$value")
                printf '%s=%s\n' "$env_key" "$quoted_value" >> "$temp_file"
            fi
            
            # For user_id, also write VITE_COURIER_USER_ID with the same value
            if [ "$var" = "user_id" ] && [ -n "$value" ]; then
                quoted_value=$(quote_if_needed "$value")
                printf '%s=%s\n' "VITE_COURIER_USER_ID" "$quoted_value" >> "$temp_file"
            fi
            
            # For jwt, also write COURIER_JWT (for vanilla web components)
            if [ "$var" = "jwt" ] && [ -n "$value" ]; then
                quoted_value=$(quote_if_needed "$value")
                printf '%s=%s\n' "COURIER_JWT" "$quoted_value" >> "$temp_file"
            fi
        done
        
        # Also save user_id if it was provided during JWT generation but wasn't in the prompt list
        if [ -n "$NEW_user_id" ] && ! echo "$PROMPTED_VARS_LIST" | grep -q "|user_id|"; then
            env_key=$(get_env_key "user_id")
            quoted_value=$(quote_if_needed "$NEW_user_id")
            printf '%s=%s\n' "$env_key" "$quoted_value" >> "$temp_file"
            # Also add VITE_COURIER_USER_ID
            quoted_value=$(quote_if_needed "$NEW_user_id")
            printf '%s=%s\n' "VITE_COURIER_USER_ID" "$quoted_value" >> "$temp_file"
        fi
    fi
    
    # Replace the original file
    mv "$temp_file" "$ENV_FILE"
}

# Update .env file while preserving existing variables
update_env_file

gum style --foreground 10 "✓ Environment variables have been saved to $ENV_FILE"
echo ""

# Show a friendly summary message at the end
gum style --foreground 212 --bold "🚀 Running: $TITLE"
echo ""

