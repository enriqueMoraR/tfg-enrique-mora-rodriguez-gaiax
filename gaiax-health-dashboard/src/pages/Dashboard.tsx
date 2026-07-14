import { useEffect, useMemo, useState } from 'react'
import {
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import SearchBar from '../components/SearchBar'
import AnalyticsFiltersPanel from '../features/analytics/components/AnalyticsFiltersPanel'
import AnalyticsStatsPanel from '../features/analytics/components/AnalyticsStatsPanel'
import ComparisonScatterChart from '../features/analytics/components/ComparisonScatterChart'
import MeasurementDistributionChart from '../features/analytics/components/MeasurementDistributionChart'
import TemporalEchartsChart from '../features/analytics/components/TemporalEchartsChart'
import MetricsLineChart from '../components/MetricsLineChart'
import MeasurementsTable from '../features/patients/components/MeasurementsTable'
import PatientsTable from '../features/patients/components/PatientsTable'
import { buildAnalyticsDatasetFromResources, filterAnalyticsDataset } from '../features/analytics/services/analyticsDataset'
import { normalizeMeasurements } from '../features/patients/services/dataTransform'
import { useAnalyticsFilters } from '../features/analytics/hooks/useAnalyticsFilters'
import { downloadAnalyticsChartPng, downloadAnalyticsCsv } from '../features/analytics/services/analyticsExport'
import { buildHistogram, calculateBoxPlotSummary } from '../features/analytics/services/analyticsStatistics'
import type { Measurement } from '../types/domain'
import type { FhirObservation, FhirPatient } from '../types/fhir'
import { useFhirObservations, useFhirPatients } from '../hooks/useFhirData'

export type DashboardPage = 'overview' | 'patients' | 'analytics'

interface DashboardProps {
  activePage: DashboardPage
}

type PatientSearchFeedback =
  | { type: 'idle' }
  | { type: 'found'; query: string; inPreview: boolean; patient: FhirPatient }
  | { type: 'not-found'; query: string }

const HERO_IMAGE = 'https://gaiax-spain.com/wp-content/uploads/2026/06/Webinar-framwork-header.webp'
const STORY_IMAGE = 'https://gaiax-spain.com/wp-content/uploads/2026/01/Impulsamos-la-economia-del-dato-en-Espana.jpg'
const X_REQUEST_ID = 'fhir-dashboard-live'
const PREVIEW_LIMIT = 20
const FULL_DATA_LIMIT = 10000
const ANALYTICS_PATIENT_LIMIT = 500
const ANALYTICS_OBSERVATION_LIMIT = 5000
const ANALYTICS_VIEW_MODES = [
  { id: 'temporal', label: 'Evolución temporal', description: 'Tendencia agregada y paciente seleccionado' },
  { id: 'distribution', label: 'Distribución', description: 'Histograma y box plot de la muestra' },
  { id: 'comparison', label: 'Comparación', description: 'Scatter plot entre pacientes' },
] as const

type PressureBand = 'Baja' | 'Normal' | 'Elevada' | 'Alta' | 'Muy alta'

function parseBloodPressure(value: string) {
  const match = value.match(/(\d+)\s*\/\s*(\d+)/)
  if (!match) return null

  return {
    systolic: Number(match[1]),
    diastolic: Number(match[2]),
  }
}

function classifyPressure(reading: { systolic: number; diastolic: number }): PressureBand {
  const { systolic, diastolic } = reading

  if (systolic < 90 || diastolic < 60) return 'Baja'
  if (systolic < 120 && diastolic < 80) return 'Normal'
  if (systolic < 130 && diastolic < 80) return 'Elevada'
  if (systolic < 140 || diastolic < 90) return 'Alta'
  return 'Muy alta'
}

function buildPressureDistribution(measurements: Measurement[]) {
  const counts = new Map<PressureBand, number>([
    ['Baja', 0],
    ['Normal', 0],
    ['Elevada', 0],
    ['Alta', 0],
    ['Muy alta', 0],
  ])

  measurements.forEach((measurement) => {
    if (measurement.type !== 'blood-pressure') return
    const reading =
      typeof measurement.rawValue === 'object'
        ? measurement.rawValue
        : parseBloodPressure(String(measurement.value))
    if (!reading) return
    const band = classifyPressure(reading)
    counts.set(band, (counts.get(band) ?? 0) + 1)
  })

  const colors: Record<PressureBand, string> = {
    Baja: '#0f766e',
    Normal: '#059669',
    Elevada: '#eab308',
    Alta: '#f97316',
    'Muy alta': '#dc2626',
  }

  return Array.from(counts.entries()).map(([band, count]) => ({
    band,
    count,
    color: colors[band],
  }))
}

function summarizeMeasurements(measurements: Measurement[]) {
  const readings = measurements
    .filter((measurement) => measurement.type === 'blood-pressure')
    .map((measurement) => {
      if (typeof measurement.rawValue === 'object') {
        return measurement.rawValue
      }
      return parseBloodPressure(String(measurement.value))
    })
    .filter(Boolean) as Array<{ systolic: number; diastolic: number }>

  if (readings.length === 0) {
    return {
      averageSystolic: 0,
      averageDiastolic: 0,
      maxSystolic: 0,
      minSystolic: 0,
      latest: null as Measurement | null,
    }
  }

  const averageSystolic = Math.round(readings.reduce((sum, item) => sum + item.systolic, 0) / readings.length)
  const averageDiastolic = Math.round(readings.reduce((sum, item) => sum + item.diastolic, 0) / readings.length)
  const maxSystolic = Math.max(...readings.map((item) => item.systolic))
  const minSystolic = Math.min(...readings.map((item) => item.systolic))
  const latest = [...measurements].sort((a, b) => b.timestamp.localeCompare(a.timestamp))[0] ?? null

  return {
    averageSystolic,
    averageDiastolic,
    maxSystolic,
    minSystolic,
    latest,
  }
}

function formatDate(value?: string | null) {
  if (!value) return 'N/D'
  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
  }).format(new Date(value))
}

