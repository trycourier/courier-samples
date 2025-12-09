/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_COURIER_TEMPLATE_ID: string
  readonly VITE_COURIER_TENANT_ID: string
  readonly VITE_COURIER_JWT: string
  readonly VITE_COURIER_API_KEY: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

