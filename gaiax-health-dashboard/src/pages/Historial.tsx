import { useEffect, useState, useMemo } from 'react'
import { getHistorialPorPaciente } from '@/services/historialClinicoService'
import { HistorialClinico } from '@/types/historial'
import { HistorialClinicoDetalle } from '@/components/features/historial/historial-clinico-detalle'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { Skeleton } from '@/components/ui/skeleton'

import SearchBar from '../components/SearchBar'
import PatientsTable from '../features/patients/components/PatientsTable'
import type { FhirPatient } from '../types/fhir'
import { useFhirPatients } from '../hooks/useFhirData'

const PREVIEW_LIMIT = 20
const FULL_DATA_LIMIT = 10000

// ID de consentimiento global utilizado para todas las llamadas de historial
const PROPOSITO_ID_EJEMPLO = '770e8400-e29b-41d4-a716-446655440000'
const USER_ID_EJEMPLO = 'a3b7a5e3-d3a3-48b4-a5ae-9a21a7d8d3a1'

type PatientSearchFeedback =
  | { type: 'idle' }
  | { type: 'found'; query: string; inPreview: boolean; patient: FhirPatient }
  | { type: 'not-found'; query: string }

function formatPatientName(patient: FhirPatient) {
  const directName = patient.name?.[0]?.text
  if (directName && directName.trim()) return directName
  const given = patient.name?.[0]?.given?.[0] ?? ''
  const family = patient.name?.[0]?.family ?? ''
  const combined = `${given} ${family}`.trim()
  return combined || patient.id
}

function HistorialSkeleton() {
  return (
    <div className="space-y-6">
      <Skeleton className="h-24 w-full" />
      <Skeleton className="h-64 w-full" />
      <Skeleton className="h-80 w-full" />
    </div>
  )
}

function PatientsListSkeleton() {
  return (
    <div className="space-y-6">
      <div className="grid gap-4 lg:grid-cols-[1fr_auto]">
        <Skeleton className="h-16" />
        <Skeleton className="h-16 w-24" />
      </div>
      <Skeleton className="h-[520px]" />
    </div>
  )
}

