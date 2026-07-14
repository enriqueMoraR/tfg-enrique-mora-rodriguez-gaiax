package com.gaiahealth.provider.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;
import java.util.Optional;
import java.util.Date;

@Repository
public interface ConsentimientoRepository extends JpaRepository<Consentimiento, UUID> {

    Optional<Consentimiento> findByPacienteAndIdPropositoAndEstadoAndFechaExpiracionAfter(
        Paciente paciente, 
        UUID idProposito, 
        String estado, 
        Date fecha
    );
}
