import {
  Bar,
  BarChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts'
import type { AnalyticsBoxPlotSummary, AnalyticsHistogramBin } from '../types/analysis'

interface MeasurementDistributionChartProps {
  histogram: AnalyticsHistogramBin[]
  boxPlot: AnalyticsBoxPlotSummary
}

function BoxPlotCard({ boxPlot }: { boxPlot: AnalyticsBoxPlotSummary }) {
  const min = boxPlot.minimum
  const max = boxPlot.maximum
  const span = max - min || 1
  const toPercent = (value: number) => ((value - min) / span) * 100

  return (
    <div className="card p-6">
      <h4 className="text-base font-semibold text-slate-900">Box plot</h4>
      <p className="mt-1 text-sm text-slate-600">
        Mediana, rango intercuartílico y detección de valores atípicos por 1.5 × IQR.
      </p>

      <div className="mt-6">
        <div className="relative h-28 w-full rounded-3xl bg-slate-50 px-5 py-5">
          <div className="absolute left-5 right-5 top-1/2 h-px bg-slate-300" />
          <div
            className="absolute top-1/2 h-8 -translate-y-1/2 rounded-xl border border-blue-400 bg-blue-100/80"
            style={{ left: `${toPercent(boxPlot.percentile25)}%`, width: `${Math.max(toPercent(boxPlot.percentile75) - toPercent(boxPlot.percentile25), 2)}%` }}
          />
          <div
            className="absolute top-1/2 h-12 -translate-y-1/2 border-l-2 border-blue-700"
            style={{ left: `${toPercent(boxPlot.median)}%` }}
          />
          <div
            className="absolute top-1/2 h-4 -translate-y-1/2 border-l-2 border-slate-500"
            style={{ left: `${toPercent(boxPlot.minimum)}%` }}
          />
          <div
            className="absolute top-1/2 h-4 -translate-y-1/2 border-l-2 border-slate-500"
            style={{ left: `${toPercent(boxPlot.maximum)}%` }}
          />
          <div className="absolute left-5 right-5 top-[18px] flex justify-between text-[11px] uppercase tracking-[0.25em] text-slate-500">
            <span>Min</span>
            <span>Q1</span>
            <span>Mediana</span>
            <span>Q3</span>
            <span>Max</span>
          </div>
          <div className="absolute bottom-3 left-5 right-5 flex justify-between text-xs text-slate-600">
            <span>{boxPlot.minimum}</span>
            <span>{boxPlot.percentile25}</span>
            <span>{boxPlot.median}</span>
            <span>{boxPlot.percentile75}</span>
            <span>{boxPlot.maximum}</span>
          </div>
        </div>

        <div className="mt-4 grid gap-3 sm:grid-cols-3">
          <div className="rounded-2xl bg-slate-50 p-4">
            <p className="text-xs uppercase tracking-[0.25em] text-slate-500">IQR</p>
            <p className="mt-1 text-lg font-semibold text-slate-900">{boxPlot.iqr}</p>
          </div>
          <div className="rounded-2xl bg-slate-50 p-4">
            <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Límite inferior</p>
            <p className="mt-1 text-lg font-semibold text-slate-900">{boxPlot.lowerFence}</p>
          </div>
          <div className="rounded-2xl bg-slate-50 p-4">
            <p className="text-xs uppercase tracking-[0.25em] text-slate-500">Atípicos</p>
            <p className="mt-1 text-lg font-semibold text-slate-900">{boxPlot.outliers}</p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default function MeasurementDistributionChart({ histogram, boxPlot }: MeasurementDistributionChartProps) {
  return (
    <div className="space-y-6">
      <div className="card p-6">
        <h3 className="text-lg font-semibold text-slate-900">Histograma</h3>
        <p className="mt-1 text-sm text-slate-600">
          Permite ver la forma general de la distribución y detectar concentraciones o colas largas.
        </p>
        <div className="mt-4 h-[320px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={histogram}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
              <XAxis dataKey="label" tickLine={false} axisLine={false} interval={0} angle={-20} textAnchor="end" height={70} />
              <YAxis allowDecimals={false} tickLine={false} axisLine={false} />
              <Tooltip />
              <Bar dataKey="count" name="Frecuencia" fill="#1d4ed8" radius={[10, 10, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      <BoxPlotCard boxPlot={boxPlot} />
    </div>
  )
}
