import { describe, it, expect, vi, afterEach, afterAll } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import ErrorBoundary from '../../components/ErrorBoundary'

// Component that throws an error
const ThrowError = () => {
  throw new Error('Test error')
}

describe('ErrorBoundary', () => {
  const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {})

  afterEach(() => {
    consoleSpy.mockClear()
  })

  afterAll(() => {
    consoleSpy.mockRestore()
  })

  it('renders children when no error', () => {
    render(
      <ErrorBoundary>
        <div>Normal content</div>
      </ErrorBoundary>
    )

    expect(screen.getByText('Normal content')).toBeInTheDocument()
  })

  it('catches and displays error fallback UI', () => {
    render(
      <ErrorBoundary>
        <ThrowError />
      </ErrorBoundary>
    )

    expect(screen.getByText('Algo salió mal')).toBeInTheDocument()
    expect(screen.getByText('Ocurrió un error inesperado. Por favor, intenta de nuevo.')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Reintentar' })).toBeInTheDocument()
  })

  it('logs error to console', () => {
    render(
      <ErrorBoundary>
        <ThrowError />
      </ErrorBoundary>
    )

    expect(consoleSpy).toHaveBeenCalledWith('ErrorBoundary caught:', expect.any(Error))
  })

  it('shows error details in collapsible section', () => {
    render(
      <ErrorBoundary>
        <ThrowError />
      </ErrorBoundary>
    )

    const details = screen.getByText('Detalles del error')
    expect(details).toBeInTheDocument()

    // The error message should be visible in the details
    expect(screen.getByText('Test error')).toBeInTheDocument()
  })

  it('calls window.location.reload when reset button is clicked', () => {
    render(
      <ErrorBoundary>
        <ThrowError />
      </ErrorBoundary>
    )

    const resetButton = screen.getByRole('button', { name: 'Reintentar' })
    fireEvent.click(resetButton)

    expect(screen.getByText('Algo salió mal')).toBeInTheDocument()
  })

  it('has proper error styling', () => {
    render(
      <ErrorBoundary>
        <ThrowError />
      </ErrorBoundary>
    )

    const errorContainer = screen.getByText('Algo salió mal').closest('.card')
    expect(errorContainer).toHaveClass('card', 'p-8', 'border-l-4', 'border-clinical-red', 'bg-red-50')
  })
})
