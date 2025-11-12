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
const userId = process.env.COURIER_SEND_TEMPLATE_TO_USER_ID_USER_ID;
const templateId = process.env.COURIER_SEND_TEMPLATE_TO_USER_ID_TEMPLATE_ID;

const client = new Courier({ apiKey });

const response = await client.send.message({
  message: {
    to: {
      user_id: userId
    },
    template: templateId,
    data: {
      name: 'Your Name'
    }
  }
});

console.log(JSON.stringify(response, null, 2));

