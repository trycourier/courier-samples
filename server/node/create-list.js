import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

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

