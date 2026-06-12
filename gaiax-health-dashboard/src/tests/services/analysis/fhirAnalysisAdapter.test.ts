import { describe, expect, it } from 'vitest'
import { normalizeBundleToAnalyticsDataset } from '../../../features/analytics/services/fhirAnalysisAdapter'
import type { FhirBundle } from '../../../types/fhir'

describe('normalizeBundleToAnalyticsDataset', () => {
  it('normalizes mixed FHIR bundles into analytics-ready structures', () => {
    const bundle: FhirBundle<any> = {
      resourceType: 'Bundle',
      type: 'collection',
      timestamp: '2026-06-11T09:00:00Z',
      entry: [
        {
          resource: {
            resourceType: 'Patient',
            id: 'patient-001',
            gender: 'male',
            birthDate: '1980-05-12',
            name: [{ given: ['Juan'], family: 'Pérez' }],
            meta: {
              tag: [
                {
                  system: 'https://gaia-x.eu/trust-framework#',
                  code: 'sovereignty-policy',
                  display: 'CONS-2026-001',
                },
              ],
            },
          },
        },
        {
          resource: {
            resourceType: 'Patient',
            id: 'patient-002',
            gender: 'female',
            birthDate: '2005-03-20',
            name: [{ given: ['Ana'], family: 'García' }],
          },
        },
        {
          resource: {
            resourceType: 'Device',
            id: 'device-001',
            type: {
              coding: [
                {
                  system: 'http://snomed.info/sct',
                  code: '43770009',
                  display: 'Blood pressure monitor',
                },
              ],
            },
          },
        },
        {
          resource: {
            resourceType: 'Observation',
            id: 'obs-bp',
            status: 'final',
            code: {
              coding: [{ code: '85354-9', system: 'http://loinc.org', display: 'Blood pressure panel' }],
              text: 'Blood pressure systolic & diastolic',
            },
            subject: { reference: 'Patient/patient-001', display: 'Juan Pérez' },
            encounter: { reference: 'Encounter/enc-001' },
            effectiveDateTime: '2026-06-10T10:25:00+02:00',
            issued: '2026-06-10T10:25:05+02:00',
            performer: [{ reference: 'Device/device-001', display: 'Blood pressure monitor' }],
            bodySite: { coding: [{ code: '368209003', system: 'http://snomed.info/sct', display: 'Right arm' }] },
            component: [
              {
                code: { coding: [{ code: '8480-6', system: 'http://loinc.org', display: 'Systolic blood pressure' }] },
                valueQuantity: { value: 128, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]' },
              },
              {
                code: { coding: [{ code: '8462-4', system: 'http://loinc.org', display: 'Diastolic blood pressure' }] },
                valueQuantity: { value: 82, unit: 'mmHg', system: 'http://unitsofmeasure.org', code: 'mm[Hg]' },
              },
            ],
            device: {
              reference: 'Device/device-001',
              type: {
                coding: [
                  {
                    system: 'http://snomed.info/sct',
                    code: '43770009',
                    display: 'Blood pressure monitor',
                  },
                ],
              },
              identifier: [{ system: 'http://hl7.org/fhir/sid/ndc', value: 'SN-0001' }],
            },
          },
        },
        {
          resource: {
            resourceType: 'Observation',
            id: 'obs-hr',
            status: 'final',
            code: {
              coding: [{ code: '8867-4', system: 'http://loinc.org', display: 'Heart rate' }],
            },
            subject: { reference: 'Patient/patient-002', display: 'Ana García' },
            effectiveDateTime: '2026-06-10T11:00:00+02:00',
            issued: '2026-06-10T11:00:05+02:00',
            valueQuantity: { value: 72, unit: 'bpm', system: 'http://unitsofmeasure.org', code: '/min' },
          },
        },
        {
          resource: {
            resourceType: 'Observation',
            id: 'obs-temp',
            status: 'final',
            code: {
              coding: [{ code: '8310-5', system: 'http://loinc.org', display: 'Body temperature' }],
            },
            subject: { reference: 'Patient/patient-002', display: 'Ana García' },
            effectiveDateTime: '2026-06-10T11:15:00+02:00',
            valueQuantity: { value: 37.4, unit: 'C', system: 'http://unitsofmeasure.org', code: 'Cel' },
          },
        },
        {
          resource: {
            resourceType: 'Observation',
            id: 'obs-custom',
            status: 'final',
            code: {
              coding: [{ code: '99999-9', system: 'http://loinc.org', display: 'Biomarcador personalizado' }],
            },
            subject: { reference: 'Patient/patient-001', display: 'Juan Pérez' },
            effectiveDateTime: '2026-06-10T11:30:00+02:00',
            valueQuantity: { value: 42, unit: 'mg/dL', system: 'http://unitsofmeasure.org', code: 'mg/dL' },
          },
        },
      ],
    }

    const dataset = normalizeBundleToAnalyticsDataset(bundle)

    expect(dataset.patients).toHaveLength(2)
    expect(dataset.observations).toHaveLength(4)
    expect(dataset.measurementTypes.map((item) => item.key)).toEqual(
      expect.arrayContaining(['blood-pressure', 'heart-rate', 'temperature', 'biomarcador-personalizado'])
    )
    expect(dataset.series).toHaveLength(4)
    expect(dataset.stats.totalPatients).toBe(2)
    expect(dataset.stats.totalObservations).toBe(4)
    expect(dataset.patients.find((patient) => patient.id === 'patient-001')).toMatchObject({
      displayName: 'Juan Pérez',
      sex: 'male',
      ageGroup: '41-65',
      consentSummary: 'CONS-2026-001',
    })
    expect(dataset.patients.find((patient) => patient.id === 'patient-002')).toMatchObject({
      displayName: 'Ana García',
      sex: 'female',
      ageGroup: '19-40',
    })
    expect(dataset.observations.find((item) => item.id === 'obs-bp')).toMatchObject({
      measurementTypeKey: 'blood-pressure',
      displayValue: '128/82',
      patientDisplayName: 'Juan Pérez',
      patientAgeGroup: '41-65',
      deviceDisplay: 'Blood pressure monitor',
      consentSummary: 'CONS-2026-001',
    })
    expect(dataset.observations.find((item) => item.id === 'obs-temp')).toMatchObject({
      measurementTypeKey: 'temperature',
      displayValue: '37.4 C',
    })
  })

  it('normalizes a standalone observation bundle without patient resource', () => {
    const bundle: FhirBundle<any> = {
      resourceType: 'Bundle',
      type: 'collection',
      entry: [
        {
          resource: {
            resourceType: 'Observation',
            id: 'obs-single',
            code: {
              coding: [{ code: '8867-4', system: 'http://loinc.org', display: 'Heart rate' }],
            },
            subject: { reference: 'Patient/patient-xyz', display: 'Paciente X' },
            effectiveDateTime: '2026-06-11T12:00:00Z',
            valueQuantity: { value: 77, unit: 'bpm', system: 'http://unitsofmeasure.org', code: '/min' },
          },
        },
      ],
    }

    const dataset = normalizeBundleToAnalyticsDataset(bundle)

    expect(dataset.patients).toHaveLength(0)
    expect(dataset.observations).toHaveLength(1)
    expect(dataset.observations[0]).toMatchObject({
      patientId: 'patient-xyz',
      measurementTypeKey: 'heart-rate',
      displayValue: '77 bpm',
      patientDisplayName: 'Paciente X',
    })
    expect(dataset.stats.totalPatients).toBe(0)
    expect(dataset.stats.totalObservations).toBe(1)
  })
})
