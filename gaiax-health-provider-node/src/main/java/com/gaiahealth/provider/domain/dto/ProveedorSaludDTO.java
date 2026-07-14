package com.gaiahealth.provider.domain.dto;

import lombok.Data;
import java.util.List;
import java.util.UUID;

@Data
public class ProveedorSaludDTO {
    private UUID idProveedor;
    private String nombreInstitucion;
    private String nifCif;
    private String tipoProveedor;
    private String idGaiaX;
    private String certificacionSoap;
    private String direccion;
    private List<MedicoDTO> medicos;

    @Data
    public static class MedicoDTO {
        private UUID idMedico;
        private String nombre;
        private String nroColegiado;
        private String especialidad;
        private Boolean estadoActivo;
    }
}
