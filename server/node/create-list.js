import Courier from '@trycourier/courier';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: join(__dirname, '..', '.env') });

const apiKey = process.env.COURIER_API_KEY;
const listId = process.env.COURIER_CREATE_LIST_LIST_ID;
const listName = process.env.COURIER_CREATE_LIST_LIST_NAME || 'My List Name';

const client = new Courier({ apiKey });

await client.lists.update(listId, {
  name: listName,
  preferences: {
    categories: {},
    notifications: {}
  }
});

