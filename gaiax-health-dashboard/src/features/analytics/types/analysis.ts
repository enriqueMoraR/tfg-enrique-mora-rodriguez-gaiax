import type { FhirObservation } from '../../../types/fhir'

export type MeasurementSex = 'male' | 'female' | 'other' | 'unknown'

export type AgeGroup = '0-18' | '19-40' | '41-65' | '65+'

export type AnalysisViewMode = 'temporal' | 'distribution' | 'comparison'

export type TemporalBucket = 'hour' | 'day' | 'week' | 'month'

export interface AnalyticsFilters {
  patientId?: string | null
  measurementType?: string | null
  dateFrom?: string | null
  dateTo?: string | null
  sex?: MeasurementSex | 'any'
  ageGroup?: AgeGroup | 'any'
}

export interface AnalyticsPatient {
  id: string
  reference: string
  displayName: string
  sex: MeasurementSex
  birthDate?: string
  age?: number
  ageGroup: AgeGroup
  consentSummary?: string
}

export interface AnalyticsObservation {
  id: string
  resourceType: 'Observation'
  patientId: string
  patientReference: string
  patientDisplayName: string
  patientSex: MeasurementSex
  patientAge?: number
  patientAgeGroup: AgeGroup
  measurementTypeKey: string
  measurementTypeLabel: string
  code: string
  codeDisplay?: string
  timestamp: string
  issued?: string
  numericValue?: number
  displayValue: string
  unit?: string
  systolic?: number
  diastolic?: number
  performerDisplay?: string
  deviceReference?: string
  deviceDisplay?: string
  encounterReference?: string
  bodySiteDisplay?: string
  consentSummary?: string
  source: FhirObservation
}

export interface AnalyticsSeriesPoint {
  timestamp: string
  value: number
  displayValue: string
  observationId: string
  patientId: string
  patientDisplayName: string
  measurementTypeKey: string
  measurementTypeLabel: string
  unit?: string
  lower?: number
  upper?: number
}

export interface AnalyticsSeries {
  key: string
  label: string
  measurementTypeKey: string
  measurementTypeLabel: string
  patientId?: string
  patientDisplayName?: string
  points: AnalyticsSeriesPoint[]
}

export interface AnalyticsMeasurementTypeOption {
  key: string
  label: string
  count: number
}

export interface AnalyticsStats {
  totalPatients: number
  totalObservations: number
  mean: number
  median: number
  stdDev: number
  minimum: number
  maximum: number
  percentile25: number
  percentile75: number
  iqrOutliers: number
}

export interface AnalyticsHistogramBin {
  index: number
  start: number
  end: number
  label: string
  count: number
}

export interface AnalyticsBoxPlotSummary {
  minimum: number
  percentile25: number
  median: number
  percentile75: number
  maximum: number
  iqr: number
  lowerFence: number
  upperFence: number
  outliers: number
}

export interface AnalyticsTemporalAggregate {
  bucket: string
  label: string
  observationCount: number
  patientCount: number
  mean: number
  median: number
  stdDev: number
  minimum: number
  maximum: number
  percentile25: number
  percentile75: number
  iqrOutliers: number
}

export interface AnalyticsGroupSummary {
  key: string
  label: string
  observationCount: number
  patientCount: number
  values: number[]
  stats: AnalyticsStats
}

export interface AnalyticsDataset {
  patients: AnalyticsPatient[]
  observations: AnalyticsObservation[]
  series: AnalyticsSeries[]
  measurementTypes: AnalyticsMeasurementTypeOption[]
  stats: AnalyticsStats
  temporalAggregates?: AnalyticsTemporalAggregate[]
  generatedAt: string
}
