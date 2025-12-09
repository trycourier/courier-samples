import Courier from '@trycourier/courier';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: join(__dirname, '..', '.env') });

const apiKey = process.env.COURIER_API_KEY;
const userId = process.env.COURIER_GENERATE_JWT_USER_ID;
const expiresInDays = process.env.COURIER_EXPIRES_IN_DAYS || '30';

const client = new Courier({ apiKey });

const response = await client.auth.issueToken({
  scope: `user_id:${userId} write:user-tokens inbox:read:messages inbox:write:events read:preferences write:preferences read:brands`,
  expiresIn: `${expiresInDays} days`
});

console.log(response);

