import type { FhirBundle, FhirDevice, FhirObservation, FhirPatient } from '../../../types/fhir'
import type {
  AgeGroup,
  AnalyticsDataset,
  AnalyticsMeasurementTypeOption,
  AnalyticsObservation,
  AnalyticsPatient,
  AnalyticsSeries,
  AnalyticsSeriesPoint,
  MeasurementSex,
} from '../types/analysis'
import { calculateAnalyticsStats } from './analyticsStatistics'

type BundleResource = FhirPatient | FhirDevice | FhirObservation

type BundleEntry = {
  resource?: BundleResource
}

interface MeasurementDescriptor {
  key: string
  label: string
  value?: number
  displayValue: string
  unit?: string
  systolic?: number
  diastolic?: number
}

const KNOWN_TYPES: Record<string, { key: string; label: string }> = {
  '55284-4': { key: 'blood-pressure', label: 'Presión arterial' },
  '85354-9': { key: 'blood-pressure', label: 'Presión arterial' },
  'blood-pressure': { key: 'blood-pressure', label: 'Presión arterial' },
  '8867-4': { key: 'heart-rate', label: 'Frecuencia cardíaca' },
  'heart-rate': { key: 'heart-rate', label: 'Frecuencia cardíaca' },
  '8310-5': { key: 'temperature', label: 'Temperatura' },
  temperature: { key: 'temperature', label: 'Temperatura' },
  '59408-5': { key: 'oxygen-saturation', label: 'Saturación de oxígeno' },
  '2708-6': { key: 'oxygen-saturation', label: 'Saturación de oxígeno' },
  'oxygen-saturation': { key: 'oxygen-saturation', label: 'Saturación de oxígeno' },
  '2339-0': { key: 'glucose', label: 'Glucosa' },
  '41653-7': { key: 'glucose', label: 'Glucosa' },
  glucose: { key: 'glucose', label: 'Glucosa' },
  '29463-7': { key: 'weight', label: 'Peso' },
  weight: { key: 'weight', label: 'Peso' },
  '8302-2': { key: 'height', label: 'Altura' },
  height: { key: 'height', label: 'Altura' },
}

