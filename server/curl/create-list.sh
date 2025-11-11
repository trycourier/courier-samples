#!/bin/bash

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file in script directory
if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(cat "$SCRIPT_DIR/.env" | grep -v '^#' | xargs)
fi

# Set the variables from environment or prompt
AUTH_KEY="${COURIER_API_KEY:-$YOUR_AUTH_KEY}"
LIST_ID="${COURIER_LIST_ID:-$YOUR_LIST_ID}"
LIST_NAME="${COURIER_LIST_NAME:-My List Name}"

curl --request PUT \
  --url "https://api.courier.com/lists/${LIST_ID}" \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${AUTH_KEY}" \
  --header 'Content-Type: application/json' \
  --data "{
    \"name\": \"${LIST_NAME}\",
    \"preferences\": {
      \"categories\": {},
      \"notifications\": {}
    }
  }"

