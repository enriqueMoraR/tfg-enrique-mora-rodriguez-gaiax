import { describe, expect, it } from 'vitest'
import { render, screen } from '@testing-library/react'
import AnalyticsStatsPanel from '../../../features/analytics/components/AnalyticsStatsPanel'
import type { AnalyticsObservation, AnalyticsMeasurementTypeOption, AnalyticsStats } from '../../../features/analytics/types/analysis'

const stats: AnalyticsStats = {
  totalPatients: 2,
  totalObservations: 4,
  mean: 120,
  median: 118,
  stdDev: 4.5,
  minimum: 110,
  maximum: 128,
  percentile25: 115,
  percentile75: 122,
  iqrOutliers: 0,
}

const measurementTypes: AnalyticsMeasurementTypeOption[] = [
  { key: 'blood-pressure', label: 'Presión arterial', count: 3 },
  { key: 'heart-rate', label: 'Frecuencia cardíaca', count: 1 },
]

const selectedObservation: AnalyticsObservation = {
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
  numericValue: 120,
  displayValue: '120/80',
  unit: 'mmHg',
  consentSummary: 'CONS-2026-001',
  source: {} as never,
}

describe('AnalyticsStatsPanel', () => {
  it('renders stats, types and selected observation', () => {
    render(
      <AnalyticsStatsPanel
        stats={stats}
        measurementTypes={measurementTypes}
        selectedObservation={selectedObservation}
      />
    )

    expect(screen.getByText('Estadísticas dinámicas')).toBeInTheDocument()
    expect(screen.getByText('Pacientes')).toBeInTheDocument()
    expect(screen.getByText('Presión arterial · 3')).toBeInTheDocument()
    expect(screen.getByText('Ana García')).toBeInTheDocument()
    expect(screen.getByText(/120\/80 mmHg/)).toBeInTheDocument()
  })
})
