import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts'
import type { Measurement } from '../types/domain'
import { formatTimestamp, formatValue } from '../features/patients/services/dataTransform'

interface MetricsLineChartProps {
  measurements: Measurement[]
  title?: string
}

export default function MetricsLineChart({ measurements, title = 'Evolución Temporal' }: MetricsLineChartProps) {
  if (measurements.length === 0) {
    return (
      <div className="card p-8 text-center text-gray-500">
        <p>No hay mediciones para mostrar</p>
      </div>
    )
  }

  // Transform data for Recharts
  const data = [...measurements]
    .sort((a, b) => new Date(a.timestamp).getTime() - new Date(b.timestamp).getTime())
    .map((m) => ({
      timestamp: formatTimestamp(m.timestamp),
      value: typeof m.rawValue === 'number' ? m.rawValue : m.rawValue.systolic,
      diastolic: typeof m.rawValue === 'object' ? m.rawValue.diastolic : undefined,
      type: m.type,
      xRequestId: m.xRequestId,
      fullTimestamp: m.timestamp,
      original: m,
    }))

  // Determine Y-axis domain
  const allValues = data.flatMap((d) => [d.value, ...(d.diastolic ? [d.diastolic] : [])])
  const minValue = Math.min(...allValues)
  const maxValue = Math.max(...allValues)
  const padding = (maxValue - minValue) * 0.1

  const renderTooltip = (props: any) => {
    const { active, payload } = props
    if (active && payload && payload[0]) {
      const data = payload[0].payload
      return (
        <div className="bg-white p-3 border border-gray-300 rounded shadow-lg text-xs">
          <p className="font-semibold">{data.timestamp}</p>
          <p className="text-clinical-blue">
            {data.type}: {formatValue(data.original)}
          </p>
          <p className="text-gray-600 text-xs mt-1">ID: {data.xRequestId.substring(0, 20)}...</p>
        </div>
      )
    }
    return null
  }

  return (
    <div className="card p-6">
      <h3 className="text-lg font-semibold mb-4 text-gray-800">{title}</h3>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="timestamp" angle={-45} textAnchor="end" height={80} interval={Math.ceil(data.length / 10)} />
          <YAxis domain={[minValue - padding, maxValue + padding]} />
          <Tooltip content={renderTooltip} />
          <Legend />
          <Line
            type="monotone"
            dataKey="value"
            stroke="#1e40af"
            isAnimationActive={false}
            name="Valor Principal"
            dot={{ fill: '#1e40af', r: 4 }}
            activeDot={{ r: 6 }}
          />
          {data.some((d) => d.diastolic) && (
            <Line
              type="monotone"
              dataKey="diastolic"
              stroke="#059669"
              isAnimationActive={false}
              name="Valor Secundario (Diástole)"
              dot={false}
            />
          )}
        </LineChart>
      </ResponsiveContainer>
    </div>
  )
}
