import { describe, expect, it } from 'vitest'
import { render, screen } from '@testing-library/react'
import TemporalEchartsChart from '../../../features/analytics/components/TemporalEchartsChart'
import type { AnalyticsTemporalAggregate } from '../../../features/analytics/types/analysis'

const aggregates: AnalyticsTemporalAggregate[] = [
  {
    bucket: '2026-06-10T00:00:00.000Z',
    label: '10 jun 2026',
    observationCount: 2,
    patientCount: 2,
    mean: 120,
    median: 120,
    stdDev: 4.2,
    minimum: 116,
    maximum: 124,
    percentile25: 118,
    percentile75: 122,
    iqrOutliers: 0,
  },
  {
    bucket: '2026-06-11T00:00:00.000Z',
    label: '11 jun 2026',
    observationCount: 3,
    patientCount: 2,
    mean: 124,
    median: 124,
    stdDev: 3.8,
    minimum: 119,
    maximum: 128,
    percentile25: 121,
    percentile75: 126,
    iqrOutliers: 0,
  },
]

describe('TemporalEchartsChart', () => {
  it('renders the temporal chart shell with aggregates', () => {
    render(<TemporalEchartsChart aggregates={aggregates} />)

    expect(screen.getByText('Evolución temporal')).toBeInTheDocument()
    expect(document.querySelector('.recharts-responsive-container')).toBeInTheDocument()
  })

  it('renders a patient series mode', () => {
    render(
      <TemporalEchartsChart
        aggregates={aggregates}
        showPatientSeries
        patientLabel="Juan Pérez"
        patientPoints={[
          {
            timestamp: '2026-06-10T10:00:00Z',
            value: 120,
            displayValue: '120/80',
            unit: 'mmHg',
            patientDisplayName: 'Juan Pérez',
          },
        ]}
      />
    )

    expect(screen.getByText(/Serie individual del paciente Juan Pérez/)).toBeInTheDocument()
  })
})
