import type {
  AnalyticsBoxPlotSummary,
  AnalyticsGroupSummary,
  AnalyticsHistogramBin,
  AnalyticsObservation,
  AnalyticsStats,
  AnalyticsTemporalAggregate,
  TemporalBucket,
} from '../types/analysis'

function toFiniteNumber(value: unknown): value is number {
  return typeof value === 'number' && Number.isFinite(value)
}

function sortedValues(values: number[]) {
  return [...values].filter(toFiniteNumber).sort((a, b) => a - b)
}

export function percentile(values: number[], fraction: number) {
  const sorted = sortedValues(values)
  if (sorted.length === 0) return 0
  if (sorted.length === 1) return sorted[0] ?? 0

  const position = (sorted.length - 1) * fraction
  const lower = Math.floor(position)
  const upper = Math.ceil(position)

  if (lower === upper) return sorted[lower] ?? 0

  const lowerValue = sorted[lower] ?? 0
  const upperValue = sorted[upper] ?? lowerValue
  return lowerValue + (upperValue - lowerValue) * (position - lower)
}

function calculateStdDev(values: number[], mean: number) {
  if (values.length === 0) return 0
  const variance = values.reduce((acc, value) => acc + (value - mean) ** 2, 0) / values.length
  return Math.sqrt(variance)
}

export function calculateAnalyticsStats(values: number[], patientCount = 0): AnalyticsStats {
  const cleanValues = sortedValues(values)

  if (cleanValues.length === 0) {
    return {
      totalPatients: patientCount,
      totalObservations: 0,
      mean: 0,
      median: 0,
      stdDev: 0,
      minimum: 0,
      maximum: 0,
      percentile25: 0,
      percentile75: 0,
      iqrOutliers: 0,
    }
  }

  const totalObservations = cleanValues.length
  const sum = cleanValues.reduce((acc, value) => acc + value, 0)
  const mean = sum / totalObservations
  const median = percentile(cleanValues, 0.5)
  const percentile25 = percentile(cleanValues, 0.25)
  const percentile75 = percentile(cleanValues, 0.75)
  const stdDev = calculateStdDev(cleanValues, mean)
  const iqr = percentile75 - percentile25
  const lowerFence = percentile25 - 1.5 * iqr
  const upperFence = percentile75 + 1.5 * iqr
  const iqrOutliers = cleanValues.filter((value) => value < lowerFence || value > upperFence).length

  return {
    totalPatients: patientCount,
    totalObservations,
    mean: Number(mean.toFixed(2)),
    median: Number(median.toFixed(2)),
    stdDev: Number(stdDev.toFixed(2)),
    minimum: cleanValues[0] ?? 0,
    maximum: cleanValues[cleanValues.length - 1] ?? 0,
    percentile25: Number(percentile25.toFixed(2)),
    percentile75: Number(percentile75.toFixed(2)),
    iqrOutliers,
  }
}

export function calculateBoxPlotSummary(values: number[]): AnalyticsBoxPlotSummary {
  const cleanValues = sortedValues(values)
  if (cleanValues.length === 0) {
    return {
      minimum: 0,
      percentile25: 0,
      median: 0,
      percentile75: 0,
      maximum: 0,
      iqr: 0,
      lowerFence: 0,
      upperFence: 0,
      outliers: 0,
    }
  }

  const percentile25 = percentile(cleanValues, 0.25)
  const median = percentile(cleanValues, 0.5)
  const percentile75 = percentile(cleanValues, 0.75)
  const iqr = percentile75 - percentile25
  const lowerFence = percentile25 - 1.5 * iqr
  const upperFence = percentile75 + 1.5 * iqr
  const outliers = cleanValues.filter((value) => value < lowerFence || value > upperFence).length

  return {
    minimum: cleanValues[0] ?? 0,
    percentile25: Number(percentile25.toFixed(2)),
    median: Number(median.toFixed(2)),
    percentile75: Number(percentile75.toFixed(2)),
    maximum: cleanValues[cleanValues.length - 1] ?? 0,
    iqr: Number(iqr.toFixed(2)),
    lowerFence: Number(lowerFence.toFixed(2)),
    upperFence: Number(upperFence.toFixed(2)),
    outliers,
  }
}

export function buildHistogram(values: number[], binCount = 10): AnalyticsHistogramBin[] {
  const cleanValues = sortedValues(values)
  if (cleanValues.length === 0) return []

  const minimum = cleanValues[0] ?? 0
  const maximum = cleanValues[cleanValues.length - 1] ?? 0
  if (minimum === maximum) {
    return [
      {
        index: 0,
        start: minimum,
        end: maximum,
        label: `${minimum}`,
        count: cleanValues.length,
      },
    ]
  }

  const bins = Math.max(1, Math.min(binCount, cleanValues.length))
  const width = (maximum - minimum) / bins
  const histogram = Array.from({ length: bins }, (_, index) => {
    const start = minimum + width * index
    const end = index === bins - 1 ? maximum : minimum + width * (index + 1)
    return {
      index,
      start: Number(start.toFixed(2)),
      end: Number(end.toFixed(2)),
      label: index === bins - 1 ? `${start.toFixed(1)}-${end.toFixed(1)}` : `${start.toFixed(1)}-${end.toFixed(1)}`,
      count: 0,
    }
  })

  cleanValues.forEach((value) => {
    const rawIndex = Math.floor((value - minimum) / width)
    const index = Math.min(bins - 1, Math.max(0, rawIndex))
    const bucket = histogram[index]
    if (bucket) bucket.count += 1
  })

  return histogram.map((bucket) => ({
    ...bucket,
    label: `${bucket.start.toFixed(1)}-${bucket.end.toFixed(1)}`,
  }))
}