function formatPatientName(patient: FhirPatient) {
  const directName = patient.name?.[0]?.text
  if (directName && directName.trim()) return directName
  const given = patient.name?.[0]?.given?.[0] ?? ''
  const family = patient.name?.[0]?.family ?? ''
  const combined = `${given} ${family}`.trim()
  return combined || patient.id
}

function MetricCard({
  title,
  value,
  detail,
  accent = 'text-clinical-blue',
}: {
  title: string
  value: string
  detail: string
  accent?: string
}) {
  return (
    <div className="card p-5">
      <p className="text-xs uppercase tracking-[0.25em] text-slate-500">{title}</p>
      <div className={`mt-2 text-3xl font-semibold tracking-tight ${accent}`}>{value}</div>
      <p className="mt-2 text-sm text-slate-600">{detail}</p>
    </div>
  )
}

function SkeletonBlock({ className = '' }: { className?: string }) {
  return <div className={`animate-pulse rounded-2xl bg-slate-100 ${className}`} />
}

function OverviewSkeleton() {
  return (
    <section className="space-y-6">
      <SkeletonBlock className="h-[320px] w-full rounded-[2rem]" />
      <div className="grid gap-4 md:grid-cols-4">
        <SkeletonBlock className="h-28" />
        <SkeletonBlock className="h-28" />
        <SkeletonBlock className="h-28" />
        <SkeletonBlock className="h-28" />
      </div>
      <div className="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
        <SkeletonBlock className="h-[380px]" />
        <SkeletonBlock className="h-[380px]" />
      </div>
    </section>
  )
}

function PatientsSkeleton() {
  return (
    <section className="grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
      <div className="space-y-6">
        <div className="grid gap-4 lg:grid-cols-[1fr_auto]">
          <SkeletonBlock className="h-16" />
          <SkeletonBlock className="h-16 w-24" />
        </div>
        <SkeletonBlock className="h-[520px]" />
      </div>
      <div className="space-y-6">
        <SkeletonBlock className="h-[220px]" />
        <SkeletonBlock className="h-[260px]" />
      </div>
    </section>
  )
}

function AnalyticsSkeleton() {
  return (
    <section className="space-y-6">
      <SkeletonBlock className="h-40" />
      <div className="grid gap-4 md:grid-cols-4">
        <SkeletonBlock className="h-28" />
        <SkeletonBlock className="h-28" />
        <SkeletonBlock className="h-28" />
        <SkeletonBlock className="h-28" />
      </div>
      <div className="grid gap-6 xl:grid-cols-[1.4fr_0.8fr]">
        <div className="space-y-6">
          <SkeletonBlock className="h-16" />
          <SkeletonBlock className="h-[480px]" />
          <SkeletonBlock className="h-[320px]" />
        </div>
        <SkeletonBlock className="h-[720px]" />
      </div>
    </section>
  )
}

