import "@trycourier/react-designer/styles.css";

import { TemplateEditor, TemplateProvider } from "@trycourier/react-designer";

function App() {
  return (
    <TemplateProvider 
      templateId={import.meta.env.VITE_COURIER_TEMPLATE_ID || "template-123"} 
      tenantId={import.meta.env.VITE_COURIER_TENANT_ID || "tenant-123"} 
      token={import.meta.env.VITE_COURIER_JWT || "jwt"}
    >
      <TemplateEditor/>
    </TemplateProvider>
  );
}

export default App;

