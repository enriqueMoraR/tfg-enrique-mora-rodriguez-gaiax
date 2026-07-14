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
@Table(name = "diagnostico")
public class Diagnostico {

    @Id
    @Column(name = "id_diagnostico")
    private UUID idDiagnostico;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_historial", nullable = false)
    private HistorialClinico historialClinico;

    @Column(name = "cie_10")
    private String cie10;

    @Column(name = "cie_11")
    private String cie11;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "fecha_diagnostico", nullable = false)
    private Date fechaDiagnostico;

    @Column(name = "fecha_resolucion")
    private Date fechaResolucion;

    @Column(name = "severidad")
    private String severidad;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_medico_autor")
    private Medico medico;


    // Getters and Setters
}
