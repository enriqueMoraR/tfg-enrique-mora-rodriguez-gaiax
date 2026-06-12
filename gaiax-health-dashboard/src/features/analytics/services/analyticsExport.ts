import type { AnalyticsObservation } from '../types/analysis'

function escapeCsvCell(value: string | number | null | undefined) {
  if (value === null || value === undefined) return ''
  const text = String(value)
  if (/[",\n]/.test(text)) {
    return `"${text.replace(/"/g, '""')}"`
  }
  return text
}

function triggerDownload(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = filename
  link.click()
  URL.revokeObjectURL(url)
}

export function buildAnalyticsCsv(observations: AnalyticsObservation[]) {
  const headers = [
    'id',
    'patientId',
    'patientDisplayName',
    'patientSex',
    'patientAge',
    'patientAgeGroup',
    'measurementType',
    'measurementLabel',
    'code',
    'timestamp',
    'value',
    'unit',
    'issued',
    'device',
    'performer',
    'consent',
  ]

  const rows = observations.map((observation) =>
    [
      observation.id,
      observation.patientId,
      observation.patientDisplayName,
      observation.patientSex,
      observation.patientAge ?? '',
      observation.patientAgeGroup,
      observation.measurementTypeKey,
      observation.measurementTypeLabel,
      observation.code,
      observation.timestamp,
      observation.displayValue,
      observation.unit ?? '',
      observation.issued ?? '',
      observation.deviceDisplay ?? observation.deviceReference ?? '',
      observation.performerDisplay ?? '',
      observation.consentSummary ?? '',
    ]
      .map(escapeCsvCell)
      .join(',')
  )

  return [headers.join(','), ...rows].join('\n')
}

export function downloadAnalyticsCsv(filename: string, observations: AnalyticsObservation[]) {
  const csv = buildAnalyticsCsv(observations)
  const blob = new Blob([`\ufeff${csv}`], { type: 'text/csv;charset=utf-8' })
  triggerDownload(blob, filename)
}

function getSvgDimensions(svg: SVGSVGElement) {
  const fallbackWidth = 1200
  const fallbackHeight = 800
  const width =
    Number(svg.getAttribute('width')) ||
    (svg.viewBox && svg.viewBox.baseVal.width) ||
    Math.ceil(svg.getBoundingClientRect().width) ||
    fallbackWidth
  const height =
    Number(svg.getAttribute('height')) ||
    (svg.viewBox && svg.viewBox.baseVal.height) ||
    Math.ceil(svg.getBoundingClientRect().height) ||
    fallbackHeight

  return { width, height }
}

async function svgToPngBlob(svg: SVGSVGElement) {
  const svgClone = svg.cloneNode(true) as SVGSVGElement
  svgClone.setAttribute('xmlns', 'http://www.w3.org/2000/svg')

  const serializer = new XMLSerializer()
  const svgData = serializer.serializeToString(svgClone)
  const svgBlob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' })
  const svgUrl = URL.createObjectURL(svgBlob)
  const image = new Image()

  return new Promise<Blob>((resolve, reject) => {
    const { width, height } = getSvgDimensions(svgClone)
    image.onload = () => {
      const canvas = document.createElement('canvas')
      canvas.width = width
      canvas.height = height
      const context = canvas.getContext('2d')
      if (!context) {
        URL.revokeObjectURL(svgUrl)
        reject(new Error('No canvas context available'))
        return
      }

      context.clearRect(0, 0, width, height)
      context.drawImage(image, 0, 0, width, height)
      URL.revokeObjectURL(svgUrl)
      canvas.toBlob((blob) => {
        if (!blob) {
          reject(new Error('Unable to export chart to PNG'))
          return
        }
        resolve(blob)
      }, 'image/png')
    }

    image.onerror = () => {
      URL.revokeObjectURL(svgUrl)
      reject(new Error('Unable to load SVG for PNG export'))
    }

    image.src = svgUrl
  })
}

export async function downloadAnalyticsChartPng(selector: string, filename: string) {
  const root = document.querySelector(selector)
  const svg = root?.querySelector('svg') as SVGSVGElement | null
  if (!svg) {
    throw new Error('No se encontró ningún SVG para exportar')
  }

  const blob = await svgToPngBlob(svg)
  triggerDownload(blob, filename)
}
