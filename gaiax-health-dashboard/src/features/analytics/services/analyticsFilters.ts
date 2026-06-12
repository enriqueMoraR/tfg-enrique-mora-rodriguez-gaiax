import type { AnalyticsFilters, AgeGroup, MeasurementSex } from '../types/analysis'

const FILTER_KEYS = {
  patientId: 'patientId',
  measurementType: 'measurementType',
  dateFrom: 'dateFrom',
  dateTo: 'dateTo',
  sex: 'sex',
  ageGroup: 'ageGroup',
} as const

export const DEFAULT_ANALYTICS_FILTERS: AnalyticsFilters = {
  patientId: null,
  measurementType: null,
  dateFrom: null,
  dateTo: null,
  sex: 'any',
  ageGroup: 'any',
}

function normalizeSex(value: string | null): MeasurementSex | 'any' {
  if (value === 'male' || value === 'female' || value === 'other' || value === 'unknown') return value
  return 'any'
}

function normalizeAgeGroup(value: string | null): AgeGroup | 'any' {
  if (value === '0-18' || value === '19-40' || value === '41-65' || value === '65+') return value
  return 'any'
}

export function parseAnalyticsFilters(search: string | URLSearchParams): AnalyticsFilters {
  const params = search instanceof URLSearchParams ? search : new URLSearchParams(search.startsWith('?') ? search.slice(1) : search)

  return {
    patientId: params.get(FILTER_KEYS.patientId) || null,
    measurementType: params.get(FILTER_KEYS.measurementType) || null,
    dateFrom: params.get(FILTER_KEYS.dateFrom) || null,
    dateTo: params.get(FILTER_KEYS.dateTo) || null,
    sex: normalizeSex(params.get(FILTER_KEYS.sex)),
    ageGroup: normalizeAgeGroup(params.get(FILTER_KEYS.ageGroup)),
  }
}

export function serializeAnalyticsFilters(filters: AnalyticsFilters) {
  const params = new URLSearchParams()

  if (filters.patientId) params.set(FILTER_KEYS.patientId, filters.patientId)
  if (filters.measurementType) params.set(FILTER_KEYS.measurementType, filters.measurementType)
  if (filters.dateFrom) params.set(FILTER_KEYS.dateFrom, filters.dateFrom)
  if (filters.dateTo) params.set(FILTER_KEYS.dateTo, filters.dateTo)
  if (filters.sex && filters.sex !== 'any') params.set(FILTER_KEYS.sex, filters.sex)
  if (filters.ageGroup && filters.ageGroup !== 'any') params.set(FILTER_KEYS.ageGroup, filters.ageGroup)

  return params.toString()
}

export function sanitizeAnalyticsFilters(
  filters: AnalyticsFilters,
  availableMeasurementTypeKeys: string[]
): AnalyticsFilters {
  const hasMeasurementType = filters.measurementType ? availableMeasurementTypeKeys.includes(filters.measurementType) : true

  return {
    ...filters,
    measurementType: hasMeasurementType ? filters.measurementType : null,
  }
}
