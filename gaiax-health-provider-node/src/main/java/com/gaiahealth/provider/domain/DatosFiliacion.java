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
@Table(name = "datos_filiacion")
public class DatosFiliacion {

    @Id
    @Column(name = "id_filiacion")
    private UUID idFiliacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_historial", nullable = false)
    private HistorialClinico historialClinico;

    @Column(name = "comunidad_autonoma")
    private String comunidadAutonoma;

    @Column(name = "centro_asignado")
    private String centroAsignado;

    @Column(name = "nivel_socieconomico")
    private String nivelSocieconomico;

    @Column(name = "idioma_preferido")
    private String idiomaPreferido;

}
