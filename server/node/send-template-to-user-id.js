import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

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

console.log(response);

