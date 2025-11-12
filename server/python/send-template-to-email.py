import os
import json
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

# Load environment variables from .env file in server/curl directory (shared with curl scripts)
load_dotenv(Path(__file__).parent.parent / "curl" / ".env")

api_key = os.getenv("COURIER_API_KEY")
email = os.getenv("COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL")
template_id = os.getenv("COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID")

client = Courier(api_key=api_key)

response = client.send.message(
    message={
        "to": {
            "email": email
        },
        "template": template_id,
        "data": {
            "name": "Your Name"
        },
    },
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

