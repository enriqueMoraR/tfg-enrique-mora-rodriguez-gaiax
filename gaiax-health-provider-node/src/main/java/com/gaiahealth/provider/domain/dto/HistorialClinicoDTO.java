package com.gaiahealth.provider.domain.dto;

import lombok.Data;
import java.util.List;
import java.util.UUID;
import java.util.Date;

@Data
public class HistorialClinicoDTO {
    private UUID idHistorial;
    private PacienteDTO paciente;
    private Date fechaCreacion;
    private Date fechaUltimaActualizacion;
    private List<DiagnosticoDTO> diagnosticos;
    private List<TratamientoDTO> tratamientos;
    private List<DatosFiliacionDTO> filiacion;
    private List<AntecedentesPacienteDTO> antecedentes;
    private List<DispositivoIotDTO> dispositivos;

    @Data
    public static class PacienteDTO {
        private UUID idPaciente;
        private String nombreCompleto;
        private String nifDni;
    }

    @Data
    public static class DiagnosticoDTO {
        private UUID idDiagnostico;
        private String descripcion;
        private String cie10;
        private Date fechaDiagnostico;
    }

    @Data
    public static class TratamientoDTO {
        private UUID idTratamiento;
        private String nombreTratamiento;
        private String indicaciones;
        private Date fechaInicio;
        private List<MedicacionDTO> medicaciones;
    }

    @Data
    public static class MedicacionDTO {
        private UUID idMedicacion;
        private String principioActivo;
        private String dosis;
    }

    @Data
    public static class DatosFiliacionDTO {
        private UUID idFiliacion;
        private String comunidadAutonoma;
        private String centroAsignado;
        private String nivelSocieconomico;
        private String idiomaPreferido;
    }

    @Data
    public static class AntecedentesPacienteDTO {
        private UUID idAntecedente;
        private String tipo;
        private String descripcion;
        private Date fechaInicio;
        private Boolean esActivo;
        private String cie10;
    }

    @Data
    public static class DispositivoIotDTO {
        private UUID idDispositivo;
        private String tipo;
        private String modelo;
        private String fabricante;
        private Date fechaInstalacion;
        private Boolean conectado;
        private List<LecturaSensorDTO> lecturas;
    }

    @Data
    public static class LecturaSensorDTO {
        private UUID idLectura;
        private Float valor;
        private String unidad;
        private Date timestamp;
        private String calidadDato;
    }
}
