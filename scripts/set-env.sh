#!/bin/bash

# Script to set environment variables using gum input
# Usage: ./set-env.sh [api_key] [user_id] [email] ...
# This script updates only the specified variables, preserving all other existing values
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
ENV_FILE="$PROJECT_ROOT/.env"

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

# Function to normalize variable name (api_key -> COURIER_API_KEY)
normalize_var_name() {
    local var=$1
    # Convert to uppercase and add COURIER_ prefix
    echo "COURIER_$(echo "$var" | tr '[:lower:]' '[:upper:]' | tr '-' '_')"
}

# Function to get display name for variable
get_display_name() {
    local var=$1
    case "$var" in
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
        *)
            # Default: capitalize and replace underscores with spaces
            echo "$var" | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g'
            ;;
    esac
}

# Function to get help message for variable
get_help_message() {
    local var=$1
    case "$var" in
        api_key|API_KEY)
            echo "Get your API key here: https://app.courier.com/settings/api-keys"
            ;;
        user_id|USER_ID)
            echo "This is an id that you make up. Usually, developers match it to the user id's in their user database of their app"
            ;;
        template_id|TEMPLATE_ID)
            echo "The ID of the notification template you want to send. Find templates in: https://app.courier.com/designer/templates"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Parse command-line arguments
VARS_TO_PROMPT=()
for arg in "$@"; do
    # Normalize the argument (handle both api_key and API_KEY)
    normalized=$(echo "$arg" | tr '[:upper:]' '[:lower:]' | tr '-' '_')
    VARS_TO_PROMPT+=("$normalized")
done

# If no arguments provided, prompt for all default variables
if [ ${#VARS_TO_PROMPT[@]} -eq 0 ]; then
    VARS_TO_PROMPT=("api_key" "user_id" "email")
fi

# Function to get env key for a variable
get_env_key() {
    local var=$1
    case "$var" in
        api_key)
            echo "COURIER_API_KEY"
            ;;
        user_id)
            echo "COURIER_USER_ID"
            ;;
        email)
            echo "COURIER_EMAIL"
            ;;
        jwt)
            echo "VITE_COURIER_JWT"
            ;;
        template_id)
            echo "COURIER_TEMPLATE_ID"
            ;;
        *)
            # For custom variables, normalize the name
            normalize_var_name "$var"
            ;;
    esac
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

# Display header
gum style --foreground 212 --bold "Courier Environment Variables Setup"
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
        *)
            existing_value=$(get_env_value "$env_key")
            ;;
    esac
    
    # Mark this variable as prompted
    PROMPTED_VARS_LIST="$PROMPTED_VARS_LIST|$var"
    
    # Show help message if available
    if [ -n "$help_message" ]; then
        gum style --foreground 240 "$help_message"
        echo ""
    fi
    
    # Skip prompting for jwt - we'll generate it if needed
    if [ "$var" = "jwt" ]; then
        # Mark jwt as prompted but don't ask for it yet
        # We'll generate it after checking for api_key and user_id
        eval "NEW_${var}=\"\""
    else
        # Prompt for the value
        new_value=$(gum input --placeholder "Enter $display_name" --prompt "$display_name: " --value "$existing_value")
        eval "NEW_${var}=\"\$new_value\""
    fi
    
    echo ""
done

# Check if jwt was requested
JWT_REQUESTED=0
for var in "${VARS_TO_PROMPT[@]}"; do
    if [ "$var" = "jwt" ]; then
        JWT_REQUESTED=1
        break
    fi
done

