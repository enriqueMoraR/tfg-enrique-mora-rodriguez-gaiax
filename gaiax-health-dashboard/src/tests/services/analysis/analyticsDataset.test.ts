import { describe, expect, it } from 'vitest'
import type { FhirObservation, FhirPatient } from '../../../types/fhir'
import { buildAnalyticsDatasetFromResources, filterAnalyticsDataset } from '../../../features/analytics/services/analyticsDataset'
import {
  DEFAULT_ANALYTICS_FILTERS,
  parseAnalyticsFilters,
  serializeAnalyticsFilters,
} from '../../../features/analytics/services/analyticsFilters'

function buildPatient(id: string, name: string, gender: string, birthDate: string): FhirPatient {
  return {
    resourceType: 'Patient',
    id,
    name: [{ text: name }],
    gender,
    birthDate,
    meta: {
      lastUpdated: '2026-06-10T10:00:00Z',
      tag: [
        {
          system: 'https://gaia-x.eu/trust-framework#',
          code: 'sovereignty-policy',
          display: `CONS-${id}`,
        },
      ],
    },
  }
}

function buildObservation(
  id: string,
  patientId: string,
  code: string,
  display: string,
  value: number,
  unit: string,
  timestamp: string,
  systolic?: number,
  diastolic?: number
): FhirObservation {
  const isBloodPressure = code === '85354-9'

  return {
    resourceType: 'Observation',
    id,
    status: 'final',
    code: {
      coding: [
        {
          system: 'http://loinc.org',
          code,
          display,
        },
      ],
      text: display,
    },
    subject: {
      reference: `Patient/${patientId}`,
      display: patientId,
    },
    effectiveDateTime: timestamp,
    ...(isBloodPressure
      ? {
          component: [
            {
              code: {
                coding: [
                  {
                    system: 'http://loinc.org',
                    code: '8480-6',
                    display: 'Systolic blood pressure',
                  },
                ],
              },
              valueQuantity: {
                value: systolic ?? value,
                unit,
                system: 'http://unitsofmeasure.org',
                code: 'mm[Hg]',
              },
            },
            {
              code: {
                coding: [
                  {
                    system: 'http://loinc.org',
                    code: '8462-4',
                    display: 'Diastolic blood pressure',
                  },
                ],
              },
              valueQuantity: {
                value: diastolic ?? value - 10,
                unit,
                system: 'http://unitsofmeasure.org',
                code: 'mm[Hg]',
              },
            },
          ],
        }
      : {
          valueQuantity: {
            value,
            unit,
            system: 'http://unitsofmeasure.org',
            code: unit,
          },
        }),
  }
}

describe('analyticsDataset', () => {
  it('parses and serializes filters consistently', () => {
    const filters = parseAnalyticsFilters('?patientId=p-1&measurementType=blood-pressure&sex=female&ageGroup=41-65&dateFrom=2026-06-01&dateTo=2026-06-11')

    expect(filters).toEqual({
      patientId: 'p-1',
      measurementType: 'blood-pressure',
      dateFrom: '2026-06-01',
      dateTo: '2026-06-11',
      sex: 'female',
      ageGroup: '41-65',
    })

    expect(serializeAnalyticsFilters(filters)).toBe(
      'patientId=p-1&measurementType=blood-pressure&dateFrom=2026-06-01&dateTo=2026-06-11&sex=female&ageGroup=41-65'
    )
  })

  it('filters dataset by patient, measurement type, sex, age and date range', () => {
    const patients = [
      buildPatient('p-1', 'Ana García', 'female', '1978-04-10'),
      buildPatient('p-2', 'Juan Pérez', 'male', '1988-08-01'),
    ]
    const observations = [
      buildObservation('o-1', 'p-1', '85354-9', 'Blood pressure', 128, 'mmHg', '2026-06-10T10:00:00Z', 128, 82),
      buildObservation('o-2', 'p-1', '8867-4', 'Heart rate', 72, 'bpm', '2026-06-10T11:00:00Z'),
      buildObservation('o-3', 'p-2', '85354-9', 'Blood pressure', 118, 'mmHg', '2026-06-11T08:00:00Z', 118, 76),
    ]

    const dataset = buildAnalyticsDatasetFromResources(patients, observations)
    const filtered = filterAnalyticsDataset(dataset, {
      patientId: 'p-1',
      measurementType: 'blood-pressure',
      dateFrom: '2026-06-10',
      dateTo: '2026-06-10',
      sex: 'female',
      ageGroup: '41-65',
    })

    expect(dataset.patients).toHaveLength(2)
    expect(dataset.observations).toHaveLength(3)
    expect(dataset.measurementTypes.map((type) => type.key)).toEqual(expect.arrayContaining(['blood-pressure', 'heart-rate']))
    expect(filtered.patients).toHaveLength(1)
    expect(filtered.observations).toHaveLength(1)
    expect(filtered.observations[0]?.id).toBe('o-1')
    expect(filtered.series).toHaveLength(1)
    expect(filtered.measurementTypes).toEqual([
      expect.objectContaining({ key: 'blood-pressure', count: 1 }),
    ])
    expect(filtered.stats.totalPatients).toBe(1)
    expect(filtered.stats.totalObservations).toBe(1)
    expect(filtered.stats.mean).toBe(128)
    expect(DEFAULT_ANALYTICS_FILTERS.sex).toBe('any')
  })
})
