import { useEffect, useState } from 'react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import ErrorBoundary from './components/ErrorBoundary'
import Dashboard, { type DashboardPage } from './pages/Dashboard'
import HistorialPage from './pages/Historial' // Importar la nueva página
import ProveedoresPage from './pages/Proveedores' // Importar la página de proveedores
import StatusIndicator from './components/StatusIndicator'
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5,
      gcTime: 1000 * 60 * 10,
    },
  },
})

// Añadir la nueva página a la lista de páginas posibles
type AppPage = DashboardPage | 'historial' | 'proveedores'

const PAGES: Array<{ id: AppPage; label: string; description: string }> = [
  { id: 'overview', label: 'Inicio', description: 'Resumen ejecutivo y visión general en tiempo real' },
  { id: 'patients', label: 'Pacientes', description: 'Explora y selecciona pacientes cargados desde FHIR' },
  { id: 'analytics', label: 'Analítica', description: 'Tendencias, distribución y lectura clínica real' },
  { id: 'historial', label: 'Historial Clínico', description: 'Visualiza el historial detallado de un paciente' },
  { id: 'proveedores', label: 'Hospitales y Médicos', description: 'Directorio de instituciones de salud y cuadro médico colegiado' },
]

export default function App() {
  const [activePage, setActivePage] = useState<AppPage>('overview')
  const currentPage = PAGES.find((page) => page.id === activePage) ?? PAGES[0]

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }, [activePage])

  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <div className="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(30,64,175,0.09),_transparent_38%),linear-gradient(180deg,_#f8fafc_0%,_#eef2ff_100%)] text-slate-900">
          <header className="sticky top-0 z-30 border-b border-white/70 bg-white/80 backdrop-blur-xl">
            <div className="mx-auto flex max-w-7xl flex-col gap-4 px-4 py-4 sm:px-6 lg:px-8">
              <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                <div className="space-y-1">
                  <div className="flex items-center gap-3">
                    <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-clinical-blue text-white shadow-lg shadow-blue-900/20">
                      GX
                    </div>
                    <div>
                      <p className="text-xs font-semibold uppercase tracking-[0.3em] text-clinical-blue">
                        Gaia-X Health
                      </p>
                      <h1 className="text-2xl font-semibold tracking-tight text-slate-900 sm:text-3xl">
                        Dashboard de pacientes
                      </h1>
                    </div>
                  </div>
                  <p className="max-w-2xl text-sm text-slate-600">
                    {currentPage.description}. Presentación limpia, navegación por secciones y
                    gráficos pensados para explorar el estado clínico con rapidez.
                  </p>
                </div>

                <nav className="flex flex-wrap gap-2">
                  {PAGES.map((page) => {
                    const isActive = page.id === activePage
                    return (
                      <button
                        key={page.id}
                        type="button"
                        onClick={() => setActivePage(page.id)}
                        aria-pressed={isActive}
                        className={`rounded-full px-4 py-2 text-sm font-medium transition ${
                          isActive
                            ? 'bg-clinical-blue text-white shadow-lg shadow-blue-900/20'
                            : 'border border-slate-200 bg-white text-slate-700 hover:border-clinical-blue hover:text-clinical-blue'
                        }`}
                      >
                        {page.label}
                      </button>
                    )
                  })}
                </nav>
              </div>
            </div>
          </header>

          <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
            {/* Renderizado condicional */}
            {activePage === 'historial' ? (
              <HistorialPage />
            ) : activePage === 'proveedores' ? (
              <ProveedoresPage />
            ) : (
              <Dashboard activePage={activePage} />
            )}
          </main>

          <footer className="border-t border-white/70 bg-white/70 backdrop-blur-xl">
            <div className="mx-auto max-w-7xl px-4 py-6 text-sm text-slate-600 sm:px-6 lg:px-8">
              Presentación de datos Gaia-X Health · Vista pública de paciente y analítica.
            </div>
          </footer>
          <div className="fixed bottom-4 right-4 z-50 pointer-events-none">
            <StatusIndicator />
          </div>
        </div>
      </QueryClientProvider>
    </ErrorBoundary>
  )
}
