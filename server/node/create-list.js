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
const listId = process.env.COURIER_CREATE_LIST_LIST_ID;
const listName = process.env.COURIER_CREATE_LIST_LIST_NAME || 'My List Name';

const client = new Courier({ apiKey });

try {
  await client.lists.update(listId, {
    name: listName,
    preferences: {
      categories: {},
      notifications: {}
    }
  });

  // lists.update returns void, so always print success message
  console.log(JSON.stringify({
    status: 'success',
    message: 'List created successfully',
    list_id: listId,
    name: listName
  }, null, 2));
  process.exit(0);
} catch (error) {
  console.error('Error:', error.message);
  process.exit(1);
}

