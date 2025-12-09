import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
user_id = os.getenv("COURIER_GENERATE_JWT_USER_ID")
expires_in_days = os.getenv("COURIER_EXPIRES_IN_DAYS", "30")

client = Courier(api_key=api_key)

response = client.auth.issue_token(
    scope=f"user_id:{user_id} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands",
    expires_in=f"{expires_in_days} days"
)

print(response)

