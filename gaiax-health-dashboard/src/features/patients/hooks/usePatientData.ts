import { useQuery } from '@tanstack/react-query'
import { getConsumptionJobs, checkBackendStatus } from '../services/consumerService'
import type { ConsumptionJob } from '../../../types/api'

/**
 * Hook to fetch consumption jobs for a patient
 * Uses TanStack Query for caching and automatic retries
 */
export function usePatientData(patientId?: string) {
  return useQuery<ConsumptionJob[], Error>({
    queryKey: ['patientData', patientId],
    queryFn: async () => {
      if (!patientId) {
        return []
      }
      return getConsumptionJobs(patientId, true)
    },
    enabled: !!patientId,
    staleTime: 1000 * 60 * 5, // 5 minutes
    retry: 3,
  })
}

/**
 * Hook to check backend connectivity
 */
export function useBackendStatus() {
  return useQuery<boolean>({
    queryKey: ['backendStatus'],
    queryFn: checkBackendStatus,
    staleTime: 1000 * 30, // 30 seconds
    refetchInterval: 1000 * 60, // Poll every 60 seconds
  })
}
