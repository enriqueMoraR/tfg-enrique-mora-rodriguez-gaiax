import { beforeEach, describe, expect, it, vi } from 'vitest'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { renderHook, waitFor } from '@testing-library/react'
import type { ReactNode } from 'react'
import { useFhirBackendStatus, useFhirObservations, useFhirPatients } from '../../hooks/useFhirData'

const { mockListPatients, mockListObservations, mockCheckStatus } = vi.hoisted(() => ({
  mockListPatients: vi.fn(),
  mockListObservations: vi.fn(),
  mockCheckStatus: vi.fn(),
}))

vi.mock('../../features/patients/services/fhirApi', () => ({
  listPatients: mockListPatients,
  listObservations: mockListObservations,
  checkFhirBackendStatus: mockCheckStatus,
}))

describe('useFhirData', () => {
  let queryClient: QueryClient

  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )

  beforeEach(() => {
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
      },
    })
    mockListPatients.mockReset()
    mockListObservations.mockReset()
    mockCheckStatus.mockReset()
  })

  it('loads patients', async () => {
    mockListPatients.mockResolvedValue([{ resourceType: 'Patient', id: 'patient-001' }])

    const { result } = renderHook(() => useFhirPatients(20), { wrapper })

    await waitFor(() => {
      expect(result.current.isSuccess).toBe(true)
    })

    expect(mockListPatients).toHaveBeenCalledWith(20)
    expect(result.current.data).toEqual([{ resourceType: 'Patient', id: 'patient-001' }])
  })

  it('loads observations for a patient', async () => {
    mockListObservations.mockResolvedValue([{ resourceType: 'Observation', id: 'obs-001' }])

    const { result } = renderHook(() => useFhirObservations('patient-001', 50, true), { wrapper })

    await waitFor(() => {
      expect(result.current.isSuccess).toBe(true)
    })

    expect(mockListObservations).toHaveBeenCalledWith('patient-001', 50)
    expect(result.current.data).toEqual([{ resourceType: 'Observation', id: 'obs-001' }])
  })

  it('checks backend status', async () => {
    mockCheckStatus.mockResolvedValue(true)

    const { result } = renderHook(() => useFhirBackendStatus(), { wrapper })

    await waitFor(() => {
      expect(result.current.isSuccess).toBe(true)
    })

    expect(mockCheckStatus).toHaveBeenCalled()
    expect(result.current.data).toBe(true)
  })
})
