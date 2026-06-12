import { Component, ReactNode } from 'react'

interface ErrorBoundaryProps {
  children: ReactNode
}

interface ErrorBoundaryState {
  hasError: boolean
  error: Error | null
}

export default class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props)
    this.state = { hasError: false, error: null }
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error }
  }

  componentDidCatch(error: Error) {
    console.error('ErrorBoundary caught:', error)
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="card p-8 border-l-4 border-clinical-red bg-red-50">
          <div className="flex items-start gap-4">
            <div className="text-3xl text-clinical-red">⚠️</div>
            <div className="flex-1">
              <h2 className="text-lg font-semibold text-clinical-red mb-2">Algo salió mal</h2>
              <p className="text-gray-700 mb-4">Ocurrió un error inesperado. Por favor, intenta de nuevo.</p>
              {this.state.error && (
                <details className="text-xs text-gray-600 bg-white p-2 rounded border border-gray-300 mb-4">
                  <summary className="cursor-pointer font-mono">Detalles del error</summary>
                  <pre className="mt-2 whitespace-pre-wrap break-words">{this.state.error.message}</pre>
                </details>
              )}
              <button
                onClick={() => {
                  this.setState({ hasError: false, error: null })
                  window.location.reload()
                }}
                className="px-4 py-2 bg-clinical-blue text-white rounded hover:bg-blue-700 transition"
              >
                Reintentar
              </button>
            </div>
          </div>
        </div>
      )
    }

    return this.props.children
  }
}
