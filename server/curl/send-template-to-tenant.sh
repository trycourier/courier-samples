#!/bin/bash

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file in script directory
if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(cat "$SCRIPT_DIR/.env" | grep -v '^#' | xargs)
fi

curl -s --request POST \
--url https://api.courier.com/send \
--header "Authorization: Bearer ${COURIER_API_KEY}" \
--header 'Content-Type: application/json' \
--data "{
  \"message\": {
    \"to\": {
      \"tenant_id\": \"${COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID}\"
    },
    \"template\": \"${COURIER_SEND_TEMPLATE_TO_TENANT_ID_TEMPLATE_ID}\",
    \"data\": {
      \"name\": \"Your Name\"
    }
  }
}"