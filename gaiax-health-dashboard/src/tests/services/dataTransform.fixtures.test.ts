import { describe, it, expect } from 'vitest'
import bundleSample from '../fixtures/bundle-sample.json'
import observationSample from '../fixtures/observation-sample.json'
import observationRealSample from '../fixtures/observation-real-2026.json'
import { aggregateByType, normalizeMeasurements } from '../../features/patients/services/dataTransform'
import type { FhirObservation } from '../../types/fhir'

type BundleEntry = {
  resource?: {
    resourceType?: string
  }
}

describe('dataTransform fixtures', () => {
  it('normalizes the blood pressure bundle fixture', () => {
    const observations = (bundleSample as { entry: BundleEntry[] }).entry
      .map((entry) => entry.resource)
      .filter((resource): resource is FhirObservation => resource?.resourceType === 'Observation')

    const measurements = normalizeMeasurements(observations, 'req-fixture-bundle')

    expect(measurements).toHaveLength(1)
    expect(measurements[0]).toMatchObject({
      timestamp: '2026-01-01T00:00:00Z',
      type: 'blood-pressure',
      value: '120/80',
      unit: 'mmHg',
      xRequestId: 'req-fixture-bundle',
    })
  })

  it('normalizes the standalone observation fixture and aggregates it', () => {
    const measurements = normalizeMeasurements(
      [observationSample as FhirObservation],
      'req-fixture-observation'
    )
    const aggregate = aggregateByType(measurements)

    expect(measurements).toHaveLength(1)
    expect(measurements[0].type).toBe('blood-pressure')
    expect(aggregate.total).toBe(1)
    expect(aggregate.data).toEqual([
      {
        type: 'blood-pressure',
        count: 1,
        percentage: 100,
        color: '#1e40af',
      },
    ])
  })

  it('normalizes the real standalone observation fixture and preserves provenance', () => {
    const measurements = normalizeMeasurements(
      [observationRealSample as FhirObservation],
      'req-fixture-observation-real'
    )

    expect(measurements).toHaveLength(1)
    expect(measurements[0]).toMatchObject({
      timestamp: '2026-06-10T10:25:00+02:00',
      type: 'blood-pressure',
      value: '128/82',
      unit: 'mmHg',
      xRequestId: 'req-fixture-observation-real',
      issued: '2026-06-10T10:25:05+02:00',
      subjectDisplay: 'Juan Pérez',
      encounterReference: 'Encounter/enc-home-monitoring-001',
      performerDisplay: 'Omron X200 Smart Tensiómetro',
      bodySiteDisplay: 'Right arm',
      deviceReference: 'Device/tensiometer-omron-x200',
      deviceDisplay: 'Blood pressure monitor',
      consentSummary: 'Data usage governed by patient consent ID: CONS-2026-889',
    })
  })
})
