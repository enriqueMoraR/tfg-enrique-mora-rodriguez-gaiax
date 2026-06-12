import { describe, it, expect } from 'vitest'
import { renderHook } from '@testing-library/react'
import { useMeasurements } from '../../features/patients/hooks/useMeasurements'
import type { ConsumptionJob } from '../../types/api'
import type { Measurement, MeasurementAggregate } from '../../types'

describe('useMeasurements', () => {
  it('returns empty data when no jobs provided', () => {
    const { result } = renderHook(() => useMeasurements())

    expect(result.current.measurements).toEqual([])
    expect(result.current.aggregates).toEqual([])
    expect(result.current.total).toBe(0)
  })

  it('returns empty data when jobs array is empty', () => {
    const { result } = renderHook(() => useMeasurements([]))

    expect(result.current.measurements).toEqual([])
    expect(result.current.aggregates).toEqual([])
    expect(result.current.total).toBe(0)
  })

  it('transforms FHIR observations into measurements', () => {
    const mockJobs = [
      {
        id: 'job-1',
        patientId: 'patient-001',
        datasetId: 'dataset-1',
        status: 'SUCCEEDED',
        consumedAt: '2026-04-28T10:00:00Z',
        measurements: [
          {
            resourceType: 'Observation',
            id: 'obs-1',
            code: {
              coding: [{ code: '55284-4', system: 'http://loinc.org' }],
            },
            valueQuantity: { value: 120, unit: 'mmHg' },
            component: [
              {
                code: { coding: [{ code: '8480-6', display: 'Systolic blood pressure' }] },
                valueQuantity: { value: 120, unit: 'mmHg' },
              },
              {
                code: { coding: [{ code: '8462-4', display: 'Diastolic blood pressure' }] },
                valueQuantity: { value: 80, unit: 'mmHg' },
              },
            ],
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:00:00Z',
          },
          {
            resourceType: 'Observation',
            id: 'obs-2',
            code: {
              coding: [{ code: '8867-4', system: 'http://loinc.org' }],
            },
            valueQuantity: { value: 72, unit: 'bpm' },
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:05:00Z',
          },
        ],
        metadata: { xRequestId: 'req-123' },
      },
    ] as ConsumptionJob[]

    const { result } = renderHook(() => useMeasurements(mockJobs))

    expect(result.current.total).toBe(2)
    expect(result.current.measurements).toHaveLength(2)

    // Check blood pressure measurement
    const bpMeasurement = result.current.measurements.find((measurement: Measurement) => measurement.type === 'blood-pressure')
    expect(bpMeasurement).toBeDefined()
    expect(bpMeasurement?.value).toBe('120/80')
    expect(bpMeasurement?.unit).toBe('mmHg')
    expect(bpMeasurement?.rawValue).toEqual({ systolic: 120, diastolic: 80 })

    // Check heart rate measurement
    const hrMeasurement = result.current.measurements.find((measurement: Measurement) => measurement.type === 'heart-rate')
    expect(hrMeasurement).toBeDefined()
    expect(hrMeasurement?.value).toBe(72)
    expect(hrMeasurement?.unit).toBe('bpm')
    expect(hrMeasurement?.rawValue).toBe(72)
  })

  it('aggregates measurements by type', () => {
    const mockJobs = [
      {
        id: 'job-1',
        patientId: 'patient-001',
        datasetId: 'dataset-1',
        status: 'SUCCEEDED',
        consumedAt: '2026-04-28T10:00:00Z',
        measurements: [
          // 2 blood pressure measurements
          {
            resourceType: 'Observation',
            id: 'obs-1',
            code: { coding: [{ code: '55284-4', system: 'http://loinc.org' }] },
            component: [
              { valueQuantity: { value: 120, unit: 'mmHg' } },
              { valueQuantity: { value: 80, unit: 'mmHg' } },
            ],
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:00:00Z',
          },
          {
            resourceType: 'Observation',
            id: 'obs-2',
            code: { coding: [{ code: '55284-4', system: 'http://loinc.org' }] },
            component: [
              { valueQuantity: { value: 125, unit: 'mmHg' } },
              { valueQuantity: { value: 85, unit: 'mmHg' } },
            ],
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:10:00Z',
          },
          // 1 heart rate measurement
          {
            resourceType: 'Observation',
            id: 'obs-3',
            code: { coding: [{ code: '8867-4', system: 'http://loinc.org' }] },
            valueQuantity: { value: 72, unit: 'bpm' },
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:05:00Z',
          },
        ],
        metadata: { xRequestId: 'req-123' },
      },
    ] as ConsumptionJob[]

    const { result } = renderHook(() => useMeasurements(mockJobs))

    expect(result.current.aggregates).toHaveLength(2)

    const bpAggregate = result.current.aggregates.find((aggregate: MeasurementAggregate) => aggregate.type === 'blood-pressure')
    expect(bpAggregate).toBeDefined()
    expect(bpAggregate?.count).toBe(2)
    expect(bpAggregate?.percentage).toBe(67) // 2/3 ≈ 67%
    expect(bpAggregate?.color).toBe('#1e40af')

    const hrAggregate = result.current.aggregates.find((aggregate: MeasurementAggregate) => aggregate.type === 'heart-rate')
    expect(hrAggregate).toBeDefined()
    expect(hrAggregate?.count).toBe(1)
    expect(hrAggregate?.percentage).toBe(33) // 1/3 ≈ 33%
    expect(hrAggregate?.color).toBe('#059669')
  })

  it('sorts measurements by timestamp descending', () => {
    const mockJobs = [
      {
        id: 'job-1',
        patientId: 'patient-001',
        datasetId: 'dataset-1',
        status: 'SUCCEEDED',
        consumedAt: '2026-04-28T10:00:00Z',
        measurements: [
          {
            resourceType: 'Observation',
            id: 'obs-1',
            code: { coding: [{ code: '8867-4', system: 'http://loinc.org' }] },
            valueQuantity: { value: 72, unit: 'bpm' },
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:00:00Z',
          },
          {
            resourceType: 'Observation',
            id: 'obs-2',
            code: { coding: [{ code: '8867-4', system: 'http://loinc.org' }] },
            valueQuantity: { value: 75, unit: 'bpm' },
            subject: { reference: 'Patient/patient-001' },
            effectiveDateTime: '2026-04-28T09:30:00Z',
          },
        ],
        metadata: { xRequestId: 'req-123' },
      },
    ] as ConsumptionJob[]

    const { result } = renderHook(() => useMeasurements(mockJobs))

    expect(result.current.measurements[0].rawValue).toBe(75) // Newer first
    expect(result.current.measurements[1].rawValue).toBe(72) // Older second
  })
})
