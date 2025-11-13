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
const email = process.env.COURIER_SEND_TEMPLATE_TO_EMAIL_EMAIL;
const templateId = process.env.COURIER_SEND_TEMPLATE_TO_EMAIL_TEMPLATE_ID;

const client = new Courier({ apiKey });

const response = await client.send.message({
  message: {
    to: {
      email: email
    },
    template: templateId,
    data: {
      name: 'Your Name'
    }
  }
});

console.log(JSON.stringify(response, null, 2));

