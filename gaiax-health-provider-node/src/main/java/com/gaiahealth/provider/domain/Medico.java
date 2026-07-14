package com.gaiahealth.provider.domain;

import jakarta.persistence.Entity;
import lombok.Data;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Table;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.FetchType;
import java.util.UUID;

@Data
@Entity
@Table(name = "medico")
public class Medico {

    @Id
    @Column(name = "id_medico")
    private UUID idMedico;

    @Column(name = "nombre", nullable = false)
    private String nombre;

    @Column(name = "nro_colegiado", nullable = false, unique = true)
    private String nroColegiado;

    @Column(name = "especialidad")
    private String especialidad;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_proveedor", nullable = false)
    private ProveedorSalud proveedorSalud;

    @Column(name = "estado_activo", nullable = false)
    private boolean estadoActivo;

    // Getters and Setters
}
