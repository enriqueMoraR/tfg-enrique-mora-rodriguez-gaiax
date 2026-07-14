package com.gaiahealth.provider.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface DiagnosticoRepository extends JpaRepository<Diagnostico, UUID> {
    List<Diagnostico> findByHistorialClinico(HistorialClinico historial);
}
