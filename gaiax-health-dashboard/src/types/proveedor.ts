export interface Medico {
  idMedico: string
  nombre: string
  nroColegiado: string
  especialidad: string
  estadoActivo: boolean
}

export interface ProveedorSalud {
  idProveedor: string
  nombreInstitucion: string
  nifCif: string
  tipoProveedor: string
  idGaiaX: string
  certificacionSoap: string
  direccion: string
  medicos: Medico[]
}
