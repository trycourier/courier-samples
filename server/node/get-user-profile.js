import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

const apiKey = process.env.COURIER_API_KEY;
const userId = process.env.COURIER_GET_USER_PROFILE_USER_ID;

const client = new Courier({ apiKey });

const response = await client.profiles.retrieve(userId);

console.log(response);

