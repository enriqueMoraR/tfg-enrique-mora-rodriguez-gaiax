export interface Medicacion {
  idMedicacion: string
  principioActivo: string
  dosis: string
}

export interface Tratamiento {
  idTratamiento: string
  nombreTratamiento: string
  indicaciones: string
  fechaInicio: string
  medicaciones: Medicacion[]
}

export interface Diagnostico {
  idDiagnostico: string
  descripcion: string
  cie10: string
  fechaDiagnostico: string
}

export interface Paciente {
  idPaciente: string
  nombreCompleto: string
  nifDni: string
}

export interface DatosFiliacion {
  idFiliacion: string
  comunidadAutonoma: string
  centroAsignado: string
  nivelSocieconomico: string
  idiomaPreferido: string
}

export interface AntecedentesPaciente {
  idAntecedente: string
  tipo: string
  descripcion: string
  fechaInicio: string
  esActivo: boolean
  cie10: string
}

export interface LecturaSensor {
  idLectura: string
  valor: number
  unidad: string
  timestamp: string
  calidadDato: string
}

export interface DispositivoIot {
  idDispositivo: string
  tipo: string
  modelo: string
  fabricante: string
  fechaInstalacion: string
  conectado: boolean
  lecturas: LecturaSensor[]
}

export interface HistorialClinico {
  idHistorial: string
  paciente: Paciente
  fechaCreacion: string
  fechaUltimaActualizacion: string
  diagnosticos: Diagnostico[]
  tratamientos: Tratamiento[]
  filiacion: DatosFiliacion[]
  antecedentes: AntecedentesPaciente[]
  dispositivos: DispositivoIot[]
}
