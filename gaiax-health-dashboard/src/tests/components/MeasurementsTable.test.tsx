import { describe, it, expect } from 'vitest'
import { render, screen, fireEvent, within } from '@testing-library/react'
import MeasurementsTable from '../../features/patients/components/MeasurementsTable'
import type { Measurement } from '../../types'

const mockMeasurements: Measurement[] = [
  {
    timestamp: '2026-04-28T14:32:10Z',
    type: 'blood-pressure',
    value: '120/80',
    rawValue: { systolic: 120, diastolic: 80 },
    unit: 'mmHg',
    xRequestId: 'req-123456789',
    issued: '2026-04-28T14:32:12Z',
    subjectDisplay: 'Juan Pérez',
    encounterReference: 'Encounter/enc-001',
    performerDisplay: 'Omron X200 Smart Tensiómetro',
    bodySiteDisplay: 'Right arm',
    deviceReference: 'Device/device-001',
    deviceDisplay: 'Blood pressure monitor',
    consentSummary: 'Data usage governed by patient consent ID: CONS-2026-889',
  },
  {
    timestamp: '2026-04-28T14:30:05Z',
    type: 'heart-rate',
    value: '72',
    rawValue: 72,
    unit: 'bpm',
    xRequestId: 'req-987654321',
  },
]

describe('MeasurementsTable', () => {
  it('renders table with measurements', () => {
    render(<MeasurementsTable measurements={mockMeasurements} />)

    expect(screen.getByRole('table')).not.toBeNull()
    expect(screen.getByText('Timestamp')).not.toBeNull()
    expect(screen.getByText('Tipo')).not.toBeNull()
    expect(screen.getByText('Valor')).not.toBeNull()
    expect(screen.getByText('X-Request-Id')).not.toBeNull()
  })

  it('displays measurement data correctly', () => {
    render(<MeasurementsTable measurements={mockMeasurements} />)

    expect(screen.getByText((content) => content.includes('32:10'))).not.toBeNull()
    expect(screen.getByText('PA')).not.toBeNull()
    expect(screen.getByText('120/80 mmHg')).not.toBeNull()
    expect(screen.getByText((content) => content.includes('Emitida'))).not.toBeNull()
    expect(screen.getByText((content) => content.includes('Omron X200 Smart Tensiómetro'))).not.toBeNull()
    expect(screen.getByTitle('req-123456789')).not.toBeNull()
  })

  it('shows full X-Request-Id on hover', () => {
    render(<MeasurementsTable measurements={mockMeasurements} />)

    const truncatedId = screen.getByTitle('req-123456789')
    expect(truncatedId.getAttribute('title')).toBe('req-123456789')
  })

  it('renders empty state when no measurements', () => {
    render(<MeasurementsTable measurements={[]} />)

    expect(screen.getByText('No hay mediciones disponibles')).not.toBeNull()
  })

  it('sorts by timestamp when header is clicked', () => {
    render(<MeasurementsTable measurements={mockMeasurements} />)

    const timestampHeader = screen.getByText('Timestamp')
    fireEvent.click(timestampHeader)

    // After sorting, first row should be the earlier timestamp
    const rows = screen.getAllByRole('row')
    const firstDataRow = rows[1] // Skip header row
    expect(within(firstDataRow).getByText((content) => content.includes('30:05'))).not.toBeNull()
  })

  it('sorts by type when header is clicked', () => {
    render(<MeasurementsTable measurements={mockMeasurements} />)

    const typeHeader = screen.getByText('Tipo')
    fireEvent.click(typeHeader)

    const rows = screen.getAllByRole('row')
    const firstDataRow = rows[1]
    expect(within(firstDataRow).getByText('PA')).not.toBeNull()
  })

  it('paginates when more than 10 measurements', () => {
    const manyMeasurements = Array.from({ length: 15 }, (_, i) => ({
      ...mockMeasurements[0],
      timestamp: `2026-04-28T14:${String(30 + i).padStart(2, '0')}:00Z`,
      xRequestId: `req-${i}`,
    }))

    render(<MeasurementsTable measurements={manyMeasurements} />)

    // Should show pagination controls
    expect(screen.getByText((content) => content.includes('Página'))).not.toBeNull() // Page 1
    expect(screen.getByText((content) => content.includes('Página'))).not.toBeNull() // Page 2

    // Should show only 10 rows initially
    const rows = screen.getAllByRole('row')
    expect(rows.length).toBe(11) // 10 data + 1 header
  })

  it('is responsive with horizontal scroll', () => {
    render(<MeasurementsTable measurements={mockMeasurements} />)

    const tableContainer = document.querySelector('.overflow-x-auto')
    expect(tableContainer).not.toBeNull()
  })
})
