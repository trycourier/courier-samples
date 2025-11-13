import os
import json
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

# Load environment variables from .env file in server directory (shared across all language examples)
load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
user_id = os.getenv("COURIER_UPSERT_USER_USER_ID")
email = os.getenv("COURIER_UPSERT_USER_EMAIL")
name = os.getenv("COURIER_UPSERT_USER_NAME")
phone_number = os.getenv("COURIER_UPSERT_USER_PHONE_NUMBER")

client = Courier(api_key=api_key)

# Build profile object dynamically, only including fields that are set
# Note: All profile fields are optional. If you skip them, an empty profile will be created.
profile = {}
if email:
    profile["email"] = email
if name:
    profile["name"] = name
if phone_number:
    profile["phone_number"] = phone_number

response = client.profiles.create(
    user_id=user_id,
    profile=profile
)

# Print response as JSON (use to_dict() to get clean dict, then serialize)
if hasattr(response, 'to_dict'):
    print(json.dumps(response.to_dict(), indent=2))
elif hasattr(response, 'model_dump'):
    result = response.model_dump(by_alias=False)
    print(json.dumps(result, indent=2))
elif hasattr(response, 'dict'):
    result = response.dict(by_alias=False)
    print(json.dumps(result, indent=2))
else:
    print(json.dumps(response, indent=2))

