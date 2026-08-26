import Courier from '@trycourier/courier';
import dotenv from 'dotenv';

dotenv.config({ path: new URL('../.env', import.meta.url) });

const apiKey = process.env.COURIER_API_KEY;
const tenantId = process.env.COURIER_SEND_TEMPLATE_TO_TENANT_TENANT_ID;
const templateId = process.env.COURIER_SEND_TEMPLATE_TO_LIST_TEMPLATE_ID;

const client = new Courier({ apiKey });

const response = await client.send.message({
  message: {
    to: {
      tenant_id: tenantId
    },
    template: templateId
  }
});

console.log(response);

