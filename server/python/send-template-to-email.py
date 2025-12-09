import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

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

print(response)

