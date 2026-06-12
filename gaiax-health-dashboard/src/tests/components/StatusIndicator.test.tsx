import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import StatusIndicator from '../../components/StatusIndicator'

const mockUseFhirBackendStatus = vi.fn()

vi.mock('../../hooks/useFhirData', () => ({
  useFhirBackendStatus: () => mockUseFhirBackendStatus(),
}))

describe('StatusIndicator', () => {
  beforeEach(() => {
    mockUseFhirBackendStatus.mockReset()
  })

  it('shows loading state', () => {
    mockUseFhirBackendStatus.mockReturnValue({
      data: undefined,
      isLoading: true,
    })

    render(<StatusIndicator />)

    expect(screen.getByText('FHIR API:')).toBeInTheDocument()
    expect(screen.getByText('Verificando...')).toBeInTheDocument()
    expect(screen.getByTitle('Desconectado')).toHaveClass('animate-pulse')
  })

  it('shows connected state', () => {
    mockUseFhirBackendStatus.mockReturnValue({
      data: true,
      isLoading: false,
    })

    render(<StatusIndicator />)

    expect(screen.getByText('✓ Conectado')).toBeInTheDocument()
    expect(screen.getByTitle('Conectado')).toHaveClass('bg-clinical-green')
  })

  it('shows disconnected state', () => {
    mockUseFhirBackendStatus.mockReturnValue({
      data: false,
      isLoading: false,
    })

    render(<StatusIndicator />)

    expect(screen.getByText('✗ Desconectado')).toBeInTheDocument()
    expect(screen.getByTitle('Desconectado')).toHaveClass('bg-clinical-red')
  })

  it('has proper accessibility attributes', () => {
    mockUseFhirBackendStatus.mockReturnValue({
      data: true,
      isLoading: false,
    })

    render(<StatusIndicator />)

    const indicator = screen.getByTitle('Conectado')
    expect(indicator).toHaveAttribute('title', 'Conectado')
  })
})
