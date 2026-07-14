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
@Table(name = "antecedentes_paciente")
public class AntecedentesPaciente {

    @Id
    @Column(name = "id_antecedente")
    private UUID idAntecedente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_historial", nullable = false)
    private HistorialClinico historialClinico;

    @Column(name = "tipo")
    private String tipo;

    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;

    @Column(name = "fecha_inicio")
    private Date fechaInicio;

    @Column(name = "es_activo")
    private Boolean esActivo;

    @Column(name = "cie_10")
    private String cie10;

}
