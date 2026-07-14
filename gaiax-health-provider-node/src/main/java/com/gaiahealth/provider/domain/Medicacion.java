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
@Table(name = "medicacion")
public class Medicacion {

    @Id
    @Column(name = "id_medicacion")
    private UUID idMedicacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_tratamiento", nullable = false)
    private Tratamiento tratamiento;

    @Column(name = "nombre_comercial")
    private String nombreComercial;

    @Column(name = "principio_activo", nullable = false)
    private String principioActivo;

    @Column(name = "dosis")
    private String dosis;

    @Column(name = "via_administracion")
    private String viaAdministracion;

    @Column(name = "frecuencia")
    private String frecuencia;

    @Column(name = "fecha_inicio", nullable = false)
    private Date fechaInicio;

    @Column(name = "fecha_fin")
    private Date fechaFin;

    @Column(name = "es_alergia")
    private boolean esAlergia;

    // Getters and Setters
}
