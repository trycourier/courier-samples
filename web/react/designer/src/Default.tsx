import { useEffect, useState } from 'react'
import "@trycourier/react-designer/styles.css";

import { TemplateEditor, TemplateProvider } from '@trycourier/react-designer'

export default function App() {

  const [jwt, setJwt] = useState<string | undefined>(undefined);

  const generateCourierJwtOnYourServer = async () => {  
    
    // You should call an endpoint on your backend that wraps the Courier issue-token endpoint.
    // For server sdk samples, see ../server-side

    // Delay to simulate the time it takes to generate the JWT on your server.
    await new Promise((resolve) => setTimeout(resolve, 1000));
    return import.meta.env.VITE_COURIER_JWT;
  };

  useEffect(() => {
    const initialize = async () => {
      const token = await generateCourierJwtOnYourServer();
      setJwt(token);
    };
    initialize();
  }, []);

  if (!jwt) {
    return null;
  }

  return (
    <TemplateProvider 
      templateId={import.meta.env.VITE_COURIER_TEMPLATE_ID || "template-123"} 
      tenantId={import.meta.env.VITE_COURIER_TENANT_ID || "tenant-123"} 
      token={jwt}
    >
      <TemplateEditor
        routing={{
          method: "single", // "single" for fallback delivery, "all" for simultaneous delivery
          channels: ["email", "sms", "push", "inbox", "slack", "msteams"] // Available channels in the editor
        }}
      />
    </TemplateProvider>
  );
}