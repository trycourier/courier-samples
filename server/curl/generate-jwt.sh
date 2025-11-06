#!/bin/bash

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load environment variables from .env file in project root
if [ -f "$PROJECT_ROOT/.env" ]; then
  export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | xargs)
fi

# Set the variables from environment or prompt (YOUR_AUTH_KEY, YOUR_USER_ID, YOUR_NUMBER)
AUTH_KEY="${COURIER_API_KEY:-$YOUR_AUTH_KEY}"
USER_ID="${COURIER_USER_ID:-$YOUR_USER_ID}"
EXPIRES_IN_DAYS="${COURIER_EXPIRES_IN_DAYS:-30}" # Default to 30 days if not set

curl --request POST \
  --url https://api.courier.com/auth/issue-token \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${AUTH_KEY}" \
  --header 'Content-Type: application/json' \
  --data "{
    \"scope\": \"user_id:${USER_ID} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands\", 
    \"expires_in\": \"${EXPIRES_IN_DAYS} days\"
  }"