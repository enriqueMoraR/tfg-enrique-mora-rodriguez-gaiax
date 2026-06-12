import { describe, expect, it } from 'vitest'
import { buildAnalyticsCsv } from '../../../features/analytics/services/analyticsExport'
import type { AnalyticsObservation } from '../../../features/analytics/types/analysis'

const observations: AnalyticsObservation[] = [
  {
    id: 'obs-1',
    resourceType: 'Observation',
    patientId: 'patient-1',
    patientReference: 'Patient/patient-1',
    patientDisplayName: 'Ana García',
    patientSex: 'female',
    patientAge: 54,
    patientAgeGroup: '41-65',
    measurementTypeKey: 'blood-pressure',
    measurementTypeLabel: 'Presión arterial',
    code: '85354-9',
    timestamp: '2026-06-10T10:00:00Z',
    issued: '2026-06-10T10:00:05Z',
    numericValue: 120,
    displayValue: '120/80',
    unit: 'mmHg',
    performerDisplay: 'Omron X200 Smart Tensiómetro',
    deviceReference: 'Device/tensiometer-omron-x200',
    deviceDisplay: 'Omron X200 Smart Tensiómetro',
    consentSummary: 'CONS-2026-889',
    source: {} as never,
  },
]

describe('buildAnalyticsCsv', () => {
  it('serializes filtered observations with escaped cells', () => {
    const csv = buildAnalyticsCsv(observations)

    expect(csv).toContain('id,patientId,patientDisplayName')
    expect(csv).toContain('Ana García')
    expect(csv).toContain('CONS-2026-889')
    expect(csv.split('\n')).toHaveLength(2)
  })
})
