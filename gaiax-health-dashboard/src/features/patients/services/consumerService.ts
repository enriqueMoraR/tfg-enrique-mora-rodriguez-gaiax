import api from '../../../services/api'
import type { ConsumptionJob, Dataset, DatasetsResponse } from '../../../types/api'

/**
 * Get consumption jobs for a patient
 */
export async function getConsumptionJobs(patientId: string, summary = false): Promise<ConsumptionJob[]> {
  try {
    const response = await api.get<ConsumptionJob[]>(`/consumption-jobs`, {
      params: { patientId, summary },
    })
    return response.data
  } catch (error) {
    if (error instanceof Error) {
      console.error(`Error fetching consumption jobs for ${patientId}:`, error.message)
    }
    throw new Error(`Failed to fetch consumption jobs: ${patientId}`)
  }
}

/**
 * Get detailed consumption job with measurements
 */
export async function getConsumptionJobDetail(jobId: string): Promise<ConsumptionJob> {
  try {
    const response = await api.get<ConsumptionJob>(`/consumption-jobs/${jobId}`)
    return response.data
  } catch (error) {
    if (error instanceof Error) {
      console.error(`Error fetching consumption job ${jobId}:`, error.message)
    }
    throw new Error(`Failed to fetch consumption job: ${jobId}`)
  }
}

/**
 * Get list of available datasets
 */
export async function getDatasets(): Promise<Dataset[]> {
  try {
    const response = await api.get<DatasetsResponse>('/datasets')
    return response.data.items || []
  } catch (error) {
    if (error instanceof Error) {
      console.error('Error fetching datasets:', error.message)
    }
    throw new Error('Failed to fetch datasets')
  }
}

/**
 * Search patients (mock implementation)
 * In production, this would query the backend
 */
export async function listPatients(limit = 1000): Promise<string[]> {
  try {
    // Fetch consumption jobs without patient filter and extract unique patientIds
    const response = await api.get<ConsumptionJob[]>(`/consumption-jobs`, { params: { summary: true } })
    const jobs = response.data || []
    const seen = new Set<string>()
    const patients: string[] = []
    if (limit <= 0) {
      return []
    }
    for (const job of jobs) {
      if (job.patientId && !seen.has(job.patientId)) {
        seen.add(job.patientId)
        patients.push(job.patientId)
      }
      if (patients.length >= limit) break
    }
    return patients
  } catch (error) {
    console.error('Error listing patients:', error)
    return []
  }
}

export async function searchPatients(query: string): Promise<{ id: string; name: string }[]> {
  try {
    if (!query || !query.trim()) return []
    const q = query.toLowerCase()
    // Use listPatients to obtain known patientIds and filter by substring
    const patients = await listPatients()
    const matches = patients.filter((p) => p.toLowerCase().includes(q))
    // Return up to 100 matches with id as name when no name available
    return matches.slice(0, 100).map((id) => ({ id, name: id }))
  } catch (error) {
    console.error('Error searching patients:', error)
    throw new Error('Failed to search patients')
  }
}

/**
 * Verify backend connectivity
 */
export async function checkBackendStatus(): Promise<boolean> {
  try {
    // Use a lightweight consumer endpoint that should exist and return 200 when healthy
    const response = await api.get('/consumption-jobs', { timeout: 3000 })
    return response.status === 200
  } catch (err) {
    console.debug('Backend status check failed:', err)
    return false
  }
}
