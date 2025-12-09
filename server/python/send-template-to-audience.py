import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
audience_id = os.getenv("COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID")
template_id = os.getenv("COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID")

client = Courier(api_key=api_key)

response = client.send.message(
    message={
        "to": {
            "audience_id": audience_id
        },
        "template": template_id,
    },
)

print(response)

