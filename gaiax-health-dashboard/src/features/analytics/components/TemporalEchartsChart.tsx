import { useMemo, useState } from 'react'
import {
  Area,
  Brush,
  CartesianGrid,
  ComposedChart,
  Legend,
  Line,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import type { AnalyticsTemporalAggregate } from '../types/analysis'

interface TemporalEchartsChartProps {
  title?: string
  aggregates: AnalyticsTemporalAggregate[]
  showPatientSeries?: boolean
  patientLabel?: string
  patientPoints?: Array<{
    timestamp: string
    value: number
    displayValue: string
    unit?: string
    patientDisplayName: string
  }>
}

type PatientChartPoint = {
  label: string
  value: number
  tooltipLabel: string
  tooltipValue: string
  tooltipUnit?: string
}

type AggregateChartPoint = {
  label: string
  mean: number
  median: number
  percentile25: number
  percentile75: number
  percentile75Band: number
  minimum: number
  maximum: number
  observationCount: number
  patientCount: number
}

function formatLabel(value: string) {
  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
    timeZone: 'UTC',
  }).format(new Date(value))
}

function EmptyState({ message }: { message: string }) {
  return (
    <div className="card flex h-[420px] items-center justify-center p-8 text-center text-slate-500">
      <p>{message}</p>
    </div>
  )
}

