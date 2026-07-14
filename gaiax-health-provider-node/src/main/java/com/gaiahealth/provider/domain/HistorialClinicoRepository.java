package com.gaiahealth.provider.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface HistorialClinicoRepository extends JpaRepository<HistorialClinico, UUID> {

    Optional<HistorialClinico> findByPacienteIdPaciente(UUID pacienteId);

    @Query("SELECT h FROM HistorialClinico h JOIN FETCH h.paciente WHERE h.idHistorial = :idHistorial")
    Optional<HistorialClinico> findByIdWithPaciente(UUID idHistorial);
}
