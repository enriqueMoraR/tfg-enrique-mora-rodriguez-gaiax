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
@Table(name = "consentimiento")
public class Consentimiento {

    @Id
    @Column(name = "id_consentimiento")
    private UUID idConsentimiento;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_paciente", nullable = false)
    private Paciente paciente;

    @Column(name = "id_proposito", nullable = false)
    private UUID idProposito;

    @Column(name = "fecha_inicio", nullable = false)
    private Date fechaInicio;

    @Column(name = "fecha_expiracion")
    private Date fechaExpiracion;

    @Column(name = "estado", nullable = false)
    private String estado;

    @Column(name = "ambitos_consentidos", columnDefinition = "TEXT")
    private String ambitosConsentidos;

    @Column(name = "id_dominio_gaia_fk")
    private UUID idDominioGaiaFk;

    @Column(name = "firma_digital", columnDefinition = "TEXT")
    private String firmaDigital;

    // Getters and Setters
}
