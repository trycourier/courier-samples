import os
import json
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

# Load environment variables from .env file in server directory (shared across all language examples)
load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
list_id = os.getenv("COURIER_CREATE_LIST_LIST_ID")
list_name = os.getenv("COURIER_CREATE_LIST_LIST_NAME", "My List Name")

client = Courier(api_key=api_key)

response = client.lists.update(
    list_id=list_id,
    name=list_name,
    preferences={
        "categories": {},
        "notifications": {}
    }
)

# Print response as JSON (use to_dict() to get clean dict, then serialize)
# Note: lists.update() returns None on success, so we print a success message
if response is None:
    print(json.dumps({
        "success": True,
        "message": f"List '{list_id}' created/updated successfully",
        "list_id": list_id,
        "list_name": list_name
    }, indent=2))
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

