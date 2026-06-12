import type { AnalyticsMeasurementTypeOption, AnalyticsObservation, AnalyticsStats } from '../types/analysis'

interface AnalyticsStatsPanelProps {
  stats: AnalyticsStats
  measurementTypes: AnalyticsMeasurementTypeOption[]
  selectedObservation?: AnalyticsObservation | null
}

function StatCard({
  label,
  value,
  tone = 'text-slate-900',
}: {
  label: string
  value: string
  tone?: string
}) {
  return (
    <div className="rounded-2xl bg-slate-50 p-4">
      <p className="text-xs uppercase tracking-[0.25em] text-slate-500">{label}</p>
      <p className={`mt-1 text-lg font-semibold ${tone}`}>{value}</p>
    </div>
  )
}

export default function AnalyticsStatsPanel({
  stats,
  measurementTypes,
  selectedObservation,
}: AnalyticsStatsPanelProps) {
  return (
    <aside className="card sticky top-28 space-y-6 overflow-hidden p-6">
      <div>
        <p className="text-xs uppercase tracking-[0.25em] text-clinical-blue">Panel lateral</p>
        <h3 className="mt-1 text-xl font-semibold text-slate-900">Estadísticas dinámicas</h3>
        <p className="mt-2 text-sm text-slate-600">
          Los valores se recalculan con cada filtro y permiten una lectura rápida del conjunto clínico.
        </p>
      </div>

      <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-1">
        <StatCard label="Pacientes" value={`${stats.totalPatients}`} />
        <StatCard label="Observaciones" value={`${stats.totalObservations}`} />
        <StatCard label="Media" value={stats.totalObservations > 0 ? `${stats.mean}` : 'N/D'} tone="text-blue-700" />
        <StatCard label="Mediana" value={stats.totalObservations > 0 ? `${stats.median}` : 'N/D'} />
        <StatCard label="Desviación" value={stats.totalObservations > 0 ? `${stats.stdDev}` : 'N/D'} />
        <StatCard label="Mínimo / Máximo" value={stats.totalObservations > 0 ? `${stats.minimum} / ${stats.maximum}` : 'N/D'} />
        <StatCard label="P25 / P75" value={stats.totalObservations > 0 ? `${stats.percentile25} / ${stats.percentile75}` : 'N/D'} />
        <StatCard label="Anómalos" value={`${stats.iqrOutliers}`} tone="text-rose-700" />
      </div>

      <div className="rounded-2xl border border-slate-200 bg-white p-4">
        <h4 className="text-sm font-semibold text-slate-900">Tipos de medición</h4>
        <div className="mt-3 flex flex-wrap gap-2">
          {measurementTypes.length > 0 ? (
            measurementTypes.map((type) => (
              <span
                key={type.key}
                className="rounded-full bg-blue-50 px-3 py-1 text-xs font-medium text-clinical-blue"
              >
                {type.label} · {type.count}
              </span>
            ))
          ) : (
            <p className="text-sm text-slate-500">Sin tipos disponibles</p>
          )}
        </div>
      </div>

      <div className="rounded-2xl border border-slate-200 bg-slate-50 p-4">
        <h4 className="text-sm font-semibold text-slate-900">Selección activa</h4>
        {selectedObservation ? (
          <div className="mt-3 space-y-2 text-sm text-slate-700">
            <p className="font-medium text-slate-900">{selectedObservation.patientDisplayName}</p>
            <p>{selectedObservation.measurementTypeLabel}</p>
            <p>
              Valor: {selectedObservation.displayValue} {selectedObservation.unit ?? ''}
            </p>
            <p>Fecha: {selectedObservation.timestamp}</p>
            <p>Sexo: {selectedObservation.patientSex}</p>
            <p>Edad: {selectedObservation.patientAge ?? 'N/D'}</p>
            {selectedObservation.consentSummary && (
              <p className="text-xs uppercase tracking-[0.2em] text-slate-500">
                {selectedObservation.consentSummary}
              </p>
            )}
          </div>
        ) : (
          <p className="mt-3 text-sm text-slate-500">No hay observación seleccionada.</p>
        )}
      </div>
    </aside>
  )
}
