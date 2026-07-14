package com.gaiahealth.provider.domain;

import jakarta.persistence.Entity;
import lombok.Data;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Table;
import java.util.Date;
import java.util.UUID;

@Data
@Entity
@Table(name = "paciente")
public class Paciente {

    @Id
    @Column(name = "id_paciente")
    private UUID idPaciente;

    @Column(name = "nif_dni", nullable = false, unique = true)
    private String nifDni;

    @Column(name = "nombre_completo", nullable = false)
    private String nombreCompleto;

    @Column(name = "fecha_nacimiento")
    private Date fechaNacimiento;

    @Column(name = "genero")
    private String genero;

    @Column(name = "grupo_sanguineo")
    private String grupoSanguineo;

    @Column(name = "nacionalidad")
    private String nacionalidad;

    @Column(name = "telefono")
    private String telefono;

    @Column(name = "email")
    private String email;

    @Column(name = "direccion_fisica")
    private String direccionFisica;

    @Column(name = "id_seguro_social")
    private String idSeguroSocial;

    @Column(name = "estado_activo", nullable = false)
    private boolean estadoActivo;

    // Getters and Setters
}
