import { useFhirBackendStatus } from '../hooks/useFhirData'

export default function StatusIndicator() {
  const { data: isConnected, isLoading } = useFhirBackendStatus()

  return (
    <div className="flex items-center gap-3 px-4 py-2 bg-gray-100 rounded-lg text-sm">
      <div
        className={`w-3 h-3 rounded-full ${
          isConnected ? 'bg-clinical-green' : 'bg-clinical-red'
        } ${isLoading ? 'animate-pulse' : ''}`}
        title={isConnected ? 'Conectado' : 'Desconectado'}
      />
      <span className="text-gray-700">
        FHIR API:{' '}
        <span className={isConnected ? 'text-clinical-green font-semibold' : 'text-clinical-red font-semibold'}>
          {isLoading ? 'Verificando...' : isConnected ? '✓ Conectado' : '✗ Desconectado'}
        </span>
      </span>
    </div>
  )
}
