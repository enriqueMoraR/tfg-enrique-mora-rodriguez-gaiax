import type { FhirBundle, FhirDevice, FhirObservation, FhirPatient } from '../../../types/fhir'
import type {
  AnalyticsDataset,
  AnalyticsFilters,
  AnalyticsObservation,
  AnalyticsSeries,
} from '../types/analysis'
import { buildTemporalAggregates, calculateAnalyticsStats } from './analyticsStatistics'
import { normalizeBundleToAnalyticsDataset } from './fhirAnalysisAdapter'

type AnalyticsBundleResource = FhirPatient | FhirDevice | FhirObservation

function buildAnalyticsBundle(patients: FhirPatient[], observations: FhirObservation[]): FhirBundle<AnalyticsBundleResource> {
  return {
    resourceType: 'Bundle',
    type: 'collection',
    entry: [
      ...patients.map((patient) => ({
        resource: patient,
      })),
      ...observations.map((observation) => ({
        resource: observation,
      })),
    ],
  }
}

function parseUtcDate(value?: string | null, endOfDay = false) {
  if (!value) return undefined
  const boundary = endOfDay ? 'T23:59:59.999Z' : 'T00:00:00.000Z'
  const date = new Date(`${value}${boundary}`)
  if (Number.isNaN(date.getTime())) return undefined
  return date
}

function observationMatchesFilters(observation: AnalyticsObservation, filters: AnalyticsFilters) {
  if (filters.patientId && observation.patientId !== filters.patientId) return false
  if (filters.measurementType && observation.measurementTypeKey !== filters.measurementType) return false
  if (filters.sex && filters.sex !== 'any' && observation.patientSex !== filters.sex) return false
  if (filters.ageGroup && filters.ageGroup !== 'any' && observation.patientAgeGroup !== filters.ageGroup) return false

  const timestamp = observation.timestamp ?? observation.issued
  const parsedTimestamp = new Date(timestamp)
  if (Number.isNaN(parsedTimestamp.getTime())) return false

  const from = parseUtcDate(filters.dateFrom ?? null)
  if (from && parsedTimestamp < from) return false

  const to = parseUtcDate(filters.dateTo ?? null, true)
  if (to && parsedTimestamp > to) return false

  return true
}

function filterSeries(series: AnalyticsSeries[], observations: AnalyticsObservation[], filters: AnalyticsFilters) {
  const matchingObservationIds = new Set(observations.map((observation) => observation.id))
  return series
    .map((item) => ({
      ...item,
      points: item.points.filter((point) => matchingObservationIds.has(point.observationId)),
    }))
    .filter((item) => {
      if (item.points.length === 0) return false
      if (filters.patientId && item.patientId !== filters.patientId) return false
      if (filters.measurementType && item.measurementTypeKey !== filters.measurementType) return false
      return true
    })
}

function buildMeasurementTypes(observations: AnalyticsObservation[]) {
  const counts = new Map<string, { key: string; label: string; count: number }>()

  observations.forEach((observation) => {
    const current = counts.get(observation.measurementTypeKey)
    if (!current) {
      counts.set(observation.measurementTypeKey, {
        key: observation.measurementTypeKey,
        label: observation.measurementTypeLabel,
        count: 1,
      })
      return
    }

    current.count += 1
  })

  return Array.from(counts.values()).sort((left, right) => left.label.localeCompare(right.label))
}

export function buildAnalyticsDatasetFromResources(
  patients: FhirPatient[],
  observations: FhirObservation[]
): AnalyticsDataset {
  return normalizeBundleToAnalyticsDataset(buildAnalyticsBundle(patients, observations))
}

export function filterAnalyticsDataset(dataset: AnalyticsDataset, filters: AnalyticsFilters): AnalyticsDataset {
  const filteredObservations = dataset.observations.filter((observation) => observationMatchesFilters(observation, filters))
  const filteredPatientIds = new Set(filteredObservations.map((observation) => observation.patientId))
  const filteredPatients = dataset.patients.filter((patient) => filteredPatientIds.has(patient.id))
  const filteredValues = filteredObservations
    .map((observation) => observation.numericValue)
    .filter((value): value is number => typeof value === 'number')
  const filteredSeries = filterSeries(dataset.series, filteredObservations, filters)
  const measurementTypes = buildMeasurementTypes(filteredObservations)
  const stats = calculateAnalyticsStats(filteredValues, filteredPatients.length)

  return {
    patients: filteredPatients,
    observations: filteredObservations.sort((left, right) => left.timestamp.localeCompare(right.timestamp)),
    series: filteredSeries,
    measurementTypes,
    stats,
    temporalAggregates: buildTemporalAggregates(filteredObservations, 'day'),
    generatedAt: dataset.generatedAt,
  }
}
