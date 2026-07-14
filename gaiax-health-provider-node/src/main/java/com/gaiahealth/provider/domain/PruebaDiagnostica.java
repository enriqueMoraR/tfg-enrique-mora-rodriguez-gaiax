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
@Table(name = "prueba_diagnostica")
public class PruebaDiagnostica {

    @Id
    @Column(name = "id_prueba")
    private UUID idPrueba;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_historial", nullable = false)
    private HistorialClinico historialClinico;

    @Column(name = "tipo")
    private String tipo;

    @Column(name = "resultado", columnDefinition = "TEXT")
    private String resultado;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "fecha_realizacion", nullable = false)
    private Date fechaRealizacion;

    @Column(name = "uri_imagen")
    private String uriImagen;

    @Column(name = "codigo_loinc")
    private String codigoLoinc;

    // Getters and Setters
}
