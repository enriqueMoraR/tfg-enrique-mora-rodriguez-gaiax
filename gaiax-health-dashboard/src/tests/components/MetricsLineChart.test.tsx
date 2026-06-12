import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import MetricsLineChart from '../../components/MetricsLineChart'
import type { Measurement } from '../../types'

const mockMeasurements: Measurement[] = [
  {
    timestamp: '2026-04-28T14:32:10Z',
    type: 'blood-pressure',
    value: '120/80',
    rawValue: { systolic: 120, diastolic: 80 },
    unit: 'mmHg',
    xRequestId: 'req-123',
  },
  {
    timestamp: '2026-04-28T14:30:05Z',
    type: 'heart-rate',
    value: '72',
    rawValue: 72,
    unit: 'bpm',
    xRequestId: 'req-124',
  },
]

describe('MetricsLineChart', () => {
  it('renders the chart shell when measurements are present', () => {
    render(<MetricsLineChart measurements={mockMeasurements} />)

    expect(screen.getByText('Evolución Temporal')).toBeInTheDocument()
    expect(document.querySelector('.recharts-responsive-container')).toBeInTheDocument()
  })

  it('renders a custom title when provided', () => {
    render(<MetricsLineChart measurements={mockMeasurements} title="Mi evolución" />)

    expect(screen.getByText('Mi evolución')).toBeInTheDocument()
  })

  it('renders empty state when no measurements', () => {
    render(<MetricsLineChart measurements={[]} />)

    expect(screen.getByText('No hay mediciones para mostrar')).toBeInTheDocument()
  })
})
