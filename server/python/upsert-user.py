import os
from pathlib import Path
from dotenv import load_dotenv
from courier import Courier

load_dotenv(Path(__file__).parent.parent / ".env")

api_key = os.getenv("COURIER_API_KEY")
user_id = os.getenv("COURIER_UPSERT_USER_USER_ID")
email = os.getenv("COURIER_UPSERT_USER_EMAIL")
name = os.getenv("COURIER_UPSERT_USER_NAME")
phone_number = os.getenv("COURIER_UPSERT_USER_PHONE_NUMBER")

client = Courier(api_key=api_key)

profile = {}
if email: profile["email"] = email
if name: profile["name"] = name
if phone_number: profile["phone_number"] = phone_number

response = client.profiles.create(
    user_id=user_id,
    profile=profile
)

print(response)