function slugify(value: string) {
  return value
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function resolveMeasurementDescriptor(observation: FhirObservation): MeasurementDescriptor | null {
  const code = observation.code.coding[0]?.code ?? ''
  const display = observation.code.coding[0]?.display ?? observation.code.text ?? code
  const known = KNOWN_TYPES[code] ?? KNOWN_TYPES[slugify(display)]

  if (known?.key === 'blood-pressure') {
    const systolic = observation.component?.find((component) => component.code.coding[0]?.code === '8480-6')?.valueQuantity?.value
    const diastolic = observation.component?.find((component) => component.code.coding[0]?.code === '8462-4')?.valueQuantity?.value
    if (typeof systolic === 'number' && typeof diastolic === 'number') {
      return {
        key: known.key,
        label: known.label,
        systolic,
        diastolic,
        value: systolic,
        displayValue: `${systolic}/${diastolic}`,
        unit: observation.component?.[0]?.valueQuantity?.unit ?? 'mmHg',
      }
    }
    return null
  }

  const value = observation.valueQuantity?.value
  if (typeof value !== 'number') {
    return null
  }

  if (known) {
    return {
      key: known.key,
      label: known.label,
      value,
      displayValue: `${value} ${observation.valueQuantity?.unit ?? ''}`.trim(),
      unit: observation.valueQuantity?.unit,
    }
  }

  return {
    key: slugify(display || code || 'other'),
    label: display || code || 'Observación',
    value,
    displayValue: `${value} ${observation.valueQuantity?.unit ?? ''}`.trim(),
    unit: observation.valueQuantity?.unit,
  }
}

function formatDisplayName(patient?: FhirPatient, fallback?: string) {
  const text = patient?.name?.[0]?.text
  if (text && text.trim()) return text.trim()

  const given = patient?.name?.[0]?.given?.[0] ?? ''
  const family = patient?.name?.[0]?.family ?? ''
  const combined = `${given} ${family}`.trim()
  if (combined) return combined

  return fallback?.trim() || patient?.id || 'Paciente'
}

function parseAge(birthDate?: string, referenceDate?: string) {
  if (!birthDate) return undefined

  const birth = new Date(`${birthDate}T00:00:00Z`)
  const reference = new Date(referenceDate ?? new Date().toISOString())
  if (Number.isNaN(birth.getTime()) || Number.isNaN(reference.getTime())) return undefined

  let age = reference.getUTCFullYear() - birth.getUTCFullYear()
  const monthDiff = reference.getUTCMonth() - birth.getUTCMonth()
  if (monthDiff < 0 || (monthDiff === 0 && reference.getUTCDate() < birth.getUTCDate())) {
    age -= 1
  }
  return Math.max(age, 0)
}

function resolveAgeGroup(age?: number): AgeGroup {
  if (typeof age !== 'number') return '65+'
  if (age <= 18) return '0-18'
  if (age <= 40) return '19-40'
  if (age <= 65) return '41-65'
  return '65+'
}

function resolveSex(value?: string): MeasurementSex {
  if (value === 'male' || value === 'female') return value
  if (value === 'other') return 'other'
  return 'unknown'
}

function getResourceId(reference?: string) {
  if (!reference) return undefined
  const parts = reference.split('/')
  return parts[parts.length - 1] || undefined
}

function buildPatients(entries: BundleEntry[], fallbackDate?: string) {
  const patientMap = new Map<string, AnalyticsPatient>()

  entries.forEach((entry) => {
    const resource = entry.resource
    if (!resource || resource.resourceType !== 'Patient') return

    const patient = resource as FhirPatient
    const id = patient.id
    const displayName = formatDisplayName(patient)
    const consentSummary = patient.meta?.tag?.find((tag) => tag.system === 'https://gaia-x.eu/trust-framework#')?.display
    const age = parseAge(patient.birthDate, patient.meta?.lastUpdated ?? fallbackDate)

    patientMap.set(id, {
      id,
      reference: `Patient/${id}`,
      displayName,
      sex: resolveSex(patient.gender),
      birthDate: patient.birthDate,
      age,
      ageGroup: resolveAgeGroup(age),
      consentSummary,
    })
  })

  return patientMap
}

function buildDeviceMap(entries: BundleEntry[]) {
  const deviceMap = new Map<string, FhirDevice>()

  entries.forEach((entry) => {
    const resource = entry.resource
    if (!resource || resource.resourceType !== 'Device') return

    const device = resource as FhirDevice
    deviceMap.set(device.id, device)
  })

  return deviceMap
}

function buildSeries(observations: AnalyticsObservation[]) {
  const seriesMap = new Map<string, AnalyticsSeries>()

  observations.forEach((observation) => {
    if (typeof observation.numericValue !== 'number') return

    const key = `${observation.patientId}:${observation.measurementTypeKey}`
    if (!seriesMap.has(key)) {
      seriesMap.set(key, {
        key,
        label: `${observation.patientDisplayName} · ${observation.measurementTypeLabel}`,
        measurementTypeKey: observation.measurementTypeKey,
        measurementTypeLabel: observation.measurementTypeLabel,
        patientId: observation.patientId,
        patientDisplayName: observation.patientDisplayName,
        points: [],
      })
    }

    const series = seriesMap.get(key)
    if (!series) return

    const point: AnalyticsSeriesPoint = {
      timestamp: observation.timestamp,
      value: observation.numericValue,
      displayValue: observation.displayValue,
      observationId: observation.id,
      patientId: observation.patientId,
      patientDisplayName: observation.patientDisplayName,
      measurementTypeKey: observation.measurementTypeKey,
      measurementTypeLabel: observation.measurementTypeLabel,
      unit: observation.unit,
      lower: observation.systolic,
      upper: observation.diastolic,
    }

    series.points.push(point)
  })

  return Array.from(seriesMap.values()).map((series) => ({
    ...series,
    points: [...series.points].sort((a, b) => a.timestamp.localeCompare(b.timestamp)),
  }))
}

function buildMeasurementTypeOptions(observations: AnalyticsObservation[]): AnalyticsMeasurementTypeOption[] {
  const counts = new Map<string, AnalyticsMeasurementTypeOption>()

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

  return Array.from(counts.values()).sort((a, b) => a.label.localeCompare(b.label))
}

export function normalizeBundleToAnalyticsDataset(
  bundle: FhirBundle<BundleResource>
): AnalyticsDataset {
  const entries = bundle.entry ?? []
  const fallbackDate = bundle.timestamp ?? new Date().toISOString()
  const patientMap = buildPatients(entries, fallbackDate)
  const deviceMap = buildDeviceMap(entries)
  const observations: AnalyticsObservation[] = []

  entries.forEach((entry) => {
    const resource = entry.resource
    if (!resource || resource.resourceType !== 'Observation') return

    const observation = resource as FhirObservation
    const descriptor = resolveMeasurementDescriptor(observation)
    if (!descriptor) return

    const patientReference = observation.subject.reference
    const patientId = getResourceId(patientReference) ?? observation.subject.display ?? observation.id
    const patientFromMap = patientMap.get(patientId)
    const patientDisplayName = patientFromMap?.displayName ?? formatDisplayName(undefined, observation.subject.display)
    const patientSex = patientFromMap?.sex ?? 'unknown'
    const patientAge = patientFromMap?.age ?? parseAge(undefined, observation.effectiveDateTime ?? observation.issued)
    const patientAgeGroup = patientFromMap?.ageGroup ?? resolveAgeGroup(patientAge)
    const deviceReference = observation.device?.reference
    const deviceId = getResourceId(deviceReference)
    const deviceFromMap = deviceId ? deviceMap.get(deviceId) : undefined
    const deviceDisplay = observation.device?.type?.coding?.[0]?.display
      ?? deviceFromMap?.type?.coding?.[0]?.display
      ?? observation.device?.reference
    const consentSummary = observation.meta?.tag?.find((tag) => tag.system === 'https://gaia-x.eu/trust-framework#')?.display
      ?? patientFromMap?.consentSummary

    observations.push({
      id: observation.id,
      resourceType: 'Observation',
      patientId,
      patientReference,
      patientDisplayName,
      patientSex,
      patientAge,
      patientAgeGroup,
      measurementTypeKey: descriptor.key,
      measurementTypeLabel: descriptor.label,
      code: observation.code.coding[0]?.code ?? observation.code.text ?? descriptor.key,
      codeDisplay: observation.code.coding[0]?.display ?? observation.code.text,
      timestamp: observation.effectiveDateTime ?? observation.issued ?? fallbackDate,
      issued: observation.issued,
      numericValue: descriptor.value,
      displayValue: descriptor.displayValue,
      unit: descriptor.unit,
      systolic: descriptor.systolic,
      diastolic: descriptor.diastolic,
      performerDisplay: observation.performer?.[0]?.display,
      deviceReference,
      deviceDisplay,
      encounterReference: observation.encounter?.reference,
      bodySiteDisplay: observation.bodySite?.coding?.[0]?.display,
      consentSummary,
      source: observation,
    })
  })

  const numericValues = observations
    .map((observation) => observation.numericValue)
    .filter((value): value is number => typeof value === 'number')

  const patients = Array.from(patientMap.values()).sort((a, b) => a.displayName.localeCompare(b.displayName))
  const series = buildSeries(observations)
  const measurementTypes = buildMeasurementTypeOptions(observations)
  const stats = calculateAnalyticsStats(numericValues, patients.length)

  return {
    patients,
    observations: observations.sort((a, b) => a.timestamp.localeCompare(b.timestamp)),
    series,
    measurementTypes,
    stats,
    generatedAt: new Date().toISOString(),
  }
}
