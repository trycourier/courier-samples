#!/bin/bash

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load environment variables from .env file in server directory (shared across all language examples)
if [ -f "$SERVER_DIR/.env" ]; then
  export $(cat "$SERVER_DIR/.env" | grep -v '^#' | xargs)
fi

# Set the variables from environment or prompt
AUTH_KEY="${COURIER_API_KEY:-$YOUR_AUTH_KEY}"
USER_ID="${COURIER_GET_USER_PROFILE_USER_ID:-$YOUR_USER_ID}"

curl -s --request GET \
  --url "https://api.courier.com/profiles/${USER_ID}" \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${AUTH_KEY}"

