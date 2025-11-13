import os
import json
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

# Load environment variables from .env file in server directory (shared across all language examples)
load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
user_id = os.getenv("COURIER_GENERATE_JWT_USER_ID")
expires_in_days = os.getenv("COURIER_EXPIRES_IN_DAYS", "30")

client = Courier(api_key=api_key)

response = client.auth.issue_token(
    scope=f"user_id:{user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
    expires_in=f"{expires_in_days} days"
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