# If jwt is requested, check if api_key and user_id are available
if [ $JWT_REQUESTED -eq 1 ]; then
    # Get api_key value (from prompt or existing)
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
    
    # Check if both are missing - if so, end the script
    if [ -z "$api_key_value" ] && [ -z "$user_id_value" ]; then
        gum style --foreground 1 --bold "Error: Cannot generate JWT. Both API key and User ID are required."
        echo "Please provide api_key and user_id before generating jwt."
        exit 1
    fi
    
    # Check if either is missing - show specific error
    if [ -z "$api_key_value" ]; then
        gum style --foreground 1 --bold "Error: Cannot generate JWT. API key is required."
        echo "Please provide api_key before generating jwt."
        exit 1
    fi
    
    if [ -z "$user_id_value" ]; then
        gum style --foreground 1 --bold "Error: Cannot generate JWT. User ID is required."
        echo "Please provide user_id before generating jwt."
        exit 1
    fi
    
    # Both are available, generate JWT
    gum style --foreground 240 "Generating JWT token..."
    echo ""
    
    # Set expiration (default to 30 days)
    EXPIRES_IN_DAYS="${COURIER_EXPIRES_IN_DAYS:-30}"
    
    # Generate JWT token directly using curl
    JWT_RESPONSE=$(curl -s -w "\n%{http_code}" --request POST \
      --url https://api.courier.com/auth/issue-token \
      --header 'Accept: application/json' \
      --header "Authorization: Bearer ${api_key_value}" \
      --header 'Content-Type: application/json' \
      --data "{
        \"scope\": \"user_id:${user_id_value} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands\", 
        \"expires_in\": \"${EXPIRES_IN_DAYS} days\"
      }" 2>&1)
    
    # Extract HTTP status code (last line)
    HTTP_CODE=$(echo "$JWT_RESPONSE" | tail -n 1)
    # Extract response body (all but last line) - macOS compatible
    JWT_BODY=$(echo "$JWT_RESPONSE" | sed '$d')
    
    # Check if request was successful
    if [ "$HTTP_CODE" != "200" ] && [ "$HTTP_CODE" != "201" ]; then
        gum style --foreground 1 --bold "Error: Failed to generate JWT token (HTTP $HTTP_CODE)"
        echo "Response: $JWT_BODY"
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
        gum style --foreground 10 "✓ JWT token generated successfully"
    else
        gum style --foreground 1 --bold "Error: Failed to generate JWT token"
        echo "Response: $JWT_RESPONSE"
        exit 1
    fi
    echo ""
fi

# Function to update .env file while preserving existing variables
update_env_file() {
    local temp_file=$(mktemp)
    
    # Write header
    echo "# Courier Environment Variables" > "$temp_file"
    echo "# Generated/Updated by set-env.sh" >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Process existing .env file if it exists
    if [ -f "$ENV_FILE" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            # Skip header comments (we'll add our own)
            if [[ "$line" =~ "Courier Environment Variables" ]] || [[ "$line" =~ "Generated" ]] || [[ "$line" =~ "Updated" ]]; then
                continue
            fi
            
            # Preserve empty lines
            if [[ -z "$line" ]]; then
                echo "" >> "$temp_file"
                continue
            fi
            
            # Preserve non-header comments
            if [[ "$line" =~ ^[[:space:]]*# ]]; then
                echo "$line" >> "$temp_file"
                continue
            fi
            
            # Check if this line contains a variable assignment
            if [[ "$line" =~ = ]]; then
                # Split on first '=' to handle values that contain '='
                key="${line%%=*}"
                key=$(echo "$key" | xargs)  # Remove whitespace
                
                # Check if this key should be updated
                should_update=0
                for var in "${VARS_TO_PROMPT[@]}"; do
                    env_key=$(get_env_key "$var")
                    if [ "$key" = "$env_key" ]; then
                        should_update=1
                        break
                    fi
                    # Check for VITE_COURIER_USER_ID update
                    if [ "$var" = "user_id" ] && [ "$key" = "VITE_COURIER_USER_ID" ]; then
                        should_update=1
                        break
                    fi
                done
                
                # If this key should be updated, skip it (we'll write the new value later)
                if [ $should_update -eq 1 ]; then
                    continue
                fi
                
                # Otherwise, preserve the existing line
                echo "$line" >> "$temp_file"
            else
                # Preserve non-variable lines
                echo "$line" >> "$temp_file"
            fi
        done < "$ENV_FILE"
    fi
    
    # Add/update the prompted variables
    for var in "${VARS_TO_PROMPT[@]}"; do
        env_key=$(get_env_key "$var")
        eval "value=\$NEW_${var}"
        echo "${env_key}=${value}" >> "$temp_file"
        
        # For user_id, also write VITE_COURIER_USER_ID with the same value
        if [ "$var" = "user_id" ]; then
            echo "VITE_COURIER_USER_ID=${value}" >> "$temp_file"
        fi
    done
    
    # Replace the original file
    mv "$temp_file" "$ENV_FILE"
}

# Update .env file while preserving existing variables
update_env_file

echo ""
gum style --foreground 10 "✓ Environment variables have been saved to $ENV_FILE"

