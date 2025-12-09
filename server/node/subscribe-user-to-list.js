import Courier from '@trycourier/courier';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: join(__dirname, '..', '.env') });

const apiKey = process.env.COURIER_API_KEY;
const listId = process.env.COURIER_SUBSCRIBE_USER_TO_LIST_LIST_ID;
const userId = process.env.COURIER_SUBSCRIBE_USER_TO_LIST_USER_ID;

const client = new Courier({ apiKey });

await client.lists.subscriptions.subscribeUser(userId, {
  list_id: listId,
  preferences: {
    categories: {},
    notifications: {}
  }
});

