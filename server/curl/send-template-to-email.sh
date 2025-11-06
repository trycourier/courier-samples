#!/bin/bash

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Load environment variables from .env file in project root
if [ -f "$PROJECT_ROOT/.env" ]; then
  export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | xargs)
fi

curl --request POST \
--url https://api.courier.com/send \
--header "Authorization: Bearer ${COURIER_API_KEY}" \
--header 'Content-Type: application/json' \
--data "{
  \"message\": {
    \"to\": {
      \"email\": \"${COURIER_EMAIL}\"
    },
    \"template\": \"${COURIER_TEMPLATE_ID}\",
    \"data\": {
      \"name\": \"Your Name\"
    }
  }
}"