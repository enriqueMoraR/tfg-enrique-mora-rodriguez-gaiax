package com.gaiahealth.provider.domain.dto;

import lombok.Data;
import java.util.List;

@Data
public class InitHistorialRequest {
    private String fhirId;
    private String nifDni;
    private String nombreCompleto;
    private String fechaNacimiento;
    private String genero;
    private List<DiagnosticoInfo> diagnosticos;
    private List<TratamientoInfo> tratamientos;
    private List<FiliacionInfo> filiacion;
    private List<AntecedentesInfo> antecedentes;
    private List<DispositivoIotInfo> dispositivos;

    @Data
    public static class DiagnosticoInfo {
        private String cie10;
        private String descripcion;
    }

    @Data
    public static class TratamientoInfo {
        private String nombreTratamiento;
        private String indicaciones;
        private String principioActivo;
    }

    @Data
    public static class FiliacionInfo {
        private String comunidadAutonoma;
        private String centroAsignado;
        private String nivelSocieconomico;
        private String idiomaPreferido;
    }

    @Data
    public static class AntecedentesInfo {
        private String tipo;
        private String descripcion;
        private String fechaInicio;
        private Boolean esActivo;
        private String cie10;
    }

    @Data
    public static class DispositivoIotInfo {
        private String tipo;
        private String modelo;
        private String fabricante;
        private String fechaInstalacion;
        private Boolean conectado;
        private List<LecturaSensorInfo> lecturas;
    }

    @Data
    public static class LecturaSensorInfo {
        private Float valor;
        private String unidad;
        private String timestamp;
        private String calidadDato;
    }
}
