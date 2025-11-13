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
const audienceId = process.env.COURIER_SEND_TEMPLATE_TO_AUDIENCE_AUDIENCE_ID;
const templateId = process.env.COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID;

const client = new Courier({ apiKey });

const response = await client.send.message({
  message: {
    to: {
      audience_id: audienceId
    },
    template: templateId
  }
});

console.log(JSON.stringify(response, null, 2));

