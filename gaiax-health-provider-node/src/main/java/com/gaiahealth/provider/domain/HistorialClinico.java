package com.gaiahealth.provider.domain;

import jakarta.persistence.Entity;
import lombok.Data;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Table;
import jakarta.persistence.OneToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.FetchType;
import java.util.Date;
import java.util.UUID;

@Data
@Entity
@Table(name = "historial_clinico")
public class HistorialClinico {

    @Id
    @Column(name = "id_historial")
    private UUID idHistorial;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_paciente", nullable = false, unique = true)
    private Paciente paciente;

    @Column(name = "fecha_creacion", nullable = false)
    private Date fechaCreacion;

    @Column(name = "fecha_ultima_actualizacion")
    private Date fechaUltimaActualizacion;

    @Column(name = "version_fhir")
    private String versionFhir;

    @Column(name = "estado", nullable = false)
    private boolean estado;

    // Getters and Setters
}
