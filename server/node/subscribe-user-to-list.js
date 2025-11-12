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
const listId = process.env.COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID;
const userId = process.env.COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID;

const client = new Courier({ apiKey });

try {
  const response = await client.lists.subscriptions.subscribeUser(userId, {
    list_id: listId,
    preferences: {
      categories: {},
      notifications: {}
    }
  });

  // Handle None/null responses
  if (response === null || response === undefined) {
    console.log(JSON.stringify({
      status: 'success',
      message: 'User subscribed successfully'
    }, null, 2));
  } else {
    console.log(JSON.stringify(response, null, 2));
  }
  process.exit(0);
} catch (error) {
  console.error('Error:', error.message);
  process.exit(1);
}

