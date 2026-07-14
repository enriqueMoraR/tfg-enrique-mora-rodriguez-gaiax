package com.gaiahealth.provider.domain;

import jakarta.persistence.Entity;
import lombok.Data;
import jakarta.persistence.Id;
import jakarta.persistence.Column;
import jakarta.persistence.Table;
import java.util.UUID;

@Data
@Entity
@Table(name = "proveedor_salud")
public class ProveedorSalud {

    @Id
    @Column(name = "id_proveedor")
    private UUID idProveedor;

    @Column(name = "nombre_institucion", nullable = false)
    private String nombreInstitucion;

    @Column(name = "nif_cif", nullable = false, unique = true)
    private String nifCif;

    @Column(name = "tipo_proveedor")
    private String tipoProveedor;

    @Column(name = "id_gaia_x", unique = true)
    private String idGaiaX;

    @Column(name = "certificacion_soap")
    private String certificacionSoap;

    @Column(name = "direccion")
    private String direccion;

    // Getters and Setters
}
