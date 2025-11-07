/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_COURIER_USER_ID: string
  readonly VITE_COURIER_JWT: string
  readonly VITE_COURIER_API_KEY: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

