import Courier from '@trycourier/courier';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Load environment variables from .env file in server directory (shared across all language examples)
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const envPath = join(__dirname, '..', '.env');
dotenv.config({ path: envPath });

const apiKey = process.env.COURIER_API_KEY;
const userId = process.env.COURIER_UPSERT_USER_USER_ID;
const email = process.env.COURIER_UPSERT_USER_EMAIL;
const name = process.env.COURIER_UPSERT_USER_NAME;
const phoneNumber = process.env.COURIER_UPSERT_USER_PHONE_NUMBER;

const client = new Courier({ apiKey });

// Build profile object dynamically, only including fields that are set
// Note: All profile fields are optional. If you skip them, an empty profile will be created.
const profile = {};
if (email) {
  profile.email = email;
}
if (name) {
  profile.name = name;
}
if (phoneNumber) {
  profile.phone_number = phoneNumber;
}

const response = await client.profiles.create(userId, {
  profile
});

console.log(JSON.stringify(response, null, 2));

