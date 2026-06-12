import { describe, expect, it, vi } from 'vitest'
import { fireEvent, render, screen } from '@testing-library/react'
import type { ReactNode } from 'react'
import ComparisonScatterChart from '../../../features/analytics/components/ComparisonScatterChart'
import type { AnalyticsObservation } from '../../../features/analytics/types/analysis'

vi.mock('recharts', () => ({
  ResponsiveContainer: ({ children }: { children: ReactNode }) => (
    <div className="recharts-responsive-container">{children}</div>
  ),
  ScatterChart: ({ children }: { children: ReactNode }) => <div data-testid="scatter-chart">{children}</div>,
  CartesianGrid: () => null,
  XAxis: () => null,
  YAxis: () => null,
  ZAxis: () => null,
  Tooltip: () => null,
  Scatter: ({
    data,
    name,
    shape,
  }: {
    data: Array<{ observation: AnalyticsObservation }>
    name?: string
    shape?: (props: { cx?: number; cy?: number; payload?: unknown }) => ReactNode
  }) => (
    <div data-testid={`scatter-${name ?? 'series'}`}>
      {data.map((point, index) => (
        <div key={`${name ?? 'series'}-${point.observation.id}`}>
          {typeof shape === 'function'
            ? shape({
                cx: 24 + index * 20,
                cy: 24 + index * 20,
                payload: point,
              })
            : null}
        </div>
      ))}
    </div>
  ),
}))

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
    numericValue: 120,
    displayValue: '120/80',
    unit: 'mmHg',
    source: {} as never,
  },
  {
    id: 'obs-2',
    resourceType: 'Observation',
    patientId: 'patient-2',
    patientReference: 'Patient/patient-2',
    patientDisplayName: 'Juan Pérez',
    patientSex: 'male',
    patientAge: 32,
    patientAgeGroup: '19-40',
    measurementTypeKey: 'heart-rate',
    measurementTypeLabel: 'Frecuencia cardíaca',
    code: '8867-4',
    timestamp: '2026-06-10T11:00:00Z',
    numericValue: 72,
    displayValue: '72 bpm',
    unit: 'bpm',
    source: {} as never,
  },
]

describe('ComparisonScatterChart', () => {
  it('renders the scatter chart shell and allows point selection', () => {
    const onSelectObservation = vi.fn()
    render(
      <ComparisonScatterChart
        observations={observations}
        selectedObservationId="obs-2"
        onSelectObservation={onSelectObservation}
      />
    )

    expect(screen.getByText('Comparación entre pacientes')).toBeInTheDocument()
    expect(screen.getByTestId('scatter-chart')).toBeInTheDocument()

    const circles = document.querySelectorAll('circle')
    expect(circles.length).toBeGreaterThan(0)
    fireEvent.click(circles[0] as SVGCircleElement)
    expect(onSelectObservation).toHaveBeenCalledWith(observations[0])
  })
})
