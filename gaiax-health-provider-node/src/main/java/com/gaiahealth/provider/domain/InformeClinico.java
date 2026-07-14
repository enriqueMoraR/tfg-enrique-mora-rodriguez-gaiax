package com.gaiahealth.provider.domain;

import jakarta.persistence.Entity;
import lombok.Data;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Table;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.FetchType;
import java.util.Date;
import java.util.UUID;

@Data
@Entity
@Table(name = "informe_clinico")
public class InformeClinico {

    @Id
    @Column(name = "id_informe")
    private UUID idInforme;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_historial", nullable = false)
    private HistorialClinico historialClinico;

    @Column(name = "tipo")
    private String tipo;

    @Column(name = "formato")
    private String formato;

    @Column(name = "uri_documento", nullable = false)
    private String uriDocumento;

    @Column(name = "fecha_emision", nullable = false)
    private Date fechaEmision;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_medico_autor", nullable = false)
    private Medico medicoAutor;

    @Column(name = "resumen_clinico", columnDefinition = "TEXT")
    private String resumenClinico;

    // Getters and Setters
}
