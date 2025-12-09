import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
list_id = os.getenv("COURIER_SEND_TEMPLATE_TO_LIST_LIST_ID")
template_id = os.getenv("COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID")

client = Courier(api_key=api_key)

response = client.send.message(
    message={
        "to": {
            "list_id": list_id
        },
        "template": template_id,
    },
)

print(response)

