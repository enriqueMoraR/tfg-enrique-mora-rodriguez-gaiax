import type { FhirPatient } from '../../../types/fhir'

interface PatientsTableProps {
  patients: FhirPatient[]
  selectedPatientId?: string
  onSelect: (patient: FhirPatient) => void
}

function displayPatientName(patient: FhirPatient) {
  const directName = patient.name?.[0]?.text
  if (directName && directName.trim()) {
    return directName
  }

  const given = patient.name?.[0]?.given?.[0] ?? ''
  const family = patient.name?.[0]?.family ?? ''
  const combined = `${given} ${family}`.trim()
  return combined || patient.id
}

export default function PatientsTable({ patients, selectedPatientId, onSelect }: PatientsTableProps) {
  if (patients.length === 0) {
    return (
      <div className="card p-8 text-center text-slate-500">
        <p>Sin datos de pacientes para mostrar</p>
      </div>
    )
  }

  return (
    <div className="card p-6">
      <div className="mb-4 flex items-start justify-between gap-4">
        <div>
          <h3 className="text-lg font-semibold text-slate-800">Pacientes cargados</h3>
          <p className="text-sm text-slate-600">
            Datos reales recuperados desde PostgreSQL a través del endpoint FHIR.
          </p>
        </div>
        <span className="rounded-full bg-clinical-blue/10 px-3 py-1 text-xs font-semibold text-clinical-blue">
          {patients.length} pacientes
        </span>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="border-b border-slate-300 text-left">
              <th className="px-4 py-2 text-xs uppercase tracking-wide text-slate-500">Paciente</th>
              <th className="px-4 py-2 text-xs uppercase tracking-wide text-slate-500">ID</th>
              <th className="px-4 py-2 text-xs uppercase tracking-wide text-slate-500">Sexo</th>
              <th className="px-4 py-2 text-xs uppercase tracking-wide text-slate-500">Nacimiento</th>
              <th className="px-4 py-2 text-xs uppercase tracking-wide text-slate-500">Acción</th>
            </tr>
          </thead>
          <tbody>
            {patients.map((patient) => {
              const isSelected = patient.id === selectedPatientId
              return (
                <tr
                  key={patient.id}
                  className={`border-b border-slate-200 transition ${
                    isSelected ? 'bg-blue-50' : 'hover:bg-slate-50'
                  }`}
                >
                  <td className="px-4 py-3">
                    <div className="font-semibold text-slate-800">{displayPatientName(patient)}</div>
                    <div className="text-xs text-slate-500">
                      {patient.meta?.lastUpdated ?? 'Sin marca temporal'}
                    </div>
                  </td>
                  <td className="px-4 py-3 text-sm text-slate-700">{patient.id}</td>
                  <td className="px-4 py-3 text-sm capitalize text-slate-700">
                    {patient.gender ?? 'unknown'}
                  </td>
                  <td className="px-4 py-3 text-sm text-slate-700">{patient.birthDate ?? 'N/D'}</td>
                  <td className="px-4 py-3 text-sm">
                    <button
                      type="button"
                      onClick={() => onSelect(patient)}
                      className="rounded-md border border-clinical-blue px-3 py-1.5 text-clinical-blue transition hover:bg-clinical-blue hover:text-white"
                    >
                      Ver datos
                    </button>
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  )
}
