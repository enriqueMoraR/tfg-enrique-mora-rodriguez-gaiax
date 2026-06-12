import { beforeEach, describe, expect, it, vi } from 'vitest'
import { fireEvent, render, screen } from '@testing-library/react'
import App from '../App'

const mockDashboard = vi.hoisted(() => vi.fn(({ activePage }: { activePage: string }) => (
  <div data-testid="dashboard-page">{activePage}</div>
)))

vi.mock('../pages/Dashboard', () => ({
  default: (props: { activePage: string }) => mockDashboard(props),
}))

describe('App shell', () => {
  beforeEach(() => {
    Object.defineProperty(window, 'scrollTo', {
      value: vi.fn(),
      writable: true,
    })
    mockDashboard.mockClear()
  })

  it('renders the overview page by default', () => {
    render(<App />)

    expect(screen.getByTestId('dashboard-page')).toHaveTextContent('overview')
    expect(screen.getByRole('button', { name: 'Inicio' })).toHaveAttribute('aria-pressed', 'true')
  })

  it('switches pages from the top navigation', () => {
    render(<App />)

    fireEvent.click(screen.getByRole('button', { name: 'Pacientes' }))
    expect(screen.getByTestId('dashboard-page')).toHaveTextContent('patients')

    fireEvent.click(screen.getByRole('button', { name: 'Analítica' }))
    expect(screen.getByTestId('dashboard-page')).toHaveTextContent('analytics')
  })
})
