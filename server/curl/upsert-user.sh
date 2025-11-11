#!/bin/bash

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables from .env file in script directory
if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(cat "$SCRIPT_DIR/.env" | grep -v '^#' | xargs)
fi

# Set the variables from environment or prompt
# Note: All profile fields are optional. If you skip them, an empty profile will be created.
AUTH_KEY="${COURIER_API_KEY:-$YOUR_AUTH_KEY}"
USER_ID="${COURIER_UPSERT_USER_USER_ID:-$YOUR_USER_ID}"
EMAIL="${COURIER_UPSERT_USER_EMAIL:-}"
NAME="${COURIER_UPSERT_USER_NAME:-}"
PHONE_NUMBER="${COURIER_UPSERT_USER_PHONE_NUMBER:-}"

# Build the profile object dynamically, only including fields that are set
PROFILE_JSON="{"
if [ -n "$EMAIL" ]; then
  PROFILE_JSON="${PROFILE_JSON}\"email\": \"${EMAIL}\""
fi
if [ -n "$NAME" ]; then
  if [ "$PROFILE_JSON" != "{" ]; then
    PROFILE_JSON="${PROFILE_JSON}, "
  fi
  PROFILE_JSON="${PROFILE_JSON}\"name\": \"${NAME}\""
fi
if [ -n "$PHONE_NUMBER" ]; then
  if [ "$PROFILE_JSON" != "{" ]; then
    PROFILE_JSON="${PROFILE_JSON}, "
  fi
  PROFILE_JSON="${PROFILE_JSON}\"phone_number\": \"${PHONE_NUMBER}\""
fi
PROFILE_JSON="${PROFILE_JSON}}"

curl --request POST \
  --url "https://api.courier.com/profiles/${USER_ID}" \
  --header 'Accept: application/json' \
  --header "Authorization: Bearer ${AUTH_KEY}" \
  --header 'Content-Type: application/json' \
  --data "{
    \"profile\": ${PROFILE_JSON}
  }"

