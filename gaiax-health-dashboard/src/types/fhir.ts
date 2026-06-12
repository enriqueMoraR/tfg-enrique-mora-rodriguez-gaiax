// FHIR Observation types (blood-pressure, heart-rate, etc.)

export interface FhirReference {
  reference?: string
  display?: string
}

export interface FhirMetaTag {
  system?: string
  code?: string
  display?: string
}

export interface FhirBundleEntry<T> {
  fullUrl?: string
  resource: T
  search?: {
    mode?: string
  }
}

export interface FhirBundle<T> {
  resourceType: 'Bundle'
  type?: string
  timestamp?: string
  total?: number
  entry?: Array<FhirBundleEntry<T>>
}

export interface FhirPatient {
  resourceType: 'Patient'
  id: string
  meta?: {
    versionId?: string
    lastUpdated?: string
    tag?: FhirMetaTag[]
  }
  name?: Array<{
    text?: string
    given?: string[]
    family?: string
  }>
  gender?: string
  birthDate?: string
}

export interface FhirDevice {
  resourceType: 'Device'
  id: string
  meta?: {
    versionId?: string
    lastUpdated?: string
  }
  type?: {
    coding?: Array<{
      system?: string
      code?: string
      display?: string
    }>
  }
  identifier?: Array<{
    system?: string
    value?: string
  }>
}

export interface BloodPressureObservation {
  timestamp: string
  value: {
    systolic: number  // mmHg
    diastolic: number // mmHg
  }
  unit: 'mmHg'
}

export interface HeartRateObservation {
  timestamp: string
  value: number // bpm
  unit: 'bpm'
}

export type MeasurementType = 'blood-pressure' | 'heart-rate'

export interface FhirObservation {
  resourceType: 'Observation'
  id: string
  meta?: {
    versionId?: string
    lastUpdated?: string
    profile?: string[]
    tag?: Array<{
      system?: string
      code?: string
      display?: string
    }>
  }
  status?: string
  category?: Array<{
    coding: Array<{
      system?: string
      code?: string
      display?: string
    }>
  }>
  code: {
    coding: Array<{
      code: string
      system: string
      display?: string
    }>
    text?: string
  }
  valueQuantity?: {
    value: number
    unit: string
    system?: string
    code?: string
  }
  component?: Array<{
    code: {
      coding: Array<{
        code: string
        system?: string
        display?: string
      }>
    }
    valueQuantity: {
      value: number
      unit: string
      system?: string
      code?: string
    }
  }>
  subject: {
    reference: string
    display?: string
  }
  encounter?: {
    reference?: string
    display?: string
  }
  effectiveDateTime?: string
  issued?: string
  performer?: Array<{
    reference?: string
    display?: string
  }>
  bodySite?: {
    coding: Array<{
      system?: string
      code?: string
      display?: string
    }>
  }
  device?: {
    reference?: string
    type?: {
      coding?: Array<{
        system?: string
        code?: string
        display?: string
      }>
    }
    identifier?: Array<{
      system?: string
      value?: string
    }>
  }
}
