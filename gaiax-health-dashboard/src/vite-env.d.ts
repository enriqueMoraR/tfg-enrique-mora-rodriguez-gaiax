/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_URL: string
  readonly VITE_API_TIMEOUT: string
  readonly VITE_FHIR_API_URL: string
  readonly VITE_FHIR_API_TIMEOUT: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
