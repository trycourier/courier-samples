#!/bin/bash

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load environment variables from .env file in server directory (shared across all language examples)
if [ -f "$SERVER_DIR/.env" ]; then
  export $(cat "$SERVER_DIR/.env" | grep -v '^#' | xargs)
fi

curl -s --request POST \
--url https://api.courier.com/send \
--header "Authorization: Bearer ${COURIER_API_KEY}" \
--header 'Content-Type: application/json' \
--data "{
  \"message\": {
    \"to\": {
      \"list_id\": \"${COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID}\"
    },
    \"template\": \"${COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID}\"
  }
}"

