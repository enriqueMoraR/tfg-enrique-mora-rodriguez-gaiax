import { describe, expect, it } from 'vitest'
import type { AnalyticsObservation } from '../../../features/analytics/types/analysis'
import {
  buildHistogram,
  buildTemporalAggregates,
  calculateAnalyticsStats,
  calculateBoxPlotSummary,
  groupObservationsByMeasurementType,
  groupObservationsByPatient,
} from '../../../features/analytics/services/analyticsStatistics'

function createObservation(overrides: Partial<AnalyticsObservation>): AnalyticsObservation {
  return {
    id: overrides.id ?? 'obs-1',
    resourceType: 'Observation',
    patientId: overrides.patientId ?? 'patient-1',
    patientReference: overrides.patientReference ?? 'Patient/patient-1',
    patientDisplayName: overrides.patientDisplayName ?? 'Paciente 1',
    patientSex: overrides.patientSex ?? 'female',
    patientAge: overrides.patientAge ?? 45,
    patientAgeGroup: overrides.patientAgeGroup ?? '41-65',
    measurementTypeKey: overrides.measurementTypeKey ?? 'blood-pressure',
    measurementTypeLabel: overrides.measurementTypeLabel ?? 'Presión arterial',
    code: overrides.code ?? '85354-9',
    codeDisplay: overrides.codeDisplay ?? 'Blood pressure',
    timestamp: overrides.timestamp ?? '2026-06-10T10:00:00.000Z',
    issued: overrides.issued ?? '2026-06-10T10:00:05.000Z',
    numericValue: overrides.numericValue ?? 120,
    displayValue: overrides.displayValue ?? '120/80',
    unit: overrides.unit ?? 'mmHg',
    systolic: overrides.systolic ?? 120,
    diastolic: overrides.diastolic ?? 80,
    source: overrides.source ?? ({} as never),
  }
}

describe('analyticsStatistics', () => {
  it('calculates descriptive statistics and outliers', () => {
    const stats = calculateAnalyticsStats([10, 20, 30, 40, 100], 3)

    expect(stats.totalPatients).toBe(3)
    expect(stats.totalObservations).toBe(5)
    expect(stats.mean).toBe(40)
    expect(stats.median).toBe(30)
    expect(stats.minimum).toBe(10)
    expect(stats.maximum).toBe(100)
    expect(stats.percentile25).toBe(20)
    expect(stats.percentile75).toBe(40)
    expect(stats.stdDev).toBeGreaterThan(0)
    expect(stats.iqrOutliers).toBe(1)
  })

  it('builds histogram and box plot summaries', () => {
    const histogram = buildHistogram([1, 2, 3, 4, 5], 2)
    const boxPlot = calculateBoxPlotSummary([1, 2, 3, 4, 5, 100])

    expect(histogram).toHaveLength(2)
    expect(histogram[0]?.count).toBe(2)
    expect(histogram[1]?.count).toBe(3)
    expect(boxPlot.minimum).toBe(1)
    expect(boxPlot.maximum).toBe(100)
    expect(boxPlot.percentile25).toBe(2.25)
    expect(boxPlot.median).toBe(3.5)
    expect(boxPlot.percentile75).toBe(4.75)
    expect(boxPlot.outliers).toBeGreaterThanOrEqual(1)
  })

  it('groups observations by patient and measurement type and aggregates by day', () => {
    const observations = [
      createObservation({
        id: 'obs-a',
        patientId: 'patient-a',
        patientDisplayName: 'Ana García',
        patientSex: 'female',
        patientAge: 54,
        patientAgeGroup: '41-65',
        measurementTypeKey: 'blood-pressure',
        measurementTypeLabel: 'Presión arterial',
        timestamp: '2026-06-10T08:00:00.000Z',
        numericValue: 118,
        displayValue: '118/76',
        systolic: 118,
        diastolic: 76,
      }),
      createObservation({
        id: 'obs-b',
        patientId: 'patient-a',
        patientDisplayName: 'Ana García',
        patientSex: 'female',
        patientAge: 54,
        patientAgeGroup: '41-65',
        measurementTypeKey: 'blood-pressure',
        measurementTypeLabel: 'Presión arterial',
        timestamp: '2026-06-10T18:00:00.000Z',
        numericValue: 126,
        displayValue: '126/82',
        systolic: 126,
        diastolic: 82,
      }),
      createObservation({
        id: 'obs-c',
        patientId: 'patient-b',
        patientDisplayName: 'Luis Pérez',
        patientSex: 'male',
        patientAge: 32,
        patientAgeGroup: '19-40',
        measurementTypeKey: 'heart-rate',
        measurementTypeLabel: 'Frecuencia cardíaca',
        timestamp: '2026-06-11T08:00:00.000Z',
        numericValue: 72,
        displayValue: '72 bpm',
        unit: 'bpm',
      }),
    ]

    const byPatient = groupObservationsByPatient(observations)
    const byType = groupObservationsByMeasurementType(observations)
    const temporal = buildTemporalAggregates(observations, 'day')

    expect(byPatient).toHaveLength(2)
    expect(byPatient[0]?.patientCount).toBe(1)
    expect(byPatient[0]?.observationCount).toBeGreaterThanOrEqual(1)
    expect(byType).toHaveLength(2)
    expect(temporal).toHaveLength(2)
    expect(temporal[0]?.observationCount).toBe(2)
    expect(temporal[0]?.mean).toBe(122)
  })
})
