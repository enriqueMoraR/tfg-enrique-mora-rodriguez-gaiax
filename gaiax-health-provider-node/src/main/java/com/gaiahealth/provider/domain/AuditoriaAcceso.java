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
@Table(name = "auditoria_acceso")
public class AuditoriaAcceso {

    @Id
    @Column(name = "id_audit")
    private UUID idAudit;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_paciente", nullable = false)
    private Paciente paciente;

    @Column(name = "id_usuario_acceso", nullable = false)
    private UUID idUsuarioAcceso;

    @Column(name = "accion", nullable = false)
    private String accion;

    @Column(name = "timestamp", nullable = false)
    private Date timestamp;

    @Column(name = "motivo_acceso")
    private String motivoAcceso;

    @Column(name = "ip_origen")
    private String ipOrigen;

    @Column(name = "resultado", nullable = false)
    private String resultado;

    // Getters and Setters
}
