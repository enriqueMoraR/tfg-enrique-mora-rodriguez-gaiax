import { describe, expect, it, beforeEach, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import type { FhirObservation, FhirPatient } from '../../types/fhir'
import Dashboard from '../../pages/Dashboard'

const mockPatients: FhirPatient[] = [
  {
    resourceType: 'Patient',
    id: 'patient-gx-12345',
    gender: 'male',
    birthDate: '1983-05-14',
    name: [{ text: 'Juan Pérez' }],
    meta: { lastUpdated: '2026-06-10T10:31:00+02:00' },
  },
  {
    resourceType: 'Patient',
    id: 'patient-gx-67890',
    gender: 'female',
    birthDate: '1978-11-02',
    name: [{ text: 'Ana Gómez' }],
    meta: { lastUpdated: '2026-06-10T10:33:00+02:00' },
  },
]

const mockObservations: FhirObservation[] = [
  {
    resourceType: 'Observation',
    id: 'bp-observation-device-001',
    status: 'final',
    meta: {
      profile: ['http://hl7.org/fhir/StructureDefinition/vitalsigns'],
      tag: [
        {
          system: 'https://gaia-x.eu/trust-framework#',
          code: 'sovereignty-policy',
          display: 'Data usage governed by patient consent ID: CONS-2026-889',
        },
      ],
      lastUpdated: '2026-06-10T10:30:00+02:00',
    },
    category: [
      {
        coding: [
          {
            system: 'http://terminology.hl7.org/CodeSystem/observation-category',
            code: 'vital-signs',
            display: 'Vital Signs',
          },
        ],
      },
    ],
    code: {
      coding: [
        {
          system: 'http://loinc.org',
          code: '85354-9',
          display: 'Blood pressure panel with all children optional',
        },
      ],
      text: 'Blood pressure systolic & diastolic',
    },
    subject: { reference: 'Patient/patient-gx-12345', display: 'Juan Pérez' },
    encounter: { reference: 'Encounter/enc-home-monitoring-001' },
    effectiveDateTime: '2026-06-10T10:25:00+02:00',
    issued: '2026-06-10T10:25:05+02:00',
    performer: [{ reference: 'Device/tensiometer-omron-x200', display: 'Omron X200 Smart Tensiómetro' }],
    bodySite: {
      coding: [
        {
          system: 'http://snomed.info/sct',
          code: '368209003',
          display: 'Right arm',
        },
      ],
    },
    component: [
      {
        code: {
          coding: [
            {
              system: 'http://loinc.org',
              code: '8480-6',
              display: 'Systolic blood pressure',
            },
          ],
        },
        valueQuantity: {
          value: 128,
          unit: 'mmHg',
          system: 'http://unitsofmeasure.org',
          code: 'mm[Hg]',
        },
      },
      {
        code: {
          coding: [
            {
              system: 'http://loinc.org',
              code: '8462-4',
              display: 'Diastolic blood pressure',
            },
          ],
        },
        valueQuantity: {
          value: 82,
          unit: 'mmHg',
          system: 'http://unitsofmeasure.org',
          code: 'mm[Hg]',
        },
      },
    ],
    device: {
      reference: 'Device/tensiometer-omron-x200',
      type: {
        coding: [
          {
            system: 'http://snomed.info/sct',
            code: '43770009',
            display: 'Blood pressure monitor',
          },
        ],
      },
      identifier: [
        {
          system: 'http://hl7.org/fhir/sid/ndc',
          value: 'SN-9988776655',
        },
      ],
    },
  },
  {
    resourceType: 'Observation',
    id: 'bp-observation-device-002',
    status: 'final',
    meta: {
      profile: ['http://hl7.org/fhir/StructureDefinition/vitalsigns'],
      tag: [
        {
          system: 'https://gaia-x.eu/trust-framework#',
          code: 'sovereignty-policy',
          display: 'Data usage governed by patient consent ID: CONS-2026-890',
        },
      ],
      lastUpdated: '2026-06-10T10:40:00+02:00',
    },
    category: [
      {
        coding: [
          {
            system: 'http://terminology.hl7.org/CodeSystem/observation-category',
            code: 'vital-signs',
            display: 'Vital Signs',
          },
        ],
      },
    ],
    code: {
      coding: [
        {
          system: 'http://loinc.org',
          code: '85354-9',
          display: 'Blood pressure panel with all children optional',
        },
      ],
      text: 'Blood pressure systolic & diastolic',
    },
    subject: { reference: 'Patient/patient-gx-67890', display: 'Ana Gómez' },
    encounter: { reference: 'Encounter/enc-home-monitoring-002' },
    effectiveDateTime: '2026-06-10T10:35:00+02:00',
    issued: '2026-06-10T10:35:05+02:00',
    performer: [{ reference: 'Device/tensiometer-omron-x210', display: 'Omron X210 Smart Tensiómetro' }],
    bodySite: {
      coding: [
        {
          system: 'http://snomed.info/sct',
          code: '368209003',
          display: 'Right arm',
        },
      ],
    },
    component: [
      {
        code: {
          coding: [
            {
              system: 'http://loinc.org',
              code: '8480-6',
              display: 'Systolic blood pressure',
            },
          ],
        },
        valueQuantity: {
          value: 118,
          unit: 'mmHg',
          system: 'http://unitsofmeasure.org',
          code: 'mm[Hg]',
        },
      },
      {
        code: {
          coding: [
            {
              system: 'http://loinc.org',
              code: '8462-4',
              display: 'Diastolic blood pressure',
            },
          ],
        },
        valueQuantity: {
          value: 76,
          unit: 'mmHg',
          system: 'http://unitsofmeasure.org',
          code: 'mm[Hg]',
        },
      },
    ],
    device: {
      reference: 'Device/tensiometer-omron-x210',
      type: {
        coding: [
          {
            system: 'http://snomed.info/sct',
            code: '43770009',
            display: 'Blood pressure monitor',
          },
        ],
      },
      identifier: [
        {
          system: 'http://hl7.org/fhir/sid/ndc',
          value: 'SN-1122334455',
        },
      ],
    },
  },
]

function createExtraPatient(index: number): FhirPatient {
  const idNumber = index + 3
  return {
    resourceType: 'Patient',
    id: `patient-gx-${String(idNumber).padStart(5, '0')}`,
    gender: idNumber % 2 === 0 ? 'female' : 'male',
    birthDate: `198${idNumber % 10}-0${(idNumber % 9) + 1}-15`,
    name: [{ text: `Paciente ${idNumber}` }],
    meta: { lastUpdated: `2026-06-10T10:${String(35 + index).padStart(2, '0')}:00+02:00` },
  }
}

function createExtraObservation(index: number, patient: FhirPatient): FhirObservation {
  const sourceObservation = mockObservations[index % mockObservations.length]
  const systolic = 110 + index
  const diastolic = 70 + (index % 8)

  return {
    ...sourceObservation,
    id: `bp-observation-device-${String(index + 3).padStart(3, '0')}`,
    meta: {
      ...sourceObservation.meta,
      lastUpdated: `2026-06-10T11:${String(index).padStart(2, '0')}:00+02:00`,
      tag: [
        {
          system: 'https://gaia-x.eu/trust-framework#',
          code: 'sovereignty-policy',
          display: `Data usage governed by patient consent ID: CONS-2026-${String(900 + index).padStart(3, '0')}`,
        },
      ],
    },
    subject: {
      reference: `Patient/${patient.id}`,
      display: patient.name?.[0]?.text ?? patient.id,
    },
    effectiveDateTime: `2026-06-10T11:${String(index).padStart(2, '0')}:30+02:00`,
    issued: `2026-06-10T11:${String(index).padStart(2, '0')}:35+02:00`,
    performer: [
      {
        reference: `Device/tensiometer-${String(index + 3).padStart(3, '0')}`,
        display: `Tensiómetro ${index + 3}`,
      },
    ],
    device: {
      reference: `Device/tensiometer-${String(index + 3).padStart(3, '0')}`,
      type: {
        coding: [
          {
            system: 'http://snomed.info/sct',
            code: '43770009',
            display: 'Blood pressure monitor',
          },
        ],
      },
      identifier: [
        {
          system: 'http://hl7.org/fhir/sid/ndc',
          value: `SN-${String(9900000000 + index)}`,
        },
      ],
    },
    component: [
      {
        code: sourceObservation.component?.[0]?.code ?? {
          coding: [
            {
              system: 'http://loinc.org',
              code: '8480-6',
              display: 'Systolic blood pressure',
            },
          ],
        },
        valueQuantity: {
          ...sourceObservation.component?.[0]?.valueQuantity,
          value: systolic,
          unit: 'mmHg',
        },
      },
      {
        code: sourceObservation.component?.[1]?.code ?? {
          coding: [
            {
              system: 'http://loinc.org',
              code: '8462-4',
              display: 'Diastolic blood pressure',
            },
          ],
        },
        valueQuantity: {
          ...sourceObservation.component?.[1]?.valueQuantity,
          value: diastolic,
          unit: 'mmHg',
        },
      },
    ],
  }
}

const extraPatients = Array.from({ length: 19 }, (_, index) => createExtraPatient(index))
const fullPatients = [...mockPatients, ...extraPatients]
const previewPatients = fullPatients.slice(0, 20)
const extraObservations = extraPatients.map((patient, index) => createExtraObservation(index, patient))
const fullObservations = [...mockObservations, ...extraObservations]
const previewObservations = fullObservations.slice(0, 20)

const { mockUseFhirPatients, mockUseFhirObservations, mockUseFhirBackendStatus } = vi.hoisted(() => ({
  mockUseFhirPatients: vi.fn(),
  mockUseFhirObservations: vi.fn(),
  mockUseFhirBackendStatus: vi.fn(),
}))

vi.mock('../../hooks/useFhirData', () => ({
  useFhirPatients: (limit?: number, enabled?: boolean) => mockUseFhirPatients(limit, enabled),
  useFhirObservations: (patientId?: string, limit?: number, enabled?: boolean) =>
    mockUseFhirObservations(patientId, limit, enabled),
  useFhirBackendStatus: () => mockUseFhirBackendStatus(),
}))

describe('Dashboard', () => {
  beforeEach(() => {
    mockUseFhirPatients.mockImplementation((limit?: number, enabled = true) => {
      if (!enabled) {
        return {
          data: [],
          isLoading: false,
          error: null,
        }
      }

      return {
        data: (limit ?? 20) >= fullPatients.length ? fullPatients : previewPatients,
        isLoading: false,
        error: null,
      }
    })

    mockUseFhirObservations.mockImplementation((patientId?: string, limit = 50, enabled = true) => {
      if (!enabled) {
        return {
          data: [],
          isLoading: false,
          error: null,
        }
      }

      const sourceData = patientId
        ? fullObservations.filter((observation) => observation.subject.reference === `Patient/${patientId}`)
        : limit >= fullObservations.length
          ? fullObservations
          : previewObservations

      return {
        data: sourceData,
        isLoading: false,
        error: null,
      }
    })

    mockUseFhirBackendStatus.mockReturnValue({
      data: true,
      isLoading: false,
    })
  })

  it('renders the live overview with real-data messaging', () => {
    render(<Dashboard activePage="overview" />)

    expect(screen.getByText(/Datos reales de pacientes/)).toBeInTheDocument()
    expect(screen.getByText('Pacientes')).toBeInTheDocument()
    expect(screen.getByText('Observaciones')).toBeInTheDocument()
    expect(screen.getAllByText('21').length).toBeGreaterThanOrEqual(2)
    expect(screen.getByText('Serie temporal poblacional')).toBeInTheDocument()
    expect(document.querySelector('.recharts-responsive-container')).toBeInTheDocument()
  })

  it('renders the patient list and provenance details', () => {
    render(<Dashboard activePage="patients" />)

    expect(screen.getByText('Pacientes cargados')).toBeInTheDocument()
    expect(screen.getAllByText('Juan Pérez').length).toBeGreaterThan(0)
    expect(screen.getByText('Paciente seleccionado')).toBeInTheDocument()
    expect(screen.getByText('Contexto FHIR y soberanía')).toBeInTheDocument()
    expect(screen.getAllByText(/Data usage governed by patient consent ID/).length).toBeGreaterThan(0)
    expect(screen.getByText('FHIR API:')).toBeInTheDocument()
    expect(screen.getByText('✓ Conectado')).toBeInTheDocument()
  })

  it('allows selecting another patient from the table', () => {
    render(<Dashboard activePage="patients" />)

    fireEvent.click(screen.getAllByRole('button', { name: 'Ver datos' })[1])

    expect(screen.getAllByText('Ana Gómez').length).toBeGreaterThan(0)
    expect(screen.getAllByText(/CONS-2026-890/).length).toBeGreaterThan(0)
  })

  it('searches patients across the full dataset and highlights results outside the first 20', () => {
    render(<Dashboard activePage="patients" />)

    fireEvent.change(screen.getByPlaceholderText('ej: patient-001'), {
      target: { value: 'patient-gx-00021' },
    })
    fireEvent.click(screen.getByRole('button', { name: 'Buscar' }))

    expect(screen.getByText('Paciente encontrado en el conjunto completo')).toBeInTheDocument()
    expect(screen.getByText(/Este paciente no está entre los 20 visibles/)).toBeInTheDocument()
    expect(screen.getByText('Paciente 21')).toBeInTheDocument()
  })

  it('shows a clear message when patient id is not found', () => {
    render(<Dashboard activePage="patients" />)

    fireEvent.change(screen.getByPlaceholderText('ej: patient-001'), {
      target: { value: 'patient-gx-99999' },
    })
    fireEvent.click(screen.getByRole('button', { name: 'Buscar' }))

    expect(screen.getByText(/No se encontró ningún paciente con el ID/)).toBeInTheDocument()
  })

  it('renders the analytics workbench with filters and modes', () => {
    render(<Dashboard activePage="analytics" />)

    expect(screen.getByText('Panel de filtros')).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /Evolución temporal/ })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /Distribución/ })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /Comparación/ })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Exportar PNG' })).toBeInTheDocument()
    expect(screen.getByRole('button', { name: 'Exportar CSV' })).toBeInTheDocument()
    expect(screen.getByText('Estadísticas dinámicas')).toBeInTheDocument()
  })

  it('renders analytics skeletons while loading', () => {
    mockUseFhirPatients.mockReturnValue({
      data: [],
      isLoading: true,
      error: null,
    })
    mockUseFhirObservations.mockReturnValue({
      data: [],
      isLoading: true,
      error: null,
    })

    render(<Dashboard activePage="analytics" />)

    expect(document.querySelectorAll('.animate-pulse').length).toBeGreaterThan(0)
    expect(screen.queryByText('Panel de filtros')).not.toBeInTheDocument()
  })
})
