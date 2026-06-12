import { useMemo } from 'react'
import {
  CartesianGrid,
  ResponsiveContainer,
  Scatter,
  ScatterChart,
  Tooltip,
  XAxis,
  YAxis,
  ZAxis,
} from 'recharts'
import type { AnalyticsObservation, MeasurementSex } from '../types/analysis'

interface ComparisonScatterChartProps {
  observations: AnalyticsObservation[]
  selectedObservationId?: string | null
  onSelectObservation: (observation: AnalyticsObservation) => void
}

interface ScatterPoint {
  x: number
  y: number
  size: number
  observation: AnalyticsObservation
}

interface ScatterShapeProps {
  cx?: number
  cy?: number
  payload?: ScatterPoint
}

const SEX_COLORS: Record<MeasurementSex, string> = {
  male: '#1d4ed8',
  female: '#db2777',
  other: '#8b5cf6',
  unknown: '#64748b',
}

function formatDate(value: number) {
  return new Intl.DateTimeFormat('es-ES', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
    timeZone: 'UTC',
  }).format(new Date(value))
}

function makePoint(observation: AnalyticsObservation): ScatterPoint | null {
  if (typeof observation.numericValue !== 'number') return null
  const date = new Date(observation.timestamp ?? observation.issued)
  if (Number.isNaN(date.getTime())) return null

  return {
    x: date.getTime(),
    y: observation.numericValue,
    size: Math.max(20, Math.min(180, (observation.patientAge ?? 35) * 2)),
    observation,
  }
}

function PointShape({
  cx,
  cy,
  payload,
  fill,
  selected,
  onSelect,
}: {
  cx?: number
  cy?: number
  payload?: ScatterPoint
  fill: string
  selected: boolean
  onSelect: (observation: AnalyticsObservation) => void
}) {
  if (typeof cx !== 'number' || typeof cy !== 'number' || !payload) return null

  const radius = Math.sqrt(payload.size) / 2 + (selected ? 2 : 0)

  return (
    <circle
      cx={cx}
      cy={cy}
      r={radius}
      fill={fill}
      stroke={selected ? '#0f172a' : '#ffffff'}
      strokeWidth={selected ? 2.5 : 1.25}
      style={{ cursor: 'pointer' }}
      onClick={() => onSelect(payload.observation)}
    />
  )
}

function createScatterShape(
  fill: string,
  selectedObservationId: string | null | undefined,
  onSelectObservation: (observation: AnalyticsObservation) => void
) {
  return (props: ScatterShapeProps) => (
    <PointShape
      {...props}
      fill={fill}
      selected={Boolean(props.payload?.observation.id === selectedObservationId)}
      onSelect={onSelectObservation}
    />
  )
}

export default function ComparisonScatterChart({
  observations,
  selectedObservationId,
  onSelectObservation,
}: ComparisonScatterChartProps) {
  const pointsBySex = useMemo(() => {
    return observations.reduce<Record<MeasurementSex, ScatterPoint[]>>(
      (acc, observation) => {
        const point = makePoint(observation)
        if (!point) return acc
        acc[observation.patientSex].push(point)
        return acc
      },
      { male: [], female: [], other: [], unknown: [] }
    )
  }, [observations])

  const hasPoints = Object.values(pointsBySex).some((points) => points.length > 0)

  if (!hasPoints) {
    return (
      <div className="card p-8 text-center text-slate-500">
        <p>No hay datos suficientes para comparar pacientes</p>
      </div>
    )
  }

  return (
    <div className="card overflow-hidden">
      <div className="border-b border-slate-200 px-6 py-5">
        <h3 className="text-lg font-semibold text-slate-900">Comparación entre pacientes</h3>
        <p className="mt-1 text-sm text-slate-600">
          Cada punto representa una observación. El color distingue el sexo y el tamaño se relaciona con la edad.
        </p>
      </div>

      <div className="h-[420px] w-full px-2 py-2">
        <ResponsiveContainer width="100%" height="100%">
          <ScatterChart margin={{ top: 20, right: 24, bottom: 32, left: 32 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
            <XAxis
              type="number"
              dataKey="x"
              name="Fecha"
              domain={['dataMin', 'dataMax']}
              tickFormatter={(value) => formatDate(Number(value))}
              tickLine={false}
              axisLine={false}
            />
            <YAxis
              type="number"
              dataKey="y"
              name="Valor"
              tickLine={false}
              axisLine={false}
            />
            <ZAxis dataKey="size" range={[60, 300]} />
            <Tooltip
              cursor={{ strokeDasharray: '3 3' }}
              content={({ active, payload }) => {
                if (!active || !payload?.length) return null
                const datum = payload[0]?.payload as ScatterPoint | undefined
                if (!datum) return null

                return (
                  <div className="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm shadow-xl">
                    <p className="font-semibold text-slate-900">{datum.observation.patientDisplayName}</p>
                    <p className="mt-1 text-slate-600">{formatDate(datum.x)}</p>
                    <p className="mt-1 text-slate-600">
                      Valor: {datum.observation.displayValue} {datum.observation.unit ?? ''}
                    </p>
                    <p className="mt-1 text-slate-600">Sexo: {datum.observation.patientSex}</p>
                  </div>
                )
              }}
            />
            <Scatter
              name="Mujeres"
              data={pointsBySex.female}
              shape={createScatterShape(SEX_COLORS.female, selectedObservationId, onSelectObservation)}
            />
            <Scatter
              name="Hombres"
              data={pointsBySex.male}
              shape={createScatterShape(SEX_COLORS.male, selectedObservationId, onSelectObservation)}
            />
            <Scatter
              name="Otros"
              data={pointsBySex.other}
              shape={createScatterShape(SEX_COLORS.other, selectedObservationId, onSelectObservation)}
            />
            <Scatter
              name="Desconocido"
              data={pointsBySex.unknown}
              shape={createScatterShape(SEX_COLORS.unknown, selectedObservationId, onSelectObservation)}
            />
          </ScatterChart>
        </ResponsiveContainer>
      </div>
    </div>
  )
}