function PressureDistributionChart({ data }: { data: ReturnType<typeof buildPressureDistribution> }) {
  if (data.every((entry) => entry.count === 0)) {
    return (
      <div className="card p-8 text-center text-slate-500">
        <p>No hay datos suficientes para el gráfico de distribución</p>
      </div>
    )
  }

  return (
    <div className="card p-6">
      <h3 className="text-lg font-semibold text-slate-800">Distribución de presión arterial</h3>
      <p className="mt-1 text-sm text-slate-600">Clasificación derivada de las observaciones reales recuperadas.</p>
      <div className="mt-4 h-[320px]">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
            <XAxis dataKey="band" tickLine={false} axisLine={false} />
            <YAxis allowDecimals={false} tickLine={false} axisLine={false} />
            <Tooltip />
            <Legend />
            <Bar dataKey="count" name="Observaciones" radius={[10, 10, 0, 0]}>
              {data.map((entry) => (
                <Cell key={entry.band} fill={entry.color} />
              ))}
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  )
}

function observationConsentSummary(observation?: FhirObservation | null) {
  if (!observation) return null

  const sovereigntyTag = observation.meta?.tag?.find((tag) => tag.system === 'https://gaia-x.eu/trust-framework#')
  const profile = observation.meta?.profile?.[0] ?? 'N/D'
  const device = observation.device?.type?.coding?.[0]?.display ?? observation.device?.reference ?? 'N/D'
  const performer = observation.performer?.[0]?.display ?? 'N/D'

  return {
    profile,
    sovereigntyTag: sovereigntyTag?.display ?? sovereigntyTag?.code ?? 'Sin etiqueta de soberanía',
    device,
    performer,
  }
}

