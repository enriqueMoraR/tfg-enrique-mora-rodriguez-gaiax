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
@Table(name = "lectura_sensor")
public class LecturaSensor {

    @Id
    @Column(name = "id_lectura")
    private UUID idLectura;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_dispositivo", nullable = false)
    private DispositivoIot dispositivoIot;

    @Column(name = "valor")
    private Float valor;

    @Column(name = "unidad")
    private String unidad;

    @Column(name = "timestamp")
    private Date timestamp;

    @Column(name = "calidad_dato")
    private String calidadDato;

}
