import { describe, it, expect } from 'vitest'
import { normalizeMeasurements, aggregateByType, formatTimestamp, formatValue } from '../../features/patients/services/dataTransform'
import type { FhirObservation } from '../../types/fhir'
import type { Measurement, MeasurementAggregate } from '../../types'

describe('normalizeMeasurements', () => {
  it('normalizes blood pressure observation', () => {
    const observations: FhirObservation[] = [
      {
        resourceType: 'Observation',
        id: 'obs-1',
        code: {
          coding: [{ code: '55284-4', system: 'http://loinc.org' }],
        },
        component: [
          {
            code: { coding: [{ code: '8480-6' }] },
            valueQuantity: { value: 120, unit: 'mmHg' },
          },
          {
            code: { coding: [{ code: '8462-4' }] },
            valueQuantity: { value: 80, unit: 'mmHg' },
          },
        ],
        subject: { reference: 'Patient/patient-001' },
        effectiveDateTime: '2026-04-28T09:00:00Z',
      },
    ]

    const result = normalizeMeasurements(observations, 'req-123')

    expect(result).toHaveLength(1)
    expect(result[0]).toEqual({
      timestamp: '2026-04-28T09:00:00Z',
      type: 'blood-pressure',
      value: '120/80',
      rawValue: { systolic: 120, diastolic: 80 },
      unit: 'mmHg',
      xRequestId: 'req-123',
    })
  })

  it('normalizes heart rate observation', () => {
    const observations: FhirObservation[] = [
      {
        resourceType: 'Observation',
        id: 'obs-1',
        code: {
          coding: [{ code: '8867-4', system: 'http://loinc.org' }],
        },
        valueQuantity: { value: 72, unit: 'bpm' },
        subject: { reference: 'Patient/patient-001' },
        effectiveDateTime: '2026-04-28T09:05:00Z',
      },
    ]

    const result = normalizeMeasurements(observations, 'req-123')

    expect(result).toHaveLength(1)
    expect(result[0]).toEqual({
      timestamp: '2026-04-28T09:05:00Z',
      type: 'heart-rate',
      value: 72,
      rawValue: 72,
      unit: 'bpm',
      xRequestId: 'req-123',
    })
  })

  it('handles unknown observation types', () => {
    const observations: FhirObservation[] = [
      {
        resourceType: 'Observation',
        id: 'obs-1',
        code: {
          coding: [{ code: 'unknown-code', system: 'http://loinc.org' }],
        },
        valueQuantity: { value: 100, unit: 'unknown' },
        subject: { reference: 'Patient/patient-001' },
        effectiveDateTime: '2026-04-28T09:00:00Z',
      },
    ]

    const result = normalizeMeasurements(observations, 'req-123')

    expect(result).toHaveLength(0)
  })

  it('handles missing effectiveDateTime', () => {
    const observations: FhirObservation[] = [
      {
        resourceType: 'Observation',
        id: 'obs-1',
        code: {
          coding: [{ code: '8867-4', system: 'http://loinc.org' }],
        },
        valueQuantity: { value: 72, unit: 'bpm' },
        subject: { reference: 'Patient/patient-001' },
        // effectiveDateTime is missing
      },
    ]

    const result = normalizeMeasurements(observations, 'req-123')

    expect(result).toHaveLength(1)
    expect(result[0].timestamp).toMatch(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/) // ISO string
  })
})

describe('aggregateByType', () => {
  it('aggregates measurements by type', () => {
    const measurements: Measurement[] = [
      { type: 'blood-pressure' as const, value: '120/80', rawValue: { systolic: 120, diastolic: 80 }, unit: 'mmHg', timestamp: '2026-04-28T09:00:00Z', xRequestId: 'req-1' },
      { type: 'blood-pressure' as const, value: '125/85', rawValue: { systolic: 125, diastolic: 85 }, unit: 'mmHg', timestamp: '2026-04-28T09:10:00Z', xRequestId: 'req-2' },
      { type: 'heart-rate' as const, value: 72, rawValue: 72, unit: 'bpm', timestamp: '2026-04-28T09:05:00Z', xRequestId: 'req-3' },
    ]

    const result = aggregateByType(measurements)

    expect(result.total).toBe(3)
    expect(result.data).toHaveLength(2)

    const bpAgg = result.data.find((aggregate: MeasurementAggregate) => aggregate.type === 'blood-pressure')
    expect(bpAgg).toEqual({
      type: 'blood-pressure',
      count: 2,
      percentage: 67,
      color: '#1e40af',
    })

    const hrAgg = result.data.find((aggregate: MeasurementAggregate) => aggregate.type === 'heart-rate')
    expect(hrAgg).toEqual({
      type: 'heart-rate',
      count: 1,
      percentage: 33,
      color: '#059669',
    })
  })

  it('handles empty measurements array', () => {
    const result = aggregateByType([])

    expect(result.total).toBe(0)
    expect(result.data).toEqual([])
  })
})

describe('formatTimestamp', () => {
  it('formats ISO timestamp correctly', () => {
    const result = formatTimestamp('2026-04-28T14:32:10Z')

    expect(result).toBe('14:32:10 28-abr')
  })

  it('handles invalid timestamp', () => {
    const result = formatTimestamp('invalid')

    expect(result).toBe('invalid')
  })
})

describe('formatValue', () => {
  it('formats blood pressure value', () => {
    const measurement = {
      type: 'blood-pressure' as const,
      value: '120/80',
      rawValue: { systolic: 120, diastolic: 80 },
      unit: 'mmHg',
      timestamp: '2026-04-28T09:00:00Z',
      xRequestId: 'req-1',
    }

    const result = formatValue(measurement)

    expect(result).toBe('120/80 mmHg')
  })

  it('formats heart rate value', () => {
    const measurement = {
      type: 'heart-rate' as const,
      value: 72,
      rawValue: 72,
      unit: 'bpm',
      timestamp: '2026-04-28T09:00:00Z',
      xRequestId: 'req-1',
    }

    const result = formatValue(measurement)

    expect(result).toBe('72 bpm')
  })
})
