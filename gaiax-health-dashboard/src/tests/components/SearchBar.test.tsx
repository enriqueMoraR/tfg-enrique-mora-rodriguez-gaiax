import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import SearchBar from '../../components/SearchBar'

describe('SearchBar', () => {
  const mockOnSearch = vi.fn()

  beforeEach(() => {
    mockOnSearch.mockClear()
    localStorage.clear()
  })

  it('renders input and button', () => {
    render(<SearchBar onSearch={mockOnSearch} />)
    expect(screen.getByPlaceholderText('ej: patient-001')).toBeTruthy()
    expect(screen.getByRole('button', { name: 'Buscar' })).toBeTruthy()
  })

  it('calls onSearch when button is clicked with valid input', () => {
    render(<SearchBar onSearch={mockOnSearch} />)
    const input = screen.getByPlaceholderText('ej: patient-001')
    const button = screen.getByRole('button', { name: 'Buscar' })

    fireEvent.change(input, { target: { value: 'patient-001' } })
    fireEvent.click(button)

    expect(mockOnSearch).toHaveBeenCalledWith('patient-001')
  })

  it('validates input format and shows alert for invalid characters', () => {
    const alertMock = vi.spyOn(window, 'alert').mockImplementation(() => {})
    render(<SearchBar onSearch={mockOnSearch} />)
    const input = screen.getByPlaceholderText('ej: patient-001')
    const button = screen.getByRole('button', { name: 'Buscar' })

    fireEvent.change(input, { target: { value: 'patient@001' } })
    fireEvent.click(button)

    expect(alertMock).toHaveBeenCalledWith('ID de paciente inválido. Usa solo letras, números y guiones.')
    expect(mockOnSearch).not.toHaveBeenCalled()

    alertMock.mockRestore()
  })

  it('saves search history to localStorage', () => {
    render(<SearchBar onSearch={mockOnSearch} />)
    const input = screen.getByPlaceholderText('ej: patient-001')
    const button = screen.getByRole('button', { name: 'Buscar' })

    fireEvent.change(input, { target: { value: 'patient-001' } })
    fireEvent.click(button)

    expect(localStorage.getItem('patientSearchHistory')).toBe('["patient-001"]')
  })

  it('loads and displays search history', () => {
    localStorage.setItem('patientSearchHistory', '["patient-001","patient-002"]')
    render(<SearchBar onSearch={mockOnSearch} />)

    expect(screen.getByText('patient-001')).toBeTruthy()
    expect(screen.getByText('patient-002')).toBeTruthy()
  })

  it('shows only the first 20 loaded patients', () => {
    const suggestions = Array.from({ length: 25 }, (_, index) => `patient-${String(index + 1).padStart(3, '0')}`)
    render(<SearchBar onSearch={mockOnSearch} suggestions={suggestions} />)

    expect(screen.getByText('Pacientes cargados (20 primeros):')).toBeTruthy()
    expect(screen.getByText('patient-020')).toBeTruthy()
    expect(screen.queryByText('patient-021')).toBeNull()
  })

  it('clears input when Limpiar button is clicked', () => {
    render(<SearchBar onSearch={mockOnSearch} />)
    const input = screen.getByPlaceholderText('ej: patient-001')
    const clearButton = screen.getByRole('button', { name: 'Limpiar' })

    fireEvent.change(input, { target: { value: 'patient-001' } })
    fireEvent.click(clearButton)

    expect((input as HTMLInputElement).value).toBe('')
  })

  it('disables button when input is empty', () => {
    render(<SearchBar onSearch={mockOnSearch} />)
    const button = screen.getByRole('button', { name: 'Buscar' })

    expect((button as HTMLButtonElement).disabled).toBe(true)
  })

  it('disables button when loading', () => {
    render(<SearchBar onSearch={mockOnSearch} isLoading={true} />)
    const button = screen.getByRole('button', { name: 'Buscando...' })

    expect((button as HTMLButtonElement).disabled).toBe(true)
    expect(button.textContent).toBe('Buscando...')
  })
})
