package com.gaiahealth.provider.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DispositivoIotRepository extends JpaRepository<DispositivoIot, UUID> {
    List<DispositivoIot> findByPaciente(Paciente paciente);
}
