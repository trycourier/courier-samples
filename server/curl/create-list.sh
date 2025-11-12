#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(cat "$SCRIPT_DIR/.env" | grep -v '^#' | xargs)
fi

AUTH_KEY="${COURIER_API_KEY:-}"
LIST_ID="${COURIER_CREATE_LIST_LIST_ID:-newsletter-subscribers}"
LIST_NAME="${COURIER_CREATE_LIST_LIST_NAME:-Newsletter Subscribers}"

curl -s --request PUT \
  --url "https://api.courier.com/lists/${LIST_ID}" \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${AUTH_KEY}" \
  --header 'Content-Type: application/json' \
  --data "{\"name\": \"${LIST_NAME}\"}"