function startOfBucket(date: Date, bucket: TemporalBucket) {
  const year = date.getUTCFullYear()
  const month = `${date.getUTCMonth() + 1}`.padStart(2, '0')
  const day = `${date.getUTCDate()}`.padStart(2, '0')
  const hour = `${date.getUTCHours()}`.padStart(2, '0')

  if (bucket === 'hour') {
    return `${year}-${month}-${day}T${hour}:00:00.000Z`
  }

  if (bucket === 'month') {
    return `${year}-${month}-01T00:00:00.000Z`
  }

  if (bucket === 'week') {
    const current = new Date(Date.UTC(year, date.getUTCMonth(), date.getUTCDate()))
    const dayOfWeek = current.getUTCDay() || 7
    current.setUTCDate(current.getUTCDate() - (dayOfWeek - 1))
    current.setUTCHours(0, 0, 0, 0)
    return current.toISOString()
  }

  return `${year}-${month}-${day}T00:00:00.000Z`
}

function bucketLabel(bucket: string, granularity: TemporalBucket) {
  const date = new Date(bucket)
  if (granularity === 'month') {
    return new Intl.DateTimeFormat('es-ES', { month: 'short', year: 'numeric', timeZone: 'UTC' }).format(date)
  }
  if (granularity === 'week') {
    return new Intl.DateTimeFormat('es-ES', { day: '2-digit', month: 'short', timeZone: 'UTC' }).format(date)
  }
  if (granularity === 'hour') {
    return new Intl.DateTimeFormat('es-ES', {
      day: '2-digit',
      month: 'short',
      hour: '2-digit',
      minute: '2-digit',
      timeZone: 'UTC',
    }).format(date)
  }
  return new Intl.DateTimeFormat('es-ES', { day: '2-digit', month: 'short', timeZone: 'UTC' }).format(date)
}

export function buildTemporalAggregates(
  observations: AnalyticsObservation[],
  bucket: TemporalBucket = 'day'
): AnalyticsTemporalAggregate[] {
  const groups = new Map<string, number[]>()

  observations.forEach((observation) => {
    if (typeof observation.numericValue !== 'number') return
    const timestamp = observation.timestamp ?? observation.issued
    const parsed = new Date(timestamp)
    if (Number.isNaN(parsed.getTime())) return

    const bucketKey = startOfBucket(parsed, bucket)
    const current = groups.get(bucketKey)
    if (!current) {
      groups.set(bucketKey, [observation.numericValue])
      return
    }
    current.push(observation.numericValue)
  })

  return Array.from(groups.entries())
    .sort(([left], [right]) => left.localeCompare(right))
    .map(([bucketKey, values]) => {
      const stats = calculateAnalyticsStats(values)
      const box = calculateBoxPlotSummary(values)

      return {
        bucket: bucketKey,
        label: bucketLabel(bucketKey, bucket),
        observationCount: values.length,
        patientCount: new Set(
          observations
            .filter((observation) => observation.numericValue !== undefined)
            .filter((observation) => startOfBucket(new Date(observation.timestamp ?? observation.issued ?? bucketKey), bucket) === bucketKey)
            .map((observation) => observation.patientId)
        ).size,
        mean: stats.mean,
        median: stats.median,
        stdDev: stats.stdDev,
        minimum: stats.minimum,
        maximum: stats.maximum,
        percentile25: stats.percentile25,
        percentile75: stats.percentile75,
        iqrOutliers: box.outliers,
      }
    })
}

export function groupObservationsByField(
  observations: AnalyticsObservation[],
  getKey: (observation: AnalyticsObservation) => string,
  getLabel: (observation: AnalyticsObservation) => string
): AnalyticsGroupSummary[] {
  const groupMap = new Map<
    string,
    {
      label: string
      values: number[]
      patients: Set<string>
    }
  >()

  observations.forEach((observation) => {
    if (typeof observation.numericValue !== 'number') return
    const key = getKey(observation)
    const label = getLabel(observation)
    const current = groupMap.get(key)
    if (!current) {
      groupMap.set(key, {
        label,
        values: [observation.numericValue],
        patients: new Set([observation.patientId]),
      })
      return
    }

    current.values.push(observation.numericValue)
    current.patients.add(observation.patientId)
  })

  return Array.from(groupMap.entries())
    .map(([key, value]) => ({
      key,
      label: value.label,
      observationCount: value.values.length,
      patientCount: value.patients.size,
      values: [...value.values],
      stats: calculateAnalyticsStats(value.values, value.patients.size),
    }))
    .sort((left, right) => left.label.localeCompare(right.label))
}

export function groupObservationsByMeasurementType(observations: AnalyticsObservation[]) {
  return groupObservationsByField(
    observations,
    (observation) => observation.measurementTypeKey,
    (observation) => observation.measurementTypeLabel
  )
}

export function groupObservationsByPatient(observations: AnalyticsObservation[]) {
  return groupObservationsByField(
    observations,
    (observation) => observation.patientId,
    (observation) => observation.patientDisplayName
  )
}
