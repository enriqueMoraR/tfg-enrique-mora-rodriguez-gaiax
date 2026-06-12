import { useState, useEffect } from 'react'

interface SearchBarProps {
  onSearch: (patientIdOrQuery: string) => void
  isLoading?: boolean
  suggestions?: string[]
}

const PRELOADED_PATIENT_LIMIT = 20
const PATIENT_ID_PATTERN = /^[a-zA-Z0-9-]+$/

export default function SearchBar({ onSearch, isLoading, suggestions = [] }: SearchBarProps) {
  const [input, setInput] = useState('')
  const [history, setHistory] = useState<string[]>([])
  const visibleSuggestions = suggestions.slice(0, PRELOADED_PATIENT_LIMIT)

  useEffect(() => {
    // Load history from localStorage
    const saved = localStorage.getItem('patientSearchHistory')
    if (saved) {
      setHistory(JSON.parse(saved))
    }
  }, [])

  const handleSearch = () => {
    const normalizedInput = input.trim()
    if (!normalizedInput) return

    if (!PATIENT_ID_PATTERN.test(normalizedInput)) {
      window.alert('ID de paciente inválido. Usa solo letras, números y guiones.')
      return
    }

    // Allow partial queries while keeping identifiers constrained.
    // Add to history (max 5)
    const newHistory = [normalizedInput, ...history.filter((h) => h !== normalizedInput)].slice(0, 5)
    setHistory(newHistory)
    localStorage.setItem('patientSearchHistory', JSON.stringify(newHistory))

    onSearch(normalizedInput)
  }

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleSearch()
    }
  }

  return (
    <div className="card p-6 mb-6">
      <label className="block text-sm font-medium text-gray-700 mb-2">
        Buscar Paciente por ID
      </label>
      <div className="flex gap-3">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="ej: patient-001"
          className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-clinical-blue"
          disabled={isLoading}
        />
        <button
          onClick={handleSearch}
          disabled={isLoading || !input.trim()}
          className="px-6 py-2 bg-clinical-blue text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition"
        >
          {isLoading ? 'Buscando...' : 'Buscar'}
        </button>
        <button
          onClick={() => setInput('')}
          className="px-4 py-2 border border-gray-300 bg-white text-gray-700 rounded-lg hover:bg-gray-100 transition"
        >
          Limpiar
        </button>
      </div>

      {/* Search history */}
      {history.length > 0 && (
        <div className="mt-4">
          <p className="text-xs font-medium text-gray-600 mb-2">Búsquedas recientes:</p>
          <div className="flex flex-wrap gap-2">
            {history.map((id) => (
              <button
                key={id}
                onClick={() => {
                  setInput(id)
                  onSearch(id)
                }}
                className="px-3 py-1 text-sm bg-gray-200 text-gray-800 rounded hover:bg-gray-300 transition"
              >
                {id}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Suggestions / Preloaded patients */}
      {visibleSuggestions.length > 0 && (
        <div className="mt-4">
          <p className="text-xs font-medium text-gray-600 mb-2">Pacientes cargados (20 primeros):</p>
          <ul className="max-h-72 overflow-y-auto rounded-lg border border-gray-200 bg-gray-50 divide-y divide-gray-200">
            {visibleSuggestions.map((id) => (
              <li key={id}>
                <button
                  type="button"
                  onClick={() => {
                    setInput(id)
                    onSearch(id)
                  }}
                  className="w-full px-3 py-2 text-left text-sm text-gray-800 hover:bg-white transition"
                >
                  {id}
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}