export default function HistorialPage() {
  const [selectedPatientId, setSelectedPatientId] = useState('')
  const [patientSearchFeedback, setPatientSearchFeedback] = useState<PatientSearchFeedback>({ type: 'idle' })

  const [historial, setHistorial] = useState<HistorialClinico | null>(null)
  const [isLoadingHistorial, setIsLoadingHistorial] = useState(false)
  const [historialError, setHistorialError] = useState<string | null>(null)

  const patientsQuery = useFhirPatients(PREVIEW_LIMIT)
  const fullPatientsQuery = useFhirPatients(FULL_DATA_LIMIT)

  const patients = patientsQuery.data ?? []
  const fullPatients = fullPatientsQuery.data ?? []
  const isPatientsLoading = patientsQuery.isLoading || fullPatientsQuery.isLoading

  // Preseleccionar el primer paciente si hay pacientes y no hay selección
  useEffect(() => {
    if (!selectedPatientId && patients.length > 0) {
      setSelectedPatientId(patients[0].id)
    }
  }, [patients, selectedPatientId])

  // Cargar historial del paciente seleccionado
  useEffect(() => {
    if (!selectedPatientId) return

    const fetchHistorial = async () => {
      try {
        setIsLoadingHistorial(true)
        setHistorialError(null)
        const data = await getHistorialPorPaciente(
          selectedPatientId,
          PROPOSITO_ID_EJEMPLO,
          USER_ID_EJEMPLO
        )
        setHistorial(data)
      } catch (err) {
        setHistorialError('Error al cargar el historial clínico. Verifique que el backend esté funcionando y que los IDs de consentimiento y usuario sean correctos.')
        console.error(err)
      } finally {
        setIsLoadingHistorial(false)
      }
    }

    fetchHistorial()
  }, [selectedPatientId])

  const selectedPatient = useMemo(
    () =>
      patients.find((patient) => patient.id === selectedPatientId) ??
      fullPatients.find((patient) => patient.id === selectedPatientId) ??
      null,
    [patients, fullPatients, selectedPatientId]
  )

  const handleSearch = (query: string) => {
    const normalizedQuery = query.trim().toLowerCase()
    if (!normalizedQuery) return

    const match =
      fullPatients.find((patient) => patient.id.toLowerCase() === normalizedQuery) ??
      fullPatients.find((patient) => patient.id.toLowerCase().includes(normalizedQuery)) ??
      null

    if (match) {
      setSelectedPatientId(match.id)
      setPatientSearchFeedback({
        type: 'found',
        query: normalizedQuery,
        patient: match,
        inPreview: patients.some((patient) => patient.id === match.id),
      })
      return
    }

    setSelectedPatientId('')
    setPatientSearchFeedback({ type: 'not-found', query: normalizedQuery })
  }

  const handleSelectPatient = (patient: FhirPatient) => {
    setSelectedPatientId(patient.id)
    setPatientSearchFeedback({
      type: 'found',
      query: patient.id,
      patient,
      inPreview: true,
    })
  }

  return (
    <section className="grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
      <div className="space-y-6">
        {isPatientsLoading ? (
          <PatientsListSkeleton />
        ) : (
          <>
            <SearchBar
              onSearch={handleSearch}
              isLoading={isPatientsLoading}
              suggestions={patients.map((patient) => patient.id)}
            />

            {patientSearchFeedback.type === 'found' && (
              <div className="card border border-blue-200 bg-blue-50 px-5 py-4 text-sm text-slate-700">
                <p className="font-semibold text-clinical-blue">Paciente encontrado en el conjunto completo</p>
                <p className="mt-1">
                  Búsqueda por ID: <span className="font-medium">{patientSearchFeedback.query}</span>
                </p>
                <p className="mt-1">
                  {patientSearchFeedback.patient.id} · {formatPatientName(patientSearchFeedback.patient)}
                </p>
                {!patientSearchFeedback.inPreview && (
                  <p className="mt-1 text-blue-700">
                    Este paciente no está entre los 20 visibles, pero sí en el dataset completo.
                  </p>
                )}
              </div>
            )}

            {patientSearchFeedback.type === 'not-found' && (
              <div className="card border border-rose-200 bg-rose-50 px-5 py-4 text-sm text-rose-700">
                No se encontró ningún paciente con el ID <span className="font-semibold">{patientSearchFeedback.query}</span>.
              </div>
            )}

            <PatientsTable
              patients={patients}
              selectedPatientId={selectedPatientId}
              onSelect={handleSelectPatient}
            />
          </>
        )}
      </div>

      <div className="space-y-6">
        {selectedPatient && (
          <div className="card overflow-hidden">
            <div className="border-b border-slate-200 px-6 py-5">
              <h3 className="text-lg font-semibold text-slate-800">Historial Clínico</h3>
              <p className="mt-1 text-sm text-slate-600">
                Datos históricos relacionales para {formatPatientName(selectedPatient)}.
              </p>
            </div>
            
            <div className="p-6">
              {isLoadingHistorial ? (
                <HistorialSkeleton />
              ) : historialError ? (
                <Alert variant="destructive">
                  <AlertTitle>Error</AlertTitle>
                  <AlertDescription>{historialError}</AlertDescription>
                </Alert>
              ) : !historial ? (
                <Alert>
                  <AlertTitle>No se encontraron datos</AlertTitle>
                  <AlertDescription>
                    No se encontró un historial clínico completo para el paciente especificado.
                  </AlertDescription>
                </Alert>
              ) : (
                <HistorialClinicoDetalle historial={historial} />
              )}
            </div>
          </div>
        )}
      </div>
    </section>
  )
}
