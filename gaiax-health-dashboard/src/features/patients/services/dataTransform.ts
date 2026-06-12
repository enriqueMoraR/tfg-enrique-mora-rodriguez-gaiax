import type { FhirObservation, MeasurementType } from '../../../types/fhir'
import type { Measurement, MeasurementAggregate } from '../../../types/domain'

/**
 * Normalize FHIR observations into Measurement[]
 */
export function normalizeMeasurements(
  fhirObservations: FhirObservation[],
  xRequestId: string
): Measurement[] {
  return fhirObservations
    .map((obs) => {
      const loincCode = obs.code.coding[0]?.code
      let type: MeasurementType
      let value: string | number
      let rawValue: number | { systolic: number; diastolic: number }
      let unit: string
      const issued = obs.issued
      const subjectDisplay = obs.subject.display
      const encounterReference = obs.encounter?.reference
      const performerDisplay = obs.performer?.[0]?.display
      const bodySiteDisplay = obs.bodySite?.coding?.[0]?.display
      const deviceReference = obs.device?.reference
      const deviceDisplay = obs.device?.type?.coding?.[0]?.display
      const consentSummary = obs.meta?.tag?.find((tag) => tag.system === 'https://gaia-x.eu/trust-framework#')?.display

      if (loincCode === '55284-4' || loincCode === '85354-9' || loincCode === 'blood-pressure') {
        // Blood Pressure
        type = 'blood-pressure'
        const sys = obs.component?.[0]?.valueQuantity.value || 0
        const dia = obs.component?.[1]?.valueQuantity.value || 0
        rawValue = { systolic: sys, diastolic: dia }
        value = `${sys}/${dia}`
        unit = 'mmHg'
      } else if (loincCode === '8867-4' || loincCode === 'heart-rate') {
        // Heart Rate
        type = 'heart-rate'
        const hr = obs.valueQuantity?.value || 0
        rawValue = hr
        value = hr
        unit = 'bpm'
      } else {
        return null
      }

      return {
        timestamp: obs.effectiveDateTime || issued || new Date().toISOString(),
        type,
        value,
        rawValue,
        unit,
        xRequestId,
        issued,
        subjectDisplay,
        encounterReference,
        performerDisplay,
        bodySiteDisplay,
        deviceReference,
        deviceDisplay,
        consentSummary,
      }
    })
    .filter((m) => m !== null) as Measurement[]
}

/**
 * Aggregate measurements by type for pie chart
 */
export function aggregateByType(
  measurements: Measurement[]
): { data: MeasurementAggregate[]; total: number } {
  const counts = new Map<MeasurementType, number>()
  const colors: Record<MeasurementType, string> = {
    'blood-pressure': '#1e40af', // clinical-blue
    'heart-rate': '#059669', // clinical-green
  }

  measurements.forEach((m) => {
    counts.set(m.type, (counts.get(m.type) || 0) + 1)
  })

  const total = measurements.length
  const data: MeasurementAggregate[] = Array.from(counts.entries()).map(
    ([type, count]) => ({
      type,
      count,
      percentage: Math.round((count / total) * 100),
      color: colors[type],
    })
  )

  return { data, total }
}

/**
 * Format timestamp for display
 */
export function formatTimestamp(isoString: string): string {
  const date = new Date(isoString)
  if (Number.isNaN(date.getTime())) {
    return isoString
  }

  const monthNames = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic']
  const pad = (value: number) => String(value).padStart(2, '0')

  const timeStr = `${pad(date.getUTCHours())}:${pad(date.getUTCMinutes())}:${pad(date.getUTCSeconds())}`
  const dateStr = `${pad(date.getUTCDate())}-${monthNames[date.getUTCMonth()]}`

  return `${timeStr} ${dateStr}`
}

/**
 * Format measurement value for display
 */
export function formatValue(measurement: Measurement): string {
  if (typeof measurement.rawValue === 'object') {
    return `${measurement.rawValue.systolic}/${measurement.rawValue.diastolic} ${measurement.unit}`
  }
  return `${measurement.rawValue} ${measurement.unit}`
}
