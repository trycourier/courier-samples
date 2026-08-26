import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

const apiKey = process.env.COURIER_API_KEY;
const listId = process.env.COURIER_UNSUBSCRIBE_USER_FROM_LIST_LIST_ID;
const userId = process.env.COURIER_UNSUBSCRIBE_USER_FROM_LIST_USER_ID;

const client = new Courier({ apiKey });

await client.lists.subscriptions.unsubscribeUser(userId, {
  list_id: listId
});

