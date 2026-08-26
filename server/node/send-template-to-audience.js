import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

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

console.log(response);

