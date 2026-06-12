import { describe, it, expect, vi, beforeEach } from 'vitest'
import {
  getConsumptionJobs,
  getConsumptionJobDetail,
  getDatasets,
  listPatients,
  searchPatients,
  checkBackendStatus,
} from '../../features/patients/services/consumerService'

const { mockGet } = vi.hoisted(() => ({
  mockGet: vi.fn(),
}))

vi.mock('../../services/api', () => ({
  default: {
    get: mockGet,
  },
}))

describe('consumerService', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  describe('getConsumptionJobs', () => {
    it('calls API with correct URL and returns data', async () => {
      const mockResponse = {
        data: [
          {
            id: 'job-1',
            patientId: 'patient-001',
            status: 'SUCCEEDED',
          },
        ],
      }

      mockGet.mockResolvedValueOnce(mockResponse)

      const result = await getConsumptionJobs('patient-001')

      expect(mockGet).toHaveBeenCalledWith('/consumption-jobs', {
        params: { patientId: 'patient-001', summary: false },
      })
      expect(result).toEqual(mockResponse.data)
    })

    it('handles API errors', async () => {
      const error = new Error('API Error')
      mockGet.mockRejectedValueOnce(error)

      await expect(getConsumptionJobs('patient-001')).rejects.toThrow('Failed to fetch consumption jobs: patient-001')
    })
  })

  describe('getConsumptionJobDetail', () => {
    it('calls API with correct URL and returns data', async () => {
      const mockResponse = {
        data: {
          id: 'job-1',
          patientId: 'patient-001',
          status: 'SUCCEEDED',
          measurements: [],
        },
      }

      mockGet.mockResolvedValueOnce(mockResponse)

      const result = await getConsumptionJobDetail('job-1')

      expect(mockGet).toHaveBeenCalledWith('/consumption-jobs/job-1')
      expect(result).toEqual(mockResponse.data)
    })

    it('handles API errors', async () => {
      const error = new Error('Not Found')
      mockGet.mockRejectedValueOnce(error)

      await expect(getConsumptionJobDetail('job-1')).rejects.toThrow('Failed to fetch consumption job: job-1')
    })
  })

  describe('getDatasets', () => {
    it('calls API and returns datasets', async () => {
      const mockResponse = {
        data: {
          items: [
            {
              datasetId: 'dataset-1',
              name: 'Blood Pressure Data',
              recordCount: 1000,
            },
          ],
        },
      }

      mockGet.mockResolvedValueOnce(mockResponse)

      const result = await getDatasets()

      expect(mockGet).toHaveBeenCalledWith('/datasets')
      expect(result).toEqual(mockResponse.data.items)
    })

    it('handles API errors', async () => {
      const error = new Error('Service Unavailable')
      mockGet.mockRejectedValueOnce(error)

      await expect(getDatasets()).rejects.toThrow('Failed to fetch datasets')
    })
  })

  describe('searchPatients', () => {
    it('returns mock patient data', async () => {
      mockGet.mockResolvedValueOnce({
        data: [
          { patientId: 'patient-001' },
          { patientId: 'patient-002' },
          { patientId: 'patient-003' },
        ],
      })

      const result = await searchPatients('patient')

      expect(result).toHaveLength(3)
      expect(result[0]).toHaveProperty('id')
      expect(result[0]).toHaveProperty('name')
    })

    it('filters results based on query', async () => {
      mockGet.mockResolvedValueOnce({
        data: [
          { patientId: 'patient-001' },
          { patientId: 'patient-002' },
          { patientId: 'patient-003' },
        ],
      })

      const result = await searchPatients('001')

      expect(result).toHaveLength(1)
      expect(result[0].id).toBe('patient-001')
    })

    it('returns empty array for no matches', async () => {
      mockGet.mockResolvedValueOnce({
        data: [
          { patientId: 'patient-001' },
          { patientId: 'patient-002' },
        ],
      })

      const result = await searchPatients('nonexistent')

      expect(result).toEqual([])
    })
  })

  describe('listPatients', () => {
    it('returns only the requested number of unique patients', async () => {
      const mockResponse = {
        data: Array.from({ length: 25 }, (_, index) => ({
          id: `job-${index + 1}`,
          patientId: `patient-${String(index + 1).padStart(3, '0')}`,
          status: 'SUCCEEDED',
        })),
      }

      mockGet.mockResolvedValueOnce(mockResponse)

      const result = await listPatients(20)

      expect(mockGet).toHaveBeenCalledWith('/consumption-jobs', { params: { summary: true } })
      expect(result).toHaveLength(20)
      expect(result[0]).toBe('patient-001')
      expect(result[19]).toBe('patient-020')
      expect(result).not.toContain('patient-021')
    })
  })

  describe('checkBackendStatus', () => {
    it('returns true when API responds successfully', async () => {
      mockGet.mockResolvedValueOnce({ status: 200 })

      const result = await checkBackendStatus()

      expect(mockGet).toHaveBeenCalledWith('/consumption-jobs', { timeout: 3000 })
      expect(result).toBe(true)
    })

    it('returns false when API fails', async () => {
      mockGet.mockRejectedValueOnce(new Error('Connection failed'))

      const result = await checkBackendStatus()

      expect(result).toBe(false)
    })

    it('returns false when API returns non-200 status', async () => {
      mockGet.mockResolvedValueOnce({ status: 500 })

      const result = await checkBackendStatus()

      expect(result).toBe(false)
    })
  })
})
