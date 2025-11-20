import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
list_id = os.getenv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID")
user_id = os.getenv("COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID")

client = Courier(api_key=api_key)

client.lists.subscriptions.unsubscribe_user(
    list_id=list_id,
    user_id=user_id,
)

