import Courier from '@trycourier/courier';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: join(__dirname, '..', '.env') });

const apiKey = process.env.COURIER_API_KEY;
const userId = process.env.COURIER_GET_USER_PROFILE_USER_ID;

const client = new Courier({ apiKey });

const response = await client.profiles.retrieve(userId);

console.log(response);

