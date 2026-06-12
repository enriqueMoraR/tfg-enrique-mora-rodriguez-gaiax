import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { usePatientData, useBackendStatus } from '../../features/patients/hooks/usePatientData'
import type { ReactNode } from 'react'

const { mockGetConsumptionJobs, mockCheckBackendStatus } = vi.hoisted(() => ({
  mockGetConsumptionJobs: vi.fn(),
  mockCheckBackendStatus: vi.fn(),
}))

vi.mock('../../features/patients/services/consumerService', () => ({
  getConsumptionJobs: mockGetConsumptionJobs,
  checkBackendStatus: mockCheckBackendStatus,
}))

describe('usePatientData', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
      },
    })
    mockGetConsumptionJobs.mockClear()
  })

  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )

  it('returns undefined data when no patientId provided (query disabled)', () => {
    const { result } = renderHook(() => usePatientData(), { wrapper })

    expect(result.current.data).toBeUndefined()
    expect(result.current.isLoading).toBe(false)
  })

  it('calls getConsumptionJobs with patientId', async () => {
    const mockData = [{ id: 'job-1', patientId: 'patient-001' }]
    mockGetConsumptionJobs.mockResolvedValue(mockData)

    const { result } = renderHook(() => usePatientData('patient-001'), { wrapper })

    expect(result.current.isLoading).toBe(true)

    await waitFor(() => {
      expect(result.current.isLoading).toBe(false)
    })

    expect(mockGetConsumptionJobs).toHaveBeenCalledWith('patient-001', true)
    expect(result.current.data).toEqual(mockData)
  })

})

describe('useBackendStatus', () => {
  let queryClient: QueryClient

  beforeEach(() => {
    queryClient = new QueryClient({
      defaultOptions: {
        queries: { retry: false },
      },
    })
    mockCheckBackendStatus.mockClear()
  })

  const wrapper = ({ children }: { children: ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )

  it('calls checkBackendStatus', async () => {
    mockCheckBackendStatus.mockResolvedValue(true)

    const { result } = renderHook(() => useBackendStatus(), { wrapper })

    await waitFor(() => {
      expect(result.current.isSuccess).toBe(true)
    })

    expect(mockCheckBackendStatus).toHaveBeenCalled()
    expect(result.current.data).toBe(true)
  })

  it('is defined', () => {
    const { result } = renderHook(() => useBackendStatus(), { wrapper })

    expect(result.current).toBeDefined()
  })
})
