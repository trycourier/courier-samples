import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
user_id = os.getenv("COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID")
template_id = os.getenv("COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID")

client = Courier(api_key=api_key)

response = client.send.message(
    message={
        "to": {
            "user_id": user_id
        },
        "template": template_id,
        "data": {
            "name": "Your Name"
        },
    },
)

print(response)

