import { useMemo } from 'react'
import type { ConsumptionJob } from '../../../types/api'
import type { Measurement, MeasurementAggregate } from '../../../types/domain'
import { normalizeMeasurements, aggregateByType } from '../services/dataTransform'

export interface UseMeasurementsReturn {
  measurements: Measurement[]
  aggregates: MeasurementAggregate[]
  total: number
}

/**
 * Hook to transform consumption jobs into measurements and aggregates
 */
export function useMeasurements(jobs?: ConsumptionJob[]): UseMeasurementsReturn {
  return useMemo(() => {
    if (!jobs || jobs.length === 0) {
      return { measurements: [], aggregates: [], total: 0 }
    }

    const measurements: Measurement[] = []

    // Flatten all measurements from all jobs
    jobs.forEach((job) => {
      const normalized = normalizeMeasurements(job.measurements, job.metadata.xRequestId)
      measurements.push(...normalized)
    })

    // Sort by timestamp descending (newest first)
    measurements.sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime())

    // Aggregate by type
    const { data: aggregates, total } = aggregateByType(measurements)

    return { measurements, aggregates, total }
  }, [jobs])
}
