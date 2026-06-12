import { describe, expect, it } from 'vitest'
import { render, screen } from '@testing-library/react'
import MeasurementDistributionChart from '../../../features/analytics/components/MeasurementDistributionChart'
import type { AnalyticsBoxPlotSummary, AnalyticsHistogramBin } from '../../../features/analytics/types/analysis'

const histogram: AnalyticsHistogramBin[] = [
  { index: 0, start: 110, end: 115, label: '110-115', count: 1 },
  { index: 1, start: 115, end: 120, label: '115-120', count: 3 },
]

const boxPlot: AnalyticsBoxPlotSummary = {
  minimum: 110,
  percentile25: 115,
  median: 118,
  percentile75: 121,
  maximum: 128,
  iqr: 6,
  lowerFence: 106,
  upperFence: 130,
  outliers: 0,
}

describe('MeasurementDistributionChart', () => {
  it('renders histogram and box plot summaries', () => {
    render(<MeasurementDistributionChart histogram={histogram} boxPlot={boxPlot} />)

    expect(screen.getByText('Histograma')).toBeInTheDocument()
    expect(screen.getByText('Box plot')).toBeInTheDocument()
    expect(document.querySelector('.recharts-responsive-container')).toBeInTheDocument()
  })
})
