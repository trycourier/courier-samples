import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
user_id = os.getenv("COURIER_GET_USER_PROFILE_USER_ID")

client = Courier(api_key=api_key)

response = client.profiles.retrieve(user_id=user_id)

print(response)

