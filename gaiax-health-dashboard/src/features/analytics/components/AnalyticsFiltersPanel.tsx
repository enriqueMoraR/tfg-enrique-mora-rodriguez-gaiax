import type { ReactNode } from 'react'
import type { AnalyticsFilters, AnalyticsMeasurementTypeOption, AnalyticsPatient } from '../types/analysis'

interface AnalyticsFiltersPanelProps {
  filters: AnalyticsFilters
  patients: AnalyticsPatient[]
  measurementTypes: AnalyticsMeasurementTypeOption[]
  onChange: <K extends keyof AnalyticsFilters>(key: K, value: AnalyticsFilters[K]) => void
  onReset: () => void
}

function filterValue(value?: string | null) {
  return value ?? ''
}

function FilterField({
  label,
  children,
}: {
  label: string
  children: ReactNode
}) {
  return (
    <label className="space-y-2 text-sm">
      <span className="block font-medium text-slate-700">{label}</span>
      {children}
    </label>
  )
}

export default function AnalyticsFiltersPanel({
  filters,
  patients,
  measurementTypes,
  onChange,
  onReset,
}: AnalyticsFiltersPanelProps) {
  return (
    <section className="card overflow-hidden">
      <div className="border-b border-slate-200 bg-slate-50 px-6 py-5">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <p className="text-xs uppercase tracking-[0.25em] text-clinical-blue">Análisis de Mediciones</p>
            <h3 className="mt-1 text-xl font-semibold text-slate-900">Panel de filtros</h3>
            <p className="mt-1 text-sm text-slate-600">
              Los filtros actúan sobre las observaciones FHIR y actualizan la vista en tiempo real.
            </p>
          </div>

          <button
            type="button"
            onClick={onReset}
            className="inline-flex items-center justify-center rounded-full border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:border-clinical-blue hover:text-clinical-blue"
          >
            Limpiar filtros
          </button>
        </div>
      </div>

      <div className="grid gap-4 px-6 py-6 md:grid-cols-2 xl:grid-cols-3">
        <FilterField label="Paciente">
          <select
            value={filterValue(filters.patientId)}
            onChange={(event) => onChange('patientId', event.target.value || null)}
            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-clinical-blue focus:ring-2 focus:ring-blue-100"
          >
            <option value="">Todos los pacientes</option>
            {patients.map((patient) => (
              <option key={patient.id} value={patient.id}>
                {patient.displayName} · {patient.ageGroup}
              </option>
            ))}
          </select>
        </FilterField>

        <FilterField label="Tipo de medición">
          <select
            value={filterValue(filters.measurementType)}
            onChange={(event) => onChange('measurementType', event.target.value || null)}
            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-clinical-blue focus:ring-2 focus:ring-blue-100"
          >
            <option value="">Todas las mediciones</option>
            {measurementTypes.map((type) => (
              <option key={type.key} value={type.key}>
                {type.label} · {type.count}
              </option>
            ))}
          </select>
        </FilterField>

        <FilterField label="Sexo">
          <select
            value={filters.sex ?? 'any'}
            onChange={(event) => onChange('sex', event.target.value as AnalyticsFilters['sex'])}
            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-clinical-blue focus:ring-2 focus:ring-blue-100"
          >
            <option value="any">Todos</option>
            <option value="female">Femenino</option>
            <option value="male">Masculino</option>
            <option value="other">Otro</option>
            <option value="unknown">Desconocido</option>
          </select>
        </FilterField>

        <FilterField label="Grupo de edad">
          <select
            value={filters.ageGroup ?? 'any'}
            onChange={(event) => onChange('ageGroup', event.target.value as AnalyticsFilters['ageGroup'])}
            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-clinical-blue focus:ring-2 focus:ring-blue-100"
          >
            <option value="any">Todos</option>
            <option value="0-18">0–18</option>
            <option value="19-40">19–40</option>
            <option value="41-65">41–65</option>
            <option value="65+">65+</option>
          </select>
        </FilterField>

        <FilterField label="Fecha desde">
          <input
            type="date"
            value={filterValue(filters.dateFrom)}
            onChange={(event) => onChange('dateFrom', event.target.value || null)}
            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-clinical-blue focus:ring-2 focus:ring-blue-100"
          />
        </FilterField>

        <FilterField label="Fecha hasta">
          <input
            type="date"
            value={filterValue(filters.dateTo)}
            onChange={(event) => onChange('dateTo', event.target.value || null)}
            className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm text-slate-900 outline-none transition focus:border-clinical-blue focus:ring-2 focus:ring-blue-100"
          />
        </FilterField>
      </div>
    </section>
  )
}
