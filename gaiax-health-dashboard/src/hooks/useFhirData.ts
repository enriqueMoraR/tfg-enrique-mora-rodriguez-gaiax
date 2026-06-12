import { useQuery } from '@tanstack/react-query'
import { checkFhirBackendStatus, listObservations, listPatients } from '../features/patients/services/fhirApi'
import type { FhirObservation, FhirPatient } from '../types/fhir'

export function useFhirPatients(limit = 20, enabled = true) {
  return useQuery<FhirPatient[], Error>({
    queryKey: ['fhirPatients', limit],
    queryFn: () => listPatients(limit),
    enabled,
    staleTime: 1000 * 60,
    retry: 2,
  })
}

export function useFhirObservations(patientId?: string, limit = 50, enabled = true) {
  return useQuery<FhirObservation[], Error>({
    queryKey: ['fhirObservations', patientId ?? 'all', limit],
    queryFn: () => listObservations(patientId, limit),
    enabled,
    staleTime: 1000 * 60,
    retry: 2,
  })
}

export function useFhirBackendStatus() {
  return useQuery<boolean>({
    queryKey: ['fhirBackendStatus'],
    queryFn: checkFhirBackendStatus,
    staleTime: 1000 * 30,
    refetchInterval: 1000 * 60,
  })
}
