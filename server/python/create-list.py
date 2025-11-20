import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
list_id = os.getenv("COURIER_CREATE_LIST_LIST_ID")
list_name = os.getenv("COURIER_CREATE_LIST_LIST_NAME", "My List Name")

client = Courier(api_key=api_key)

client.lists.update(
    list_id=list_id,
    name=list_name,
    preferences={
        "categories": {},
        "notifications": {}
    }
)

