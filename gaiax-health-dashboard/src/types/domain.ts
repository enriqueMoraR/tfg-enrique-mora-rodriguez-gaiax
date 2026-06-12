import type { MeasurementType } from './fhir'

export interface Patient {
  id: string
  name: string
  dateOfBirth?: string
}

export interface Measurement {
  timestamp: string
  type: MeasurementType
  value: string | number // formatted value
  rawValue: number | { systolic: number; diastolic: number }
  unit: string
  xRequestId: string
  issued?: string
  subjectDisplay?: string
  encounterReference?: string
  performerDisplay?: string
  bodySiteDisplay?: string
  deviceReference?: string
  deviceDisplay?: string
  consentSummary?: string
}

export interface MeasurementAggregate {
  type: MeasurementType
  count: number
  percentage: number
  color: string
}

export interface SearchResult {
  patientId: string
  measurements: Measurement[]
  aggregates: MeasurementAggregate[]
  lastSync: string
}
