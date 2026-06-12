import { PieChart, Pie, Cell, Legend, Tooltip, ResponsiveContainer } from 'recharts'
import type { MeasurementAggregate } from '../types/domain'

interface DistributionPieProps {
  aggregates: MeasurementAggregate[]
  title?: string
}

export default function DistributionPie({ aggregates, title = 'Distribución por Tipo' }: DistributionPieProps) {
  if (aggregates.length === 0) {
    return (
      <div className="card p-8 text-center text-gray-500">
        <p>No hay datos para mostrar</p>
      </div>
    )
  }

  // Transform label names
  const labelMap: Record<string, string> = {
    'blood-pressure': 'Presión Arterial',
    'heart-rate': 'Frecuencia Cardíaca',
  }

  const data = aggregates.map((agg) => ({
    name: labelMap[agg.type] || agg.type,
    value: agg.count,
    percentage: agg.percentage,
    color: agg.color,
  }))

  const renderTooltip = (props: any) => {
    const { active, payload } = props
    if (active && payload && payload[0]) {
      const data = payload[0].payload
      return (
        <div className="bg-white p-2 border border-gray-300 rounded shadow-lg text-xs">
          <p className="font-semibold">{data.name}</p>
          <p className="text-gray-700">
            {data.value} mediciones ({data.percentage}%)
          </p>
        </div>
      )
    }
    return null
  }

  return (
    <div className="card p-6">
      <h3 className="text-lg font-semibold mb-4 text-gray-800">{title}</h3>
      <ResponsiveContainer width="100%" height={300}>
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            labelLine={false}
            label={(entry) => `${entry.name}: ${entry.percentage}%`}
            outerRadius={100}
            fill="#8884d8"
            dataKey="value"
          >
            {data.map((entry, idx) => (
              <Cell key={`cell-${idx}`} fill={entry.color} />
            ))}
          </Pie>
          <Tooltip content={renderTooltip} />
          <Legend />
        </PieChart>
      </ResponsiveContainer>
    </div>
  )
}