export default function TemporalEchartsChart({
  title = 'Evolución temporal',
  aggregates,
  showPatientSeries = false,
  patientLabel,
  patientPoints = [],
}: TemporalEchartsChartProps) {
  const [range, setRange] = useState<{ startIndex?: number; endIndex?: number }>({})

  const visibleAggregates = useMemo(() => {
    if (range.startIndex === undefined || range.endIndex === undefined) return aggregates
    return aggregates.slice(range.startIndex, range.endIndex + 1)
  }, [aggregates, range.endIndex, range.startIndex])

  const patientSeries = useMemo(
    () =>
      patientPoints
        .slice()
        .sort((left, right) => left.timestamp.localeCompare(right.timestamp))
        .map((point) => ({
          ...point,
          label: formatLabel(point.timestamp),
        })),
    [patientPoints]
  )

  if (!showPatientSeries && aggregates.length === 0) {
    return <EmptyState message="No hay datos suficientes para la evolución temporal" />
  }

  if (showPatientSeries && patientSeries.length === 0) {
    return <EmptyState message="No hay observaciones para el paciente seleccionado" />
  }

  const patientChartData: PatientChartPoint[] = patientSeries.map((point) => ({
    label: point.label,
    value: point.value,
    tooltipLabel: point.patientDisplayName,
    tooltipValue: point.displayValue,
    tooltipUnit: point.unit,
  }))
  const aggregateChartData: AggregateChartPoint[] = visibleAggregates.map((item) => ({
    label: item.label,
    mean: item.mean,
    median: item.median,
    percentile25: item.percentile25,
    percentile75: item.percentile75,
    percentile75Band: Math.max(item.percentile75 - item.percentile25, 0),
    minimum: item.minimum,
    maximum: item.maximum,
    observationCount: item.observationCount,
    patientCount: item.patientCount,
  }))

  return (
    <div className="card overflow-hidden">
      <div className="border-b border-slate-200 px-6 py-5">
        <h3 className="text-lg font-semibold text-slate-900">{title}</h3>
        <p className="mt-1 text-sm text-slate-600">
          {showPatientSeries
            ? `Serie individual del paciente ${patientLabel ?? 'seleccionado'} con zoom temporal.`
            : 'Media, percentiles y banda intercuartílica sobre el conjunto filtrado.'}
        </p>
      </div>

      <div className="h-[420px] w-full px-2 py-2">
        <ResponsiveContainer width="100%" height="100%">
          {showPatientSeries ? (
            <ComposedChart data={patientChartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
              <XAxis dataKey="label" tickLine={false} axisLine={false} minTickGap={18} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip
                content={({ active, payload, label }) => {
                  if (!active || !payload?.length) return null
                  const datum = payload[0]?.payload as PatientChartPoint | undefined
                  if (!datum) return null

                  return (
                    <div className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm shadow-xl">
                      <p className="font-semibold text-slate-900">{label}</p>
                      <p className="mt-1 text-clinical-blue">{datum.tooltipLabel}</p>
                      <p className="mt-1 text-slate-600">
                        Valor: {datum.tooltipValue} {datum.tooltipUnit ?? ''}
                      </p>
                    </div>
                  )
                }}
              />
              <Legend />
              <Line
                type="monotone"
                dataKey="value"
                name={patientLabel ?? 'Paciente'}
                stroke="#1d4ed8"
                strokeWidth={3}
                dot={{ r: 4, fill: '#1d4ed8' }}
                activeDot={{ r: 6 }}
                isAnimationActive={false}
              />
              {patientChartData.length > 1 && (
                <Brush
                  dataKey="label"
                  height={28}
                  stroke="#1d4ed8"
                  travellerWidth={10}
                  onChange={({ startIndex, endIndex }) => {
                    if (typeof startIndex === 'number' && typeof endIndex === 'number') {
                      setRange({ startIndex, endIndex })
                    }
                  }}
                />
              )}
            </ComposedChart>
          ) : (
            <ComposedChart data={aggregateChartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
              <XAxis dataKey="label" tickLine={false} axisLine={false} minTickGap={18} />
              <YAxis tickLine={false} axisLine={false} />
              <Tooltip
                content={({ active, payload, label }) => {
                  if (!active || !payload?.length) return null
                  const datum = payload[0]?.payload as AggregateChartPoint | undefined
                  if (!datum) return null

                  return (
                    <div className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm shadow-xl">
                      <p className="font-semibold text-slate-900">{label}</p>
                      <div className="mt-2 space-y-1 text-slate-600">
                        <p>Media: {datum.mean}</p>
                        <p>P25: {datum.percentile25}</p>
                        <p>P75: {datum.percentile75}</p>
                        <p>Mínimo: {datum.minimum}</p>
                        <p>Máximo: {datum.maximum}</p>
                      </div>
                    </div>
                  )
                }}
              />
              <Legend />
              <Area
                type="monotone"
                dataKey="percentile25"
                name="Banda inferior"
                stackId="band"
                stroke="none"
                fill="transparent"
                isAnimationActive={false}
              />
              <Area
                type="monotone"
                dataKey="percentile75Band"
                name="IQR"
                stackId="band"
                stroke="none"
                fill="rgba(59, 130, 246, 0.18)"
                isAnimationActive={false}
              />
              <Line
                type="monotone"
                dataKey="mean"
                name="Media"
                stroke="#1d4ed8"
                strokeWidth={3}
                dot={{ r: 4, fill: '#1d4ed8' }}
                activeDot={{ r: 6 }}
                isAnimationActive={false}
              />
              <Line
                type="monotone"
                dataKey="minimum"
                name="Mínimo"
                stroke="#0f766e"
                strokeDasharray="5 5"
                dot={false}
                isAnimationActive={false}
              />
              <Line
                type="monotone"
                dataKey="maximum"
                name="Máximo"
                stroke="#dc2626"
                strokeDasharray="5 5"
                dot={false}
                isAnimationActive={false}
              />
              {aggregateChartData.length > 1 && (
                <Brush
                  dataKey="label"
                  height={28}
                  stroke="#1d4ed8"
                  travellerWidth={10}
                  onChange={({ startIndex, endIndex }) => {
                    if (typeof startIndex === 'number' && typeof endIndex === 'number') {
                      setRange({ startIndex, endIndex })
                    }
                  }}
                />
              )}
            </ComposedChart>
          )}
        </ResponsiveContainer>
      </div>
    </div>
  )
}
