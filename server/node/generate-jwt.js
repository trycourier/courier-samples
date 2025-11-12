import Courier from '@trycourier/courier';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Load environment variables from .env file in server/curl directory (shared with curl scripts)
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const envPath = join(__dirname, '..', 'curl', '.env');
dotenv.config({ path: envPath });

const apiKey = process.env.COURIER_API_KEY;
const userId = process.env.COURIER_GENERATE_JWT_USER_ID;
const expiresInDays = process.env.COURIER_EXPIRES_IN_DAYS || '30';

const client = new Courier({ apiKey });

const response = await client.auth.issueToken({
  scope: `user_id:${userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands`,
  expiresIn: `${expiresInDays} days`
});

console.log(JSON.stringify(response, null, 2));

