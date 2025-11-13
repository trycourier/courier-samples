import os
import json
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

# Load environment variables from .env file in server directory (shared across all language examples)
load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
list_id = os.getenv("COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID")
user_id = os.getenv("COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID")

client = Courier(api_key=api_key)

response = client.lists.subscriptions.subscribe_user(
    list_id=list_id,
    user_id=user_id,
)

# Print response as JSON (handles None responses)
if response is None:
    print(json.dumps({"status": "success", "message": "User subscribed successfully"}, indent=2))
elif hasattr(response, 'to_dict'):
    print(json.dumps(response.to_dict(), indent=2))
elif hasattr(response, 'model_dump'):
    result = response.model_dump(by_alias=False)
    print(json.dumps(result, indent=2))
elif hasattr(response, 'dict'):
    result = response.dict(by_alias=False)
    print(json.dumps(result, indent=2))
else:
    print(json.dumps(response, indent=2))

