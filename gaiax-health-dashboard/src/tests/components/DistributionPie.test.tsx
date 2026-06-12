import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import DistributionPie from '../../components/DistributionPie'
import type { MeasurementAggregate } from '../../types'

const mockData: MeasurementAggregate[] = [
  { type: 'blood-pressure', count: 6, percentage: 60, color: '#1e40af' },
  { type: 'heart-rate', count: 4, percentage: 40, color: '#059669' },
]

describe('DistributionPie', () => {
  it('renders chart title and container', () => {
    render(<DistributionPie aggregates={mockData} />)

    expect(screen.getByText('Distribución por Tipo')).toBeInTheDocument()
    expect(document.querySelector('.recharts-responsive-container')).toBeInTheDocument()
  })

  it('renders empty state when no data', () => {
    render(<DistributionPie aggregates={[]} />)

    expect(screen.getByText('No hay datos para mostrar')).toBeInTheDocument()
  })
})
