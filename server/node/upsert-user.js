import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

const apiKey = process.env.COURIER_API_KEY;
const userId = process.env.COURIER_UPSERT_USER_USER_ID;
const email = process.env.COURIER_UPSERT_USER_EMAIL;
const name = process.env.COURIER_UPSERT_USER_NAME;
const phoneNumber = process.env.COURIER_UPSERT_USER_PHONE_NUMBER;

const client = new Courier({ apiKey });

const profile = {};
if (email) profile.email = email;
if (name) profile.name = name;
if (phoneNumber) profile.phone_number = phoneNumber;

const response = await client.profiles.create(userId, { profile });

console.log(response);

