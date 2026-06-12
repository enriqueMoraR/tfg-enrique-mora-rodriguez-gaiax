import axios, { AxiosError, AxiosInstance } from 'axios'
import type { FhirBundle, FhirObservation, FhirPatient } from '../../../types/fhir'

const FHIR_API_URL = (import.meta.env.VITE_FHIR_API_URL as string) || '/api/fhir'
const FHIR_API_TIMEOUT = Number((import.meta.env.VITE_FHIR_API_TIMEOUT as string) || 10000)

const fhirApi: AxiosInstance = axios.create({
  baseURL: FHIR_API_URL,
  timeout: FHIR_API_TIMEOUT,
  headers: {
    Accept: 'application/fhir+json',
  },
})

fhirApi.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => Promise.reject(error)
)

function unwrapBundle<T>(bundle: FhirBundle<T>): T[] {
  return (bundle.entry ?? [])
    .map((entry) => entry.resource)
    .filter(Boolean)
}

export async function listPatients(limit = 20): Promise<FhirPatient[]> {
  const response = await fhirApi.get<FhirBundle<FhirPatient>>('/Patient', {
    params: { _count: limit },
  })
  return unwrapBundle(response.data)
}

export async function listObservations(patientId?: string, limit = 50): Promise<FhirObservation[]> {
  const response = await fhirApi.get<FhirBundle<FhirObservation>>('/Observation', {
    params: patientId ? { patient: `Patient/${patientId}`, _count: limit } : { _count: limit },
  })
  return unwrapBundle(response.data)
}

export async function checkFhirBackendStatus(): Promise<boolean> {
  try {
    const response = await fhirApi.get<FhirBundle<FhirPatient>>('/Patient', { params: { _count: 1 } })
    return response.status === 200
  } catch {
    return false
  }
}

export default fhirApi