export default function Dashboard({ activePage }: DashboardProps) {
  const [selectedPatientId, setSelectedPatientId] = useState('')
  const [patientSearchFeedback, setPatientSearchFeedback] = useState<PatientSearchFeedback>({ type: 'idle' })
  const [analyticsViewMode, setAnalyticsViewMode] = useState<(typeof ANALYTICS_VIEW_MODES)[number]['id']>('temporal')
  const [selectedAnalyticsObservationId, setSelectedAnalyticsObservationId] = useState<string | null>(null)
  const [analyticsExporting, setAnalyticsExporting] = useState<null | 'png' | 'csv'>(null)

  const patientsQuery = useFhirPatients(PREVIEW_LIMIT)
  const fullPatientsQuery = useFhirPatients(FULL_DATA_LIMIT)
  const fullObservationsQuery = useFhirObservations(undefined, FULL_DATA_LIMIT)
  const selectedObservationsQuery = useFhirObservations(selectedPatientId || undefined, 50, Boolean(selectedPatientId))
  const analyticsPatientsQuery = useFhirPatients(ANALYTICS_PATIENT_LIMIT, activePage === 'analytics')
  const analyticsObservationsQuery = useFhirObservations(undefined, ANALYTICS_OBSERVATION_LIMIT, activePage === 'analytics')

  const patients = patientsQuery.data ?? []
  const fullPatients = fullPatientsQuery.data ?? []
  const fullObservations = fullObservationsQuery.data ?? []
  const selectedObservations = selectedObservationsQuery.data ?? []
  const analyticsPatients = analyticsPatientsQuery.data ?? []
  const analyticsObservations = analyticsObservationsQuery.data ?? []

  useEffect(() => {
    if (!selectedPatientId && patients.length > 0) {
      setSelectedPatientId(patients[0].id)
    }
  }, [patients, selectedPatientId])

  const selectedPatient = useMemo(
    () =>
      patients.find((patient) => patient.id === selectedPatientId) ??
      fullPatients.find((patient) => patient.id === selectedPatientId) ??
      null,
    [patients, fullPatients, selectedPatientId]
  )

  const selectedMeasurements = useMemo(
    () => normalizeMeasurements(selectedObservations, X_REQUEST_ID),
    [selectedObservations]
  )

  const portfolioMeasurements = useMemo(
    () => normalizeMeasurements(fullObservations, X_REQUEST_ID),
    [fullObservations]
  )

  const summary = summarizeMeasurements(portfolioMeasurements)
  const pressureDistribution = buildPressureDistribution(portfolioMeasurements)
  const selectedObservation = selectedObservations[0] ?? null
  const selectedObservationContext = observationConsentSummary(selectedObservation)
  const analyticsDataset = useMemo(
    () => buildAnalyticsDatasetFromResources(analyticsPatients, analyticsObservations),
    [analyticsPatients, analyticsObservations]
  )
  const { filters: analyticsFilters, updateFilter: updateAnalyticsFilter, resetFilters: resetAnalyticsFilters } =
    useAnalyticsFilters({
      availableMeasurementTypeKeys: analyticsDataset.measurementTypes.map((item) => item.key),
    })
  const filteredAnalyticsDataset = useMemo(
    () => filterAnalyticsDataset(analyticsDataset, analyticsFilters),
    [analyticsDataset, analyticsFilters]
  )
  const filteredAnalyticsMeasurements = useMemo(
    () => normalizeMeasurements(filteredAnalyticsDataset.observations.map((observation) => observation.source), X_REQUEST_ID),
    [filteredAnalyticsDataset.observations]
  )
  const analyticsLoading = analyticsPatientsQuery.isLoading || analyticsObservationsQuery.isLoading
  const analyticsNumericValues = useMemo(
    () =>
      filteredAnalyticsDataset.observations
        .map((observation) => observation.numericValue)
        .filter((value): value is number => typeof value === 'number'),
    [filteredAnalyticsDataset.observations]
  )
  const analyticsHistogram = useMemo(() => buildHistogram(analyticsNumericValues, 12), [analyticsNumericValues])
  const analyticsBoxPlot = useMemo(() => calculateBoxPlotSummary(analyticsNumericValues), [analyticsNumericValues])
  const selectedAnalyticsObservation = useMemo(
    () =>
      filteredAnalyticsDataset.observations.find((observation) => observation.id === selectedAnalyticsObservationId) ??
      filteredAnalyticsDataset.observations[0] ??
      null,
    [filteredAnalyticsDataset.observations, selectedAnalyticsObservationId]
  )

  const analyticsExportLabel = analyticsViewMode === 'temporal'
    ? 'evolucion-temporal'
    : analyticsViewMode === 'distribution'
      ? 'distribucion'
      : 'comparacion'

  const analyticsExportBaseName = `analisis-mediciones-${analyticsExportLabel}`

  useEffect(() => {
    const availableSelection = filteredAnalyticsDataset.observations.find(
      (observation) => observation.id === selectedAnalyticsObservationId
    )
    if (!availableSelection && filteredAnalyticsDataset.observations.length > 0) {
      setSelectedAnalyticsObservationId(filteredAnalyticsDataset.observations[0]?.id ?? null)
    }
    if (filteredAnalyticsDataset.observations.length === 0 && selectedAnalyticsObservationId !== null) {
      setSelectedAnalyticsObservationId(null)
    }
  }, [filteredAnalyticsDataset.observations, selectedAnalyticsObservationId])

  const handleSearch = (query: string) => {
    const normalizedQuery = query.trim().toLowerCase()
    if (!normalizedQuery) return

    const match =
      fullPatients.find((patient) => patient.id.toLowerCase() === normalizedQuery) ??
      fullPatients.find((patient) => patient.id.toLowerCase().includes(normalizedQuery)) ??
      null

    if (match) {
      setSelectedPatientId(match.id)
      setPatientSearchFeedback({
        type: 'found',
        query: normalizedQuery,
        patient: match,
        inPreview: patients.some((patient) => patient.id === match.id),
      })
      return
    }

    setSelectedPatientId('')
    setPatientSearchFeedback({ type: 'not-found', query: normalizedQuery })
  }

  const handleSelectPatient = (patient: FhirPatient) => {
    setSelectedPatientId(patient.id)
    setPatientSearchFeedback({
      type: 'found',
      query: patient.id,
      patient,
      inPreview: true,
    })
  }

  const handleExportAnalyticsCsv = () => {
    if (filteredAnalyticsDataset.observations.length === 0) return
    try {
      setAnalyticsExporting('csv')
      downloadAnalyticsCsv(`${analyticsExportBaseName}.csv`, filteredAnalyticsDataset.observations)
    } finally {
      setAnalyticsExporting(null)
    }
  }

  const handleExportAnalyticsPng = async () => {
    if (filteredAnalyticsDataset.observations.length === 0) return

    try {
      setAnalyticsExporting('png')
      await downloadAnalyticsChartPng(
        `[data-analytics-export-root="${analyticsViewMode}"]`,
        `${analyticsExportBaseName}.png`
      )
    } finally {
      setAnalyticsExporting(null)
    }
  }

  const isLoading =
    patientsQuery.isLoading ||
    fullPatientsQuery.isLoading ||
    fullObservationsQuery.isLoading ||
    selectedObservationsQuery.isLoading
  const hasPatients = fullPatients.length > 0

  return (
    <div className="space-y-8">
      {activePage === 'overview' && (isLoading ? (
        <OverviewSkeleton />
      ) : (
        <>
          <section className="relative overflow-hidden rounded-[2rem] border border-white/70 bg-slate-900 text-white shadow-2xl shadow-slate-900/10">
            <div className="absolute inset-0">
              <img src={HERO_IMAGE} alt="" className="h-full w-full object-cover opacity-25" />
              <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_left,_rgba(14,165,233,0.32),_transparent_40%),linear-gradient(90deg,_rgba(15,23,42,0.96),_rgba(15,23,42,0.72),_rgba(15,23,42,0.38))]" />
            </div>

            <div className="relative grid gap-8 px-6 py-8 lg:grid-cols-[1.25fr_0.75fr] lg:px-10 lg:py-10">
              <div className="space-y-6">
                <span className="inline-flex items-center rounded-full border border-white/20 bg-white/10 px-4 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-cyan-100">
                  Presentación clínica Gaia-X
                </span>
                <div className="space-y-4">
                  <h2 className="max-w-3xl text-4xl font-semibold tracking-tight text-white sm:text-5xl">
                    Datos reales de pacientes, consultados desde PostgreSQL y servidos vía FHIR.
                  </h2>
                  <p className="max-w-2xl text-base leading-7 text-slate-200">
                    El dashboard carga la lista real de pacientes desde el provider, permite navegar
                    por el detalle clínico y actualiza la vista automáticamente tras una nueva
                    ingesta por API.
                  </p>
                </div>

                <div className="flex flex-wrap gap-3">
                  <span className="rounded-full border border-white/15 bg-white/10 px-4 py-2 text-sm text-slate-100">
                    Fuente: endpoint FHIR real
                  </span>
                  <span className="rounded-full border border-white/15 bg-white/10 px-4 py-2 text-sm text-slate-100">
                    Límite visual: {PREVIEW_LIMIT} primeros registros
                  </span>
                  <span className="rounded-full border border-white/15 bg-white/10 px-4 py-2 text-sm text-slate-100">
                    Gaia-X Spain como imagen de portada
                  </span>
                </div>
              </div>

              <div className="grid gap-4">
                <div className="overflow-hidden rounded-[1.75rem] border border-white/15 bg-white/10 backdrop-blur">
                  <img
                    src={STORY_IMAGE}
                    alt="Gaia-X España economía del dato"
                    className="h-56 w-full object-cover"
                  />
                  <div className="p-5">
                    <p className="text-xs uppercase tracking-[0.25em] text-cyan-100">
                      Imagen de referencia
                    </p>
                    <p className="mt-2 text-lg font-semibold text-white">
                      Impulsamos la economía del dato en España
                    </p>
                    <p className="mt-2 text-sm leading-6 text-slate-200">
                      Imagen reutilizada como recurso visual institucional, sin datos clínicos
                      embebidos.
                    </p>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <MetricCard
                    title="Pacientes"
                    value={hasPatients ? `${fullPatients.length}` : 'Sin datos'}
                    detail={hasPatients ? 'Pacientes recuperados del provider' : 'Esperando ingesta por API'}
                  />
                  <MetricCard
                    title="Observaciones"
                    value={fullObservations.length > 0 ? `${fullObservations.length}` : 'Sin datos'}
                    detail="Observaciones recuperadas desde la BBDD"
                  />
                </div>
              </div>
            </div>
          </section>

          <section className="grid gap-4 md:grid-cols-4">
            <MetricCard
              title="Último registro"
              value={formatDate(summary.latest?.timestamp)}
              detail="Última observación disponible en la muestra"
            />
            <MetricCard
              title="Sistólica media"
              value={summary.averageSystolic > 0 ? `${summary.averageSystolic}` : 'N/D'}
              detail="Promedio poblacional del snapshot actual"
              accent="text-emerald-700"
            />
            <MetricCard
              title="Sistólica máxima"
              value={summary.maxSystolic > 0 ? `${summary.maxSystolic}` : 'N/D'}
              detail="Lectura más alta del lote"
              accent="text-rose-700"
            />
            <MetricCard
              title="Paciente activo"
              value={selectedPatient ? formatPatientName(selectedPatient) : 'Sin seleccionar'}
              detail="Selección inicial basada en el primer paciente disponible"
            />
          </section>

          {!hasPatients && !isLoading && (
            <div className="card p-8 text-center text-slate-600">
              <p className="text-lg font-semibold text-slate-800">Sin datos</p>
              <p className="mt-2 text-sm">Ingiere un Bundle FHIR desde Postman y refresca la página.</p>
            </div>
          )}

          {hasPatients && (
            <section className="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
              <MetricsLineChart
                measurements={portfolioMeasurements}
                title="Serie temporal poblacional"
              />
              <PressureDistributionChart data={pressureDistribution} />
            </section>
          )}
        </>
      ))}

      {activePage === 'patients' && (isLoading ? (
        <PatientsSkeleton />
      ) : (
        <section className="grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
          <div className="space-y-6">
            <SearchBar
              onSearch={handleSearch}
              isLoading={isLoading}
              suggestions={patients.map((patient) => patient.id)}
            />

            {patientSearchFeedback.type === 'found' && (
              <div className="card border border-blue-200 bg-blue-50 px-5 py-4 text-sm text-slate-700">
                <p className="font-semibold text-clinical-blue">Paciente encontrado en el conjunto completo</p>
                <p className="mt-1">
                  Búsqueda por ID: <span className="font-medium">{patientSearchFeedback.query}</span>
                </p>
                <p className="mt-1">
                  {patientSearchFeedback.patient.id} · {formatPatientName(patientSearchFeedback.patient)}
                </p>
                {!patientSearchFeedback.inPreview && (
                  <p className="mt-1 text-blue-700">
                    Este paciente no está entre los 20 visibles, pero sí en el dataset completo.
                  </p>
                )}
              </div>
            )}

            {patientSearchFeedback.type === 'not-found' && (
              <div className="card border border-rose-200 bg-rose-50 px-5 py-4 text-sm text-rose-700">
                No se encontró ningún paciente con el ID <span className="font-semibold">{patientSearchFeedback.query}</span>.
              </div>
            )}

            <PatientsTable
              patients={patients}
              selectedPatientId={selectedPatientId}
              onSelect={handleSelectPatient}
            />
          </div>

          <div className="space-y-6">
            {selectedPatient && (
              <div className="card overflow-hidden">
                <div className="border-b border-slate-200 px-6 py-5">
                  <h3 className="text-lg font-semibold text-slate-800">Paciente seleccionado</h3>
                  <p className="mt-1 text-sm text-slate-600">
                    Datos clínicos reales recuperados desde el endpoint FHIR.
                  </p>
                </div>
                <div className="grid gap-4 px-6 py-6 sm:grid-cols-2">
                  <div>
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Paciente</p>
                    <p className="mt-1 text-lg font-semibold text-slate-800">
                      {formatPatientName(selectedPatient)}
                    </p>
                  </div>
                  <div>
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">ID</p>
                    <p className="mt-1 text-lg font-semibold text-slate-800">{selectedPatient.id}</p>
                  </div>
                  <div>
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Sexo</p>
                    <p className="mt-1 text-lg font-semibold capitalize text-slate-800">
                      {selectedPatient.gender ?? 'unknown'}
                    </p>
                  </div>
                  <div>
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Nacimiento</p>
                    <p className="mt-1 text-lg font-semibold text-slate-800">
                      {selectedPatient.birthDate ?? 'N/D'}
                    </p>
                  </div>
                </div>
              </div>
            )}

            {selectedObservationContext && selectedObservation && (
              <div className="card p-6">
                <h3 className="text-lg font-semibold text-slate-800">Contexto FHIR y soberanía</h3>
                <p className="mt-2 text-sm leading-6 text-slate-600">
                  La vista muestra el perfil, la procedencia y la política asociada a la observación
                  seleccionada.
                </p>
                <div className="mt-5 grid gap-4 sm:grid-cols-2">
                  <div className="rounded-2xl bg-slate-50 p-4">
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Perfil</p>
                    <p className="mt-1 text-sm font-semibold text-slate-900">
                      {selectedObservationContext.profile}
                    </p>
                  </div>
                  <div className="rounded-2xl bg-slate-50 p-4">
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Política</p>
                    <p className="mt-1 text-sm font-semibold text-slate-900">
                      {selectedObservationContext.sovereigntyTag}
                    </p>
                  </div>
                  <div className="rounded-2xl bg-slate-50 p-4">
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Dispositivo</p>
                    <p className="mt-1 text-sm font-semibold text-slate-900">
                      {selectedObservationContext.device}
                    </p>
                  </div>
                  <div className="rounded-2xl bg-slate-50 p-4">
                    <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Performer</p>
                    <p className="mt-1 text-sm font-semibold text-slate-900">
                      {selectedObservationContext.performer}
                    </p>
                  </div>
                </div>
                <p className="mt-4 text-sm text-slate-600">
                  Emitida {formatDate(selectedObservation.issued)} · Última actualización{' '}
                  {formatDate(selectedObservation.meta?.lastUpdated)} · Total de observaciones del paciente:{' '}
                  {selectedMeasurements.length}
                </p>
              </div>
            )}

            {selectedMeasurements.length > 0 && (
              <MetricsLineChart
                measurements={selectedMeasurements}
                title="Detalle temporal del paciente seleccionado"
              />
            )}

            {selectedMeasurements.length > 0 && (
              <MeasurementsTable measurements={selectedMeasurements} title="Tabla del paciente activo" />
            )}

            {selectedPatient && selectedMeasurements.length === 0 && (
              <div className="card p-8 text-center text-slate-500">
                <p>No hay observaciones para este paciente</p>
              </div>
            )}
          </div>
        </section>
      ))}

      {activePage === 'analytics' && (analyticsLoading ? (
        <AnalyticsSkeleton />
      ) : (
        <section className="space-y-6">
          <AnalyticsFiltersPanel
            filters={analyticsFilters}
            patients={analyticsDataset.patients}
            measurementTypes={analyticsDataset.measurementTypes}
            onChange={updateAnalyticsFilter}
            onReset={resetAnalyticsFilters}
          />

          <div className="grid gap-4 md:grid-cols-4">
            <MetricCard
              title="Pacientes filtrados"
              value={`${filteredAnalyticsDataset.stats.totalPatients}`}
              detail="Pacientes que cumplen todos los filtros activos"
            />
            <MetricCard
              title="Observaciones"
              value={`${filteredAnalyticsDataset.stats.totalObservations}`}
              detail="Recursos FHIR observados en el conjunto filtrado"
            />
            <MetricCard
              title="Media"
              value={filteredAnalyticsDataset.stats.totalObservations > 0 ? `${filteredAnalyticsDataset.stats.mean}` : 'N/D'}
              detail="Promedio de los valores numéricos filtrados"
            />
            <MetricCard
              title="Anómalos"
              value={filteredAnalyticsDataset.stats.iqrOutliers > 0 ? `${filteredAnalyticsDataset.stats.iqrOutliers}` : '0'}
              detail="Valores detectados fuera de 1.5×IQR"
              accent="text-rose-700"
            />
          </div>

          <div className="grid gap-6 xl:grid-cols-[1.4fr_0.8fr]">
            <div className="space-y-6">
              <div className="card flex flex-col gap-3 p-3 lg:flex-row lg:items-center lg:justify-between">
                <div className="flex flex-wrap gap-2">
                  {ANALYTICS_VIEW_MODES.map((mode) => {
                    const isActive = analyticsViewMode === mode.id
                    return (
                      <button
                        key={mode.id}
                        type="button"
                        onClick={() => setAnalyticsViewMode(mode.id)}
                        className={`rounded-2xl px-4 py-3 text-left text-sm font-medium transition ${
                          isActive
                            ? 'bg-clinical-blue text-white shadow-lg shadow-blue-900/20'
                            : 'bg-slate-50 text-slate-700 hover:bg-blue-50 hover:text-clinical-blue'
                        }`}
                      >
                        <span className="block">{mode.label}</span>
                        <span className={`mt-1 block text-xs ${isActive ? 'text-blue-100' : 'text-slate-500'}`}>
                          {mode.description}
                        </span>
                      </button>
                    )
                  })}
                </div>

                <div className="flex flex-wrap gap-2">
                  <button
                    type="button"
                    onClick={handleExportAnalyticsPng}
                    disabled={filteredAnalyticsDataset.observations.length === 0 || analyticsExporting !== null}
                    className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-medium text-slate-700 transition hover:border-blue-300 hover:text-clinical-blue disabled:cursor-not-allowed disabled:opacity-60"
                  >
                    {analyticsExporting === 'png' ? 'Exportando PNG...' : 'Exportar PNG'}
                  </button>
                  <button
                    type="button"
                    onClick={handleExportAnalyticsCsv}
                    disabled={filteredAnalyticsDataset.observations.length === 0 || analyticsExporting !== null}
                    className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-medium text-slate-700 transition hover:border-blue-300 hover:text-clinical-blue disabled:cursor-not-allowed disabled:opacity-60"
                  >
                    {analyticsExporting === 'csv' ? 'Exportando CSV...' : 'Exportar CSV'}
                  </button>
                </div>
              </div>

              <div data-analytics-export-root={analyticsViewMode}>
                {analyticsViewMode === 'temporal' && (
                  <TemporalEchartsChart
                    aggregates={filteredAnalyticsDataset.temporalAggregates ?? []}
                    showPatientSeries={Boolean(analyticsFilters.patientId)}
                    patientLabel={
                      analyticsFilters.patientId
                        ? analyticsDataset.patients.find((patient) => patient.id === analyticsFilters.patientId)?.displayName
                        : undefined
                    }
                    patientPoints={
                      analyticsFilters.patientId
                        ? filteredAnalyticsDataset.observations
                            .filter((observation) => observation.patientId === analyticsFilters.patientId)
                            .map((observation) => ({
                              timestamp: observation.timestamp,
                              value: observation.numericValue ?? 0,
                              displayValue: observation.displayValue,
                              unit: observation.unit,
                              patientDisplayName: observation.patientDisplayName,
                            }))
                        : []
                    }
                  />
                )}

                {analyticsViewMode === 'distribution' && (
                  <MeasurementDistributionChart
                    histogram={analyticsHistogram}
                    boxPlot={analyticsBoxPlot}
                  />
                )}

                {analyticsViewMode === 'comparison' && (
                  <ComparisonScatterChart
                    observations={filteredAnalyticsDataset.observations}
                    selectedObservationId={selectedAnalyticsObservationId}
                    onSelectObservation={(observation) => setSelectedAnalyticsObservationId(observation.id)}
                  />
                )}
              </div>

              {filteredAnalyticsMeasurements.length > 0 && (
                <MeasurementsTable measurements={filteredAnalyticsMeasurements} title="Observaciones filtradas" />
              )}

              {filteredAnalyticsDataset.observations.length === 0 && !analyticsLoading && (
                <div className="card p-8 text-center text-slate-500">
                  <p className="text-lg font-semibold text-slate-800">Sin resultados para estos filtros</p>
                  <p className="mt-2 text-sm">
                    Ajusta el paciente, el tipo de medición o el rango temporal para recuperar observaciones.
                  </p>
                </div>
              )}
            </div>

            <AnalyticsStatsPanel
              stats={filteredAnalyticsDataset.stats}
              measurementTypes={filteredAnalyticsDataset.measurementTypes}
              selectedObservation={selectedAnalyticsObservation}
            />
          </div>

          <div className="card p-6">
            <h3 className="text-lg font-semibold text-slate-800">Estado de filtros</h3>
            <div className="mt-4 grid gap-3 md:grid-cols-2 xl:grid-cols-3">
              <div className="rounded-2xl bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Paciente</p>
                <p className="mt-1 text-sm font-semibold text-slate-900">
                  {analyticsFilters.patientId
                    ? analyticsDataset.patients.find((patient) => patient.id === analyticsFilters.patientId)?.displayName ??
                      analyticsFilters.patientId
                    : 'Todos'}
                </p>
              </div>
              <div className="rounded-2xl bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Medición</p>
                <p className="mt-1 text-sm font-semibold text-slate-900">
                  {analyticsFilters.measurementType
                    ? analyticsDataset.measurementTypes.find((item) => item.key === analyticsFilters.measurementType)?.label ??
                      analyticsFilters.measurementType
                    : 'Todas'}
                </p>
              </div>
              <div className="rounded-2xl bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Sexo y edad</p>
                <p className="mt-1 text-sm font-semibold text-slate-900">
                  {analyticsFilters.sex === 'any' ? 'Todos los sexos' : analyticsFilters.sex} ·{' '}
                  {analyticsFilters.ageGroup === 'any' ? 'Todas las edades' : analyticsFilters.ageGroup}
                </p>
              </div>
            </div>
            <p className="mt-4 text-sm text-slate-600">
              El estado de filtros se sincroniza con la URL, de forma que puedes recargar o compartir
              el enlace sin perder el contexto analítico.
            </p>
          </div>
        </section>
      ))}
    </div>
  )
}
